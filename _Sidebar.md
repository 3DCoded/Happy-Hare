<details open><summary><b>&nbsp;1. Introduction</b></summary>

- [Introduction](#)
- [Documentation](#)
   - [How To Get Help](#)
   - [Organization](#)
   - [Common-Terms](#)
- [Conceptual MMU](#)
   - [Sensors-Explained](#)
   - [Encoder](#)

</details>

<details open><summary><b>&nbsp;2. Installation</b></summary>

 - [Installation](#)
   - [Creating-Base-Klipper-Config](#)
   - [Config-Overview](#)
   - [Upgrading](#)
 - [Optional Pause Resume Cancel Macros](#)
 - [Special Vendor Notes](#)
   - [ERCF v1.1](#)
   - [ERCF v2.0](#)
   - [Tradrack](#)
   - [Other](#)

</details>

<details open><summary><b>&nbsp;3. Essential Configuration</b></summary>

[Essential-Configuration](#)

</details>

<!--
04-Calibration/
[Calibration.md
    + Selector-Offsets
    + Servo
    + Gear-Stepper
    + Encoder
    + Bowden-Length
    + Gates
    + Calibration-Command-Reference
  resources/

05-Basic-Operation
[- Console
[- KlipperScreen-Happy-Hare-Edition
[- Understanding-Operation-with-MMU_STATUS
[- Debugging

<POINT AT WHICH USER CAN PLAY>

06-Slicer-MMU-Setup
[- Slicer-Configuration
[- Tip-Forming-and-Purging
[- Tip-Cutting
[- Toolchange-Toolhead-Movement
07-Optional-Feature-Setup
[- Gcode-Preprocessing
[- LED-Support
[- Spoolan-Support
08-Third-Party-Addons
[- EREC Filament Cutter
[- Blobifier
[- Filamentalist-Rewinder
09-Advanced-Configuration
[- Config-Files
  + mmu.cfg
  + mmu_hardware.cfg
  + mmu_parameters.cfg
  + mmu_macro_vars.cfg
[- Macro-Customization
  + State-Machine
10-Advanced-Concepts
[- State-Persistence
[- Statistics-and-Counters
  + Gate-Statistics
[- Tool-to-Gate-Map
[- Filament-Bypass
[- Clog-Detection
[- Endless-Spool
[- Synchronized-Gear/Extruder-Motors
  + Sync-Feedback-Sensors
[- Recovering-MMU-State
  + State-Machine
11-Configuration-Reference
12-Command-Reference
13-Troubleshooting
14-FAQ

- [Home](https://github.com/protoloft/klipper_z_calibration/wiki)
- [Changelog](https://github.com/protoloft/klipper_z_calibration/wiki/Changelog)
- [Why This](https://github.com/protoloft/klipper_z_calibration/wiki/Why-This)
- [Requirements](https://github.com/protoloft/klipper_z_calibration/wiki/Requirements)
- [What It Does](https://github.com/protoloft/klipper_z_calibration/wiki/What-It-Does)
  - [There is still one Offset](https://github.com/protoloft/klipper_z_calibration/wiki/What-It-Does#there-is-still-one-offset)
  - [Interference](https://github.com/protoloft/klipper_z_calibration/wiki/What-It-Does#interference)
  - [Example](https://github.com/protoloft/klipper_z_calibration/wiki/What-It-Does#example)
  - [Thermal Frame Expansion](https://github.com/protoloft/klipper_z_calibration/wiki/What-It-Does#thermal-frame-expansion)
- [How To Install It](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Install-It)
  - [Automatic Installation](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Install-It#automatic-installation)
  - [Manual Installation](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Install-It#manual-installation)
  - [Moonraker Update Manager](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Install-It#moonraker-update-manager)
  - [Uninstalling](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Install-It#uninstalling)
- [How To Configure It](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Configure-It)
  - [Preconditions](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Configure-It#preconditions)
  - [Configurations](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Configure-It#configurations)
  - [Bed Mesh](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Configure-It#bed-mesh)
  - [Switch Offset](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Configure-It#switch-offset)
- [How To Test It](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Test-It)
- [How To Use It](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Use-It)
  - [Command CALIBRATE\_Z](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Use-It#command-calibrate_z)
  - [Command PROBE\_Z\_ACCURACY](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Use-It#command-probe_z_accuracy)
  - [Command CALCULATE\_SWITCH\_OFFSET](https://github.com/protoloft/klipper_z_calibration/wiki/How-To-Use-It#command-calculate_switch_offset)
- [Ooze Mitigation](https://github.com/protoloft/klipper_z_calibration/wiki/Ooze-Mitigation)
-->
