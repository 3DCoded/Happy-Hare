#### Page Sections:
- [Methods of Customization](#---methods_of_customization)
  - [Macro Extension](#1-extension-of-existing-functionality)
  - [Macro Replacement](#2-replacing-default-callback-macros)
- [MMU\_ACTION\_CHANGED](#---_mmu_action_changed)
- [MMU\_PRINT\_STATE\_CHANGED](#---_mmu_action_changed)
- [MMU\_EVENT](#---_mmu_action_changed)
- [Unloading & Loading Sequence](#---unloading--loading-sequence-macros)
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
Then "MY\_MACRO" will be called when the print state changes. The "MY\_MACRO" will be passed exactly the same parameters as the original callback macro `_MMU_PRINT_STATE_CHANGED` and wil be called after the default handling. In this way, although `mmu_state.cfg` is read-only, you have extended the original functionality with a macro you control.

> [!NOTE]  
> Because the settings in `mmu_macro_vars.cfg` are yours, they will be retained on upgrade. This allow the default logic to be enhanced without effecting your custom additions. This is therefore the recommended method of adding functionality.

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
variable_user_park_move_macro
variable_user_pause_extension
variable_user_resume_extension
variable_user_cancel_extension
```
One final user extension is `variable_user_park_move_macro`. Unlike the rest in the list which extend, this **replaces** the move macro with the defined logic rather than the default behavior. This is a special case to allow for non-straight line parking moves instead of the default straight ones and saves you having to replace many macros to achieve the same behavior.

### 2. Replacing default callback macros
If you want to change the default behavior rather than add to it (often a desire for tip forming for example) or no `variable_user_XXX_extension` hooks are available at the right time you can replace the entire macro with one of your own. To do this you don't edit the read-only defaults, but instead write your own in another in your `printer.cfg` and then edit `mmu_parameters.cfg` to point to your replacement macro. For example, to define a new tip forming macro, you would change:
```yml
form_tip_macro: MY_FORM_TIP
```
Then you would write a macro MY\_FORM\_TIP to do your own tip forming.

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

Happy Hare maintains a map of all the filaments in the MMU including material type, color, etc.  When this map changes this macro is called. The `GATE` parameter will either represent a specific gate that has been updated or `-1` meaning that mutliple gates are updated. The actual gate map infomation can be read through printer variables `printer.mmu.gate_color`, `printer.mmu.gate_material`, etc..

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

<p>

The behavior of these default macros is controlled by the following set of variables found at the top of the `mmu_sequence.cfg` file.  Once you have set `variable_park_xy` to the coordinates of a safe park area (usually over your purge bucket) you can set `variable_enable_park: 1` to enable movement of the toolhead away from the print while changing filaments.
```yml
###########################################################################
# Variables controlling sequence macros are all set here
#
[gcode_macro _MMU_Variables]
variable_enable_park: 0                 # Whether the parking move is enabled. Turn on after setting park_xy
variable_park_xy: 50, 50                # Coordinates of park position for toolchange
variable_park_z_hop: 1                  # Additional Z_hop when toolchanging
variable_travel_speed: 200              # XY travel speed in mm/s
variable_lift_speed: 15                 # Z travel speed in mm/s
variable_auto_home: 0                   # Automatically home if necessary (mainly testing use case)
variable_park_after_form_tip: 0         # Set to 1 if tip cutting at toolhead to delay move to park position
```

> [!NOTE]  
> Generally `variable_park_after_form_tip` will be `0` meaning the move away from the print is immediate.  If you are using a cutter at the toolhead you will want to set this to `1`.  This delays the move until after the movement defined in the tip cutting macro.

Here are some examples of logic that might be put in these macros:

#### \_MMU\_PRE\_UNLOAD (mmu\_sequence.cfg)
Logic here would typically move the toolhead to a safe spot like over the purge bucket

#### \_MMU\_POST\_FORM\_TIP (mmu\_sequence.cfg)
Optional this logic would do the same this as `_MMU_PRE_UNLOAD` in the case of a tip cutting movement

#### \_MMU\_POST\_UNLOAD (mmu\_sequence.cfg)
Logic here can be used to implement tip cutting and cleanup at the MMU gate

#### \_MMU\_PRE\_LOAD (mmu\_sequence.cfg)
This is a great spot to add logic to take time lapse photography (although it can also be done elsewhere)

#### \_MMU\_POST\_LOAD (mmu\_sequence.cfg)
Logic here can perform extra purging operations, pause for ooze and then wipe nozzle before returning to the original position recorded in either the `_MMU_PRE_UNLOAD` or `_MMU_POST_FORM_TIP` macros

> [!NOTE]  
> Although Happy Hare has defensive logic to always return the toolhead to the correct position it may do this slowly because it is only anticipating a z\_hop movement. A common problem is that the `_MMU_POST_LOAD` does not restore the X/Y toolhead position correctly leading to this strange slow movement.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Tip Forming
Tip forming is necessary to ensure the end of the filament will pass through the MMU and extruder on subsequent loads. There are two primary methods: tip-shaping and tip-cutting. They are mutually exclusive and you choose one based on your seting and point to the macro by changing `form_tip_macro` in `mmu_parameters.cfg`

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) \_MMU\_FORM\_TIP
**Defined in `form_tip.cfg`**

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
# Unloading and Ramming values - Initial moves to form and shape tip
variable_unloading_speed_start: 80     # Fast here to seperate the filament from meltzone (Very intitial retract SS uses distance of E-15)
variable_unloading_speed: 20           # Too fast forms excessively long tip or hair. Slow is better here UNLOADING_SPEED_START/COOLING_MOVES seems a good start
variable_ramming_volume: 0             # in mm3 SS default values = 2, 5, 9, 13, 18, 23, 27. Only Used to Simulate SS Ramming during standalone
variable_ss_ramming: 0                 # Set to 0 for standalone ramming (RAMMING_VOLUME) or tuning, 1 to let the slicer do it (i.e. turn off standalone)

# Cooling Move Values - To cool the tip formed and separate from strings
variable_cooling_tube_position: 35     # Dragon ST: 35, Dragon HF: 30, Mosquito: 30, Revo: 35, Phaetus Rapido HF: 43;  Measured from Top of Heater Block to Top of Heatsink
variable_cooling_tube_length: 10       # Dragon ST: 15, Dragon HF: 10, Mosquito: 20, Revo: 10, Phaetus Rapido HF: 22; Measured from Nozzle to Top of Heater Block
variable_initial_cooling_speed: 10     # Slow to solidify tip and cool string if formed.
variable_final_cooling_speed: 50       # High speed break the string formed. Too fast = tip deformation during eject. Too Slow = long string/no seperation
variable_toolchange_temp: 0            # Used if you want to lower temp during toolchanges default 0
variable_cooling_moves: 4              # 2-4 is a good start

# SkinnyDip values - To burn off VERY FINE hairs only (This is NOT for long tip reshaping)
variable_use_skinnydip: 1              # Tune this LAST, this is for removal of VERY FINE hairs only (Different than a long tip)
variable_skinnydip_distance: 30        # Start just under Cooling_tube_position and increase - Will depend on how much Ramming Volume is used
variable_dip_insertion_speed: 30       # Medium-Slow - Just long enough to melt the fine hairs. Too slow will pull up molten filament
variable_dip_extraction_speed: 70      # Around 2x Insertion speed, Prevents forming new hairs
variable_melt_zone_pause: 0            # in milliseconds - default 0
variable_cooling_zone_pause: 0         # in milliseconds - default 0 - If you need to adjust here its possible Dip Insertion too slow
variable_use_fast_skinnydip: 0         # Skip the toolhead temp change during skinnydip move - default 0

# Park filament ready to eject
variable_parking_distance: 35          # Final filament parking position after final cooling move, 0 will leave filament where it naturally ends up

# Final Eject - for standalone tuning only. Automatically set by `MMU_FORM_TIP` command
variable_final_eject: 0                # default 0, enable during standalone tuning process to eject the filament
```

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) \_MMU\_CUT\_TIP
**Defined in `cut_tip.cfg`**

To elminate the need to spend time tuning the tip forming procedure (you never wanted to understand fluid dynamics, right?!) you can opt to cut filament at the toolhead. The filametrix cutter bundled with ERCFv2 is an example of this. Note that Happy Hare can only have one tip creation macro defined. You can switch from the default tip forming to this tip cutting macro by setting `form_tip_macro: _MMU_CUT_TIP` in `mmu_parameters.cfg` to point to this macro instead.

Here are the default values for tip cutting with explanation:

```yml
###########################################################################
# Happy Hare supporting macros
#   Standalone Tip Cutting for Filametrix and toolhead cutters
#
# To configure, set
#   'form_tip_macro: _MMU_CUT_TIP' in 'mmu_parameters.cfg'
#
# Default configuration is good for Stealthburner with CW2 and Voron Revo nozzle
#
# IMPORTANT:
#   The park position of the filament is relative to the nozzle and
#   represents where the end of the filament is after cutting. The park position
#   is important and used by Happy Hare both to finish unloading the extruder
#   as well as to calculate how far to advance the filament on the subsequent load.
#   It is important to report back the position your cutter leaves the filament
#   in the extruder via the variable 'output_park_pos'.
#
#   This can be set dynamically in gcode with this construct:
#     SET_GCODE_VARIABLE MACRO=_MMU_CUT_TIP VARIABLE=output_park_pos VALUE=..
#   or preset as a variable on the macro like this:
#     'variable_output_park_pos: 35'
#
# When using this macro it is important to turn off tip forming in your slicer and
# force Happy Hare to always run this when loading filament by adding:
#   'force_form_tip_standalone: 1' in 'mmu_parameters.cfg'
#
[gcode_macro _MMU_CUT_TIP]
description: Cut filament by pressing the cutter on a pin with a horizontal movement

# This should be set to the distance from the internal nozzle tip to the cutting blade and is used in calculations on the
# final location of the filament end (output_park_pos) and remaining filament fragment size (output_remaining_filament)
# for use by Happy Hare
variable_blade_pos: 37.5

# Distance to retract prior to making the cut, this reduces wasted filament but might cause clog 
# if set too large and/or if there are gaps in the hotend assembly 
# This must be less than 'balde_pos' - the distance from the nozzle to the cutter 
variable_retract_length: 32.5

# The location of the pin, this should be the position of the toolhead when the cutter 
# just lightly touches the pin
variable_pin_loc_x: 14
variable_pin_loc_y: 250

# The starting and end positions when making the cut
# In particular, instead of making the cut by traveling to the pin location above, 
# we leave a small safety margin along X-axis to avoid scratching on the pin when traveling
# This should also give a small distance to produce some momentum when pressing on the pin 
variable_pin_park_x_dist: 5.0

# Position of the toolhead when the cutter is fully compressed
# Should leave a small headroom (e.g., should be a bit larger than 0, or whatever xmin is) to avoid banging the toolhead or gantry
variable_pin_loc_x_compressed: 0.5
variable_pin_loc_x_compressed: 0.5

# Retract length and speed after the cut so that the cutter can go back into its origin position
variable_rip_length: 1                  # Distance to retract to aid lever decompression (>= 0)
variable_rip_speed: 3                   # mm/s

# Pushback of the remaining tip from the cold end into the hotend. Cannot be larger than 'retract_length'
variable_pushback_length: 5
variable_pushback_dwell_time: 0         # Time to dwell after the pushback

# Speed related settings
# Note that if the cut speed is too fast, the steppers can lose steps. Therefore, for a cut: 
# - We first make a fast move to accumulate some momentum and get the cut blade to the initial contact with the filament
# - We then make a slow move for the actual cut to happen 
variable_travel_speed: 150              # mm/s
variable_cut_fast_move_speed: 32        # mm/s
variable_cut_slow_move_speed: 8         # mm/s
variable_evacuate_speed: 150            # mm/s
variable_cut_dwell_time: 50             # Time to dwell at the cut point in ms
variable_cut_fast_move_fraction: 1.0    # Fraction of the move that uses fast move 

variable_extruder_move_speed: 25        # mm/s for all extruder movement

# Safety margin for fast vs slow travel
# When traveling to the pin location, we make a safer but longer move if we closer to the pin than this specified margin
# Usually setting these to the size of the toolhead (plus a small margin) should be good enough 
variable_safe_margin_x: 30
variable_safe_margin_y: 30

# If gantry servo option is installed, enable the servo and set up and down angle positions
variable_gantry_servo_enabled: 0
variable_gantry_servo_down_angle: 55
variable_gantry_servo_up_angle: 180

# Testing only: Whether to eject the filament at the end
variable_final_eject: 0                 # Don't leave enabled!

# -------------------------- Internal Don't Touch -------------------------
variable_output_park_pos: 0             # Dynamically set in macro
```

> [!NOTE]  
> The `output_park_pos` variable is used to pass the resultant position of the filament back to Happy Hare and in this reference macro it is set dynamically.
