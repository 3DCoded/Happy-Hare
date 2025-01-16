#### Page Sections:
- [Wiring](#---wiring)
- [Hardware Config](#---hardware-config)
- [Controlling LED Effects](#---controlling-led-effects)
- [Summary of Default Effects](#---summary-of-default-effects)

Happy Hare now can drive LEDs (NeoPixel/WS2812) on your MMU to provide both functional feedback as well as to add a little bling to your machine.  Typically you would connect a string of neopixels (either descrete components or an LED strip, or combination of both if compatible contollers) to the neopixel output on the MCU that drives your MMU although this can be changed.

The setup for LED's is contained at the bottom of the `mmu_hardware.cfg` file. If you would like you use LED animation you must also install the [LED Effects for Klipper](https://github.com/julianschill/klipper-led_effect). If this module is not installed, more static LED changes can be employed.

> [!IMPORTANT]  
> This page has been updated for the v3.0.2 beta (`multi_mmu` branch). Read the text in the `mmu_hardware.cfg` file for the differences with v3.0.1 and earlier

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Wiring

<p align=center><img src="Led-Support/led_connection.jpg" alt='LED Connection' width='80%'></p>

LED strips can be formed but soldering together individual neopixels or using pre-made strips.  You can also mix the two but if the "RGBW" order is different you must specify `color_order` as a list with the correct spec for each LED.  There is complete flexibility in how the LEDs are connected because Happy Hare creates a virtual chain of all the components. Segments can even be joined in parallel to drive two LED's for the same index number.  The only important concept is that when specifying the virtual chain representing gates the LEDs must be contiguous (ascending or decending).

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Hardware Config
  If you have run the Happy Hare installer it should have added a section to the end of your `mmu_hardware.cfg` that starts like this:

```yml
# MMU OPTIONAL NEOPIXEL LED SUPPORT ------------------------------------------------------------------------------------
# Define the led connection, type and length
#
# (comment out this section if you don't have leds or have them defined elsewhere)
[neopixel mmu_leds]
pin: mmu:MMU_NEOPIXEL
chain_count: 17            # Number gates x1 or x2 + 1 (if you want status)
color_order: GRBW          # Set based on your particular neopixel specification
```
This section may be all commented out, if so and you wish to configure LEDS and don't have them configured elsewhere, uncomment the entire section and ensure that the `MMU_NEOPIXEL` pin is correctly set in the aliases in `mmu.cfg` and that the `color_order` matches your particular LED (don't mix type or if you do, set to a comma separated list of the type of each led in the chain. e.g. "GRB, GRB, GRB, RGBW, RGBW, RGBW").  Note that you must also install "Klipper LED Effects" plugin.

The wiring of LED's is very flexible and doesn't have to be in a chain controlled by the same pin. You can mix multiple chains, individual LEDs, change the order, or choose leds from an existing chain. The reason is that Happy Hare creates "virtual" chains with the `[mmu_leds]` section below for each of these segments: "entry", "exit", "status" and "logo" for easy configuration and control:
```yml
# MMU LED EFFECT SEGMENTS ----------------------------------------------------------------------------------------------
# Define neopixel LEDs for your MMU. The chain_count must be large enough for your desired ranges:
#   exit   .. this set of LEDs, one for every gate, usually would be mounted at the exit point of the gate
#   entry  .. this set of LEDs, one for every gate, could be mounted at the entry point of filament into the MMU/buffer
#   status .. these LED. represents the status of the MMU (and selected filament). More than one status LED is possible
#   logo   .. these LEDs don't change during operation and are designed for driving a logo. More than one logo LED is possible
#
# Note that all sets are optional. You can opt to just have the 'exit' set for example. The advantage to having
# both entry and exit LEDs is, for example, so that 'entry' can display gate status while 'exit' displays the color
# 
# The animation effects requires the installation of Julian Schill's awesome LED effect module otherwise the LEDs
# will be static:
#   https://github.com/julianschill/klipper-led_effect
#
# LED's are indexed in the chain from 1..N. Thus to set up LED's on 'exit' and a single 'status' LED on a 4 gate MMU:
#
#    exit_leds:   neopixel:mmu_leds (1,2,3,4)
#    status_leds: neopixel:mmu_leds (5)
#
# In this example no 'entry' set is configured. Note that constructs like "mmu_leds (1-3,4)" are also valid
#
# The range is completely flexible and can be comprised of different led strips, individual LEDs, or combinations of
# both on different pins. In addition, the ordering is flexible based on your wiring, thus (1-4) and (4-1) both represent
# the same LED range but mapped to increasing or decreasing gates respectively. E.g if you have two Box Turtle MMUs, one
# with a chain of LEDs wired in reverse order and another with individual LEDs, to define 8 exit LEDs:
#
#   exit_leds: neopixel:bt_1 (4-1)
#              neopixel:bt_2a
#              neopixel:bt_2b
#              neopixel:bt_2c
#              neopixel:bt_2d
#
# Note the use of separate lines for each part of the definition,
#
# ADVANCED: Happy Hare provides a convenience wrapper [mmu_led_effect] that not only creates an effect on each of the
# [mmu_leds] specified segments as a whole but also each individual LED for atomic control. See mmu_leds.cfg for examples
#
# (comment out this section if you don't have/want leds)
[mmu_leds]
exit_leds:
entry_leds:
status_leds:
logo_leds:
frame_rate: 24
```
Some examples of how to set these values can be seen in this illustration (ERCFv2 MMU example):
<p align=center><img src="Led-Support/led_configuration.png" alt='LED Configuration' width='100%'></p>

> [!NOTE]  
> All the default LED effects are defined in the read-only `mmu_leds.cfg`.  You can create your own but be careful and note the `[mmu_led_effect]` definition - this is a wrapper around `[led_effect]` that will create the effect on the specified LED range (segment) but also duplicate the effect on each LED individually.  This is especially useful on the MMU where you want per-gate effects.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Controlling LED Effects
Happy Hare LED effects are 100% implemented in `mmu_leds.cfg` as macros so you can review if you want to tweak and create your own modifications.  I would caution that you make sure you understand the logic before doing so, and in most cases you may just want to tweak the effects defined in `mmu_macro_vars.cfg` to customize.  The macros work by intercepting changes of the Happy Hare's print state machine, changes in actions it is performing and changes to the "gate_map" containing gate status and filament color.

You can change default effect or enable/disable in `mmu_macro_vars.cfg` under the `_MMU_LED_VARS` macro:
```yml
# LED CONTROL -------------------------------------------------------------
# ██╗     ███████╗██████╗ ███████╗
# ██║     ██╔════╝██╔══██╗██╔════╝
# ██║     █████╗  ██║  ██║███████╗
# ██║     ██╔══╝  ██║  ██║╚════██║
# ███████╗███████╗██████╔╝███████║
# ╚══════╝╚══════╝╚═════╝ ╚══════╝
# Only configure if you have LEDs installed. The led_effects option is
# automatically ignored if led-effects klipper module is not installed
#   (base/mmu_led.cfg)
#
[gcode_macro _MMU_LED_VARS]
description: Happy Hare led macro configuration variables
gcode: # Leave empty

# Default effects for LED segments when not providing action status
#   'off'             - LED's off
#   'on'              - LED's white
#   'gate_status'     - indicate gate availability / status            (printer.mmu.gate_status)
#   'filament_color'  - display filament color defined in gate map     (printer.mmu.gate_color_rgb)
#   'slicer_color'    - display slicer defined set color for each gate (printer.mmu.slicer_color_rgb)
#   'r,g,b'           - display static r,g,b color e.g. "0,0,0.3" for dim blue
#   '_effect_'        - display the named led effect
#
variable_led_enable             : True                  ; True = LEDs are enabled at startup (MMU_LED can control), False = Disabled
variable_led_animation          : True                  ; True = Use led-animation-effects, False = Static LEDs
variable_default_exit_effect    : "gate_status"         ;    off|gate_status|filament_color|slicer_color|r,g,b|_effect_
variable_default_entry_effect   : "filament_color"      ;    off|gate_status|filament_color|slicer_color|r,g,b|_effect_
variable_default_status_effect  : "filament_color"      ; on|off|gate_status|filament_color|slicer_color|r,g,b|_effect_
variable_default_logo_effect    : "0,0,.3"              ;    off                                        |r,g,b|_effect_
variable_white_light            : (1, 1, 1)             ; RGB color for static white light
variable_black_light            : (.01, 0, .02)         ; RGB color used to represent "black" (filament)
variable_empty_light            : (0, 0, 0)             ; RGB color used to represent empty gate
```
To change the default effect for a segment edit the appropriate line. These effects can be any of the built-in functional defaults, any named effect you define, or even an RGB color specification in the form `red,green,blue` e.g. `0.5,0,0.5` would be 50% intensity red and blue with no green.

Happy Hare also has a command to control LEDs:

```yml
> MMU_LED
LEDs are enabled
LED animations: enabled
Default exit effect: 'gate_status'
Default entry effect: 'filament_color'
Default status effect: 'filament_color'
Default logo effect: '0,0,.3'

Options:
ENABLE=[0|1]
ANIMATION=[0|1]
EXIT_EFFECT=[off|gate_status|filament_color|slicer_color|r,g,b|_effect_]
ENTRY_EFFECT=[off|gate_status|filament_color|slicer_color|r,g,b|_effect_]
STATUS_EFFECT=[off|on|filament_color|slicer_color|r,g,b|_effect_]
LOGO_EFFECT=[off|r,g,b|_effect_]
```
You can change the effect at runtime, e.g. `MMU_LED ENTRY_EFFECT=gate_status` or `MMU_LED ENABLE=0` to turn off and disable the LED operation.  Please note that similarly to `MMU_TEST_CONFIG` changes made like this don't persist on a restart.  Update the macro variables in `mmu_macro_vars.cfg` to make changes persistent.

The `slicer_color` is not persisted and can be set with the command `MMU_SLICER_TOOL_MAP GATE=.. COLOR=..` as is the case in the recommended `MMU_START_SETUP` macro. The color can be a w3c color name or `RRGGBB` value.

> [!TIP]
> The strongly recommended Happy Hare version of Klipperscreen has buttons to quickly "toggle" between `gate_status` and `filament_color` for the default gate effect...<br>
> If you want to reduce load on your system but still support LEDs then you can opt to turn off the animations by setting `variable_led_animation_enable` or using `MMU_LED ANIMATION=0`. This mode will automatically be inforced if the klipper-led\_effects module is not installed.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Summary of Default Effects
The default effects, which are both functional as well as adding a little color, are summerized here. The logo LED is typically a static RGB color::

  | State            | Filament Entry LEDs<br>(typically gate loading) | Filament Exit LEDs<br>(to bowden tube) | Status LED |
  | ---------------- | ----------------------------------------------- | -------------------------------------- | ---------- |
  | MMU Disabled     | OFF                                             | OFF                                    | OFF        |
  | Filament Loaded  |                                                 |                                        | Dim Blue   |
  |||||
  | **MMU Print States:** ||||
  | "initialization" | OFF                                             | `Shooting stars`<br>(for 3 seconds)    | OFF        |
  | "ready"          | _default_                                       | _default_                              | _default_  |
  | "printing"       | _default_                                       | _default_                              | _default_<br>(Blue if loaded) |
  | "pause_locked"<br>(mmu pause)   | OFF                              | `Strobe`                               | `Strobe`   |
  | "paused"<br>(after unlock)      | OFF                              | Current gate: `Strobe`                 | `Strobe`   |
  | "completed"      | _default_                                       | `Sparkle`<br>(for 20 seconds)          | _default_  |
  | "cancelled"      | _default_                                       | _default_                              | _default_  |
  | "error"          | _default_                                       | `Strobe`<br>(for 20 seconds)           | _default_  |
  | "standby"        | OFF                                             | OFF                                    | OFF        |
  |||||
  | **Actions States:** ||||
  | "Loading"<br>(whole sequence)   |                                  | Current gate: `Slow Pulsing White`     | `Slow Pulsing Blue`  |
  | "Loading"<br>(toolhead)   |                                        |                                        | `Fast Pulsing Blue`  |
  | "Unloading"<br>(whole sequence) |                                  | Current gate: `Slow Pulsing White`     | `Slow Pulsing Blue`  |
  | "Unloading"<br>(toolhead)   |                                      |                                        | `Fast Pulsing Blue`  |
  | "Heating"        | _default_                                       | Current gate: `Pulsing Red`            | `Pulsing Red`        |
  | "Selecting"      | _default_                                       | `Fast Pulsing White`                   | OFF                  |
  | "Checking"       | _default_                                       | _default_                              | `Fast Pulsing White` |
  | "Idle"           | _default_                                       | _default_                              | _default_            |
  |||||
  | **Possible Defaults** | **default_entry_effect**:<br>- `gate_status`<br>- filament_color<br>- slicer_color<br>- off | **default_exit_effect**:<br>- `gate_status`<br>- filament_color<br>- slicer_color<br>- off | **default_status_effect**:<br>- filament_color<br>- slicer_color<br>- on (white)<br>- off |

In the table above, `Effect` designates effect (animation) rather than static color if `variable_led_animation_enable: True`

<br>

> [!NOTE]  
> - MMU Print State is the same as the printer variable `printer.mmu.print_state`
> - Action State is the same as the printer variable `printer.mmu.action`
> - These are built-in functional "effects":
>   - **filament_color** - displays the static color of the filament defined for the gate from MMU_GATE_MAP (specifically `printer.mmu.gate_color_rgb`). Requires you to setup color either directly or via Spoolman.
>   - **slicer_color** - dispays the static color of the filament defined in the slicer tool map (printer.mmu.slicer_color_rgb). Note this might be empty until a print starts.
>   - **gate_status** - dispays the status for the gate (printer.mmu.get_status): **red** if empty, **green** if loaded, **orange** if unknown

> [!TIP]  
> Whilst not LEDs, Mailsail and Fluidd have visualizations of the filament color next to the "extruder" `T0`, `T1`, `T2`, ... buttons. Happy Hare can drive these in various ways similar to LED visualization here. Read [Mainsail/Fluidd Integration](Mainsail-Fluidd-Integration) for more details
