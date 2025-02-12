Happy Hare allows for syncing gear motor with the extruder stepper during printing. This added functionality enhances the filament pulling torque, potentially alleviating friction-related problems. **It is crucial, however, to maintain precise rotational distances for both the primary extruder stepper and the gear stepper** A mismatch in filament transfer speeds between these components could lead to undue stress, filament grinding or printing artifacts. See the sync feedback control that can be used to mitigate this potential issue.

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Synchronized Gear and Extruder

Synchronization during printing is controlled by `sync_to_extruder` in `mmu_parameters.cfg`. If set to 1, after a toolchange, the MMU servo will stay engaged and the gear motor will sync with the extruder for extrusion and retraction moves. It can also separately be turned on for tip forming operations performed by Happy Hare's standalone tip forming macro:

**mmu_parameters.cfg parameters:**
```yaml
# Synchronized gear/extruder movement ----------------------------------------------------------------------------------
#
# This controls whether the extruder and gear steppers are synchronized during printing operations
# If you normally run with maxed out gear stepper current consider reducing it with 'sync_gear_current'
# If equipped with TMC drivers the current of the gear and extruder motors can be controlled to optimize performance.
# This can be useful to control gear stepper temperature when printing with synchronized motor
#
sync_to_extruder: 0                     # Gear motor is synchronized to extruder during print
sync_gear_current: 70                   # % of gear_stepper current (10%-100%) to use when syncing with extruder during print
sync_form_tip: 0                        # Synchronize during standalone tip formation (initial part of unload)
```

### Synchronization Workflow

If the `sync_to_extruder` feature is activated, the gear stepper will automatically coordinate with the extruder stepper following a successful tool change. Any MMU operation that necessitates exclusive gear stepper movement (like buzzing the gear stepper to verify filament engagement), will automatically disengage the sync. Generally, you don't need to manually manage the coordination/discoordination of the gear stepper — Happy Hare handles these actions. If the printer enters MMU_PAUSE state (due to a filament jam or runout, for example), synchronization is automatically disengaged and the servo lifted. Upon resuming a print synchronization will automatically be resumed however if you wish to enable it whilst operating the MMU during a pause use the `MMU_SYNC_GEAR_MOTOR` command.

The `MMU_SYNC_GEAR_MOTOR SYNC={0|1} SERVO={0|1} FORCE_IN_PRINT={0|1}` command functions as follows:
- Defaults to `sync=1`, `servo=1`
- If `sync=1` and `servo=1`, it triggers the servo and executes the synchronization
- If `sync=1` and `servo=0`, it performs only the synchronization
- In either of the above cases, `force_in_print=1` performs the synchronization and sets gear stepper current to `sync_gear_current`
- If `sync=0` and `servo=1`, it disengages and lifts the servo
- If `sync=0` and `servo=0`, it only disengages the synchronization

Note you can still control the gear stepper motor with the `MMU_TEST_MOVE` or `MMU_TEST_HOMING_MOVE` commands.

> [!WARNING]  
> If you run the gear stepper synchronized for long prints you might find that it can become very hot. You might want to consider using `sync_gear_current` to reduce the current while it is synced during print to keep the temperature down. Afterall you probably don't need full power while printing.  The current will be restored for loading and unloading operations.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Sync Feedback Sensor Options

When performing long periods of synchronized printing without a tool change to reset things, the effective synchronization of the two steppers will tend to drift. Even with perfect calibration the friction caused by the long filament path through the buffer system, the tugging of the filament on a heavy spool can cause slippage in the grip of either the extruder or more likely the gear / filament drive stepper. This mismatch can ultimately lead to artifacts in the print caused by the extruder missing steps or achieving a sub optimum extrusion ratio (btw did you know that with an encoder fitted you can monitor and see the under extrusion!). Although this is rarely an issue on a well tuned setup it can be accommodated for in Happy Hare by way of a sensor and feedback system that works against the accumulation of tension or compression in the filament path.

There are four types of sensor feedback that can be accommodated:
* Switch sensor that triggers under filament tension
* Switch sensor that triggers under filament compression
* Dual switch sensor that separately trigger under tension and compression (thus defining a neutral range)
* Proportional feedback sensor that can give a signal from 1.0 (max compression) to -1.0 (max tension) with 0 being neutral

The Belay project by Annex Engineering is a good example of the first type (note that the Klipper s/w for this project is not required). It sits somewhere in the bowden path from MMU to extruder and provides a spring loaded "gap" in the PTFE tube.

Essentially all of these provide a feedback signal (the first two lacking a neutral space and so are always working) that dynamically changes the `rotation_distance` of the gear (filament driver) stepper. When extruding and the sync feedback sensor reports tension, the `sync_multiplier_low` is used (or a proportion of it) to decrease the `rotation_distance` and thus increase the speed. This will have the effect of decreasing tension.  When the sync feedback sensor reports compression, the `sync_multiplier_high` is used (or a proportion of it) to increase the `rotation_distance` and thus decrease the speed.  This will have the effect relaxing the compression. When retracting the operation is reversed by switching multipliers.

The advantage of the dual switch and proportional feedback sensor is that they have a "neutral" zone that in theory can reduce thrashing between compression and tension. In practice with the correct tuning of `sync_multiplier_low/high` this is not an issue.

**mmu_hardware.cfg config:**
```yaml
[mmu_sensors]
sync_feedback_tension_pin:
sync_feedback_compression_pin:
```

**mmu_parameters.cfg parameters:**
```yaml
# Optionally it is possible to leverage feedback for a "compression/expansion" sensor in the bowden path from MMU to
# extruder to ensure that the two motors are kept in sync as viewed by the filament (the signal feedback state can be
# binary supplied by one or two switches: -1 (expanded) and 1 (compressed) of proportional value between -1.0 and 1.0
# Requires [mmu_sensors] setting        
#
sync_feedback_enable: 0                 # 0 = Turn off (even with fitted sensor), 1 = Turn on when printing
sync_multiplier_high: 1.05              # Maximum factor to apply to gear stepper `rotation_distance`
sync_multipler_low: 0.95                # Minimum factor to apply
```

This feature can be disabled even if hardware is configure by setting the `sync_feedback_enable` parameter (during print you can use `MMU_TEST_CONFIG sync_feedback_enable=[0|1]`

The current state of the feedback will be show in `MMU_STATUS` if active, but you can also get the raw state of the sensor switches with `MMU_SENSORS`
```
MMU_SENSORS
sync_feedback_tension_switch: open
sync_feedback_compression_switch: TRIGGERED
```
