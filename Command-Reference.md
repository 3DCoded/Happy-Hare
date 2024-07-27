#### Page Sections:
- [Operation](Command-Reference#---basic-mmu-functionality)
- [Calibration](Command-Reference#---calibration)
- [Testing](Command-Reference#---testing)
- [Macros](Command-Reference#---macros)

Firstly you can get a quick reminder of commands using the `MMU_HELP` command from the console:

  > MMU_HELP

```yml
Happy Hare MMU commands: (use MMU_HELP SLICER=1 MACROS=1 CALLBACKS=1 TESTING=1 STEPS=1 for full command set)
    MMU : Enable/Disable functionality and reset state
    MMU_CHANGE_TOOL : Perform a tool swap (called from Tx command)
    MMU_CHECK_GATE : Automatically inspects gate(s), parks filament and marks availability
    MMU_EJECT : aka MMU_UNLOAD Eject filament and park it in the MMU or optionally unloads just the extruder (EXTRUDER_ONLY=1)
    MMU_ENCODER : Display encoder position and stats or enable/disable runout detection logic in encoder
    MMU_ENDLESS_SPOOL : Diplay or Manage EndlessSpool functionality and groups
    MMU_GATE_MAP : Display or define the type and color of filaments on each gate
    MMU_HELP : Display the complete set of MMU commands and function
    MMU_HOME : Home the MMU selector
    MMU_LED : Manage mode of operation of optional MMU LED's
    MMU_LOAD : Loads filament on current tool/gate or optionally loads just the extruder for bypass or recovery usage (EXTRUDER_ONLY=1)
    MMU_LOG : Logs messages in MMU log
    MMU_MOTORS_OFF : Turn off both MMU motors
    MMU_PAUSE : Pause the current print and lock the MMU operations
    MMU_PRELOAD : Preloads filament at specified or current gate
    MMU_RECOVER : Recover the filament location and set MMU state after manual intervention/movement
    MMU_RESET : Forget persisted state and re-initialize defaults
    MMU_SELECT : Select the specified logical tool (following TTG map) or physical gate
    MMU_SELECT_BYPASS : Select the filament bypass
    MMU_SENSORS : Query state of sensors fitted to mmu
    MMU_SERVO : Move MMU servo to position specified position or angle
    MMU_SLICER_TOOL_MAP : Display or define the tools used in print as specified by slicer
    MMU_SPOOLMAN : Manage spoolman integration
    MMU_STATS : Dump and optionally reset the MMU statistics
    MMU_STATUS : Complete dump of current MMU state and important configuration
    MMU_SYNC_GEAR_MOTOR : Sync the MMU gear motor to the extruder stepper
    MMU_TOOL_OVERRIDES : Displays, sets or clears tool speed and extrusion factors (M220 & M221)
    MMU_TTG_MAP : aka MMU_REMAP_TTG Display or remap a tool to a specific gate and set gate availability
    MMU_UNLOCK : Wakeup the MMU prior to resume to restore temperatures and timeouts
```


## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Basic MMU functionality

  | Command | Description | Parameters |
  | ------- | ----------- | ---------- |
  | `MMU` | Enable and reset state or disable the MMU. Useful to completely turn off the MMU functionality rather then uninstalling it. Note that persisted state will be reset when re-enabling | `ENABLE=[0\|1]` 0 to disable, 1 to enable. |
  | `MMU_CHANGE_TOOL` | Perform a tool swap (generally called from 'Tx' macros). Use `STANDALONE=1` option in your print_start macro to saftely load the initial tool | `TOOL=[0..n]` Tool number to load. <br>`STANDALONE=[0\|1]` Optional to force standalone logic (tip forming). <br>`QUIET=[0\|1]` Optional to always suppress swap statistics |
  | `MMU_EJECT` | `MMU_UNLOAD` | Eject filament and park it in the MMU gate or does the extruder unloading part of the unload sequence if in bypass | `EXTRUDER_ONLY=[0\|1]` To force just the extruder unloading (automatic if bypass selected). <br>`SKIP_TIP=[0\|1]` if set the tip forming/cutting macro will be skipped |
  | `MMU_ENCODER` | Displays the current value of the MMU encoder or explicitly enable or disable the encoder. Note that the encoder state is set automatically so this will only be sticky until next tool change | `ENABLE=[0\|1]` 0=Disable, 1=Enable. <br>`VALUE=..` Set the current distance |
  | `MMU_HELP` | Generate reminder list of command set | `TESTING=1` Also list the testing command. <br>`MACROS=1` Also list the base macro commands. <br>`CALLBACKS=1` Also list the callback macros. <br>`STEPS=1` Also list the individual movement sequence macros for custom loading/unloading control |
  | `MMU_HOME` | Home the MMU selector and optionally selects gate associated with the specified tool | `TOOL=[0..n]` After homing, select gate associated with this tool. <br>`FORCE_UNLOAD=[0\|1]` Optional. If specified will override default intelligent filament unload behavior prior to homing |
  | `MMU_LED` | Quick way to try/test modes of operation of optional MMU LEDs  | `ENABLE=[0\|1]` Whether LED's are operational or not. <br>`ENTRY_EFFECT=[off\|gate_status\|filament_color\|slicer_color]` Selects the default effect for gate "entry" LEDs when no action is taking place. <br>`EXIT_EFFECT=[off\|gate_status\|filament_color\|slicer_color]` Selects the default effect for gate "exit" LED when no action is taking place. <br>`STATUS_EFFECT=[off\|on\|filament_color\|slicer_color]` Selects the default effect for the single status LED is fitted. <br>`QUIET=1` Suppose non essential output from the command. |
  | `MMU_LOAD` | Loads filament in currently selected tool/gate to extruder. Optionally performs just the extruder load part of the sequence - designed for bypass loading or non MMU use | `EXTRUDER_ONLY=[0\|1]` To force just the extruder loading (automatic if bypass selected). |
  | `MMU_PAUSE` | Pause the current print and locks the MMU operations. (`MMU_UNLOCK + RESUME` or just `RESUME` to continue print) | `FORCE_IN_PRINT=[0\|1]` This option forces the handling of pause as if it occurred in print and is useful for testing. Calls "PAUSE" by default or your "pause_macro". <br>`MSG=<message>` Supply message to be displayed. Useful when used in macros. |
  | `MMU_PRELOAD` | Helper for filament loading. Feed filament into gate, MMU will catch it and correctly position at the specified gate | `GATE=[0..n]` The specific gate to preload. If omitted the currently selected gate will be loaded. |
  | `MMU_RECOVER` | Recover filament position and optionally reset MMU state. Useful to call prior to RESUME if you intervene/manipulate filament by hand | `TOOL=[0..n]\|-2` Optionally force set the currently selected tool (-2 = bypass). Use caution!. <br>`GATE=[0..n]` Optionally force set the currently selected gate if TTG mapping is being leveraged otherwise it will get the gate associated with current tool. Use caution!. <br>`LOADED=[0\|1]` Optionally specify if the filamanet is fully loaded or fully unloaded. Use caution! If not specified, MMU will try to discover filament position. <br>`STRICT=[0\|1]` If automatically detecting impose stricter testing for filament position (temporarily sets 'strict_filament_recovery' parameter). |
  | `MMU_RESET` | Reset the MMU persisted state back to defaults | `CONFIRM=[0\|1]` Must be sepcifed for affirmative action of this dangerous command |
  | `MMU_SELECT` | Selects the logical tool or physical gate. If tool is sepficed the gate associated with the specified tool (TTG map) will be selected | `TOOL=[0..n]` The tool to be selected (will actually select the gate currently mapped to the tool with TTG). <br>`GATE=[0..n]` The gate to be selected (ignores TTG map). <br>`BYPASS=1` Selects the bypass selector position if configured (same as "MMU_SELECT_BYPASS"). |
  | `MMU_SELECT_BYPASS` | Select the bypass selector position if configured. Same as `MMU_SELECT BYPASS=1` | None. |
  | `MMU_TOOL_OVERRIDES` | Displays, sets or clears tool speed and extrusion factors (M220 & M221) | `TOOL=[0..n]` Specify tool to set. <br>`M220=[0-200]` Speed (feedrate) multiplier percentage. <br> `M221=[0-200]` Extrusion multiplier percentage. <br> `RESET=1` Reset specified override for specified tool to default 100%. Note that omitting "TOOL=" will reset all tools |
  | `MMU_UNLOCK` | Wakeup the MMU prior to RESUME to restore temperatures and timeouts | None |

<br>

  ### Filament specification, Tool to Gate map and Endless spool commands
  | Command | Description | Parameters |
  | ------- | ----------- | ---------- |
  | `MMU_CHECK_GATE` | Inspect the gate(s) and mark availability. By default it will check just the current gate but options allow many | `ALL=1` To check all gates. <br>`GATE=[0..n]` The specific gate to check. <br>`TOOL=[0..n]` The specific too to check (same as gate if no TTG mapping in place). <br>`TOOLS={csv}` The list of tools to check. Typically used in print start macro to validate all necessary tools. <br>`GATES={csv}` The list of gates to check. <br>If all parameters are omitted the current gate will be checked (the default). <br>`QUIET=[0\|1]` Optional, supresses dump of gate status at end of checking procedure. |
  | `MMU_ENDLESS_SPOOL` | Display or edit the EndlessSpool groups. It can also modify the defined EndlessSpool groups at runtime | ` ` Without parameters this will display the current EndlessSpool groups. <br>`RESET=1` If specified the EndlessSpool groups will be reset to that defined in mmu_parameters.cfg. <br>`GROUPS={csv of groups}` The same format as the default groups defined in mmu_parameters.cfg. Must be the same length as the number of MMU gates | `QUIET=[0\|1]` Optional. Supresses dump of current TTG and endless spool map to log file. <br>`ENABLE=[0\|1]` Optional. Force the enabling or disabling of endless spool at runtime (not persisted). |
  | `MMU_GATE_MAP` | Display for configure the filament type, color and availabilty. Used in colored UI's and available via printer variables in your print_start macro | ` ` Without parameters this will display the current gate map. <br>`RESET=1` If specified the 'gate_materials, 'gate_colors' and 'gate_status' will be reset to that defined in mmu_parameters.cfThe following must be specified together to create a complete entry in the gate map:. <br>`GATE=[0..n]` Gate number. <br>`GATES={csv}` The list of gates to set. Can be used as an alternative to a single "GATE=.." when setting common filament attributes. <br>`MATERIAL=..` The material type. Short, no spaces. e.g. "PLA+". <br>`COLOR=..` The color of the filament. Can be a string representing one of the [w3c color names](https://www.w3.org/TR/css-color-4/#named-colors) e.g. "violet" or a color string in the hexadeciaml format RRGGBB e.g. "ff0000" for red. NO space or # symbols. Empty string for no color. <br>`AVAILABLE=[0\|1\|2]` Optionally marks gate as empty (0) or available from spool (1) or available from buffer (2). <br>`SPEED=[10..150]` Optional and controls the speed and accelaration factor (percent) used in loading and unloading moves. This is particularly useful when special handling is required for TPU material. <br>`SPOOLID=..` The SpoolMan SpoolID (integer) if SpoolMan support is enabled. <br>`QUIET=[0\|1]` Optional. Supresses dump of current gate map to log file. <br>`REFRESH=1` Will refresh data from Spoolman if configured for all filaments. <br>`NEXT_SPOOLID=..` Will auto assign specified spool_id to the next gate preloaded either specifically or registered by pre-gate sensor. Valid for "pending_spool_id_timeout" seconds (useful for RFID reader). <br>`DETAIL=1` for additional information. <br> `SYNC` forces synchronization with the spoolman db. This is the default behavior with "enable_spoolman" enabled. |
  | `MMU_SLICER_TOOL_MAP` | Used to set or display tools used in print. Typically this will be set in the print_start macro based on placeholders from the slicer including filament color, material type and temperature setting. This detail can be used in print by reading the printer variable. For example, `printer.mmu. slicer_tool_map. tools.5.material` will contain the material the slicer is expecting in tool T5 or `printer.mmu. slicer_tool_map. purge_volumes[0][2]` the volume in mm^3 to purge when changing from tool T0 to T2 | ` ` Without parameters this will display the tools used in the current print. <br>`TOOL` the tool to set. <br>`MATERIAL` the material type e.g. PLA or ABS. Used as identifier in autogate mapping feature. <br>`COLOR` the color in form RRBBGG or legal w3c color name. Used as identifier in autogate mapping feature. <br>`TEMP` the filament print temperature. <br>`NAME` the filament name. Used as identifier in autogate mapping feature. <br>`USED=[0\|1]` Whether the tool is used in current print. Defaults to 1 (used). <br>`INITIAL_TOOL=..` Sets the initial tool used in the print. <br>`PURGE_VOLUMES` a comma separated list of purge volumes when changing tools. Map is always NxN but the volumes can be specified as a single volume (same unload/load on every tool), N volumes (same unload/load volume separately for each tool), 2xN volumes (specific unload/load volumes for each tool), or NxN volumes (every possible unload tool and load tool). <br>`QUIET=0` to suppress output after set. <br>`RESET=[0\|1]` used to reset/clear the map. <br>`DETAIL=1` will display all the tools regardless of whether they are used in the print and will dump the purge volumes map. <br>`PURGE_MAP=1` will display the full purge map. <br>`SPARSE_PURGE_MAP=1` can be used for readability purposes to display the sparse purge map with volumes only for possible tool changes. <br>`NUM_SLICER_TOOLS` if specified this is the assumed number of tools defined in the slicer. When combined with "PURGE_VOLUMES" this is used to check the purge volumes and against this number of gates (allows for a slicer to have less tools defined than the MMU has gates). If not specified it is assumed the slicer is setup with the same number of gates as the MMU. If combined with "PURGE_MAP" or "SPARSE_PURGE_MAP" it will restrict the size of the map shown. <br>`AUTOMAP=[name\|spool_id\|material\|color\|closest_color]` (requires "TOOL=" parameter) will automatically set the tool-to-gate mapping for tool based on the strategy specified. This is typically called from the print startup macro after the tool information is pulled in from the slicer
  | `MMU_SPOOLMAN` | Used to display or manage the gate mapping in spoolman db | Note that this command can be used without spoolman support enabled but spoolman must be configured into moonraker.<br> <br>` ` Without parameters this will display the gate mapping for stored in spoolman db. Optionally "PRINTER=.." can be added to look at another printers gate map. <br>`REFRESH=1` will completely refresh the cache of spoolman db and then synchronized the local gate map with spoolman in the direction of the "spoolman_support" setting in "mmu_parameters.cfg". Should not generally be necessary but useful if you suspect something is out of sync or the spoolman db has been edited outside of Happy Hare or from a remote system. Note that command will report inconsistencies found in the database, to fix those automatically you can add the `FIX=1` parameter. <br>`SYNC=1` will synchronize the local gate map with spoolman db in the direction of the "spoolman_support" setting.  If 'push' the printer name, gate and optionally the location field will be updated to match local map. If 'pull' the local gate mapping will be synced based on the printer name, gate assignment stored in spoolman. <br>`CLEAR=1` will clear all gate assigned to this printer in the spoolman db. <br>`UPDATE=1` specify this in conjunction with "SPOOLID" and/or "GATE" to write updates to spoolman and update cache. <br>`SPOOLID` specify the spool_id. <br>`GATE` specify the gate. <br> `PRINTER=..` optionally choose a different printer name than the local one. Only work with "SPOOLINFO" at the moment. <br>`SPOOLINFO=<spool_id>` display the essential information about a spool in the console. If "spool_id" is 0 or -1 this will default to the currently active spool. <br>`QUIET=1` to reduce volume of non essential messages |
  | `MMU_TTG_MAP` | Display for reconfiguration of the Tool-to-Gate (TTG) map.  Can also set gates as empty! | ` ` Without parameters this will display the current gate map. <br>`RESET=1` If specified the Tool -> Gate mapping will be reset to that defined in mmu_parameters.cf`TOOL=[0..n]` Tool to set in TTG map. <br>`GATE=[0..n]` Maps specified tool to this gate (multiple tools can point to same gate). <br>`AVAILABLE=[0\|1]`  Marks gate as available or empty. <br>`QUIET=[0\|1]` Optional. Supresses dump of current TTG map to log file. <br>`MAP={csv}` List of gates, one for each tool to specify the entire TTG map for bulk updates. |

<br>

  ### Status, Logging and Persisted state
  | Command | Description | Parameters |
  | ------- | ----------- | ---------- |
  | `MMU_SENSORS` | Report on the state of all sensors connected to the MMU | `DETAIL=[0\|1]` Whether to show all disabled sensors or just active ones |
  | `MMU_STATS` | Dump (and optionally reset) the MMU statistics for current print job or total | `RESET=1` If specified the persisted statistics will be reset (will only apply to counts if COUNTER argument is supplied). <br> `TOTAL=[0\|1]` whether to also show the total swap stats in addition to the current/last print job. <br>`DETAIL=[0\|1]` Whether to display additional details about the per-gate statistics. <br>`COUNTER=<name>` Consumption counter name. <br>`LIMIT=<int>` The maximum count for consumption counter before warning. <br>`WARNING="<message>"` The warning message to issue when the counter exceeds limit. <br>`PAUSE=1` Whether to pause the print when the limit is reach verses just warning. <br>`INCR=1` Increment the consumption counter by one (can be any positive number). <br>`DELETE=1` deletes the specified consumption counter completely (use "RESET=1" to reset count to 0). <br>`SHOWCOUNTS=1` will also display the comsuption counters |
  | `MMU_STATUS` | Report on MMU state, capabilities and Tool-to-Gate map | `DETAIL=[0\|1]` Whether to show a more detailed view including EndlessSpool groups and full Tool-To-Gate mapping. <br>`SHOWCONFIG=[0\|1]` (default 0) Whether or not to describe the machine configuration in status message |

<br>
  
  ### Servo and motor control
  | Command | Description | Parameters |
  | ------- | ----------- | ---------- |
  | `MMU_MOTORS_OFF` | Turn off both MMU motors | None. |
  | `MMU_SERVO` | Set the servo to specified postion or a sepcific angle for testing. Will also report position when run without parameters | `POS=[up\|down\|move]` Move servo to predetermined position. <br>`ANGLE=..` Move servo to specified angle. <br>`SAVE=1` Specifed with the POS= parameter will cause Happy Hare to store the current servo angle for the specified position. This is written to mmu_vars.cfg |
  | `MMU_SYNC_GEAR_MOTOR` | Explicitly override the synchronization of extruder and gear motors. Note that synchronization is set automatically so this will only be sticky until the next tool change | `SYNC=[0\|1]` Turn gear/extruder synchronization on/off (default 1). <br>`SERVO=[0\|1]` If 1 (the default) servo will engage if SYNC=1 or disengage if SYNC=0 otherwise servo position will not change. <br>`FORCE_IN_PRINT=[0\|1]` If 1, gear stepper current will be set according to "sync_gear_current". If 0, gear stepper current is set to 100%. The default is automatically determined based on print state but can be overridden with this argument. Only meaningful if "SYNC=1". |
  
<br>

  ## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Calibration

```yml
    MMU_CALIBRATE_BOWDEN : Calibration of reference bowden length for gate 0
    MMU_CALIBRATE_ENCODER : Calibration routine for the MMU encoder
    MMU_CALIBRATE_GATES : Optional calibration of individual MMU gate
    MMU_CALIBRATE_GEAR : Calibration routine for gear stepper rotational distance
    MMU_CALIBRATE_SELECTOR : Calibration of the selector positions or postion of specified gate
    MMU_CALIBRATE_TOOLHEAD : Calibration of key toolhead distances
    MMU_COLD_PULL : Guide you through the process of cleaning your extruder with a cold pull
```
  
  | Command | Description | Parameters |
  | ------- | ----------- | ---------- |
  | `MMU_SERVO` | Set the servo to specified postion or a sepcific angle for testing. Will also report position when run without parameters | `POS=[up\|down\|move]` Move servo to predetermined position. <br>`ANGLE=..` Move servo to specified angle. <br>`SAVE=1` Specifed with the POS= parameter will cause Happy Hare to store the current servo angle for the specified position. This is written to mmu_vars.cfg |
  | `MMU_CALIBRATE_GEAR` | Calibration rourine for the the gear stepper rotational distance | `LENGTH=..` length to test over (default 100mm). <br>`MEASURED=..` User measured distance. <br>`SAVE=[0\|1]` (default 1) Whether to save the result. |
  | `MMU_CALIBRATE_ENCODER` | Calibration routine for MMU encoder | `LENGTH=..` Distance (mm) to measure over. Longer is better, defaults to 400mm. <br>`REPEATS=..` Number of times to average over. <br>`SPEED=..` Speed of gear motor move. Defaults to long move speed. <br>`ACCEL=..` Accel of gear motor move. Defaults to motor setting in ercf_hardware.cfg. <br>`MINSPEED=..` & `MAXSPEED=..` If specified the speed is increased over each iteration between these speeds (only for experimentation). <br>`SAVE=[0\|1]` (default 1)  Whether to save the result. |
  | `MMU_CALIBRATE_SELECTOR` | Calibration of the selector gate positions. By default will automatically calibrate every gate.  ERCF v1.1 users must specify the bypass block position if fitted.  If GATE to BYPASS option is sepcifed this will update the calibrate for a single gate | `GATE=[0..n]` The individual gate position to calibrate. <br>`BYPASS=[0\|1]` Calibrate the bypass position. <br>`BYPASS_BLOCK=..` Optional (v1.1 only). Which bearing block contains the bypass where the first one is numbered 1. <br>`SAVE=[0\|1]` (default 1) Whether to save the result. |
  | `MMU_CALIBRATE_BOWDEN` | Measure the calibration length of the bowden tube used for fast load movement. This will be performed on gate #0 | `BOWDEN_LENGTH=..` The approximate length of the bowden tube but NOT longer than the real measurement. 50mm less that real is a good starting point. <br>`HOMING_MAX=..` (default 100) The distance after the sepcified BOWDEN_LENGTH to search of the extruder entrance. <br>`REPEATS=..` (default 3) Number of times to average measurement over. <br>`SAVE=[0\|1]` (default 1)  Whether to save the result. <br>`MANUAL=1` This allows for calibration without an encoder. |
  | `MMU_CALIBRATE_GATES` | Optional calibration for loading of a sepcifed gate or all gates. This is calculated as a ratio of gate #0 and thus this is usually the last calibration step | `GATE=[0..n]` The individual gate position to calibrate. <br>`ALL=[0\|1]` Calibrate all gates 1..n sequentially (filament must be available in each gate). <br>`LENGTH=..` Distance (mm) to measure over. Longer is better, defaults to 400mm. <br>`REPEATS=..` Number of times to average over. <br>`SAVE=[0\|1]` (default 1)  Whether to save the result. |
  | `MMU_CALIBRATE_TOOLHEAD` | Optional calibration of key toolhead dimension and toolhead cutting variables. This should be run as instructed in [Blobbing and Stringing](Blobbing-and-Stringing) | `CLEAN=1` This will calibrate **toolhead_extruder_to_nozzle**, **toolhead_sensor_to_nozzle**, **toolhead_entry_to_extruder**. <br>` ` Without parameters this will calibrate **toolhead_ooze_reduction**. <br>`CUT=1` Calibrate **variable_blade_pos** for the tip cutting macro |
  | `MMU_COLD_PULL` | This command (implement as a macro) should be run as instructed in [Blobbing and Stringing](Blobbing-and-Stringing#---cleaning-extruder-with-a-cold-pull). It walks you through the process automating much of the work | `MATERIAL=[nylon\|pla\|abs\|petg]` Specify the type of material you are using for the cold pull for temperature default. <br>`HOT_TEMP=xxx` Override initial high temp in °C. <br>`COLD_TEMP=xxx` Override temp to cool too to help release filament. <br>`MIN_EXTRUDE_TEMP=xxx` Override temp to which the extruder will keep nozzle pressurized. <br>`PULL_TEMP=xxx` Override temp to perform the cold pull. <br>`PULL_SPEED=[10]` Optionally change the speed of extruder movement to help manual pull in mm/s. <br>`CLEAN_LENGTH=[25]` Optionally change the amount of filament to extrude to prime extruder/nozzle. <br>`EXTRUDE_SPEED=[1.5]` Optionally change speed in mm/s to perform extrude operations |

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Testing

```yml
    MMU_SOAKTEST_LOAD_SEQUENCE : Soak test tool load/unload sequence
    MMU_SOAKTEST_SELECTOR : Soak test of selector movement
    MMU_TEST_BUZZ_MOTOR : Simple buzz the selected motor (default gear) for setup testing
    MMU_TEST_CONFIG : Runtime adjustment of MMU configuration for testing or in-print tweaking purposes
    MMU_TEST_FORM_TIP : Convenience macro for calling the standalone tip forming functionality (or cutter logic)
    MMU_TEST_GRIP : Test the MMU grip for a Tool
    MMU_TEST_HOMING_MOVE : Test filament homing move to help debug setup / options
    MMU_TEST_LOAD : For quick testing filament loading from gate to the extruder
    MMU_TEST_MOVE : Test filament move to help debug setup / options
    MMU_TEST_RUNOUT : Manually invoke the clog/runout detection logic for testing
    MMU_TEST_TRACKING : Test the tracking of gear feed and encoder sensing
```
    
  | Command | Description | Parameters |
  | ------- | ----------- | ---------- |
  | `MMU_SOAKTEST_SELECTOR` | Reliability testing to put the selector movement under stress to test for failures. Randomly selects gates and occasionally re-homes | `LOOP=..[100]` Number of times to repeat the test. <br>`SERVO=[0\|1]` Whether to include the servo down movement in the test. <br> `HOME=[0\|1]` Whether to include randomized homing operations |
  | `MMU_SOAKTEST_LOAD_SEQUENCE` | Soak testing of load sequence. Great for testing reliability and repeatability| `LOOP=..[10]` Number of times to loop while testing. <br>`RANDOM=[0\|1]` Whether to randomize tool selection. <br>`FULL=[0\|1]` Whether to perform full load to nozzle or short load just past encoder. |
  | `MMU_TEST_BUZZ_MOTOR` | Buzz the sepcified MMU motor. If the gear motor is buzzed it will also report if filament is detected | `MOTOR=[gear\|selector\|servo]`. |
  | `MMU_TEST_CONFIG` | Dump / Change Happy Hare klipper parameters at runtime | `..many..` Best to run MMU_TEST_CONFIG without options to report all parameters than can be specified. <br>`QUIET=1` To suppress the list of current values. Useful for use in a macro. <br> <br>You must manually update mmu_parameters.cfg to persist the change accross restarts. <br> <br>Note: this only modifies Happy Hare klipper parameters in found in mmu_parameters.cfg; Happy Hare macro variables in mmu\_macro\_vars.cfg can be updated in a similar way using `SET_GCODE_VARIABLE`. See [Macro Variable Tip](Configuring-mmu_macro_vars.cfg#time-saving-tip). |
  | `MMU_TEST_FORM_TIP` | Convenience macro to call to test the standalone tip forming functionality | `..many..` Any valid "\_MMU\_FORM\_TIP" gcode variables found in mmu\_macro\_vars.cfg can be supplied as a parameter and will override the defaults. The overrides will remain active (sticky) until called with "RESET=1" which will cause Happy Hare to revert to starting values (in mmu\_macro\_vars.cfg). <br>`SHOW=1` will just list the current macro variable values and not run macro. <br>`RUN=0` will set the variable but not run the macro. <br>`FORCE_IN_PRINT=1` behave like in print with gear/extruder syncing and current. <br>`EJECT=[0\|1]` Force ejection of filament after tip forming, akin to setting "variable\_final\_eject=1". <br>`RESET=1` Restore in memory override values back to config file defaults. |
  | `MMU_TEST_GRIP` | Test the MMU grip of the currently selected tool by gripping filament but relaxing the gear motor so you can check for good contact | None. |
  | `MMU_TEST_LOAD` | Test loading filament from park position in the gate. (MMU_EJECT will unload) | `LENGTH=..[100]` Test load the specified length of filament into selected too. <br>`FULL=[0\|1]` If set to one a full bowden move will occur and filament will home to extruder. |
  | `MMU_TEST_MOVE` | Simple test move the MMU gear stepper | `MOVE=..[100]` Length of gear move in mm. <br>`SPEED=..` (defaults to speed defined to type of motor/homing combination) Stepper move speed. <br>`ACCEL=..` (defaults to min accel defined on steppers employed in move) Motor acceleration. <br>`MOTOR=[gear\|extruder\|gear+extruder\|extruder+gear]` (default: gear) The motor or motor combination to employ. gear+extruder commands the gear stepper and links extruder to movement, extruder+gear commands the extruder stepper and links gear to movement. |
  | `MMU_TEST_HOMING_MOVE` | Testing homing move of filament using multiple stepper combinations specifying endstop and driection of homing move | `MOVE=..[100]` Length of gear move in mm. <br>`SPEED=..` (defaults to speed defined to type of motor/homing combination) Stepper move speed. <br>`ACCEL=..` Motor accelaration (defaults to min accel defined on steppers employed in homing move). <br>`MOTOR=[gear\|extruder\|gear+extruder\|extruder+gear]` (default: gear) The motor or motor combination to employ. gear+extruder commands the gear stepper and links extruder to movement, extruder+gear commands the extruder stepper and links gear to movement. This is important for homing because the endstop must be on the commanded stepper. <br>`ENDSTOP=..` Symbolic name of endstop to home to as defined in mmu_hardware.cfg. Must be defined on the primary stepper. <br>`STOP_ON_ENDSTOP=[1\|-1]` (default 1) The direction of homing move. 1 is in the normal direction with endstop firing, -1 is in the reverse direction waiting for endstop to release. Note that virtual (touch) endstops can only be homed in a forward direction. |
  | `MMU_TEST_RUNOUT` | Invoke filament runout handler that will also trigger EndlessSpool if enabled and thus useful to validate your load/unload sequence macros (define in `mmu_sequence.cfg`) | `FORCE_RUNOUT=0` optional parameter (defaults to `1`) that if set to `0` will cause HH to try to determine if a clog vs runout by also running a filament movement test. |
  | `MMU_TEST_TRACKING` | Simple visual test to see how encoder tracks with gear motor | `DIRECTION=[-1\|1]` Direction to perform the test (default load direction). <br>`STEP=[0.5 .. 20]` Size of individual steps (default 1mm). <br>`SENSITIVITY=..` (defaults to expected encoder resolution). Sets the scaling for the +/- mismatch visualization. |

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Macros

```yml
    MMU_END : Called when ending print to finalize MMU
    MMU_START_CHECK : Helper macro. Can be called to perform pre-start checks on MMU based on slicer requirements
    MMU_START_LOAD_INITIAL_TOOL : Helper to load initial tool if not paused
    MMU_START_SETUP : Called when starting print to setup MMU
    _MMU_ACTION_CHANGED : Called when an action has changed
    _MMU_DUMP_TOOLHEAD : For debugging: dump current configuration of MMU Toolhead rails
    _MMU_GATE_MAP_CHANGED : Called when gate map is updated
    _MMU_POST_FORM_TIP : Optional post tip forming/cutting routing
    _MMU_POST_LOAD : Optional post load routine for filament change
    _MMU_POST_UNLOAD : Optional post unload routine for filament change
    _MMU_PRE_LOAD : Optional pre load routine for filament change
    _MMU_PRE_UNLOAD : Optional pre unload routine for filament change
    _MMU_PRINT_END : Cleans up state after after print end
    _MMU_PRINT_START : Initialize MMU state and ready for print
    _MMU_PRINT_STATE_CHANGED : Called when print state changes
```

<br>

### Macros intended for Slicer Setup (defined in mmu_software.cfg):

See [Slicer Setup](Slicer-Setup) for details

  | Macro | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Description&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Parameters |
  | ----- | ----------- | ---------- |
  | `MMU_END` | Called when ending print to finalize MMU | `EJECT=[0\|1]` Override the macro setting for final unloading of filament. |
  | `MMU_START_CHECK` | Helper macro. Can be called to perform pre-start checks on MMU based on slicer requirements | |
  | `MMU_START_LOAD_INITIAL_TOOL` | Helper to load initial tool if not paused | |
  | `MMU_START_SETUP` | Call when starting print to setup MMU | `INITIAL_TOOL`, `REFERENCED_TOOLS`, `TOOL_COLORS`, `TOOL_TEMPS`, `TOOL_MATERIALS`, `TOOL_NAMES`. See [Slicer Setup](Slicer-Setup) for details. |
  | | | |
  | `_MMU_UPDATE_HEIGHT` | Called on layer change to record maximum toolhead height for z-hop base for sequential printing | `HEIGHT=..` Optionally reset the minimum height. Normally not specified. |

<br>

### Callbacks (defined in mmu_state.cfg, mmu_sequence.cfg):

  | Macro | Description | Supplied Parameters |
  | ----- | ----------- | ------------------- |
  | `_MMU_PRE_UNLOAD` | Called prior to unloading on toolchange | |
  | `_MMU_POST_FORM_TIP` | Called immediately after forming tip | |
  | `_MMU_POST_UNLOAD` | Called after unload is complete and filament is parked at the gate | |
  | `_MMU_PRE_LOAD` | Called prior to the loading of a new filament | |
  | `_MMU_POST_LOAD` | Called subsequent to loading new filament | |
  | `_MMU_FORM_TIP` | Called to create tip on filament (when not under the control of the slicer). You tune this macro by modifying the defaults to the parameters | `FINAL_EJECT` override the default configured behavior in mmu_macro_vars.cfg |
  | `_MMU_CUT_TIP` | Called to create tip by cutting the filament. You tune this macro by modifying the defaults to the parameters | `FINAL_EJECT` override the default configured behavior in mmu_macro_vars.cfg |
  | | | |
  | `_MMU_ACTION_CHANGED` | Callback that is called everytime the `printer.ercf.action` is updated. Great for contolling LED lights, etc | `ACTION` <br>`OLD_ACTION`|
  | `_MMU_GATE_MAP_CHANGED` | Called when gate map is updated. Useful for updating LED lights, etc | `GATE` |
  | `_MMU_PRINT_STATE_CHANGED` | Callback when the print job state changes and `printer.ercf.print_state` is updated. Great for contolling LED lights, etc | `STATE` <br>`OLD_STATE`|

<br>

### Internal "step" macros for custom composition of load/unload sequences:

```yml
_MMU_LOAD_SEQUENCE : Called when MMU is asked to load filament
_MMU_UNLOAD_SEQUENCE : Called when MMU is asked to unload filament
_MMU_M400 : Wait on both move queues
_MMU_STEP_HOME_EXTRUDER : User composable loading step: Home to extruder sensor or entrance through collision detection
_MMU_STEP_HOMING_MOVE : User composable loading step: Generic homing move
_MMU_STEP_LOAD_BOWDEN : User composable loading step: Smart loading of bowden
_MMU_STEP_LOAD_GATE : User composable loading step: Move filament from gate to start of bowden
_MMU_STEP_LOAD_TOOLHEAD : User composable loading step: Toolhead loading
_MMU_STEP_MOVE : User composable loading step: Generic move
_MMU_STEP_SET_FILAMENT : User composable loading step: Set filament position state
_MMU_STEP_UNLOAD_BOWDEN : User composable unloading step: Smart unloading of bowden
_MMU_STEP_UNLOAD_GATE : User composable unloading step: Move filament from start of bowden and park in the gate
_MMU_STEP_UNLOAD_TOOLHEAD : User composable unloading step: Toolhead unloading
```

<br>

  | Macro | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Description&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Parameters |
  | ----- | ----------- | ---------- |
  | `_MMU_LOAD_SEQUENCE` | Advanced: Called when MMU is asked to load filament | `FILAMENT_POS` <br>`LENGTH` <br>`FULL` <br>`HOME_EXTRUDER` <br>`SKIP_EXTRUDER` <br>`EXTRUDER_ONLY` |
  | `_MMU_UNLOAD_SEQUENCE` | Advanced: Called when MMU is asked to unload filament | `FILAMENT_POS` <br>`LENGTH` <br>`EXTRUDER_ONLY` <br>`PARK_POS` |
  | | | |
  | `_MMU_M400` | User composable loading step that will force a wait on both the toolhead and mmu move queues | |
  | `_MMU_STEP_LOAD_GATE` | User composable loading step: Move filament from gate to start of bowden using encoder or gate sensor | |
  | `_MMU_STEP_LOAD_BOWDEN` | User composable loading step: Smart loading of bowden | `LENGTH=..` |
  | `_MMU_STEP_HOME_EXTRUDER` | User composable loading step: Extruder collision detection | |
  | `_MMU_STEP_LOAD_TOOLHEAD` | User composable loading step: Toolhead loading | `EXTRUDER_ONLY=[0\|1]` |
  | `_MMU_STEP_UNLOAD_TOOLHEAD` | User composable unloading step: Toolhead unloading | `EXTRUDER_ONLY=[0\|1]` <br>`PARK_POS=..` |
  | `_MMU_STEP_UNLOAD_BOWDEN` | User composable unloading step: Smart unloading of bowden | `FULL=[0\|1]` `LENGTH=..` |
  | `_MMU_STEP_UNLOAD_GATE` | User composable unloading step: Move filament from start of bowden and park in the gate using encoder or gate sensor | `FULL=[0\|1]` |
  | `_MMU_STEP_SET_FILAMENT` | User composable loading step: Set filament position state | `STATE=[0..8]` <br>`SILENT=[0\|1]` |
  | `_MMU_STEP_MOVE` | User composable loading step: Generic move | `MOVE=..[100]` Length of gear move in mm. <br>`SPEED=..` (defaults to speed defined to type of motor/homing combination) Stepper move speed. <br>`ACCEL=..` (defaults to min accel defined on steppers employed in move) Motor acceleration. <br>`MOTOR=[gear\|extruder\|gear+extruder\|extruder+gear]` (default: gear) The motor or motor combination to employ. gear+extruder commands the gear stepper and links extruder to movement, extruder+gear commands the extruder stepper and links gear to movement |
  | `_MMU_STEP_HOMING_MOVE` | User composable loading step: Generic homing move | `MOVE=..[100]` Length of gear move in mm. <br>`SPEED=..` (defaults to speed defined to type of motor/homing combination) Stepper move speed. <br>`ACCEL=..` Motor accelaration (defaults to min accel defined on steppers employed in homing move). <br>`MOTOR=[gear\|extruder\|gear+extruder\|extruder+gear]` (default: gear) The motor or motor combination to employ. gear+extruder commands the gear stepper and links extruder to movement, extruder+gear commands the extruder stepper and links gear to movement. This is important for homing because the endstop must be on the commanded stepper. <br>`ENDSTOP=..` Symbolic name of endstop to home to as defined in mmu\_hardware.cfg. Must be defined on the primary stepper. <br>`STOP_ON_ENDSTOP=[1\|-1]` (default 1) The direction of homing move. 1 is in the normal direction with endstop firing, -1 is in the reverse direction waiting for endstop to release. Note that virtual (touch) endstops can only be homed in a forward direction |

<br>

> [!NOTE]  
> *Recommended and working PAUSE / RESUME / CANCEL_PRINT macros are defined in `client_macros.cfg` and can be used if you don't already have your own*
