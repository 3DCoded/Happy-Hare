#### Page Sections:
- [Multiple MMUs](#---multiple-mmus)
#  - [Off](#mode-off)
#  - [Readonly](#mode-readonly)
#  - [Push (local gate map)](#mode-push)
#  - [Pull (remote gate map)](#mode-pull)
- [Setting up "touch" on multiple gear steppers](#---touch-homing-on-multiple-gear-steppers)

This page explains more complex setup of multiple MMU's and the setup of "touch" homing operation for multiple gear steppers

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Multiple MMUs

Since v3.0.2 Happy Hare is able to support multiple MMU's multiplexed together to form a single unit. The most common situation is the combining of multiple type-B MMU's like Box Turtle or Night Owl together. So long as the units are fundamentally similar in operation (techinically share the same `mmu_parmeters.cfg`) they can be combined.  I.e. you cannot combine an ERCF with a BoxTurtle (at lest not yet - that support is planned in the future).

To combine MMU's you would connect the bowden output from each to a combiner/splitter which merges them together before the toolhead. You then need to make them look like a logical larger MMU by adjusting configuration as described here.

> [!NOTE]  
> The Happy Hare installer can only be used to setup the first MMU. You will need to augment `mmu_hardware.cfg` manually with the configuration for additional units

### Adjust `num_gates`

Normally `num_gates` is an integer representing the number of gates/lanes on your MMU. To support multiple units you simply specify a comma separated list with the number of gates in each unit. For example, if you have two Box Turtle with 4 gates each, you would specify:
```yml
[mmu_machine]
num_gates: 4,4
```
Happy Hare will see this as a 8-gate MMU but will know it is broken into two units.

### Variable Bowden Lenghts

Since you are connecting different MMU's together the bowden length of each will be different. Therefore it is necessary to tell Happy Hare that each bowden length can be different by (uncommenting and) setting:
```yml
variable_bowden_lengths: 1             # 1 = If MMU design has different bowden lengths per gate, 0 = bowden length is the same
```

### Define extra gear steppers

Extend the definiton of gear steppers for additional units in the same way you did for the first unit. Make sure the gate/lane numbering is contiguous.

```yml
# Filament Drive Gear_4 --------------------------
[tmc2209 stepper_mmu_gear_4]
uart_pin: mmu2:MMU_GEAR_UART_4

[stepper_mmu_gear_4]
step_pin: mmu2:MMU_GEAR_STEP_4
dir_pin: !mmu2:MMU_GEAR_DIR_4
enable_pin: !mmu2:MMU_GEAR_ENABLE_4
```
> [!IMPORTANT]  
> It is unlikely that you have spare pins on your existing MMU thus you will also need to configure the additional mcu and create aliases (`mmu2` is used in this example) or specify the additional pins directly in the config file. Aliases are recommended so you might want to add another section to `mmu.cfg` with new pins

### `[mmu_sensors]`

A default Happy Hare setup will define a single pin for each sensor. However in a multi-mmu setup it is possible for some sensors to be "per-unit". These include: `gate_switch_pin`, `sync_feedback_tension_pin` and `sync_feedback_compression_pin`. For these sensors you can specify a list of pins in the order of MMU units. For example, here is a setup for 2x Box Turtle each with it's own "hub" aka gate_sensor and "turtle neck" aka sync-feedback sensors:
```yml
[mmu_sensors]
pre_gate_switch_pin_0: ^mmu:MMU_PRE_GATE_0
pre_gate_switch_pin_1: ^mmu:MMU_PRE_GATE_1
pre_gate_switch_pin_2: ^mmu:MMU_PRE_GATE_2
pre_gate_switch_pin_3: ^mmu:MMU_PRE_GATE_3

pre_gate_switch_pin_4: ^mmu2:MMU_PRE_GATE_4
pre_gate_switch_pin_5: ^mmu2:MMU_PRE_GATE_5
pre_gate_switch_pin_6: ^mmu2:MMU_PRE_GATE_6
pre_gate_switch_pin_7: ^mmu2:MMU_PRE_GATE_7

post_gear_switch_pin_0: ^mmu:MMU_POST_GEAR_0
post_gear_switch_pin_1: ^mmu:MMU_POST_GEAR_1
post_gear_switch_pin_2: ^mmu:MMU_POST_GEAR_2
post_gear_switch_pin_3: ^mmu:MMU_POST_GEAR_3

post_gear_switch_pin_4: ^mmu2:MMU_POST_GEAR_4
post_gear_switch_pin_5: ^mmu2:MMU_POST_GEAR_5
post_gear_switch_pin_6: ^mmu2:MMU_POST_GEAR_6
post_gear_switch_pin_7: ^mmu2:MMU_POST_GEAR_7

# There are optionally per-unit lists:
gate_switch_pin: ^mmu:MMU_GATE_SENSOR, ^mmu2:MMU_GATE_SENSOR
sync_feedback_tension_pin: ^mmu:MMU_TENSION_SENSOR, ^mmu2:MMU_TENSION_SENSOR
sync_feedback_compression_pin: ^mmu:MMU_COMPRESSION_SENSOR, ^mmu2:MMU_COMPRESSION_SENSOR

extruder_switch_pin: ^EXTRUDER_SENSOR
toolhead_switch_pin: ^TOOLHEAD_SENSOR
```
Note that if you MMU setup had a `gate_sensor` after the final filament combiner and not one per-MMU then simple specify a scalar value and not a list

> [!NOTE]  
> Per unit sensor are named with a `unit_X_` prefix, so the gate sensor for unit 1 would be `unit_1_mmu_gate`<br>
> All defined sensors can be seen in Mainsail/Fluidd UI and can be dynamically enabled/diabled. If disabled, Happy Hare will treat them as non-existent and modify behavior to work as if they were never present. This can be useful during a print to temporarily disable a troublesome sensor.

### LED configuration

LED setup is explained on the [LED Support](#Led-Support) page but essentially you have complete freedom to define a set of LEDs. Happy Hare will form "virtual chains" that are used for effects but doesn't care if they are bits of other chains, individual LEDs or care about order. In a multi-MMU setup you simply define as a single set. E.g. The following creates a virtual chain of 8 gates for "exit" LEDs using a neopixel strip for the first MMU in reverse other and then using individual LEDs on the second unit.
```yml
[mmu_leds]
   exit_leds: neopixel:bt_1 (4-1)
              neopixel:bt_2a
              neopixel:bt_2b
              neopixel:bt_2c
              neopixel:bt_2d
```

### MMU Status

Once you have correctly setup as above you should see the bootup and `MMU_STATUS` refect the different units like so:
```
Unit : ------- 0 -------   ------- 1 -------   --- 2 ---
Gate : | 0 | 1 | 2 | 3 |   | 4 | 5 | 6 | 7 |   | 8 | 9 |
Tools: |T0 |T1 |T2 |T3 |   |T4 |T5 |T6 |T7 |   |T8 |T9 |
Avail: | * |   | * | * |   | * | * | * |   |   | B |   |
Selct: |\ /|------------   -----------------   --------- T0
[T0] > (g) .......... ( ) .. [Ex ... Nz] UNLOADED 0.0mm
```
Or another with 2x Box Turtles and 1x Night Owl:
```
Unit : ------- 0 -------   ------- 1 -------   --- 2 ---
Gate : | 0 | 1 | 2 | 3 |   | 4 | 5 | 6 | 7 |   | 8 | 9 |
Tools: |T0 |T1 |T2 |T3 |   |T4 |T5 |T6 |T7 |   |T8 |T9 |
Avail: | * |   | * | * |   | * | * | * |   |   | B |   |
Selct: ------------|\*/|   -----------------   --------- T0
[T1] > (g) >>>>>>>>>> (*) >> [Ex >>> Nz] LOADED 0.0mm
```

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) "touch" homing on multiple gear steppers

Happy Hare has a experimental gear "touch" homing for detection of hitting the extruder. It is possible to configure this on a type-B MMU with multiple gear steppers by extending each additional stepper motor with the necessary `DIAG` pin and `extra_endstop` setup. This is best illustrated with a TMC2209 example where the first stepper (gate 0) is configured as per the doc. Each subsequent gear stepper would require addition attributes to define the stallguard endstop with the gate number as part of the endstop name:

```
[tmc2209 stepper_mmu_gear]
:
diag_pin: ^mmu:MMU_GEAR_DIAG            # Set to MCU pin connected to TMC DIAG pin for gear stepper
driver_SGTHRS: 60                       # 255 is most sensitive value, 0 is least sensitive

[stepper_mmu_gear]
:
extra_endstop_pins: tmc2209_stepper_mmu_gear:virtual_endstop
extra_endstop_names: mmu_gear_touch

# ADDITIONAL FILAMENT DRIVE GEAR STEPPERS FOR TYPE-B MMU's -------------------------------------------------------------
# Filament Drive Gear_1 --------------------------
[tmc2209 stepper_mmu_gear_1]
:
diag_pin: ^mmu:MMU_GEAR_DIAG_1
driver_SGTHRS: 60

[stepper_mmu_gear_1]
:
extra_endstop_pins: tmc2209_stepper_mmu_gear_1:virtual_endstop
extra_endstop_names: mmu_gear_touch_1

# Filament Drive Gear_2 --------------------------
[tmc2209 stepper_mmu_gear_2]
:
diag_pin: ^mmu:MMU_GEAR_DIAG_2
driver_SGTHRS: 60

[stepper_mmu_gear_2]
:
extra_endstop_pins: tmc2209_stepper_mmu_gear_2:virtual_endstop
extra_endstop_names: mmu_gear_touch_2

etc...
```
As with mutli-mmu support, Happy Hare will select the correct "touch" endstop based on the currently selected gate and thus associated stepper. I.e. a name of `mmu_gear_touch` is automatically interpreted as `mmu_gear_touch_2` if gate 2 is the one selected.

