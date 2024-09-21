#### Page Sections:
- [Methods of Customization](#---methods_of_customization)
  - [Macro Extension](#1-extension-of-existing-functionality)
  - [Macro Replacement](#2-replacing-default-callback-macros)
- [MMU\_ACTION\_CHANGED](#---_mmu_action_changed)
- [MMU\_PRINT\_STATE\_CHANGED](#---_mmu_action_changed)
- [MMU\_EVENT](#---_mmu_action_changed)
- [Unloading & Loading Sequence Macros](#---unloading--loading-sequence-macros)
- [Tip Forming](#)
  - [\_MMU\_FORM\_TIP](#---_mmu_form_tip)
  - [\_MMU\_CUT\_TIP](#---_mmu_cut_tip)

<br>

Happy Hare provides many "callback macros" that, if defined, will be called at specific times.  They are designed for you to be able to extend the base functionality and to implement additional operations.  For example, if you want to control your printers LED's based on the action Happy Hare is performing you would replace/extend `_MMU_ACTION_CHANGED`.

All of the default handlers and examples are defined in either `mmu_state.cfg`, `mmu_sequence.cfg`, `mmu_form_tip.cfg` or `mmu_cut_tip.cfg` and implement default behavior but can also serve as a starting point for designing your own.

Since you will most likely want extend the default behavior these macros are designed to be read-only but can be replaced. Therefore there are two methods of modifying behavior:

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Methods of customization

### 1. Extension of existing functionality
Generally you will be able to add functionality simply by definng the appropriate `variable_user_XXX_extension` variables in `mmu_macro_vars.cfg`. For example, if you want to do something custom when the MMU print state changes, you would define:
```yml
variable_user_print_state_changed_extension : 'MY_MACRO'
```
Then "MY\_MACRO" will be called when the print state changes. The "MY\_MACRO" will be passed exactly the same parameters as the original callback macro `_MMU_PRINT_STATE_CHANGED` and will be called after the default handling. In this way, although `mmu_state.cfg` (where `_MMU_PRINT_STATE_CHANGED) is read-only, you have extended the original functionality with a macro you control.

> [!NOTE]  
> Because the settings in `mmu_macro_vars.cfg` are yours, they will be retained on upgrade. This allow the default logic to be upgraded without effecting your custom additions. This is therefore the recommended method of adding functionality.

This extension methodology works for many macros called by Happy Hare, including:
```
variable_user_pre_initialize_extension
variable_user_action_changed_extension
variable_user_print_state_changed_extension
variable_user_mmu_event_extension
variable_user_pre_unload_extension
variable_user_post_unload_extension
variable_user_pre_load_extension
variable_user_post_load_extension
variable_user_mmu_error_extension
variable_user_park_move_macro
variable_user_pause_extension
variable_user_resume_extension
variable_user_cancel_extension
```
One final user extension is `variable_user_park_move_macro`. Unlike the rest in the list which extend, this **replaces** the move macro with the defined logic rather than the default behavior. This is a special case to allow for non-straight line parking moves instead of the default straight ones and saves you having to replace many macros to achieve the same behavior.

### 2. Replacing default callback macros
If the extension cability is insufficent you can completely replace the default behavior rather than add to it. This is often a desire for tip forming for example or where no `variable_user_XXX_extension` hooks are available at the right time. To do this you don't edit the read-only defaults, but instead write your own macro in another and include in your `printer.cfg`. Then edit `mmu_parameters.cfg` to point to your replacement macro. For example, to define a new tip forming macro, you would change:
```yml
form_tip_macro: MY_FORM_TIP
```
Then you would implement a macro MY\_FORM\_TIP to do your own tip forming.

This methodology works for many macros called by Happy Hare, including:
```
form_tip_macro: _MMU_FORM_TIP
pause_macro: PAUSE
action_changed_macro: _MMU_ACTION_CHANGED
print_state_changed_macro: _MMU_PRINT_STATE_CHANGED
mmu_event_macro: _MMU_EVENT
pre_unload_macro: _MMU_PRE_UNLOAD
post_form_tip_macro: _MMU_POST_FORM_TIP
post_unload_macro: _MMU_POST_UNLOAD
pre_load_macro: _MMU_PRE_LOAD
post_load_macro: _MMU_POST_LOAD
unload_sequence_macro: _MMU_UNLOAD_SEQUENCE
load_sequence_macro: _MMU_LOAD_SEQUENCE
```

> [!IMPORTANT]  
> Before embarking on this approach it is important that you understand the operation of the existing macro and the parameters that may be sent to it. Therefore it is best practice to copy the reference macro as a starting point into your own renaming all "helper" macros that may be called. This method also will survive upgrades (because `mmu_parameters.cfg` is maintained) but has the disadvantage that you will not see updated functionality unless you also update your replacement macro. Other than for `form_tip_macro` replacement of these macros is rare and instead the use of `variable_user_XXX_extension` mechanism is encouraged.

<hr>

<br>

Here are all the callout macros together with details of where to find them:

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) \_MMU\_ACTION\_CHANGED
**Defined in `mmu_state.cfg`**

Most of the time Happy Hare will be in the `Idle` state but it starts to perform a new action this macro is called.  The action string is passed as a `ACTION` parameter to the macro but can also be read with the printer variable `printer.mmu.action`. The previous action is passed in as `OLD_ACTION`.

Possible action strings are:

```yml
    Idle           No action being performed
    Loading        Filament loading
    Unloading      Filamdng unloading
    Loading Ext    Loading filament into the extruder (usually occurs after Loading)
    Exiting Ext    Unloading filament from the extruder (usually after Foriming Tip and before Unloading)
    Forming Tip    When running standalone tip forming (cannot detect when slicer does it)
    Heating        When heating the nozzle
    Checking       Checking gates for filament (MMU_CHECK_GATE)
    Homing         Homing the selector
    Selecting      When the selector is moving to select a new filament
    Unknown        Should not occur
```

Here is the start of the reference macro packaged in `mmu_state.cfg` which is used by default to drive LED effects:

```yml
###########################################################################
# Called when when the MMU action status changes
#
# The `ACTION` parameter will contain the current action string
# (also available in `printer.mmu.action` printer variable).
# Also the previous action is available in `OLD_ACTION`.
#
# See Happy Hare README for full list of action strings, but a quick ref is:
#
#  Idle|Loading|Unloading|Loading Ext|Exiting Ext|Forming Tip|Heating|Checking|Homing|Selecting
#
# The reference logic here drives a set of optional LED's
#
[gcode_macro _MMU_ACTION_CHANGED]
description: Called when an action has changed
gcode:
    {% set ACTION = params.ACTION|string %}
    {% set OLD_ACTION = params.OLD_ACTION|string %}
```

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) \_MMU\_PRINT\_STATE\_CHANGED
**Defined in `mmu_state.cfg`**

Happy Hare implements a state machine tracking the prgoress of a print. It is difference from the klipper `print_stats` because it is specific to MMU state during a print. Full details can be found [here](Print-Job-State-Machine#---job-state-transitions).  Every time a state changes this macro will be called. Then new state will be passed with the `STATE` parameter and the previous state as `OLD_STATE`. The state can also be read with the printer variable `printer.mmu.print_state`.

Possible state strings are:

```yml
    initialized    State occurs on first bootup or after initialization command like `MMU_RESET` or `MMU ENABLE=0 -> MMU ENABLE=1`
    ready          MMU is idle out of a print
    started        Short lived state the occurs during the startup phase when starting a print
    printing       State meaning that a print is underway
    complete       End state that occurs after a print has sucessfully finished printing
    cancelled      End state that occurs if a print is cancelled
    error          End state when a print ends in an error
    pause_locked   State that indicates MMU has experienced and error and certain features are locked until `MMU_UNLOCK` is run
    paused         State that occurs after `MMU_UNLOCK`
    standby        Printer has been idle for extended period of time
```

Here is the start of the reference macro packaged in `mmu_state.cfg` which is used by default to drive LED effects:

```yml
###########################################################################
# Called when the MMU print state changes
#
# The `STATE` parameter will contain the current state string
# (also available in `printer.mmu.print_state` printer variable)
# Also the previous action is available in `OLD_STATE`.
#
# See Happy Hare README for full list of state strings and the state transition
# diagram, but a quick ref is:
#
#  initialized|ready|started|printing|complete|cancelled|error|pause_locked|paused|standby
#
# The reference logic here drives a set of optional LED's
#
[gcode_macro _MMU_PRINT_STATE_CHANGED]
description: Called when print state changes
gcode:
    {% set STATE = params.STATE|string %}
    {% set OLD_STATE = params.OLD_STATE|string %}
```

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) \_MMU\_EVENT
**Defined in `mmu_state.cfg`**

The extract from the cfg file illustrates current events and parameters. The `EVENT` parameter will always be defined with one of the available event strings. Optionally additional parameters by be supplied. For example:

<p>

Happy Hare maintains a map of all the filaments in the MMU including material type, color, etc.  When this map changes this macro is called with a `gate_map_changed` event. The `GATE` parameter will either represent a specific gate that has been updated or `-1` meaning that mutliple gates are updated. The actual gate map infomation can be read through printer variables `printer.mmu.gate_color`, `printer.mmu.gate_material`, etc..

Here is the start of the reference macro packaged in `mmu_state.cfg` which is used by default to manage consumption counters:


```yml
###########################################################################
# Called when an atomic event occurs. Different from ACTION_CHANGE because
# these are not necessarily part of any important state change but rather
# informational
#
# The `EVENT` parameter will contain the event name. Other parameters
# depend on the event type
#
# See Happy Hare README for full list of event strings, but a quick ref is:
#
# Events:
#   "restart"              Called when Happy Hare starts / restarts
#       Parameters: None
#
#   "gate_map_changed"    Called when the MMU gate_map (containing information
#                         about the filament type, color, availability and
#                         spoolId) is updated
#       Parameters: GATE  The gate that is updated or -1 if all updated
#
#   "servo_down"          Called when MMU servo (if fitted) grips filament
#       Parameters: None
#
#   "filament_cut"        Called when filament is cut
#       Parameters: None
#
# The reference logic here updates counters and drives optional LED's
#
[gcode_macro _MMU_EVENT]
description: Called when certain MMU actions occur
gcode:
    {% set event = params.EVENT|string %}
```

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Unloading / Loading "Sequence" Macros
**Defined in `mmu_sequence.cfg`**

This set of macros are called during filament loading or unloading. They can be used for the insertion of logic specific to your printer setup. The ordering of these macros is as follows (if any are not defined they are skipped):

```yml
Unloading sequence...
  _MMU_PRE_UNLOAD             Called before starting the unload
    'form_tip_macro'          User defined macro for tip forming
  _MMU_POST_FORM_TIP          Called immediately after tip forming
    (_MMU_UNLOAD_SEQUENCE)    Advanced: Optionally called based on 'gcode_unload_sequence'
  _MMU_POST_UNLOAD            Called after unload completes

Loading sequence...
  _MMU_PRE_LOAD               Called before starting the load
    (_MMU_LOAD_SEQUENCE)      Advanced: Optionally called based on 'gcode_load_sequence'
  _MMU_POST_LOAD              Called after the load is complete
```

If changing a tool the unload sequence will be immediately followed by the load sequence. Note that Happy Hare has some built in functionality to minimize the logic necessary in these macros:
* Happy Hare separately implements z-hop moves on toolchange (including EndlessSpool) specified with the 'z_hop_height_toolchange' parameter as well as on errors and print cancellation with 'z_hop_error' parameter.
* Toolhead will be correctly placed prior to resuming the print although the logic will only be expecting to correct z_hop height and will be slow if horizonal moves are necessary
* Pressure advance will automatically be restored after tip forming
* M220 & M221 overrides will be retained after a toolchange
* If configured, Spoolman will be notified of toolchange
* Should an error occur causing a pause, the extruder temperature will be saved and restored on MMU_UNLOCK or resume


Leveraging the basic callbacks is usually sufficent for customization, however if you really want to do something unusual you can enable the gcode loading/unloading sequences by setting the following in 'mmu_parameters.cfg'
```yml
gcode_load_sequence: 1
gcode_unload_sequence: 1
```
This is quite advanced and you will need to understand the Happy Hare state machine before embarking on changes. Read [Custom Load/Unload Sequences](Custom-Load-Unload-Sequences) for more details.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Tip Forming
Tip forming is necessary to ensure the end of the filament will pass through the MMU and extruder on subsequent loads. There are two primary methods: tip-shaping and tip-cutting. They are mutually exclusive and you choose one based on your seting and point to the macro by changing `form_tip_macro` in `mmu_parameters.cfg`

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) \_MMU\_FORM\_TIP
**Defined in `form_tip.cfg`** (variables in `mmu_macro_vars.cfg`)

This is probably the most important aspect of getting a reliable MMU after basic calibration is complete. There is plenty written about tip forming and lots of advice in the forums.  What is important to understand here is that this macro mimicks the tip forming logic from SuperSlicer (almost identical to PrusaSlicer). Read SuperSlicer documentation for hints. That said, here are a few things you should know:

* This macro will always be used when not printing, but you can elect to use it instead of your slicers logic by:</li>
  - Turning OFF all tip forming logic in your slicer</li>
  - Setting the `variable_standalone: 1` in the `T0` macro</li>
* When tuning if is useful to pull the bowden from your extruder, load filament with the `MMU_LOAD EXTRUDER_ONLY=1` command, then call `MMU_FORM_TIP` command (and not the macro directly) or better still `MMU_EJECT EXTRUDER_ONLY=1`</li>
  - The benefit of calling as desribed is the additional TMC current control and pressure advance restoration will occur so it exactly mimicks what will occur when called automatically later</li>
  - If calling `MMU_FORM_TIP` you will want to set `variable_final_eject: 1` so that the filament is fully ejected for inspection (MMU\_EJECT will automatically do this and therefore is recommended)
  - Calling with `MMU_EJECT EXTRUDER_ONLY=1` will also report on the final parking position of the filament</li>
* Before you start tweaking, make sure the settings accurately represent the geometry of your extruder. The defaults are for my Voron Clockwork 2 extruder with Voron Revo hotend with 0.4mm tip</li>
* Lastely there is a setting called `parking_distance` which, if set, will determine the final resting place measured from the nozzle. This should be a postive number!</li>

Here are the default values for tip forming.  These are the exact values I used for non PLA filaments (PLA seems to like skinny dip):

```yml
# FORM_TIP ----------------------------------------------------------------
# ███████╗ ██████╗ ██████╗ ███╗   ███╗    ████████╗██╗██████╗ 
# ██╔════╝██╔═══██╗██╔══██╗████╗ ████║    ╚══██╔══╝██║██╔══██╗
# █████╗  ██║   ██║██████╔╝██╔████╔██║       ██║   ██║██████╔╝
# ██╔══╝  ██║   ██║██╔══██╗██║╚██╔╝██║       ██║   ██║██╔═══╝ 
# ██║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║       ██║   ██║██║     
# ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝       ╚═╝   ╚═╝╚═╝     
# Don't need to configure if using tip cutting
#   (base/mmu_form_tip.cfg)
#
[gcode_macro _MMU_FORM_TIP_VARS]
description: Happy Hare tip forming macro configuration variables
gcode: # Leave empty

# Step 1 - Ramming
# Ramming is the initial squeeze of filament prior to cooling moves and is
# described in terms of total volume and progression of squeeze intensity
# printing/standalone. This can be separately controlled when printing or
# standalone
variable_ramming_volume            : 0          ; Volume in mm^3, 0 = disabled (optionally let slicer do it)
variable_ramming_volume_standalone : 0          ; Volume in mm^3, 0 = disabled

# Optionally set for temperature change (reduction). The wait will occur
# before nozzle separation if 'use_fast_skinnydip: False' else after cooling
# moves. Temperature will be restored after tip creation is complete
variable_toolchange_temp        : 0             ; 0 = don't change temp, else temp to set
variable_toolchange_fan_assist  : False         ; Whether to use part cooling fan for quicker temp change
variable_toolchange_fan_speed   : 50            ; Fan speed % if using fan_assist enabled

# Step 2 - Nozzle Separation
# The filament is then quickly separated from the meltzone by a fast movement
# before then slowing to travel the remaining distance to cooling tube. The
# initial fast movement should be as fast as extruder can comfortably perform.
# A good starting point# for slower move is unloading_speed_start/cooling_moves.
# Too fast a slower movement can lead to excessively long tips or hairs
variable_unloading_speed_start  : 80            ; Speed in mm/s for initial fast movement
variable_unloading_speed        : 18            ; Speed in mm/s for slow move to cooling zone

# Step 3 - Cooling Moves
# The cooling move allows the filament to harden while constantly moving back
# and forth in the cooling tube portion of the extruder to prevent a bulbous
# tip forming. The cooling tube position is measured from the internal nozzle
# to just past the top of the heater block (often it is beneficial to add a
# couple of mm to ensure the tip is in the cooling section. The cooling tube
# length is then the distance from here to top of heatsink (this is the length
# length of the cooling moves). The final cooling move is a fast movement to
# break the string formed.
variable_cooling_tube_position  : 35            ; Start of cooling tube. DragonST:35, DragonHF:30, Mosquito:30, Revo:35, RapidoHF:27
variable_cooling_tube_length    : 10            ; Movement length. DragonST:15, DragonHF:10, Mosquito:20, Revo:10, RapidoHF:10
variable_initial_cooling_speed  : 10            ; Inital slow movement (mm/s) to solidify tip and cool string if formed
variable_final_cooling_speed    : 50            ; Fast movement (mm/s) Too fast: tip deformation on eject, Too Slow: long string/no seperation
variable_cooling_moves          : 4             ; Number of back and forth cooling moves to make (2-4 is a good start)

# Step 4 - Skinnydip
# Skinnydip is an advanced final move that may have benefit with some
# material like PLA to burn off persistent very fine hairs. To work the
# depth of insertion is critical (start with it disabled and tune last)
# For reference the internal nozzle would be at a distance of
# cooling_tube_position + cooling_tube_length, the top of the heater
# block would be cooling_tube_length away.
variable_use_skinnydip          : True          ; True = enable skinnydip, False = skinnydip move disabled
variable_skinnydip_distance     : 30            ; Distance to reinsert filament into hotend starting from end of cooling tube
variable_dip_insertion_speed    : 30            ; Medium/Slow insertion speed mm/s - Just long enough to melt the fine hairs, too slow will pull up molten filament
variable_dip_extraction_speed   : 70            ; Speed mm/s - Around 2x Insertion speed to prevents forming new hairs
variable_melt_zone_pause        : 0             ; Pause if melt zone in ms. Default 0
variable_cooling_zone_pause     : 0             ; Pause if cooling zone after dip in ms. Default 0
variable_use_fast_skinnydip     : False         ; False = Skip the toolhead temp change wait during skinnydip move

# Step 5 - Parking
# Park filament ready to eject
variable_parking_distance       : 0             ; Position mm to park the filament at end of tip forming, 0 = leave where filament ends up after tip forming
variable_extruder_eject_speed   : 25            ; Speed mm/s used for parking_distance (and final_eject when testing)
```

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) \_MMU\_CUT\_TIP
**Defined in `cut_tip.cfg`** (variables in `mmu_macro_vars.cfg`)

To elminate the need to spend time tuning the tip forming procedure (you never wanted to understand fluid dynamics, right?!) you can opt to cut filament at the toolhead. The filametrix cutter bundled with ERCFv2 is an example of this. Note that Happy Hare can only have one tip creation macro defined. You can switch from the default tip forming to this tip cutting macro by setting `form_tip_macro: _MMU_CUT_TIP` in `mmu_parameters.cfg` to point to this macro instead.

Here are the default values for tip cutting with explanation:

```yml
# CUT_TIP -----------------------------------------------------------------
#  ██████╗██╗   ██╗████████╗    ████████╗██╗██████╗ 
# ██╔════╝██║   ██║╚══██╔══╝    ╚══██╔══╝██║██╔══██╗
# ██║     ██║   ██║   ██║          ██║   ██║██████╔╝
# ██║     ██║   ██║   ██║          ██║   ██║██╔═══╝ 
# ╚██████╗╚██████╔╝   ██║          ██║   ██║██║     
#  ╚═════╝ ╚═════╝    ╚═╝          ╚═╝   ╚═╝╚═╝     
# Don't need to configure if using tip forming
#   (base/mmu_cut_tip.cfg)
#
[gcode_macro _MMU_CUT_TIP_VARS]
description: Happy Hare toolhead tip cutting macro configuration variables
gcode: # Leave empty

# Whether the toolhead tip cutting macro will return toolhead to initial
# position (usually wipetower) after the cut is complete. If using parking
# logic you may want to disable this and set 'park_after_form_tip: True'
variable_restore_position       : True          ; True = return to initial position, False = don't return

# Distance from the internal nozzle tip to the cutting blade. This dimension
# is based on your toolhead and should not be used for tuning
# Note: If you have a toolhead sensor this variable can be automatically determined!
# Read https://github.com/moggieuk/Happy-Hare/wiki/Blobing-and-Stringing
variable_blade_pos              : 37.5          ; Distance in mm from internal nozzle tip

# Distance to retract prior to making the cut, this reduces wasted filament
# (left behind in extruder) but might cause clog if set too large and/or if
# there are gaps in the hotend assembly.  This must be less than 'blade_pos'
variable_retract_length         : 32.5          ; (5mm less than 'blade_pos' is a good starting point)

# Whether to perform a simple tip forming move after the initial retraction
# Enabling this adds some time to the cutting but gives some additional cooling
# time of molten filament and avoids potential clogging on some hotends
variable_simple_tip_forming     : 1             ; True = Perform simple tip forming, False = skip

# This should be the position of the toolhead where the cutter arm just
# lightly touches the depressor pin
variable_pin_loc_xy             : 13, 213       ; x,y coordinates of depressor pin

# This distance is added to 'pin_loc_x' to determine the starting position
# and to create a small saftely distance that aids in generating momentum
variable_pin_park_x_dist        : 5.0           ; Distance in mm

# Position of the toolhead when the cutter is fully compressed. Should leave
# a small headroom (should be a bit larger than 0, or whatever xmin is) to
# avoid banging the toolhead or gantry
variable_pin_loc_x_compressed   : 0.5           ; x coordinate

# Retract length and speed after the cut so that the cutter blade doesn't
# get stuck on return to origin position
variable_rip_length             : 1             ; Distance in mm to retract to aid lever decompression (>= 0)
variable_rip_speed              : 3             ; Speed mm/s

# Pushback of the remaining tip from the cold end into the hotend. This does
# not have to push back all the way, just sufficient to ensure filament
# fragment stays in hot end. Cannot be larger than 'retract_length'
variable_pushback_length        : 5             ; Distance in mm
variable_pushback_dwell_time    : 0             ; Time in ms to dwell after the pushback

# Speed related settings for tip cutting
# Note that if the cut speed is too fast, the steppers can lose steps.
# Therefore, for a cut:
# - We first make a fast move to accumulate some momentum and get the cut
#   blade to the initial contact with the filament
# - We then make a slow move for the actual cut to happen
variable_travel_speed           : 200           ; Speed mm/s
variable_cut_fast_move_speed    : 32            ; Speed mm/s
variable_cut_slow_move_speed    : 8             ; Speed mm/s
variable_evacuate_speed         : 150           ; Speed mm/s
variable_cut_dwell_time         : 50            ; Time in ms to dwell at the cut point
variable_cut_fast_move_fraction : 1.0           ; Fraction of the move that uses fast move
variable_extruder_move_speed    : 25            ; Speed mm/s for all extruder movement

# Safety margin for fast vs slow travel. When traveling to the pin location
# we make a safer but longer move if we are closer to the pin than this
# specified margin. Usually setting these to the size of the toolhead
# (plus a small margin) should be good enough
variable_safe_margin_xy         : 30, 30        ; Approx toolhead width +5mm, height +5mm)

# If gantry servo option is installed, enable the servo and set up and down
# angle positions
variable_gantry_servo_enabled   : False         ; True = enabled, False = disabled
variable_gantry_servo_down_angle: 55            ; Angle for when pin is deployed
variable_gantry_servo_up_angle  : 180           ; Angle for when pin is retracted
```

> [!NOTE]  
> The `output_park_pos` variable is used to pass the resultant position of the filament back to Happy Hare and in this reference macro it is set dynamically.
