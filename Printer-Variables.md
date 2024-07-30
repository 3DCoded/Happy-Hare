## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Happy Hare Added Printer Variables

Happy Hare exposed 'printer' variables that can be used in your own macros.

```yml
    printer.mmu.enabled : {bool} True if MMU is enabled
    printer.mmu.is_paused : {bool} True if MMU is paused after an error (can also use print_job_state)
    printer.mmu.is_locked : {bool} Deprecated, use for printer.mmu.is_paused instead
    printer.mmu.is_homed : {bool} True if MMU has been homed
    printer.mmu.is_in_print : {bool} True if MMU is managing a print job (print_job_state is printing|pause_locked|paused)
    printer.mmu.tool : {int} 0..n | -1 for unknown | -2 for bypass
    printer.mmu.gate : {int} 0..n | -1 for unknown
    printer.mmu.active_filament : {dict} of active filament attributes (from gate_map, e.g. active_filament.material, active_filament.color)
    printer.mmu.next_tool : {int} 0..n | -1 for unknown | -2 for bypass (during a tool change)
    printer.mmu.last_tool : {int} 0..n | -1 for unknown | -2 for bypass (during a tool change after unload)
    printer.mmu.last_toolchange : {string} description of last change similar to M117 display
    printer.mmu.runout : {bool} True while MMU is handling a runout
    printer.mmu.filament : {string} filament state in extruder (Loaded | Unloaded | Unknown)
    printer.mmu.filament_position : {float} location in mm of filament
    printer.mmu.filament_pos : {int} state machine - exact location of filament
    printer.mmu.filament_direction : {int} 1 (load) | -1 (unload)
    printer.mmu.servo : {string} Up | Down | Move | Unknown
    printer.mmu.ttg_map : {list} defined gate for each tool
    printer.mmu.gate_status : {list} per gate: 0 empty | 1 available | 2 available from buffer |  -1 unknown
    printer.mmu.gate_material : {list} of material names, one per gate
    printer.mmu.gate_name : {list} of filament names, one per gate
    printer.mmu.gate_color : {list} of color names, one per gate
    printer.mmu.gate_color_rgb : {list} of color rbg values from 0.0 - 1.0 in truples (red, green blue), one per gate
    printer.mmu.gate_spool_id : {list} of IDs for Spoolman, one per gate
    printer.mmu.custom_color_rgb : {list} of color rbg values from 0.0 - 1.0 in truples (red, green blue), one per gate
    printer.mmu.slicer_tool_map : {dict} of slicer defined tool attributes (in form slicer_tool_map.tools.x.[color|material|temp|in_use])
    printer.mmu.endless_spool_groups : {list} membership group (int) for each tool
    printer.mmu.tool_extrusion_multipliers : {list} current M221 extrusion multipliers (float), one per tool
    printer.mmu.tool_speed_multipliers : {list} current M220 extrusion multipliers (float), one per tool
    printer.mmu.action : {string} Idle | Loading | Unloading | Forming Tip | Heating | Loading Ext | Exiting Ext | Checking | Homing | Selecting
    printer.mmu.has_bypass : {int} 0 (not available) | 1 (available)
    printer.mmu.sync_drive : {bool} True if gear stepper is currently synced to extruder
    printer.mmu.sync_feedback_state : {string} State of sync feedback sensor (compressed | expanded | neutral | disabled)
    printer.mmu.print_job_state : {string} current job state seen by MMU (initialized | standby | started | printing | pause_locked | paused | complete | cancelled | error)
    printer.mmu.clog_detection : {int} 0 (off) | 1 (manual) | 2 (auto)
    printer.mmu.endless_spool : {int} 0 (disabled) | 1 (enabled) | 2 (additionally enabled for pre-gate sensor)
    printer.mmu.print_start_detection : {int} 0 (disabled) | 1 (enabled)
    printer.mmu.reason_for_pause : {string} 
    printer.mmu.extruder_filament_remaining : {float} amount of cut filament left in the extruder (for toolchange macros)
    printer.mmu.extruder_residual_filament : {float} amount of residual filament always left in extruder (for toolchange macros)
    printer.mmu.toolchange_retract : {float} amount of extruder retraction (useful in toolchange macros)
    printer.mmu.enable_spoolman : {int} 0 (disabled) | 1 (enabled) Deprecated, use printer.mmu.spoolman_support instead
    printer.mmu.spoolman_support: {string} spoolman integration mode (off | readonly | push | pull)
```

Optionally exposed for mmu_encoder (if fitted):

```yml
    printer['mmu_encoder mmu_encoder'].encoder_pos : {float} Encoder position measurement in mm
    printer['mmu_encoder mmu_encoder'].detection_length : {float} The detection length for clog detection
    printer['mmu_encoder mmu_encoder'].min_headroom : {float} How close clog detection was from firing on current tool change
    printer['mmu_encoder mmu_encoder'].headroom : {float} Current headroom of clog detection (i.e. distance from trigger point)
    printer['mmu_encoder mmu_encoder'].desired_headroom : {float} Desired headroom (mm) for automatic clog detection
    printer['mmu_encoder mmu_encoder'].detection_mode : {int} Same as printer.mmu.clog_detection
    printer['mmu_encoder mmu_encoder'].enabled : {bool} Whether encoder is currently enabled for clog detection
    printer['mmu_encoder mmu_encoder'].flow_rate : {int} % flowrate (extruder movement compared to encoder movement)
```
