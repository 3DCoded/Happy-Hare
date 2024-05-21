#### Page Sections:
- [Runout Detection](#---Runout-Detection)
- [Optional Encoder](#---Optional-Encoder)
- [Clog Detection](#---Clog-Detection)
- [EndlessSpool](#---EndlessSpool)
- [Flowrate Monitoring](#---Flowrate-Monitoring)

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Runout Detection

Filament runout detection will be enabled if you have suitable sensors configured. These sensors include the `mmu_gate` sensor, all `pre_gate` sensors and the encoder. When this occurs the print will pause and allow you to replace filament before proceding. If EndlessSpool is enabled this filament replacement can be automatic. In addition if the MMU is enabled with an encoder it is able to detect clogs.

The runout sensors are included in the list displayed by the `MMU_SENSORS` command:

```yml
    sync_feedback_tension: open
    toolhead: open
    mmu_gate: open                # Runout capable
    extruder: open
    mmu_pre_gate_0: TRIGGERED     # Runout capable
    mmu_pre_gate_1: TRIGGERED     # Runout capable
    mmu_pre_gate_2: TRIGGERED     # Runout capable
    mmu_pre_gate_3: open          # Runout capable
    mmu_pre_gate_4: TRIGGERED     # Runout capable
    mmu_pre_gate_5: open          # Runout capable
    mmu_pre_gate_6: open          # Runout capable
    mmu_pre_gate_7: open          # Runout capable
    mmu_pre_gate_8: TRIGGERED     # Runout capable
```


## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Optional Encoder

This is a device that measures the movement of filament and can be used for detecting and loading/unloading filament at the gate; validating that slippage is not occurring; runout and clog detection; flow rate verification and more. The following is an output of the `MMU_ENCODER` command to control and view the encoder:

> MMU\_ENCODER

```yml
    Encoder position: 743.5mm
    Runout detection: Disabled
    Clog/Runout mode: Automatic (Detection length: 10.2)
    Trigger headroom: 8.3mm (Minimum observed: 5.6mm)
    Flowrate: 0 %
```

Normally the encoder is automatically enabled when needed and disabled when not printing. It can be explicitly disabled with:

> MMU\_ENCODER ENABLE=0

<ul>
  <li>The encoder, when calibrated, measures the movement of filament through it.  It should closely follow movement of the gear or extruder steppers but can drift over time.</li>
  <li>If enabled the clog/runout detection length is the maximum distance the extruder is allowed to move without the encoder seeing it.
 A difference equal or greater than this value will trigger the clog/runout logic in Happy Hare</li>
  <li>If clog detection is in `automatic` mode the `Trigger headroom` represents the distance that Happy Hare will aim to keep the clog detection from firing.  Generally around 6mm - 8mm is good starting point.</li>
  <li>The minimum observed headroom represents how close (in mm) clog detection came to firing since the last toolchange. This is useful for tuning your detection length (manual config) or trigger headroom (automatic config)</li>
<li>Finally the `Flowrate` will provide an averaged % value of the mismatch between extruder extrusion and measured movement. Whilst it is not possible for this to be real-time accurate it should average above 94%. If not it indicates that you may be trying too extrude too fast.</li>
</ul>

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Clog Detection

This is a useful feature that may save a print if the extruder clogs because it will promptly pause the print given you the chance to unblock and resume printing.

If the MMU has an encoder it can be used to detect filament movement by comparing filament extruded to that measured. If this is ever greater than the `mmu_calibration_clog_length` (stored in `mmu_vars.cfg`) the runout/clog detection logic is triggered because it means that either the filament is not present (runout) or has stopped moving (clog).

If it is determined to be a clog, the printer will pause in the usual manner and require fixing followed by `RESUME` to continue. If a runout is determined and EndlessSpool is enabled the fragment of filament will be unloaded, the current tool will be remapped to the next specified gate, and printing will automatically continue.

Clog detection functionality is enabled with the `enable_clog_detection` parameter in `mmu_parameters.cfg`. Setting `enable_clog_detection: 1` enables clog detection employing the static clog detection length. Setting `enable_clog_detection: 2` will enable automatic adjustment of the detection length and Happy Hare will periodically update the calibration value based on what it learns about your system. Whilst this doesn't guarantee you won't get a false trigger it will continually self-tune until false triggers no longer occur. The automatic algorithm is controlled by two variables in the `[mmu_encoder]` section of `mmu_hardware.cfg`:

    desired_headroom: 5.0  # The runout headroom that Happy Hare will attempt to maintain (closest MMU comes to triggering runout)
    average_samples: 4     # The "damping" effect of last measurement. Higher value means clog_length will be reduced more slowly

These default values makes the autotune logic try to maintain 5mm of "headroom" from the trigger point. If you have very fast movements defined in your custom macros or a very long bowden tube you might want to increase this a little. The `average_samples` is purely the damping of the statistical sampling. Higher values means the automatic adjustments will be slower.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) EndlessSpool

As mentioned earlier, EndlessSpool will, if configured, spring into action when a filament runs out. It effectively allows a sequence of filament spools to be used under the same tool number. This means that if a particular color runs out during a print, another spool of the same color can take over. When a runout occurs it will map the current tool to the next gate in the defined sequence (see below) and continue printing. To see the current EndlessSpool groups simply run this command with no parameters:

> MMU\_ENDLESS\_SPOOL

To enable or disable the functionality use:

> MMU\_ENDLESS\_SPOOL ENABLE=0|1

To set / change grouping you must specify a list which is the same length as the number of gates you have on your MMU where each postion indicates the group membership for that gate. For example:

> MMU\_ENDLESS\_SPOOL GROUPS=1,2,3,1,2,3,1,2,3

```
    T0 -> Gate #0(B) ES_Group_1: 0*> 3?> 6?
    T1 -> Gate #1(B) ES_Group_2: 1*> 4?> 7?
    T2 -> Gate #2(B) ES_Group_3: 2*> 5?> 8* [SELECTED on gate #2]
    T3 -> Gate #3(?) ES_Group_1: 3?> 6?> 0*
    T4 -> Gate #4(?) ES_Group_2: 4?> 7?> 1*
    T5 -> Gate #5(?) ES_Group_3: 5?> 8*> 2*
    T6 -> Gate #6(?) ES_Group_1: 6?> 0*> 3?
    T7 -> Gate #7(?) ES_Group_2: 7?> 1*> 4?
    T8 -> Gate #8(B) ES_Group_3: 8*> 2*> 5?

    MMU Gates / Filaments:
    Gate #0(B) -> T0, Material: PLA, Color: red, Status: Buffered
    Gate #1(B) -> T1, Material: ABS+, Color: orange, Status: Buffered
    Gate #2(B) -> T2, Material: ABS, Color: tomato, Status: Buffered [SELECTED supporting tool T2]
    Gate #3(?) -> T3, Material: ABS, Color: green, Status: Unknown
    Gate #4(?) -> T4, Material: PLA, Color: blue, Status: Unknown
    Gate #5(?) -> T5, Material: PLA, Color: indigo, Status: Unknown
    Gate #6(?) -> T6, Material: PETG, Color: violet, Status: Unknown
    Gate #7(?) -> T7, Material: ABS, Color: ffffff, Status: Unknown
    Gate #8(B) -> T8, Material: ABS, Color: black, Status: Buffered
```

Here three groups are defined. ES\_Group\_1 consisting of gates 0, 3 and 6; ES\_Group\_2 consisting of gates 1, 4 and 7; ES\_Group\_3 consisting of gates 2, 5 and 8. The first paragraph indicates how each tool would cycle through gates and the second paragraph is a remining of what filament is loaded into each gate.

Since EndlessSpool is not something that triggers very often you can use the following to simulate the action and familiarize yourself with its action and validate it is correctly setup prior to needing it:

> MMU\_TEST\_RUNOUT

This will emulate a filament runout and force the MMU to interpret it as a true runout and not a possible clog. The MMU will then run the following sequence:

<ul>
  <li>Move the toolhead up a little (defined by `z_hop_height_toolchange` & `z_hop_speed`) to avoid blobs
  <li>Call the unloading sequence macros (defined in `mmu_sequence.cfg`). By default this will quickly move the toolhead to your defined parking area
  <li>Perform the toolchange and map the new gate in the sequence
  <li>Call the loading sequence macros (defined in `mmu_sequence.cfg`). Typically this is where you would add logic to clean the nozzle and then quickly move the toolhead back to the position where it was before the toolchange
  <li>Move the toolhead back down the final amount and resume the print
</ul>

The default supplied sequence macros work well and provide lots of configuration and extension options.

If you ever get confused you can reset the EndlessSpool groups to the default "one gate per tool" by running:

> MMU\_ENDLESS\_SPOOL RESET=1

> [!NOTE]  
> Similar to Tool-to-Gate mapping, EndlessSpool is best visualized and modified using KlipperScreen Happy Hare edition.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Flowrate Monitoring

This experimental feature uses the measured filament movement of the encoder to assess the % flowrate being achieved. If you print too fast or with a hotend that is too cold you will get a decreased % flowrate and under extrusion problems. The encoder driver with Happy Hare updates a printer variable called `printer['mmu_encoder mmu_encoder'].flow_rate` with the % measured flowrate. Whilst it is impossible for this value to be instantaneously accurate, if it tracks below about 94% it is likely you have some under extrusion problems and should slow down your print. Note this is best monitored in the [KlipperScreen-HappyHare edition](https://github.com/moggieuk/KlipperScreen-Happy-Hare-Edition) application.
