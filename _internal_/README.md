<p align="center">
  <img src="https://github.com/moggieuk/Happy-Hare/wiki/resources/happy_hare_logo.jpg" alt='Happy Hare' width='30%'>
  <h1 align="center">Happy Hare</h1>
</p>

<p align="center">
Universal MMU driver for Klipper
</p>

<p align="center">
<!--
  <a aria-label="Downloads" href="https://github.com/moggieuk/Happy-Hare/releases">
    <img src="https://img.shields.io/github/release/moggieuk/Happy-Hare?display_name=tag&style=flat-square">
  </a>
  -->
  <a aria-label="Stars" href="https://github.com/moggieuk/Happy-Hare/stargazers">
    <img src="https://img.shields.io/github/stars/moggieuk/Happy-Hare?style=flat-square"></a> &nbsp;
  <a aria-label="Forks" href="https://github.com/moggieuk/Happy-Hare/network/members">
    <img src="https://img.shields.io/github/forks/moggieuk/Happy-Hare?style=flat-square"></a> &nbsp;
  <a aria-label="License" href="https://github.com/moggieuk/Happy-Hare/blob/master/LICENSE">
    <img src="https://img.shields.io/github/license/moggieuk/Happy-Hare?style=flat-square"></a> &nbsp;
  <a aria-label="Commits" href="">
    <img src="https://img.shields.io/github/commit-activity/y/moggieuk/Happy-Hare"></a> &nbsp;
</p>

Happy Hare (v2) is the second edition of what started life and as [alternative software control](https://github.com/moggieuk/ERCF-Software-V3) for the ERCF v1.1 ecosystem. Now in its second incarnation it has been re-architected to support any type of MMU (ERCF, Tradrack, Prusa) in a consistent manner on the Klipper platform. It is best partnered with [KlipperScreen for Happy Hare](#---klipperscreen-happy-hare-edition) until the Mainsail integration is complete :-)

Some folks have asked about making a donation to cover the cost of the all the coffee I'm drinking (actually it's been G&T lately!). Although I'm not doing this for any financial reward this is a BIG undertaking (9000 lines of python, 5000 lines of doc, 4000 lines of macros/config). I have put hundreds of hours into this project and if you find value and feel inclined a donation to PayPal https://www.paypal.me/moggieuk will certainly be spent making your life with your favorate MMU more enjoyable. Thank you!
<p align="center"><a href="https://www.paypal.me/moggieuk"><img src="https://github.com/moggieuk/Happy-Hare/wiki/resources/donate.svg" width="25%"></a></p>

<br>

## ![#f03c15](https://github.com/moggieuk/Happy-Hare/wiki/resources/f03c15.png) ![#c5f015](https://github.com/moggieuk/Happy-Hare/wiki/resources/c5f015.png) ![#1589F0](https://github.com/moggieuk/Happy-Hare/wiki/resources/1589F0.png) Major features:

<ul>
  <li>Support any brand of MMU and user defined monsters. (Caveat: ERCF 1.1, 2.0 and Tradrack so far. Prusa coming very soon)</li>
  <li>Companion <a href="#---klipperscreen-happy-hare-edition">KlipperScreen for Happy Hare</a> for very simple graphical interaction</li>
  <li>Synchronized movement of extruder and gear motors during any part of the loading or unloading operations or homing so it can overcome friction and even work with FLEX materials!</li>
  <li>Sophisticated multi-homing options including extruder!</li>
  <li>Implements a Tool-to-Gate mapping so that the physical spool can be mapped to any tool</li>
  <li>EndlessSpool allowing a spool to automatically be mapped and take over from a spool that runs out</li>
  <li>Sophisticated logging options (console and mmu.log file)</li>
  <li>Can define material type and color in each gate for visualization and customized settings (like Pressure Advance)</li>
  <li>Spoolman integration</li>
  <li>Automated calibration for easy setup</li>
  <li>Supports MMU "bypass" gate functionality</li>
  <li>Ability to manipulate gear and extruder current (TMC) during various operations for reliable operation</li>
  <li>Moonraker update-manager support</li>
  <li>Complete persistence of state and statistics across restarts. That's right you don't even need to home!</li>
  <li>Highly configurable speed control that intelligently takes into account the realities of friction and tugs on the spool</li>
  <li>Optional integrated encoder driver that validates filament movement, runout, clog detection and flow rate verification!</li>
  <li>Vast customization options most of which can be changed and tested at runtime</li>
  <li>Integrated help, testing and soak-testing procedures</li>
  <li>Gcode pre-processor check that all the required tools are avaialble!</li>
  <li>Drives LEDs for functional feed and some bling!</li>
  <li>Built in tip forming and filament cutter support</li>
  <li>Lots more...</li>
</ul>

Companion customized [KlipperScreen for Happy Hare](#---klipperscreen-happy-hare-edition) for easy touchscreen MMU control!

<p align="center"><img src="https://github.com/moggieuk/Happy-Hare/wiki/resources/my_klipperscreen.png" width="600" alt="KlipperScreen-Happy Hare edition"></p>

<br>
 
## ![#f03c15](https://github.com/moggieuk/Happy-Hare/wiki/resources/f03c15.png) ![#c5f015](https://github.com/moggieuk/Happy-Hare/wiki/resources/c5f015.png) ![#1589F0](https://github.com/moggieuk/Happy-Hare/wiki/resources/1589F0.png) Installation

The module can be installed into an existing Klipper installation with the install script. Once installed it will be added to Moonraker update-manager to easy updates like other Klipper plugins:

```
cd ~
git clone https://github.com/moggieuk/Happy-Hare.git
cd Happy-Hare

./install.sh -i
```

The `-i` option will bring up an interactive installer to aid setting some confusing parameters. For popular external mcu boards it will also configure all the pins for you. If run without with the `-i` flag it defaults to updating the current installation which is sometimes necessary for significant version updates (see [here](doc/update.md)). Note that if an existing install is found it will never be overwritten, it will be moved to a numbered backup folder with a `<file>.<date>` extension and current configuration defaults carried over. If you still choose not to install the new `mmu*.cfg` files automatically you can copy the templates and fill in all the tokens and blank parameters by hand. Frankly it is much easier to run through an initial install and use the generated config files as a starting point.
<br>

Note that the installer will look for Klipper install and config in standard locations. If you have customized locations or multiple Klipper instances on the same rpi, or the installer fails to find Klipper you can use the `-k` and `-c` flags to override the Klipper home directory and Klipper config directory respectively. Also, if installing on Repetier-Server add the `-r` option. E.g.
```
./install.sh -i -k /opt/klipper/LK5_Pro_ERCF -c /var/lib/Repetier-Server/database/klipper -m /opt/klipper/LK5_Pro_ERCF/moonraker -r LK5_Pro_ERCF
```

If you have multiple Klipper instances installed with for example Kiauh. You can use the `-a` flag to specify the service name. E.g.
```
./install-sh -a -a klipper-two -k <klipper_home_dir> -c <klipper_config_dir>
```

<br>

> [!IMPORTANT]  
> `mmu.cfg`, `mmu_hardware.cfg`, `mmu_macro_vars.cfg` & `mmu_parameters.cfg` (and other base config files) must all be referenced by your `printer.cfg` master config file with `mmu.cfg` and `mmu_hardware.cfg` listed first (the recommended way to achieve this is simply with `[include mmu/base/*.cfg]`). `mmu/optional/client_macros.cfg` should also explicitly be referenced if you don't already have working PAUSE / RESUME / CANCEL_PRINT macros (but be sure to read the section beforehand regarding macro expectations and review the default macros). The install script can also include these optional config files for you.
<br>

> [!TIP]  
> If you are concerned about running `install.sh -i` then run like this: `install.sh -i -c /tmp -k /tmp` This will build the `*.cfg` files for you but put then in /tmp rather than overwriting your active configuration. You can then refer to them, pulling out the bits you need to augment your existing install or simply see what answers to the various questions will do...

```
Usage: ./install.sh [-k <klipper_home_dir>] [-c <klipper_config_dir>] [-m <moonraker_home_dir>] [-b <branch>] [-r <Repetier-Server stub>] [-i] [-d] [-z]

-i for interactive install
-d for uninstall
-z skip github check (nullifies -b <branch>)
-r specify Repetier-Server <stub> to override printer.cfg and klipper.service names
(no flags for safe re-install / upgrade)
```

> [!WARNING]  
> Hall effect toolhead sensors can be problematic in a heated chamber because their characteristics change with temperature. Microswitch versions are preferred.

<br>

## ![#f03c15](/doc/resources/f03c15.png) ![#c5f015](/doc/resources/c5f015.png) ![#1589F0](/doc/resources/1589F0.png) Video Tutorials & Other Resources
## ![#f03c15](https://github.com/moggieuk/Happy-Hare/wiki/resources/f03c15.png) ![#c5f015](https://github.com/moggieuk/Happy-Hare/wiki/resources/c5f015.png) ![#1589F0](https://github.com/moggieuk/Happy-Hare/wiki/resources/1589F0.png) Documentation

## ![#f03c15](https://github.com/moggieuk/Happy-Hare/wiki/resources/f03c15.png) ![#c5f015](https://github.com/moggieuk/Happy-Hare/wiki/resources/c5f015.png) ![#1589F0](https://github.com/moggieuk/Happy-Hare/wiki/resources/1589F0.png) Video Tutorials & Other Resources

### English: 
<i>coming soon</i>

### German:
<div align="left">
  <a href="https://www.youtube.com/watch?v=uaPLuWJBdQU">
    <img src="https://github.com/moggieuk/Happy-Hare/blob/main/doc/resources/youtube1.png" width="30%"></a>
    Instructional video created by the Crydteam
<!--
    <img src="https://i9.ytimg.com/vi_webp/uaPLuWJBdQU/maxresdefault.webp?v=6522d1a6&sqp=CKycn6kG&rs=AOn4CLBCiHQsjGJ0c8ywvkxy9uWEk_yUXw" 
         alt="Everything Is AWESOME" 
         style="width:50%;">
-->
  </a>
</div>

<br>

## ![#f03c15](/doc/resources/f03c15.png) ![#c5f015](/doc/resources/c5f015.png) ![#1589F0](/doc/resources/1589F0.png) Overview

Happy Hare has been built to support most types of MMU's connected to the Klipper ecosystem. That includes ERCF, Tradrack, AMS-style and other custom designs. It has extensive configuration to allow for customization using the installer and specifying MMU type through `vendor` and `version` to minimize the need for customization.  The three conceptual types of MMUs and the function and operation of their various sensors can be [found here](doc/conceptual_mmu.md) and should be consulted for any customized setup.




<br>

## ![#f03c15](/doc/resources/f03c15.png) ![#c5f015](/doc/resources/c5f015.png) ![#1589F0](/doc/resources/1589F0.png) Basic Commands and Printer Variables

Happy Hare has a built in help system to aid remembering the command set. It can be accessed with the `MMU_HELP` command and can also be used to view testing commands and user extensible macros which are called by Happy Hare on certain conditions. The full list of commands and options can be [found here](/doc/command_ref.md). A very useful command for understanding MMU operate (`MMU_STATUS`) is explained [in detail here](/doc/operation.md).






<br>

## ![#f03c15](/doc/resources/f03c15.png) ![#c5f015](/doc/resources/c5f015.png) ![#1589F0](/doc/resources/1589F0.png) Setup and Calibration:

Configuration and calibration will vary slightly depending on your particular brand of MMU although the steps are essentially the same with some being dependent on your hardware configuration. Here are the five basic steps.

### 1\. Important MMU Vendor / Version Specification

Happy Hare functionality will vary with MMU vendor. After running the installer, it is important to verify `mmu_vendor` and `mmu_version` have been correctly set in `mmu_parameters.cfg` because they define the basic capabilities and options in Happy Hare. The only complication in order to correctly support the many popular modifications to some MMU's is that the correct suffix must be specified depending on modifications/upgrades.

<details>
<summary><sub>🔹 Read more about vendor/version specification...</sub></summary>
<br>
 
```yml
#
# The vendor and version config is important to define the capabilities of the MMU and basic CAD dimensions. These can
# all be overridden with the `cad` parameters detailed in the documentation but the vendor setting saves time.
#
# ERCF
# 1.1 original design, add "s" suffix for Springy, "b" for Binky, "t" for Triple-Decky
#     e.g. "1.1sb" for v1.1 with Springy mod and Binky encoder
#
# 2.0 new community ERCFv2
#
# Tradrack
# 1.0 add "e" if using encoder is fitted
#
# Prusa
#  - Comming soon (use Other for now)
#
# Other
#  - Generic setup that will require further customization of `cad` parameters. See doc
#
mmu_vendor: ERCF			# MMU family
mmu_version: 1.1sb			# MMU hardware version number (add mod suffix documented above)
mmu_num_gates: 9 			# Number of selector gates
```

> [!NOTE]  
> Despite the vendor and version strings taking care of most MMU variations, there are still a few parameters that need to be set. In an attempt to support such mods (as well as supporting completely custom designs) the follow parameters can be specified to override default settings. Note these mostly relate to CAD dimensions, encoder resolution (if fitted) and gate parking distance. Use ONLY if necessary because they could change in the future:<br>

`cad_gate0_pos:` Distance from endstop to first gate in mm<br>
`cad_gate_width:` Width of individual filament block in mm - if using modified/custom block<br>
`cad_last_gate_offset:` Distance from end of travel to last gate<br>
`cad_bypass_offset:` Distance from end of selector travel back to the bypass<br>

This only apply to ERCF v1.1:<br>
`cad_block_width:` Width of bearing block (ERCF v1.1)<br>
`cad_bypass_block_width:` Width of bypass support block - if using a custom bypass bearing block like the one in my repo which is 7mm thick (ERCF v1.1)<br>
`cad_bypass_block_delta:` - Distance from previous gate to bypass (ERCF v1.1)<br>

This non-CAD setting are also commonly required to adjust for non Binky encoders:<br>
`encoder_min_resolution:` Resolution of one 'pulse' on the encoder. Binky (default) is 23/(2x12)=0.96, TCRT5000 based is 23/(2x17)=0.68

All other configuration parameters are made available and documented in `mmu_parameters.cfg`

</details>

### 2\. Validate your mmu_hardware.cfg configuration and basic operation

Generally the typical "Type-A" MMU will consist of selector motor to position at the desired gate, a gear motor to drive the filament to the extruder and a servo to grip and release the filament. In addition there may be a one or more sensors (endstops) to aid filament positioning. See [hardware configuration doc](/doc/hardware_config.md) for detailed instructions and consult [MMU conceptual model](/doc/conceptual_mmu.md) for details of less common MMU types.

<details>
<summary><sub>🔹 Details on optional hardware...</sub></summary>

#### Optional hardware - Encoder

Happy Hare supports the use of an encoder which is fundamental to the ERCF MMU design. This is a device that measures the movement of filament and can be used for detecting and loading/unloading filament at the gate; validating that slippage is not occurring; runout and clog detection; flow rate verification and more. The following is an output of the `MMU_ENCODER` command to control and view the encoder:

> MMU_ENCODER ENABLE=1<br>MMU_ENCODER

```
    Encoder position: 743.5mm
    Clog/Runout detection: Automatic (Detection length: 10.0mm)
    Trigger headroom: 8.3mm (Minimum observed: 5.6mm)
    Flowrate: 0 %
```

Normally the encoder is automatically enabled when needed and disabled when not printing. To see the extra information, you need to temporarily enable if out of a print (hence the extra `ENABLE=1` command).

<ul>
  <li>The encoder, when calibrated, measures the movement of filament through it.  It should closely follow movement of the gear or extruder steppers but can drift over time.</li>
  <li>If enabled the clog/runout detection length is the maximum distance the extruder is allowed to move without the encoder seeing it. 
 A difference equal or greater than this value will trigger the clog/runout logic in Happy Hare</li>
  <li>If clog detection is in `automatic` mode the `Trigger headroom` represents the distance that Happy Hare will aim to keep the clog detection from firing.  Generally around 6mm - 8mm is good starting point.</li>
  <li>The minimum observed headroom represents how close (in mm) clog detection came to firing since the last toolchange. This is useful for tuning your detection length (manual config) or trigger headroom (automatic config)</li>
<li>Finally the `Flowrate` will provide an averaged % value of the mismatch between extruder extrusion and measured movement. Whilst it is not possible for this to be real-time accurate it should average above 94%. If not it indicates that you may be trying too extrude too fast.</li>
</ul>

</details>

### 3\. Calibration Commands

Before using your MMU you will need to calibrate it to adjust for differences in components used on your particular build. Be careful to calibrate in the recommended order because some settings build and depend on earlier ones. Happy Hare now has automated calibration for some of the traditionally longer steps and does not require any Klipper restarts so the process is quick and painless. See [MMU Calibration doc](/doc/calibration.md) for detailed instructions

### 4\. Setup configuration in mmu_parameters.cfg

After calibration you might want to review and tweak the configuration and options in `mmu_parameters.cfg`. The default values set by the installer are good starting points although you will always have to specify things like the dimensions of your extruder which are very specific to your build. The [MMU Configuration guide](/doc/configuration.md) contains an in-depth reference but some of the selected features are also discussed in more detail in the following sections.




### 5\. Tweak configuration at runtime

It's worth noting, and a very useful feature, that all the essential configuration and tuning parameters (in `mmu_parameters.cfg`) can be modified at runtime without restarting Klipper. Use the `MMU_TEST_CONFIG` command to do this. Running without any parameters will display the current values. This even allows changes to configuration during a print!

<details>
<summary><sub>🔹 Read about run-time testing of configuration...</sub></summary>
<br>
 
Running without any parameters will display the current values:

> MMU_TEST_CONFIG

```
    SPEEDS:
    gear_from_buffer_speed = 160.0
    gear_from_buffer_accel = 400.0
    gear_from_spool_speed = 60.0
    gear_from_spool_accel = 100.0
    gear_short_move_speed = 60.0
    gear_short_move_accel = 400.0
    gear_short_move_threshold = 60.0
    gear_homing_speed = 50.0
    extruder_homing_speed = 20.0
    extruder_load_speed = 15.0
    extruder_unload_speed = 20.0
    extruder_sync_load_speed = 20.0
    extruder_sync_unload_speed = 25.0
    extruder_accel = 400.0
    selector_move_speed = 200.0
    selector_homing_speed = 60.0
    selector_touch_speed = 80.0
    selector_touch_enable = 0                    # Advanced
    
    TMC & MOTOR SYNC CONTROL:
    sync_to_extruder = 1
    sync_form_tip = 1
    sync_gear_current = 50
    extruder_homing_current = 30
    extruder_form_tip_current = 120
    
    LOADING/UNLOADING:
    bowden_apply_correction = 0                  # Advanced
    bowden_allowable_load_delta = 20             # Advanced
    bowden_pre_unload_test = 1
    extruder_force_homing = 0
    extruder_homing_endstop = collision
    extruder_homing_max = 50.0
    toolhead_sync_unload = 0                     # Advanced
    toolhead_homing_max = 50.0
    toolhead_extruder_to_nozzle = 72.0
    toolhead_sensor_to_nozzle = 62.0
    gcode_load_sequence = 0                      # Expert
    gcode_unload_sequence = 0                    # Expert
    
    OTHER:
    z_hop_height_error = 1.0
    z_hop_height_toolchange = 0.5
    z_hop_speed = 15.0
    enable_clog_detection = 2
    enable_endless_spool = 1                     # Advanced
    slicer_tip_park_pos = 0.0
    auto_calibrate_gates = 0                     # Advanced
    strict_filament_recovery = 0
    retry_tool_change_on_error = 0
    print_start_detection = 1                    # Advanced
    log_level = 1
    log_visual = 2
    log_statistics = 1
    pause_macro = PAUSE                          # Advanced
    form_tip_macro = _MMU_FORM_TIP               # Advanced

    CALIBRATION:
    mmu_calibration_bowden_length = 698.0
    mmu_calibration_clog_length = 13.6
```

Any of the displayed config settings can be modified. For example, to update the distance from extruder entrance (homing postion) to nozzle.

> MMU_TEST_CONFIG toolhead_extruder_to_nozzle=45

> [!IMPORTANT]  
> When you make a change with `MMU_TEST_CONFIG` it will not be persisted and is only effective until the next restart. Therefore, once you find your tuned settings be sure to update `mmu_parameters.cfg`

</details>

<br>

## ![#f03c15](/doc/resources/f03c15.png) ![#c5f015](/doc/resources/c5f015.png) ![#1589F0](/doc/resources/1589F0.png) Important Concepts and Features

### 1. How to handle errors

We all hope that printing is straightforward, and everything works to plan. Unfortunately that is not always the case with an MMU and it may need manual intervention to complete a successful print and specifically how you use `MMU_RECOVER`, etc.

<details>
<summary><sub>🔹 Read more about handling errors and recovery...</sub></summary>
<br>

Although error conditions are inevitable, that isn't to say fairly reliable operation isn't possible - I've had many multi-thousand swap prints complete without incident. Here is what you need to know when something goes wrong.

When Happy Hare detects something has gone wrong, like a filament not being correctly loaded or perhaps a suspected clog, it will pause the print and ready the printer for fixing. You can test this condition by running:

> MMU_PAUSE FORCE_IN_PRINT=1

A few things happen in this paused state:

<ul>
  <li>Happy Hare will lift the toolhead off the print to avoid blobs</li>
  <li>The `PAUSE` macro will be called. Typically this will further move the toolhead to a parking position</li>
  <li>The heated bed will remain heated for the time set by `timeout_pause`</li>
  <li>The extruder will remain hot for the time set with `disable_heater`</li>
</ul>

To proceed you need to address the specific issue. You can move the filament by hand or use basic MMU commands. Once you think you have things corrected you may (optionally) need to run:

> MMU_RECOVER

This is optional and ONLY needed if you may have confused the MMU state. I.e. if you left everything where the MMU expects it there is no need to run and indeed if you use MMU commands then the state will be correct and there is never a need to run. However, this can be useful to force Happy Hare to run its own checks to, for example, confirm the position of the filament. By default, this command will automatically fix essential state, but you can also force it by specifying additional options. E.g. `MMU_RECOVER TOOL=1 GATE=1 LOADED=1`. See the [Command Reference](/doc/command_ref.md) for more details.

When you ready to continue with the print:

> RESUME

This will not only run your own print resume logic, but it will reset the heater timeout clocks and restore the z-hop move to put the printhead back on the print at the correct position.

```mermaid
    graph TD;
    Printing --> Paused_Error
    Paused_Error --> Fix_Problem
    Fix_Problem --> RESUME
    Fix_Problem --> MMU_RECOVER
    Fix_Problem --> CANCEL_PRINT
    MMU_RECOVER --> RESUME
    RESUME --> Printing
```

</details>

### 11. Useful pre-print functionality

There are a couple of commands (`MMU_PRELOAD` and `MMU_CHECK_GATE`) that are useful to ensure MMU readiness prior to printing.

<details>
<summary><sub>🔹 Read more on pre-print readiness...</sub></summary><br>
 
The `MMU_PRELOAD` is an aid to loading filament into the MMU.  The command works a bit like the Prusa's functionality and spins gear with servo depressed until filament is fed in.  It then parks the filament nicely. This is the recommended way to load filament into your MMU and ensures that filament is not under/over inserted potentially preventing pickup or blocking the gate.<br>

Similarly the `MMU_CHECK_GATE` command will run through all the gates (or the one specified), checks that filament is loaded, correctly parks and updates the "gate status" map so the MMU knows which gates have filament available.<br>

> [!NOTE]  
> The `MMU_CHECK_GATE` command has a special option that is designed to be called from your `PRINT_START` macro. When called as in this example: `MMU_CHECK_GATE TOOLS=0,3,5`. Happy Hare will validate that tools 0, 3 & 5 are ready to go else generate an error prior to starting the print. This is a really useful pre-print check! See [Gcode Preprocessing](/doc/gcode_preprocessing.md) for more details.

</details>


## ![#f03c15](/doc/resources/f03c15.png) ![#c5f015](/doc/resources/c5f015.png) ![#1589F0](/doc/resources/1589F0.png) KlipperScreen Happy Hare Edition

<img src="doc/mmu_main_printing.png" width="500" alt="KlipperScreen">

Even if not a KlipperScreen user yet you might be interested in my fork of KlipperScreen [Github link](https://github.com/moggieuk/KlipperScreen-Happy-Hare-Edition) simply to control your MMU. It makes using your MMU the way it should be. Dare I say as easy at Bambu Labs ;-) I run mine with a standalone Raspberry Pi attached to my buffer array and can control multiple MMU's with it.

Be sure to follow the install directions carefully and read the [panel-by-panel](https://github.com/moggieuk/KlipperScreen-Happy-Hare-Edition/blob/master/docs/MMU.md) documentation :tada:

<br> 
 
## ![#f03c15](/doc/resources/f03c15.png) ![#c5f015](/doc/resources/c5f015.png) ![#1589F0](/doc/resources/1589F0.png) My Testing:
This new v2 Happy Hare software is largely rewritten and so, despite best efforts, has probably introduced some bugs that may not exist in the previous version.  It also lacks extensive testing on different configurations that will stress the corner cases.  I have been using it successfully on Voron 2.4 / ERCF v1.1 and ERCF v2.0 with EASY-BRD and ERB board.  I use a self-modified CW2 extruder with foolproof microswitch toolhead sensor (hall effect switches are extremely problematic in my experience). My day-to-day configuration is to load the filament to the extruder in a single movement at 250mm/s, then home to toolhead sensor with synchronous gear/extruder movement although I have just moved to an experimental automatic "touch" homing to the nozzle which works without ANY knowledge of my extruder dimensions!! Yeah, really, load filament in gate, fast 670mm move, home to nozzle!

### My Setup:

<img src="doc/my_voron_and_ercf.jpg" width="400" alt="My Setup">

 
## ![#f03c15](/doc/resources/f03c15.png) ![#c5f015](/doc/resources/c5f015.png) ![#1589F0](/doc/resources/1589F0.png) Revision History

Detail change log can be found in the [wiki](Change-Log)

```
    (\_/)
    ( *,*)
    (")_(") Happy Hare Ready
```
