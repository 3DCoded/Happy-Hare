# Happy Hare - Detailed Revision History

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Imperfect Log Changes since V2 launch

### v2.0.1
- Initial Release (forked from my ERCF-Software-V3 project which is now deprecated).
- HHv2 is a rewrite to structure the software so it can support all types of MMU (only ERCF at release) and sanitize command set
- Adds total control of motor synchronization, multiple endstops (even for the extruder!!)
- Although HHv1 (aka ERCF-Software-V3) will remain available, HHv2 will be where all future enhancements will be made
- The latest KlipperScreen-Happy_Hare edition requires HHv2 (for my sanity)
- Much better doc and LOTS of new features to discover

### v2.1.0
- Speed and extrusion overrides (M220/M221) support .. records overrides across tool changes (MMU_TOOL_OVERRIDES command to see/reset)
- SpoolMan support (new options to MMU_GATE_MAP for SpoolD.. see  doc)
- Separate "per-print" and total swap stats!  No need to clear in your print_start anymore.
- "Auto restoring" gate quality indication (the "excellent/good/../terrible" one).  Slowly averages out bad results.
- New "state machine" that closes a lot of annoying corner cases that I knew about but most users hadn't found yet [doc](Print-Job-State-Machine).
- New filament cutter option (Alternative `_MMU_CUT_TIP` macro) instead of tip forming and `mmu_form_tip_macro` setting
- MMU_UNLOCK is back (but as an optional step to resume temps).  Can just call `RESUME` as well.
- Better support for Octoprint users where the [print_stats] module is not available. Read up on new state machine and `_MMU_START_PRINT` and `_MMU_END_PRINT` conventions (must read doc)
- New  moonraker gcode pre-processor module! Adds !referenced_tools!  placeholder so you can automatically check all used tools before printing [wiki](Gcode-Preprocessing)
- 'MMU_FORM_TIP' command updated to allow for runtime "tuning"  Any variable to the macro can be adjust (and persisted) for testing or tweaking in print (handles tip cutting macro as well)
- Config now also automatically adjusts references to "extruder"  when referring to stepper (e.g. in rare [controller_fan], [homing_heaters] and [angle])
- Lots of little things/bug fixes but I lost track 🫣

### v2.2.0
- Replacement of manual steppers with new MMU toolhead - faster homing and movements in general, new optional `gate` and `extruder` sensors, optional encoder, intial support for Tradrack and other customized designs.
- Ever wanted to use Happy Hare on a non-ERCF MMU?
- Ever wanted to use a pre-extruder entry sensor instead of collision?
- Wanted to fit a gate sensor and not rely on encoder for loading and parking at the gate
- Want to run without an encoder? (why? 🤷 )
- Want fast (no wait) homing?
- DON'T WANT TO RECONFIGURE YOUR EXISTING EXTRUDER? 👍
- Want the latest and greatest features?

### v2.3.0
**NOTE: Requires Klipper 0.12.0 or greater**
- LED support for bling, gate_status, filament color and action status, pre-gate sensor support for automated loading and gate_status setting, BTT MMB board support, integrated filametrix cutter support, new [mmu_sensors] config section of easy sensor setup. Doc improvements.
New Features:
- LED (bling) support! See new page in the [wiki doc](Led-Support)
- Pre-gate sensor support:  Automatically set gate_status, LED status and activate pre-load. Oh, and new earlier run-out detection of reliable EndlessSpool
- Installer updates and support for BTT MMB board
- Integrated Filament Cutter support (Filametrix)
- Improved doc. E.g. [Conceptual MMU](Conceptual-MMU)
- New [mmu_sensors] section for simple setup of filament_sensors and endstops
- Enhancements for gate_sensor as alternative or in addition to encoder
- Lots of bug fixes and minor enhancements requested.
- Version tracking and better feedback on what to do
- Enhancements to existing commands. E.g try: 'MMU_STATUS SHOWCONFIG=1'

### v2.3.1
- Better Spoolman integration: will now pull material and colors from spoolman in addition to activating the spool
- Allow the LED effects to be configure anywhere on a chain (as well as gate 0->N or N->0 ordering)
- EndlessSpool got some love because I think it will be much more valuable with pre-gate switches and early runout detection:
 - a) endless_spool_on_load parameter that will activate ES on loading a tool with empty gate
 - b) endless_spool_final_eject distance specification for push beyond park position in an attempt to prevent filament from being accidentally re-loaded
 - c) Cleanup of the display on klipper console and log messages
 - d) Will ensure that the gate_status is at least "unknown" when MMU_REMAP_TTG is run, so attempt will always be made to load from the gate

### v2.4.0
- Updated LED support with lots more "multi-segment" flexibility
- New servo calibration - to fine tune and save without klipper restart!
- New full set of default toolhead positioning macros (defined in `mmu_sequence.cfg`)
- Full support for pre-extruder sensor option (prior to extruder entry)
- Exposed vendor-specific params (including the "cad_" set -- see doc at bottom of `mmu_parameters.cfg`)
- Full support for Tradrack including installer
- New manual bowden calibration for setups without encoder
- Workaround for CANbus comms timeout that is plaguing klipper
- Much improved `MMU_STATUS SHOWCONFIG=1`.  It will tell you in english what loading and unload sequence you have based on dynamic changes with `MMU_TEST_CONFIG` or sensor disable/enable.
- EndlessSpool is now available on tool load
- Sync feedback sensor support .. I.e support for Annex Belay or another other sensor including proportional feedback. [doc](Synchronized-Gear-Extruder#---sync-feedback-sensor-options)
- Improved "tip forming" test procedure and `MMU_FORM_TIP` command
- Fixed silly bug in spoolman integration where spool_id was being used to search as filament_id
- New `toolhead_ooze_reduction` parameter for tuning without messing with what should be fixed extruder measurements. Doc page to follow
- Refined toolhead unloading with better detection of incorrect config
- Cleanup and separation of config files based on function
- Lots of new/updated doc

### v2.4.1
- Fixes / update to the way toolhead movement occurs through the "sequence macros" like `_MMU_PRE_UNLOAD` and `_MMU_POST_LOAD` etc. 
  - Also if enabled these will now work while not actively printing (that was an oversight)
  - These macros also play nicely with Klippain  pause/resume macros now
  - The z_hop_height_error has been deprecated. Additional z_hop height can be configured in the macro variables at the start of mmu_sequence.cfg
- LED update
  - Better error feedback on LED misconfiguration
  - Fix for led index when order of reversed.

### v2.4.2 (Klipperscreen-Happy Hare edition will also need to be updated)
- New placeholder preprocessing for colors and filament temps pulled from you slicer ( !colors! and !temperatures! ). See [here](Gcode-Preprocessing)
- LED update: New effect `custom_color`.  This will display colors stored for each gate based on user setting. One example use is to render the colors used in the slicer so you can visually compare with what is loaded.  Documentation is in the gcode pre-processing section.
- Improved movement "sequence" macros.  These now work better when not completely homed (e.g. z-hop is optional.
- CUT_TIP macro now has option to control whether movement goes back to wipetower or not after cut
- Faster pausing on runout
- Fix for not automatically engaging the sync/servo after fixing error and resuming.
  - New [Slicer Setup](Slicer-Setup) doc on how to setup your slicer to disable tip forming
  - New [Toolchange Movement](Toolchange-Movement) doc on how to setup toolhead movement during toolchange or error
- Couple of new states to filament movement.  These are to enable and display of various other sensors such as a gate sensor (option to encoder) and pre-entry extruder sensor.
- New rendering of filament position in console (and KlipperScreen-HH) showing all sensor options if fitted
- Imporved use of miscellaneous sensors to detect errors or non-errors
- Cleanup of the status displays of various commands `MMU_GATE_MAP`, `MMU_TTG_MAP`, `MMU_ENDLESS_SPOOL`
- New encoder calibration routine that allows calibration that "remembers" gate homing point and compensates for space between gate sensor and encoder if both are fitted
- Other bug fixes report in github "Issues"

### v2.4.3
- Bug fixes reported via github "Issues"
- Added capability to install to auto-check github to ensure the latest version and to switch branches with `-b <branch name>` option

### v2.5.0 (Recommend Klipperscreen-Happy Hare edition should be updated to get dialog popup fixes)
This release centralizes macro configuration and extends will a lot more pre-packaged options
- Macro config moved into a unified `mmu_macro_vars.cfg`.
- Default macros have become read-only with a formal way to add custom extensions
- New recommended "print_start" and end integration
  - See https://github.com/moggieuk/Happy-Hare/wiki/Slicer-Setup
- New `MMU_SLICER_TOOLS_MAP` command that is used by the "print_start" and for easy integration of non-wipetower purge options like the excellent "Blobifier"
E.g.
```
> MMU_SLICER_TOOL_MAP DETAIL=1
--------- Slicer MMU Tool Summary ---------
2 color print (Purge volume map loaded)
T0 (Gate 0, ASA, ff0000, 245°C)
T1 (Gate 1, ABS+, 00fe02, 240°C)
T6 (Gate 6, ABS, 0310fe, 240°C)
Initial Tool: T0
-------------------------------------------
Purge Volume Map:
To -> T0   T1   T2   T3   T4   T5   T6   T7   T8
T0    -   200  210  210  200  200  200  210  210
T1   200   -   210  210  200  200  200  210  210
T2   210  210   -   220  210  210  210  220  220
T3   210  210  220   -   210  210  210  220  220
T4   200  200  210  210   -   200  200  210  210
T5   200  200  210  210  200   -   200  210  210
T6   200  200  210  210  200  200   -   210  210
T7   210  210  220  220  210  210  210   -   220
T8   210  210  220  220  210  210  210  220   -
```
- New [Tip Forming and Purging](Tip-Forming-and-Purging) doc
- New printer variables:
   - `printer.mmu.slicer_tool_map.initial_tool`
   - `printer.mmu.slicer_tool_map.tools.<tool_num>.material|color|temp`
   - `printer.mmu.slicer_tool_map.purge_volumes`
   - `printer.mmu.runout` which is true during runout toolchange
   - `printer.mmu.active_gate` map of a attributes of current filament (like color, material, temp,..)
- Z-hop modfications:
   - By default HH will not return to pre-toolchange position (will only restore z-height).
   - New `variable_restore_xy_pos: True|False` to control sequence macros return to starting pos or let the slicer do it. This has benefit when printing without a wipe tower so the print is not contaminated at the point of tool-change
- New "addons" folder for recommended third-party extensions with ready-to-use configs
   - Includes @kevinakasam's "EREC" filament cutter logic for cutting at the MMU (ERCF specific)
   - Includes @dendrowen's excellent "Blobifier" - intelligent purging that doesn't require a wipe tower!! (Any MMU)
- Enhanced `MMU_SENSORS` command for quick review of all mmu sensors
- New (optional) popup dialog option in Mainsail/KlipperScreen/Fluidd when MMU pauses on error
- Two new pre-processing placeholders: !materials! and !purge_volumes!
- Also, thanks to the Blobifer author, @dendrowen, the "MMU Statistics" has been given some love with new layout and some new customization. For both total stats and current job status. See `console_stat_*` options in `mmu_parameters.cfg`). Note advanced formatting on Python3 only.
```
MMU Statistics:
+------------+-----------------------+--------------------------+----------+
| 1895(1230) |       unloading       |         loading          | complete |
|   swaps    | pre  |    -    | post | pre  |    -    |   post  |   swap   |
+------------+------+---------+------+------+---------+---------+----------+
|     total  | 0:47 | 6:54:24 | 0:02 | 0:02 | 5:35:31 | 6:40:30 | 20:05:52 |
|      └ avg | 0:00 |    0:13 | 0:00 | 0:00 |    0:10 |    0:12 |     0:35 |
|  this job  | 0:36 | 4:26:51 | 0:01 | 0:01 | 3:34:34 | 4:34:54 | 13:22:01 |
|      └ avg | 0:00 |    0:12 | 0:00 | 0:00 |    0:10 |    0:13 |     0:38 |
|       last | 0:00 |    0:12 | 0:00 | 0:00 |    0:10 |    0:17 |     0:42 |
+------------+------+---------+------+------+---------+---------+----------+

11:43:27 spent paused over 10 pauses (All time)
8:15:38 spent paused over 3 pauses (This job)
Number of swaps since last incident: 105 (Record: 1111)

Gate Statistics:
#0: 😎, #1: 😎, #2: —, #3: —, #4: —, #5: —, #6: 😎, #7: —, #8: —
```

### v2.5.1
The release provides more flexibilty in tool change movement, introduces consumption counters, optimizes statistics output
- New (moonraker) pre-processing option to lookahead for next print location to allow for option to move to the NEXT print position on completion of tool change. Requires addition to `[mmu_server]` section of `moonraker.conf`:
  - `enable_toolchange_next_pos: True`
- `variable_restore_xy_pos` can now be "none", "last" or "next" (next being new functionality)
- Augmented `MMU_STATS` functionality to provide "consumption counters" that can warn or even pause your print when threshold is exceeded
- New doc page to explain [statistics and consumption counters](Statistics-and-Consumption-Counters)
- New doc page to explain [spoolman config and use](Spoolman-Support)
- Elimination of "h" option to ERCFv2 MMU - ThumperBlock are not a compatible 23mm wide so no longer required
- More accurate timing of tool change phases
- Defaults for "white" and "black" filament can not be configured in `mmu_macro_vars.cfg`
- Fixes to `printer.mmu.runout` and `printer.mmu.last_tool` for better accuracy at all possible times
- Filament remaining in toolhead is now tracked accross reboots / restarts to prevent over extruding initial load
- `custom_color` is now a more intuitive `slicer_color` and set with the `MMU_SLICER_TOOL_MAP` command (MMU_START_SETUP does this for you)
- New config parameter `extruder_temp_variance` to specify the +/- delta allowable when waiting for extruder temperature
- Updates and to bloblifier macro (needs latest klipper)
- Allow specifying spool_id in advance for supporting RFID readers. You can read more about it [here](Spoolman-Support#auto-setting-with-rfid-reader)

### v2.5.1 (patches)
- Fixed incorrect doc in `mmu_macro_vars`
- Bug: Fixed user defined load/unload_sequence macro names (previously would always look for default names)
- Add all slicer tools to the "slicer_tool_map" (unused tools only visible with DETAIL=1 flag).
- Set color on Tx macros so color can be seen in Mainsail / Fluidd UI's. Requires refresh of Mainsail screen because it doesn't update dynamically :-(

### v2.5.2
- Doc converted to Wiki and removed from distribution. Old doc links will be invalid

### v2.6.0
**Main focus on this release is the reduction of blobing, stringing and tuning** for beautiful prints Read [here](https://github.com/moggieuk/Happy-Hare/wiki/Blobbing-and-Stringing). Most issues are because of incorrect toolhead parameters and the former lack of a retract setting when the toolhead is moving.  Both of those are now solved with automated toolhead calibration (including tip cutting variables) and an new z-hop ramp setting:
  - Added new `MMU_CALIBRATE_TOOLHEAD` command for automated measurement of `toolhead_extruder_to_nozzle`, `toolhead_sensor_to_nozzle`, `toolhead_entry_to_extruder` and `toolhead_ooze_reduction`. Read the doc but this will eliminate incorrect "trial and error" values for these key dimensions.
  - Added new `toolchange_retract` and `toolchange_retract_speed` parameters to allow for retraction at the time of "z-hop" and un-retract as print resumes.
  - Added new `z_hop_ramp` parameter to control how the toolhead move off the print to help break stringing. It allow the definition of a horizonal move on top of the "z-hop". The direction will be towards the center of the print area. The toolhead will ramp up and away from the print and then move back to original position above starting point. `z_hop_speed` should be increased closer to your x,y travel speed
  - Updated `form_tip` and `cut_tip` macros (and Blobifer) to correctly compensate for `toolhead_ooze_reduction` and `toolchange_retract`
  - Blobifier automatically calculates "additional purge" volume basaed on filament left in the hotend based on calibration rather than having to compensate by altering slicer purge map
  - New printer.mmu variables.. 'extruder_filament_remaining', 'extruder_residual_filament', 'toolchange_retract' for use in your own macros
  - Removed some minor pauses when resuming print
- New `MMU_COLD_PULL` helper command. Useful in its own right but essential for the new toolhead calibration. Check it out - it can work in a completely automated way (https://github.com/moggieuk/Happy-Hare/wiki/Blobbing-and-Stringing#---cleaning-extruder-with-a-cold-pull)

**Other new features include:**
- Help address one of the Timer Too Close error conditions - Klipper has a less than optimal "save-variable" implementation can can cause problems with old/slower SD-cards. To workaround this HH now includes a batch update so all the HH overhead is combined into one or two calls rather than the previous 10 or so. You can see a "mmu__revision" added to you `mmu_vars.cfg` that increments on every write.
- Couple more bug fixes (erroneous load errors) when using the `EXTRUDER_ONLY=1` flag on extruder loading/unloading without using bypass
- Added `gate_autoload` parameter to allow the pre-gate sensor autoload feature to be disabled
- Enhanced EndlessSpool functionality with `endless_spool_eject_gate` option allow for one gate to marked the waste gate ('W' in status) so that filament fragments will be sent to this gate rather than current gate. Allows for a "dump shoot" and prevents possible tangling when buffering on certain buffer designs where retracted filament end can escape into neighboring buffers. The default value of `-1` will use the current gate.
- Change parameter name `extruder_homing_current` to `extruder_collision_homing_current` to be more precise on meaning (upgrade will have made this change for you)
- Improved `MMU_STATUS SHOWCONFIG=1` functionality
- New installer support:
  - For new MMU's boards
  - For GDW DS041MG servo option with Siboor ERCFv2 kits
- New `servo_always_active` parameter for servos that require continuous PWM signal (like GDW DS041MG). Use with caution!
- `MMU_CHECK_GATE` now defaults to current gate when invoked with no arguments. `ALL=1` flag to force checking all gates.
- New Wiki content and enhancements to existing pages
- Bug fixes: one condition that could result in klipper "stepcompress" error

### v2.7.0
**Main focus: tighter integration with spoolman**
- Better integration with spoolman db. Printer name and gate assignment will be reflected in the spoolman db (requires spoolman >= 0.18.1)
- Now three modes of spoolman integration: `readonly` the former mode, `push` the former augmented with the updating of assigned gate directly in spoolman, and `pull` where the gate map is defined by what is in spoolman. Useful in larger print farms. This is controlled via a new `spoolman_support` parameter. Details [here](Spoolman-Support.md)
- New `MMU_SPOOLMAN` command for performing gate related management (updates) to spoolman db
- New innovative automatic TTG mapping strategies. Controlled by `variable_automap_strategy`. Essentially this is applied after reading the slicer tool map to ensure mapping to the correct gate even if the MMU is loaded incorrectly. Strategies include: 'none', 'filament_name', 'material', 'color', 'closest_color', 'spool_id'. Details [here](Tool-and-Gate-Maps.md#---automatic-tool-to-gate-ttg-mapping)
- Moonraker plugin now parses the filament names and includes in slicer tool map and mmu gate maps
- Mainsail integration: Extruder/Filament colors and other filament attributes from spoolman are displayed in UI. Also there are controls on what color to display: `slicer`, `gatemap` (hiding unused filaments), `allgates` for the full gate map. Controlled with the new `t_macro_color` parameter. Details [here](Mainsail-Fluidd-Integration.md) :cool:

**Other features/updates:**
- Can now use LEDs without led_effects being installed.  A new `variable_led_animation_enable` has been added to control this behavior and will simply be forced to False if led_effects module isn't installed. It can also be controlled from `MMU_LED ANIMATION=[0|1]`. LED updates have also been made slightly more efficient. Details in this [Wiki](Led-Support)
- Consumption counters now automatically track servo arm movement and filament cutting for automatic maintenance warnings - no need to add macros yourself. Remember `MMU_STATS SHOWCOUNTS=1` to view current counts.
- Now incorporates a filament "tightening" move after loading the toolhead if synced extruder is turned off. This is to prevent false clog detection when the slack in the bowden is greater than the clog detection length
- New `variable_user_park_move_macro` can be used to customized the movement to the park position instead of default straight line move (Issue #351).
- New printer variables: `printer.mmu.gate_filament_name` and `printer.mmu.spoolman_support`
- Fixed issue when the loaded slicer tool map could be reset during print start.
- Several PR's incorporated and bug fixes to address reported Issues.
- Slight changes to stepper synchronization that should help with TTC and stepcompress errors.
- Lots of wiki updates (see links above).
- Tolerance to in Danger Klipper "bleeding edge" added. Comes without warantee!
- Fixed (cosmetic) problem where the load/unload distances in the console animation weren't consistent (Issue #348)
- Added sanity checks to MMU_COLDPULL parameters so it can be called from Mainsail UI (Issue #362)
- Exposed `preload_retries` parameter to extend the time Happy Hare tries to automatically load a spool once the pre-gate sensor has been triggered (Issue #360)
- Added `variable_min_toolchange_z` (mmu_macro_vars.cfg) to specify the floor at which any toolchange movement will occur to prevent scraping the bed if no z-hop is specified.
- Project against klipper's new habit of setting toolhead position slightly out of range after homing - save position will ensure it is in range.
- Octoprint compatibity option has been removed from mmu_macro_vars .. not necessary to ensure compatibility anymore
- Wiki page on [macro customization](Macro-Customization) has been improved.
- Bloblifier macro update that adds "safe decend logic" to ensure toolhead doesn't hit parts of the print.

### v2.7.0 (patches)
- Lots of work to avoid TTC errors. Specifically working around what appears to be a klipper bug when lots of homing moves are used. I know this has solved the problem for the 4 users I was working closely with.
- Improved error reporting for connection problems with SpoolMan.

### v2.7.1
**Completely revised parking and movement for toolchange operations:**
- This is the big one. After upgrade, you **MAY NEED TO REVIEW and TWEAK the MOVEMENT** section `mmu_macro_vars.cfg` to finish configuration -- upgrade cannot be completely automated for all setups.
- Previously anything other than simple toolchange workflows was very confusing to setup. The configuration had too many "enable_parking" settings, etc. The new system is both much more sophisticated but should be easier to configure to get the behavior you want. Specifically parking can be defined on 7 operations: toolchange, load, unload, runout, complete, pause & cancel, and for each of those you can choose the parking location,z-hop (including optional ramp) and retraction.
- Additionally movements can be specified between certain toolchange steps to make it easy to, for example, park on a silicon pad to stop ozzing while changing. 
- End of print eject will no longer return to the print.
- Rewritten wiki page: [Toolchange Movement](Toolchange-Movement)

<br>Teaser:
```yml
variable_enable_park_printing   : 'toolchange,runout,load,unload,complete,pause,cancel'
variable_enable_park_standalone : 'toolchange,load,unload,pause,cancel'
variable_enable_park_disabled   : 'pause,cancel'

variable_min_toolchange_z       : 1.0

variable_park_toolchange        : -1, -1, 1, 10, 2
variable_park_runout            : -1, -1, 2, 10, 2
variable_park_pause             : 50, 50, 10, 0, 2
variable_park_cancel            : 150, 50, 20, 0, 5
variable_park_complete          : 50, 50, 20, 0, 5

variable_pre_unload_position    : -1, -1, 0
variable_post_form_tip_position : -1, -1, 0
variable_pre_load_position      : -1, -1, 0
```

**Automated calibration / tuning of bowden length and gear ratios:**
- Gear "ratios" in `mmu_vars.cfg` have been upgraded to a single list of `rotation_distances`.
- Bowden tube length can now be automatically tuned over time by setting the `auto_calibrate_bowden: 1` parameter. This will use telemetry from successful loads and unloads on gate 0 to adjust slowly to find the perfect length. [Caveat: not tested with all sync-feedback devices like Belay so may be better to initially disable]
- For designs like the ERCF that use a different BMG drive for each gate, each gear needs to be calibrated. Now the option `auto_calibrate_gates: 1` will use telemetry similar to above to tune the "rotation_distance" for that gear so movement matches the reference gate 0.

**Other:**
- Further **TTC mitigation**. Working with various users I narrowed down the cases where this was most likely to happen and worked around them. Logic is near identical but changes timing enough to prevent the error. But note that TTC can be caused by legitimate causes: PSU, heat, bad cables, overload, etc, etc. 
- Fixed error in the amount of filament loaded when using tip cutting (Filametrix). The load length was not correctly being reduced by the `toolhead_ooze_reduction` value when cutting tip (thanks to user @jacksky007 for debugging)
- Improved error feedback from spoolman moonraker module
- X and Y axis filament cutter support (PR413 - thank you)
- Creality K1 support (PR388 -- thank you)
- Toolerance to skew correct (move out of bounds) in both axes in blobifer macro (PR427 - thank you)
- Various bug fixes from Discord / Issue feedback
- Start of a new wiki page for KlipperScreen-Happy-Hare edition: [Klipperscreen](KlipperScreen)
- Wiki pages updated: [Slicer Setup](Slicer-Setup), [Command Reference](Command-Reference), [Happy Hare Parameters](Happy-Hare-Parameters), [Blobbing and Stringing](Blobbing-and-Stringing) and more..

### v2.7.2
**Addressed design oversight in toolhead calibration settings when cutting tips**
- Fixes issue where `toolhead_ooze_reduction` parameter was used for two purposes that cancelled each other out and thus prevented use for fine tuning load distance.
  - The previous `toolhead_ooze_reduction` value will be moved to `toolhead_residual_filament` to better represent what is means
  - `toolhead_ooze_reduction` will be reset to 0 and used exclusively for tuning the loading length (it's primary purpose)
  - `MMU_CALBRATE_TOOLHEAD` updated accordingly
  - Printer variables updated: `printer.mmu.extruder_filament_remaining` now holds the combined `toolhead_residual_filament` + any cut fragment length
  - Wiki updated
- New printer variable `printer.mmu.toolchange_purge_volume` which is valid during a toolchange and contains the recommended purge volume (from slicer tool map purge volues + volume of any residual filament left in extruder). Saves time in macros reading the entire purge volumes map
- Possible TTC mitigations (doing everything possible to give host more headroom)
  - Absolute minimal writes to `[save_variables]` during toolchange or check gates operations
  - Improved logger
- Allow extruder (entry) sensor to be used to autoload extruder when using the bypass. Controlled with new `bypass_autoload` parameter in `mmu_parameters.cfg`
- New rainbow effect on startup on entry LEDs

### v2.7.3
** Blobifier v1.5 update. Pretty cool update by @dendrowen incorporating @igiannakas idea of pulsing purging!**
- Purge with a pulsating (and occasionally, retracting) motion. This will prevent laminar flow from occuring and purge the old filament more quickly. (Up to 30% EXTRA filament saved!)
- Changed the blob calculation mode. The blob will now split into equal parts if it is too large (e.g. 2x85mm instead of 150mm + 20mm). This will eliminate/reduce the small blobs scattering over the buildplate.
- Due to the above changes, certain variables have been added and removed:
  - new:
    - z_raise: The total amount the nozzle should be raised during a blob. The value should be somewhere around iteration_z_raise * max_iterations_per_blob - triangular(iteration) * iteration_z_change
    - z_raise_exp: The rate at which the hotend reduces raising speed during a blob. 0.85 seems to be a good starting value.
    - purge_length_maximum: The maximum length of the entire purge. Use max_iterations_per_blob * max_iteration_length.
  - removed: `iteration_z_raise, max_iterations_per_blob, iteration_z_change, max_iteration_length`
- Revised some parameter checks to work with the new Happy Hare version 2.7
- Add settings:
  - shaker_arm_z to allow for different bed/shaker arm heights.
  - brush_accell to be able to change the acceleration of the brush movement.

<hr>

### v3.0.0
**Major code refactor for modular design**

**The BIG news - Finally support for Type-B MMU's**
- MMU's now supported by Happy Hare:
  - ERCF
  - Angry-Beaver
  - Box Turtle
  - Night Owl
  - 3MS
  - Tradrack
  - Custom
  - more comming! (Prusa, Chameleon)

- MMU Options supported by Happy Hare:
  - Toolhead filament cutting
  - MMU filament cutting (EREC, Snapping Turtle, ..)
  - Blobifier purging system
  - Passive or active rewinders
  - Sync feedback (Belay, TurtleNeck, ..)

Specific changes:
  - New style `mmu_hardware.cfg` to support replicated stepper configuration. Old configurations will be upgraded with new `[mmu_machine]` section but this might be a good time to look at the latest `mmu.cfg` and `mmu_hardware.cfg` templates.
  - New individual `mmu_gear` sensor option just past the MMU filament driver (e.g. for Box Turtle and Night Owl)
  - Combined `mmu_gate` and `mmu_extruder` (entry) sensors for "no bowden designs" (e.g. Angry Beaver and 3MS)
  - New per-gate bowden lengths option for specific MMU designs
  - New "no bowden" option for certain Type-B designs where the filaments are kept close to the extruder
  - Simplifed `mmu_parameters.cfg` for type-B MMU's without selector
  - KlipperScreen-happy_hare_edition updated with new type-B functionality

**Other**
- New calculated purge volume option using filament colors that is calculted by Happy Hare rather than relying on slicer to supply purge matrix
  - New `MMU_CALC_PURGE_VOLUMES` command to instruct Happy Hare to calculate purge volumes based on color strategy (slicer or gatemap). This is an option to reading from the slicer.
  - Printer varible `printer.mmu.toolchange_purge_volume` is always available on toolchange with the purge volume based on chosen strategy.<br>
E.g. In this example I have my "gate map" populated with filaments (that were pulled from spoolman). I can now calculate purge volume map...
```yml
> MMU_CALC_PURGE_VOLUMES
Purge map updated. Use 'MMU_SLICER_TOOL_MAP PURGE_MAP=1' to view
> MMU_SLICER_TOOL_MAP PURGE_MAP=1
No slicer tool map loaded
Purge Volume Map (mm^3):
To -> T0   T1   T2   T3   T4   T5   T6   T7   T8
T0    -   117  209  174  201  201  203  203  203
T1   287   -   190  141  357  357  296  296  296
T2   348  162   -   171  321  321  178  178  178
T3   293   71  130   -   327  327  240  240  240
T4   121  141  112  150   -    -   150  150  150
T5   121  141  112  150   -    -   150  150  150
T6   285  204   89  192  320  320   -    -    -
T7   285  204   89  192  320  320   -    -    -
T8   285  204   89  192  320  320   -    -    -
```
- MMU_UNLOAD / MMU_EJECT distinction: MMU_UNLOAD should be used for unloading filament and parking at the gate. MMU_EJECT will do the same as MMU_UNLOAD if loaded but if unloaded will take the further action of ejecting the filament out of the the gear stepper! careful which one you pick -- KlipperScreen and print end macros have been updated. Note on multi-gear MMUs is it possible to `MMU_EJECT GATE=x` even when another gate is loaded
  - the "final_ejection" of filament from the MMU is necessary for type-B designs but also use for ERCF/Tradrack users. You just have to change your muscle memory
- Improved "exit" LED status (a "blue" loading/loaded status) for MMU designs without a separate "status" LED.
- Removed `persistence_level` parameter so that state is now always persisted. There are many command available to reset specifc parts of the state so I decided it was better to always persist. But for QoL, two new startup options have been added:
  - `startup_home_if_unloaded` can be used to force homing of the selector (if MMU is unloaded) on startup if using a type-A MMU.
  - `startup_reset_ttg_map` used to reset TTG map to the default on restart.
- Renamed `auto_calibrate_gates` to `autotune_rotation_distance` to better describe what it does (auto upgraded)
- Renamed `auto_calibrate_bowden` to `autotune_bowden_length` to better describe what it does (auto upgraded)
- Added `extruder_homing_buffer` parameter which is the amount to reduce the fast bowden load so filament doesn't overshoot the extruder homing point. Useful if you need/want to home to extruder sensor before loading extruder
- New per-filament temperature setting!
  - New (persisted) gatemap "filament temperature" attribute
  - `MMU_GATE_MAP` command extended with "TEMP=xx" setting per gate
  - When out of a print, logic to ensure correct temperature will be per-filament, falling back to `extruder_default_temperature` setting if not available
  - Extruder temperature will be pulled from spoolman if spoolman is enabled
- New "addon" for driving DC eSpooler motor (for example for the Armored Turtle MMU design). Thanks @ammaze!
  - Two new parameters in `mmu_parameters.cfg` for calling macro to control the eSpooler: `espooler_start_macro` and `espooler_stop_macro`
- Reworked state recovery (MMU_RECOVER) that will utilize all new sensors if available
- Imporved filament pre-load functionality. Most noticable on type-B MMU's where we can load a gate without selecting it but it can now also allows pre-loading during a pause
- Don't enforce the `min_toolchange_z` if the parking move is `-1, -1, 0` i.e. no movement
- Improved calibration and intial setup:
    - Better selector calibration for designs without CAD defined physical travel limit (e.g. Tradrack)
    - Improved bowden calibration methods. Will now use automatically use the best method possible but all methods have been revamped
    - New startup calibration state message that reports any lapses of calibration
- Incorporated many PR's. Sorry, I lost count, but thanks to all of you who submitted, not matter how big or small

### v3.0.1
**Production Release for v3**
- Support for 3DChameleon added thanks to user @u3dreal !!
- Fixed some bugs introduced during the code refactor
- Dare I say **fixed the majority of Timer Too Close (TTC) errors**.  Really... results are very promising.

### v3.0.2
**Support for Multiple MMU**
- It is now possible to combine mutliple MMUs on the same printer and operate them as one. Currently this only works with type-B designs that have a separate stepper per gate/lane but will be extended to support any number and combinations in a future release.
  - Updated visualization for status
  - New Muli-MMU [wiki page](https://github.com/moggieuk/Happy-Hare/wiki/Multi-MMU)
- Updated LED support
  - New configuration that allows for complete flexibility of multiple chains, individual leds, partial chains, etc
  - New separate `logo` LED control (adds to `entry`, `exit` and `status`)
- New `gear_unload_speed` and `gear_unload_accel` in `mmu_parameters.cfg` to allow for tuning different from load speed - this allows squeezing the best performance out of your MMU but also allows for imposing limits on rewinder speed, etc
- New `has_filament_buffer` option in `mmu_parameters.cfg` (default to 1). This can be set to `0` if no filament buffer is installed (e.g. on designs with DC rewinder systems or users of Filamentalist). This option controls the use and visability in `MMU_STATUS` display.
- Beta support for awesome new [QuattroBox MMU](https://github.com/Batalhoti/QuattroBox/tree/main)
- Beta support for the tiny [PicoMMU](https://www.printables.com/model/1083174-mmu-multi-material-upgrade) with servo selector
- Fixed bug in `MMU_SOAKTEST_LOAD_SEQUENCE` where it may not home when unloading
- Ensure extruder syncing is disabled if MMU is disabled with `MMU ENABLE=0` (note it is often better to enable bypass and have a bowden feed that is outside of the MMU if not already integrated like ERCF)
- Minor fix for encoder reading accuracy on ERCF
- Integrated several PRs (refer to Github for details)

### v3.1.0
**Mainsail!!**
- Production release of v3.0.2 beta (support for multiple running MMUs)
- Compatibility with New mainsail beta UI!  (Fluidd under development)
  - Allows for blobifer animation, and toolhead and MMU tip cutting visualization
- Support for the fantastic new [QuattroBox](https://github.com/Batalhoti/QuattroBox)
- Support for the PicoMMU

<!--
- Beta support for [MMX - Multi Material eXtruder](#)
-->

<br>

_This project continues to take considerable effort and time not to mention the cost of building many MMU prototypes. Please consider helping to support me by donating to my [PayPal link](https://www.paypal.com/paypalme/moggieuk) in the github :pray:_
