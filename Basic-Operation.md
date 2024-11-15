#### Page Sections:
- [Console and Logging](#---console-and-logging)
- [KlipperScreen](#---klipperscreen-happy-hare)
- [Useful Pre-Print Operations](#---useful-pre-print-operations)
- [Filament Loading and Unloading](#---filament-loading-and-unloading-sequences)
- [Debugging Problems](#---debugging-problems)

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Console and Logging

Happy Hare controls the MMU mainly through Klipper command extensions but a few are implemented as macros. You can manage these commands buy typing then directly into a console like Mainsail or Fluidd or you can create macro buttons for easier operation. For the easiest control take a look at the [KlippeScreen Happy Hare Edition](#---klipperscreen-happy-hare) - it really does make operation a pleasure.

> [!NOTE]  
> A Mainsail module is also under development!

The result of operations is written to both the console and a custom Klipper log file called `mmu.log`. The verbosity of messages to these channels can be independently controlled. The verbosity levels in increasing order are:
- Essential messages only
- Information messages
- Debug messages
- Code trace messages
- Developer message including detailed stepper movement

The default config will display up to informational messages to the console and up to debug level to the log file. This is a good compormise of verbosity and information although you may wish to increase the verbosity while setting up your MMU. Remember you can also look at the log file to get more information than is displayed in the console.

The `mmu.log` logfile will be placed in the same directory as other Klipper log files. It will rotate and keep the last 5 versions (just like Klipper). Oh, and if you don't want the logfile, no problem, just set `logfile_level: -1` in `mmu_parameters.cfg` (anything on the console will end up in klipper.log anyway)

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) KlipperScreen Happy Hare

<p align="center"><img src="resources/mmu_main_printing.png" width="500" alt="KlipperScreen"></p>

Even if not a KlipperScreen user yet you might be interested in my fork of KlipperScreen [Github link](https://github.com/moggieuk/KlipperScreen-Happy-Hare-Edition) simply to control your MMU. It makes using your MMU the way it should be. Dare I say as easy at Bambu Labs ;-) I run mine with a standalone Raspberry Pi attached to my buffer array and can control multiple MMU's with it.

Be sure to follow the install directions carefully. The most up-to-date documention is included in this wiki [here](KlipperScreen) :tada:

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Useful Pre-Print Operations

There are a couple of commands (`MMU_PRELOAD` and `MMU_CHECK_GATE`) that are useful to ensure MMU readiness prior to printing.

### MMU\_PRELOAD

The `MMU_PRELOAD` is an aid to loading filament into the MMU.  The command works a bit like the Prusa's functionality and spins gear with servo depressed until filament is fed in.  It then parks the filament at the perfect postion in the gate. This is the recommended way to load filament into your MMU and ensures that filament is not under/over inserted potentially preventing pickup or blocking the gate.

> [!TIP]
> If you have pre-gate sensors installed they will automatically run this command when triggered outside of a print. This really helps with loading up your MMU. Note that if new filament is inserted while in a print it's presence will be noted but it will not be loaded.

### MMU\_CHECK\_GATE

Similarly the `MMU_CHECK_GATE` command will check the current gate (no options) or run through all the gates (`ALL=1`) or the one specified (`GATE=`) and checks that filament is available, correctly parks and updates the [Gate Map](Tool-and-Gate-Maps#---gate-map) including the "gate status" so the MMU knows which gates have filament available.

> [!NOTE]
> The `MMU_CHECK_GATE` command has a special option that is designed to be called from your `PRINT_START` macro. When called as in this example: `MMU_CHECK_GATE TOOLS=0,3,5`. Happy Hare will validate that tools 0, 3 & 5 are ready to go else generate an error prior to starting the print. This is a really useful pre-print check! See [Slicer Setup](Slicer-Setup) for more details.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Filament Loading and Unloading sequences

Happy Hare provides built-in loading and unloading sequences that have many options controlled by settings in `mmu_parameters.cfg`. These are grouped into "modular phases" that control each step of the process and vary slightly based on the capabilities of your particular MMU. Normally this provides sufficient flexibility of control. However, for advanced situations, you are able to elect to control the sequences via gcode macros. This capability is discussed later in the [gcode guide](/doc/macro_customization.md).

### Understanding the load sequence:

```
Loading filament...
1.  MMU [T2] >.. [En] ....... [Ex] .. [Ts] .. [Nz] UNLOADED (@0.0 mm)
2.  MMU [T2] >>> [En] >...... [Ex] .. [Ts] .. [Nz] (@43.8 mm)
3.  MMU [T2] >>> [En] >>>>>>> [Ex] .. [Ts] .. [Nz] (@710.1 mm)
4a. MMU [T2] >>> [En] >>>>>>| [Ex] .. [Ts] .. [Nz] (@720.0 mm)
4b. MMU [T2] >>> [En] >>>>>>> [Ex] >| [Ts] .. [Nz] (@720.0 mm)
5.  MMU [T2] >>> [En] >>>>>>> [Ex] >> [Ts] >> [Nz] LOADED (@783.6 mm)
MMU load successful
Loaded 780.3mm of filament (encoder measured 783.6mm)
```

The "visual log" (enabled with `log_visual:1`) above shows individual steps of a typical loading process for MMU with optional toolhead sensor. Here is an explanation of steps with `mmu_parameter.cfg` options:

#### 1. Filament unload:
Starting with filament unloaded and sitting in the gate for tool 2

#### 2. Loading the Gate:
Firstly MMU pulls a short length of filament from the gate to the start of the bowden tube.

- **With Encoder:** This is achieved using the encoder by advancing filament until if is measured. It it doesn't see filament it will try `encoder_load_retries` times (default 2). If still no filament it will report the error. The speed of this initial movement is controlled by `gear_short_move_speed`.  Note that the encoder sensor is considered "point 0" and any movement beyond into the bowden will automatically be handled by the next bowden move.
- **With Gate Sensor:** This is achieved by homing to specific point. Note that the homing point is considered "point 0".

#### 3. Bowden Tube Loading:
The MMU will then load the filament through the bowden in a fast movement. The speed is controlled by `gear_from_spool_speed` and `gear_from_buffer_speed` depending on whether Happy Hare believes it is pulling filament from the spool or from the buffer. It is advantageous to pull more slowly from the spool to overcome the higher friction. Once a full unload has occurred and deposited filament in the buffer the higher speed `gear_speed_from_buffer` can be used to reduce loading times. The length of the bowden move is determined by the calibrated value `mmu_calibration_bowden_length` that is persisted in `mmu_vars.cfg`

- **With Encoder:** Sometimes when loading from spool a sudden jerk can occur causing the gear stepper to loose steps. There is an advanced option to allow for correction if this occurs (or other slippage) if an encoder is fitted. If `bowden_apply_correction` is enabled and the encoder measures a difference greater than `bowden_allowable_load_delta`, additional moves will be made correct the error (see comments in `mmu_parameters.cfg` for more details)

#### 4. Toolhead Homing:
Before loading to the nozzle it is usually necessary to establish a known home position close or in the toolhead. For this point is then a known distance to the nozzle. There are four main methods of achieving this and the choice depends on the setting of `extruder_homing_endstop` and associated parameters.
- **4a.** `collision` - Detects the collision with the extruder gear by creeping towards the extruder while monitoring encoder movement (obviously requires encoder and can cause filament grinding)
- **4a.** `mmu_gear_touch` - Use touch detection when the gear stepper hits the extruder (requires careful stallguard callibration)
- **4a.** `extruder` - If you have a "filament entry" endstop configured this will delicately home filament to this sensor before moving `toolhead_entry_to_extruder` to snug the filament to the extruder gears
- **4a.** `none` - Don't attempt to home. Only possibiliy if lacking all sensor options but also automatically employed by Happy Hare if a toolhead sensor is available. In this case the fast bowden similar move the required calibrated distance
- **4b. Toolhead Homing:** MMU will home the end of the filament to the toolhead sensor up to a maximum distance of `toolhead_homing_max`. Since the toolhead sensor is inside the extruder the transition moves detailed below will be employed.
Of the various methods, having a toolhead sensor positioned past the extruder gears and letting Happy Hare opt out of the need to home to the extruder is the most accurate and reliable.

#### 4-5. Transition Move:
Depending on the toolhead homing option employed the transition move can occur during the homing (toolhead sensor) or in the subsequent move, but in both cases it aims to reliably get the filament through the extruder gears using synchronized gear and extruder stepper movement.

#### 5. Final Move to Nozzle:
Filament is moved the remaining distance to the meltzone. This distance is defined by `toolhead_extruder_to_nozzle` (extruder homing) or `toolhead_sensor_to_nozzle` (toolhead sensor homing) reduced by any filament remaining in nozzle (explained later in guide). This movement will always be with synced gear and extruder steppers.

> [!NOTE]  
> - If an encoder is available sanity checks checking for movement will monitor the loading process and issue errors (and lock the MMU) if things aren't copacetic.
> - It is expected that encoder readings will differ slightly from the actual stepper movement. This is due to a number of valid reasons including calibration accuracy and slippage. It should not be a cause for concern unless the difference is excessive (>5% of movement)

<br>

### Understanding the unload sequence:

```
Unloading filament...
1.  MMU [T6] <<< [En] <<<<<<< [Ex] << [Ts] << [Nz] LOADED (@0.0 mm)
2.  Forming tip...
    Run Current: 0.67A Hold Current: 0.40A
    pressure_advance: 0.000000
    pressure_advance_smooth_time: 0.040000
    pressure_advance: 0.035000
    pressure_advance_smooth_time: 0.040000
    Run Current: 0.55A Hold Current: 0.40A
3.  MMU [T6] <<< [En] <<<<<<< [Ex] << [Ts] <. [Nz] (@40.5 mm)
4.  MMU [T6] <<< [En] <<<<<<< [Ex] <| [Ts] .. [Nz] (@61.4 mm)
5.  MMU [T6] <<< [En] <<<<<<< [Ex] .. [Ts] .. [Nz] (@70.1 mm)
6.  MMU [T6] <<< [En] <...... [Ex] .. [Ts] .. [Nz] (@746.3 mm)
7.  MMU [T6] <.. [En] ....... [Ex] .. [Ts] .. [Nz] UNLOADED (@784.7 mm)
Unloaded 781.8mm of filament (encoder measured 784.7mm)
```

<br>
The "visual log" (set at level 2) above shows individual steps of a typical unloading process for MMU with optional toolhead sensor. Here is an explanation of steps with `mmu_parameter.cfg` options:

#### 1. Filament loaded:
Starting with filament loaded and sitting in the gate for tool 6

#### 2. Tip Forming:
- **Standalone:** Happy Hare contains a tip forming routine that mimics that found in PrusaSlicer / SuperSlicer. If you every unload out of a print or by explicitly configuring Happy Hare, the standalone routine will be called. The pressure advance is turned off and reset after the tip forming move automatically.  In addition you can increase the extruder stepper motor current for often-fast set of movements to avoid skipping steps. Motor current % increase is controlled with `extruder_form_tip_current`. For even more force you can also elect to synchronize the gear motor with the extruder for this step by setting `sync_form_tip`.
- **Slicer:** In a print tip forming may be done but your slicer (in fact that is assumed unless you explicitly configure otherwise) and you will not see this step. If you are astute you may wonder how Happy Hare knows where the filament is left in the toolhead by the slicer.  The simple answer is that it doesn't and, although it can handle an unknown starting position, the unload process can be streamlined by setting `slicer_tip_park_pos` parameter to the distance from the nozzle to match your slicer. Note that if you are printing with synchronized gear and extruder steppers the slicer (`sync_to_extruder` and `sync_gear_current`) will also perform the tip forming move with synchronized steppers.

#### 3-5. Unloading Toolhead:
There are various methods by which the toolhead will be unloaded. Happy Hare will choice the optimum method based on available sensors and will use synchronize or extruder-only stepper movements as necessary.
- If an `extruder` (entry) sensor is present, filament will be reverse homed to this sensor before the fast bowden unload. This is the best method for unload and why this sensor is recommended.
- Otherwise if a `toolhead` sensor is present, filament will be revered homed to this before moving a fixed additional distance to exit the extruder.

#### 6. Bowden tube Unloading:
The filament is now extracted quickly through the bowden by the calibrated length. Generally the speed is controlled by `gear_from_buffer_speed` but can be reduced to a slower speed `gear_homing_speed` or incremental moves of `gear_short_move_speed` in cases of recovery or if Happy Hare is unsure of filament position after manual intervention.

#### 7. Parking in Gate:
The final move prior to optionally instructing the MMU to release grip on the filament is to park the filament in the correct position in the gate, so, in the case of a type-A design with linear selector the filament does not impeed gate selection. The filament is now unloaded.

> [!NOTE]  
> - When the state of the MMU is unknown, Happy Hare will perform other movements and look at its sensors to try to ascertain filament location. This may modify the above sequence and result in the omission of the fast bowden move for unloads.<br>
> - Happy Hare allows for easy experimentation of loading/unloading sequence or even during a print using the `MMU_TEST_CONFIG` command to dynamically adjust parameters or simply by enabling/disabling sensors. E.g you can use this feature to tune `toolhead_extruder_to_nozzle` or perhaps obserbing the different in load quality by turning on/off the toolhead sensor.

<br>

### Load and Unload Speeds:

Filament movement speeds and accelaration for all operations are detailed in the `mmu_parameters.cfg` file and will likely need to be tuned to your specific hardware.

<br>

> [!TIP] 
> Probably the most important tip is to use the `MMU_STATUS SHOWCONFIG=1` command to get a detailed english language description of the load and unload sequences based on your specific configuration and setup. The output of this command will present ALL the parameters used in the loading and unloading logic together with current values. I guarantee it will help configuration and fine tuning. Try it now...
> ```
> MMU_STATUS SHOWCONFIG=1
> ```

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Debugging Problems

There is a lot that can go wrong with an MMU and initial setup can be frustrating. It is really important to tackle one problem at a time. Never move on and think the problem will go away - that is very unlikely. You have all the tools you need to diagnose issues:

- This wiki. Read it all. I recommend a first pass all the way through to understand the scope and then methodically as you setup your MMU. Make sure you understand conceptually what Happy Hare is trying to do.
- `mmu.log`.  This, by default, will log at the DEBUG (2) level which will provide addition infomation not displayed on the console. Review it when strange things happen.
- `MMU_TEST_CONFIG log_level=2`. This can be a useful tool. Running this on startup will temporarily turn the console verbosity level to `DEBUG`. This will provide a richer running commentary of issues you might encounter. Similarly you can `MMU_TEST_CONFIG file_log_level=3` to add `TRACE` level logging to `mmu.log` for even more detail about operation.
- Check slicer settings. Happy Hare has only limited visibility into what the slicer is doing - if it, for example, ejects filament from the extruder when Happy Hare expects the filament to still be in the extruder, it will result in an error. Understand this interaction.

Good luck!
