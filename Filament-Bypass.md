The filament bypass is a really useful addition to an MMU. It allows for use of the printer as if the MMU wasn't attached by feeding an ad hoc spool through the bypass gate but otherwise through the MMU filament path. This is really useful if you want to do a single color print and don't have or don't want to go through the hassle of installing into the MMU.

Without this option the alternative would be to disconnect the MMU bowden, turn off Happy Hare with `MMU ENABLE=0` and feed filament from an alternative path.

Note that using the MMU bypass also allows for runout/clog detection which may not be possible with other approaches.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Configuring Filament Bypass

For the ERCFv1.1 (with bypass block) or ERCFv2 the bypass position would have been set during the selector calibration. However it can be done at any time with the method described in the [Selector Calibration](MMU-Calibration#---step-1-calibrate-selector-offsets) guide. Specifically, carefully  align the selector with the bypass using a fragment of filament, remove the fragment, then run:

> MMU_CALIBRATE_SELECTOR BYPASS=1

The position of the bypass will be measures and stored in `mmu_vars.cfg` as `mmu_selector_bypass` variable. You can directly edit this value too then restart klipper, but be careful not to corrupt this important file.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Using Filament Bypass

Once configured you can select the bypass position one of these commands:

> MMU_SELECT BYPASS=1<br>
> MMU_SELECT_BYPASS

Once selected you would insert the filament through the bypass all the way up to the extruder entrance. Then you can use Happy Hare to load to the nozzle:

> MMU_LOAD

Finally, you can unload the extruder with the usual eject:

> MMU_UNLOAD

Be sure to manually pull the filament all the way back out of the MMU before selecting another gate.

> [!NOTE]
> The `MMU_LOAD` and `MMU_UNLOAD` automatically add the `EXTRUDER_ONLY=1` flag when the bypass is selected

> [!TIP]
> A very useful timesaver is automatic extruder loading if you have an extruder (entry) sensor. This is enabled with the `bypass_autoload` setting in `mmu_parameters.cfg`. If enabled, when a filament triggers the sensor the loading will be automatic.
