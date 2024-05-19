*TODO - Remove config file layout and link to outline page*
#### Page Sections:
- [Klipper Config](Hardware-Configuration#step-1-validate-your-hardware-configuration)
- [Endstops](Hardware-Configuration#step-2-check-endstops--optional-sensors)
- [Motor Movement](Hardware-Configuration#step-3-check-motor-movement-and-direction)
- [Encoder](Hardware-Configuration#step-4-check-encoder-if-fitted)
- [Other Sensors](Hardware-Configuration#step-5-check-other-sensors-if-fitted)
- [Servo](Hardware-Configuration#step-6-check-servo)

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Hardware configuration (mmu_hardware.cfg explained)

This will vary slightly depending on your particular brand of MMU but the steps are essentially the same with some being dependent on hardware configuration.

The Klipper configuration files for Happy Hare are modular and where to find them is discussed in the [Configuration Reference](Configuration-Reference). Also be sure to consult the [Configuring mmu\_hardware.cfg](Configuring-mmu_hardware.cfg) page for details about each and every parameter.

<br>

## Step 1. Validate you hardware configuration

### a) MCU and Pin Validation (mmu.cfg)
The `mmu.cfg` file is part of the hardware configuration but defines aliases for all of the pins used in `mmu_hardware.cfg`. The benefit of this is that configuration frameworks like [Klippain](https://github.com/Frix-x/klippain) can more easily incorporate. It is also in keeping with an organized modular layout.

<br>

### b) Hardware Configuration (mmu_hardware.cfg):
This can be daunting but the interactive installer will make the process easier for common mcu's designed for a MMU (e.g. ERCF EASY-BRD, Burrows ERB, etc) and perform most of the setup for you. A few tweaks remain and include the setting of endstop options, optional extruder "touch" homing as the usual pin invert checking, etc.

Endstop setup and options can be found in [Movement and Homing](Movement and Homing)

Note that all sensors can be setup with a simple section in `mmu_hardware.cfg`. This ensures things are setup correctly and only requires you to supply the pins. There is no need to comment out if not used, you can leave the pin empty or reference an empty alias. In those cases the sensor will be ignored

```yml
# FILAMENT SENSORS ---------------------------------------------------------------------------------------------------------
# Define the pins for optional sensors in the filament path. All but the pre-gate sensors will be automatically setup as
# both endstops (for homing) and sensors for visibility purposes.
#
# 'pre_gate_switch_pin_X' .. 'mmu_pre_gate_X` sensor detects filament at entry to MMU. X=gate number (0..N)
# 'gate_switch_pin'       .. 'mmu_gate' sensor detects filament at the gate of the MMU
# 'toolhead_switch_pin'   .. 'toolhead' sensor detects filament after extruder entry
# 'extruder_switch_pin'   .. 'extruder' sensor detects filament just before the extruder entry
#
# Sync motor feedback will typically have a tension switch (more important) or both tension and compression
# 'sync_feedback_tension_pin'     .. pin for switch activated when filament is under tension
# 'sync_feedback_compression_pin' .. pin for switch activated when filament is under compression
#
# Simply define pins for any sensor you want to enable, if pin is not set (or the alias is empty) it will be ignored (can also comment out)
#
[mmu_sensors]
pre_gate_switch_pin_0: ^mmu:MMU_PRE_GATE_0
pre_gate_switch_pin_1: ^mmu:MMU_PRE_GATE_1
pre_gate_switch_pin_2: ^mmu:MMU_PRE_GATE_2
pre_gate_switch_pin_3: ^mmu:MMU_PRE_GATE_3

gate_switch_pin: ^mmu:MMU_GATE_SENSOR
extruder_switch_pin:
toolhead_switch_pin:

sync_feedback_tension_pin:
sync_feedback_compression_pin:
```

<br>

### c) Variables file (mmu_vars.cfg):
This is the file where Happy Hare stores all calibration settings and state. It is pointed to by this section at the top of `mmu_software.cfg`:

```
[save_variables]
filename: /home/pi/printer_data/config/mmu/mmu_vars.cfg
```

Klipper can only have one `save_variables` file and so if you are already using one you can simply comment out the lines above and Happy Hare will append into your existing "variables" file.

If all other pin's and setup look correct *RESTART KLIPPER* and proceed to step 2.

<br>

## Step 2. Check endstops & Optional sensors
Verify that the necessary endstops are working and the polarity is correct. The recommended procedure is:

```yml
MMU_MOTORS_OFF
  # remove filament from ERCF and extruder, move selector to center of travel
QUERY_ENDSTOPS
  # or use the visual query in Mainsail or Fluuid
```
Validate that you can see:

```yml
mmu_sel_home:open (Essential)
toolhead:open (Optional if you have a toolhead sensor)
```
Then manually press and hold the selector microswitch and rerun `QUERY_ENDSTOPS`.<br>
Validate that you can see `mmu_sel_home:TRIGGERED` in the list.<br>
If you have toolhead sensor, feed filament into the extruder past the switch and rerun `QUERY_ENDSTOPS`.<br>
Validate that you can see `toolhead:TRIGGERED` in the list.

If either of these don't change state then the pin assigned to the endstop is incorrect.  If the state is inverted (i.e. enstop transitions to `open` when pressed) the add/remove the `!` on the respective endstop pin either in the `[stepper_mmu_selector]` block for selector endstop or in `[filament_switch_sensor toolhead_sensor]` block for toolhead sensor.

Other endstops like "touch" operation are advanced and are not cover by this inital setup.

<br>

## Step 3. Check motor movement and direction
Once pins are correct it is important to verify direction.  It is not possible for the installer to ensure this because it depends on the actual stepper wiring.  The recommended procedure is:
```yml
MMU_MOTORS_OFF
  # move selector to the center of travel
MMU_HOME
  # verify that the selector moves to the left towards the home position
```
If the selector doesn't move or moves the wrong way open up `mmu_hardware.cfg`, find the section `[stepper_mmu_selector]`:<br>
If selector doesn't move it is likley that the pin configuration for `step_pin` and/or `enable_pin` are incorrect. Verify the pin names and prefix the pin with `!` to invert the signal. E.g.
```yml
enable_pin: !mmu:MMU_SEL_ENABLE
  # or
enable_pin: mmu:MMU_SEL_ENABLE
```
If the selector moves the wrong way the `dir_pin` is inverted. Either add or remove the `!` prefix:
```yml
dir_pin: !mmu:MMU_SEL_DIR
  # or
dir_pin: mmu:MMU_SEL_DIR
```

Now repeat the exercise with the gear stepper:
```yml
MMU_MOTORS_OFF
  # remove any filament from your MMU
MMU_TEST_MOVE MOVE=100 SPEED=50
  # verify that the gear stepper would pull filament towards the extruder
MMU_TEST_MOVE MOVE=-100 SPEED=50
  # verify that the gear stepper is push filament away from the extruder
```
If the gear stepper doesn't move or moves the wrong way open up `mmu_hardware.cfg`, find the section `[stepper_mmu_gear]`:<br>
If gear doesn't move it is likley that the pin configuration for `step_pin` and/or `enable_pin` are incorrect. Verify the pin names and prefix the pin with `!` to invert the signal. E.g.
```yml
enable_pin: !mmu:MMU_GEAR_ENABLE
  # or
enable_pin: mmu:MMU_GEAR_ENABLE
```
If the gear moves the wrong way the `dir_pin` is inverted. Either add or remove the `!` prefix:
```yml
dir_pin: !mmu:MMU_GEAR_DIR
  # or
dir_pin: mmu:MMU_GEAR_DIR
```

<br>

## Step 4. Check Encoder (if fitted)
If you have an encoder based design like the ERCF, need to check that it is wired correctly. Run the command `MMU_ENCODER` and note the position displayed.
```yml
MMU_ENCODER
Encoder position: 23.4
```
Insert some filament (from either side) and pull backwards and forwards.  You should see the LED flashing.  Rerun `MMU_ENCODER` and validate the position displayed has increased (note that the encoder is not direction aware so it will always increase in reading)

If the encoder postion does not change, validate the `encoder_pin` is correct. It shouldn't matter if it has a `!` (inverted) or not, but it might require a `^` (pull up resister) to function.
```yml
[mmu_encoder mmu_encoder]
encoder_pin: ^mmu:MMU_ENCODER	
```

<br>

## Step 5. Check other sensors (if fitted)
Other sensors are generally filament sensors and act on a switch. The easiest way to check these is to run something similar to the following for each sensor/switch.
```yml
QUERY_FILAMENT_SENSOR SENSOR=mmu_gate_sensor
Filament Sensor mmu_gate_sensor: filament not detected
```

Activate the sensor with a piece of filament and run again:
```yml
QUERY_FILAMENT_SENSOR SENSOR=mmu_gate_sensor
Filament Sensor mmu_gate_sensor: filament detected
```

Note thatFrequently enstops / filament sensors that are wired normally open (NO) require `^` (pull up resister) to correctly function.

<br>

## Step 6. Check Servo
Ok, last sanity check.  Check that the servo you have fitted is operational. Run this simple commmand.  The servo should waggle somewhere short of the configured 'up' and 'down' positions.  Don't worry yet about calibration. That comes next.

```yml
MMU_TEST_BUZZ_MOTOR MOTOR=servo
```

You can also try:
```yml
MMU_SERVO POS=down
MMU_SERVO POS=up
```

<br>

### More essential config setup:
[Movement and Homing](Toolchange-Movement)
[Happy Hare Parameters](Happy-Hare-Parameters)
[Macro Configuration](Macro-Configuration)
