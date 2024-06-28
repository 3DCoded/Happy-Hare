This discussion assumes that you have initial setup complete and are now ready to tune the quality of your prints. Although some of the information contained here is useful early in your journey it will make a lot more sense once you have some experience with default or "borrowed" toolhead parameters. Then this will guide you to optimizing a few critical parameters for quality prints that avoids blobbing on your wipetower or print and stringing when moving to change tool.

Specifically in this guide you will learn how to correctly set the following parameters (`mmu/base/mmu_parameters.cfg`):
- `toolhead_extruder_to_nozzle`
- `toolhead_sensor_to_nozzle`
- `toolhead_entry_to_extruder`
- `toolhead_ooze_reduction`

Use z-hop and retraction settings to eliminate blobs and stringing during color changes in your prints:
- `z_hop_height_toolchange`
- `z_hop_ramp`
- `z_hop_speed`
- `toolchange_retract` & `toolchange_retract_speed`

Set key tip cutting macro variables (`mmu/base/mmu_macros_vars.cfg`):
- `variable_blade_pos`
- `variable_retract_length`

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Correct Meaning of Key Dimensions

First it is important to understand that while sensors like a toolhead sensor can help with extruder loading and unloading, the process relies on precise movement distances. These "dimensions" often interact with each other so it is also important that they be set according to their meaning. Doing so will give deterministic toolchanges rather than a "these settings seem to work" scenario.

When the extruder is loaded, Happy Hare will move the filament a precise distance from either the extruder gear or the toolhead sensor to the end of the nozzle. This distance is set with `toolhead_extruder_to_nozzle` and/or `toolhead_sensor_to_nozzle` and represents the CAD measured distance in a perfectly clean extruder/nozzle. The reality is that once the extruder is "dirty" this distance changes. I.e. some filament is inevitably left behind in the extruder/nozzle shortening this distance. The amount of filament remaining seems to vary greatly from a couple of mm to as much as 15mm in some HF hotends!

To account for this, Happy Hare defines `toolhead_extruder_to_nozzle` and `toolhead_sensor_to_nozzle` as theoretical and thus should be able to be pulled form CAD drawings or other users. It uses `toolhead_ooze_reduction` to represent how much to reduce the loading move by for the new filament to butt up against the old without accidently oozing.

In practice it has been hard to determine these values other than through experimentation and even then it is hard to determine for example, whether to increase `toolhead_ooze_reduction` or reduce `toolhead_sensor_to_nozzle`.

Let's run through the important steps in a toolchange (for both tip forming and tip cutting cases) and relate to these parameters:

### With Tip Forming

Transitioning from an orange filament to a blue _(Click on images to see the detail)_:

<p align="center"><a href="https://github.com/moggieuk/Happy-Hare/wiki/Blobbing-and-Stringing/Unloading_Tip_Forming.png"><img src="Blobbing-and-Stringing/Unloading_Tip_Forming.png" alt="Unloading Tip Forming"></a></p>
<p align="center"><a href="https://github.com/moggieuk/Happy-Hare/wiki/Blobbing-and-Stringing/Loading_Tip_Forming.png"><img src="Blobbing-and-Stringing/Loading_Tip_Forming.png" alt="Loading Tip Forming" width="70%"></a></p>

<br>

### With Toolhead Tip Cutting

With toolhead tip cutting the procedure is a little more complex and introduces two additional macro variables (defined in `mmu_macro_vars.cfg` that configure the tip cutting logic):

<p align="center"><a href="https://github.com/moggieuk/Happy-Hare/wiki/Blobbing-and-Stringing/Unloading_Tip_Cutting.png"><img src="Blobbing-and-Stringing/Unloading_Tip_Cutting.png" alt="Unloading Tip Cutting"></a></p>
<p align="center"><a href="https://github.com/moggieuk/Happy-Hare/wiki/Blobbing-and-Stringing/Loading_Tip_Cutting.png"><img src="Blobbing-and-Stringing/Loading_Tip_Cutting.png" alt="Loading Tip Cutting" width="70%"></a></p>

Note that the cut piece of filament remaining and the residual filament are automatically accounted for by Happy Hare so long as you have configured the parameters exactly as defined in this illustration.

<br>

> [!IMPORTANT]  
> 1. The really important reference point is the internal nozzle "shoulder". This is considered the 0mm reference point for most parameters. For CHT nozzle this will be further away from the tip than regular nozzles.
> 2. You can see how the `toolhead_XXX_to_nozzle` settings and `toolhead_ooze_reduction` are related, so while you can tune the former and ignore latter, it is recommended you use them correctly so that Happy Hare is able to optimize print quality and correctly control purge volumes.
> 3. `toolhead_ooze_reduction` is dependent on your extruder and nozzle. High flow systems generally have a much higher value (more residual filament stuck in extruder) than regular ones.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Calibrating Toolhead

Ok, now you know what the correct meaning of the dimensions are the next question is how to discover them for your setup. For everything other than `toolhead_ooze_reduction` it is possible to use accurate CAD models to measure them (remember to use the internal shoulder in the nozzle). If you have a toolhead sensor there is now an automated way to measure! If not, then you can refer back to this wiki where we will collate verified measurements for common toolhead combinations and once you have those set experiment to discover the correct `toolhead_ooze_reduction` setting.

You have a toolhead sensor...

Now Happy Hare can help with a new `MMU_CALIBRATE_TOOLHEAD` command. The complete process is to start with a CLEAN extruder/nozzle. To do this you need to perform a cold pull where you warm up the extruder, purge some filament, then cool. At the right temperature you manually pull the filament out with a bit of force pulling all the old residue and carbon deposits. This is something that most of you probably already know how to do, but for those that need help you can run the supplied `MMU_COLD_PULL` macro and follow directions. This is documented [later in this page](#---cleaning-extruder-with-a-cold-pull).

<br>

### Step 1: With a CLEAN toolhead (after cold pull)

Reattach bowden to toolhead, and prepare the MMU: select the gate you wish to use but ensure filament is available but don't try to load the extruder. Then run:

> MMU\_CALIBRATE\_TOOLHEAD CLEAN=1

This will perform some probing with a cold extruder and report back on the critical toolhead parameters. For example:

```
Reminder:
1) 'CLEAN=1' with clean extruder for: toolhead_extruder_to_nozzle, toolhead_sensor_to_nozzle (and toolhead_entry_to_extruder)
2) No flags with dirty extruder (no cut tip) for: toolhead_ooze_reduction (and toolhead_entry_to_extruder)
3) 'CUT=1' holding blade in for: variable_blade_pos
Desired gate should be selected but the filament unloaded

Modifying MMU gear stepper run current to 40% for collision detection
Run Current: 0.21A Hold Current: 0.09A
Restoring MMU gear stepper run current to 100% configured
Run Current: 0.49A Hold Current: 0.09A
Measuring clean toolhead dimensions after cold pull...
Measured toolhead_sensor_to_nozzle: 62.1
Measured toolhead_extruder_to_nozzle: 70.6
Measured toolhead_entry_to_extruder: 7.9
-----------------------------------
Calibration Results (clean nozzle):
> toolhead_extruder_to_nozzle: 70.6 (currently: 70.0)
> toolhead_sensor_to_nozzle: 62.1 (currently: 62.0)
> toolhead_entry_to_extruder: 7.9 (currently: 8.5)
-----------------------------------
New toolhead calibration active until restart. Update mmu_parameters.cfg to persist settings
```

Assuming you didn't run with the `SAVE=0` option this will temporarily correct your toolhead parameters.

> [!TIP]  
> 1. You must remember these and manually update `mmu_parameters.cfg` for them to persist across a restart, but do that later.
> 2. If you want to run again before dirtying the extruder you can to validate your results. Add `SAVE=0` to skip updating parameters.

<table>
<tr>
<td>

Referring back to the earlier ilustrations, because the extruder was empty we were able to establish the position of the internal nozzle shoulder as well (magically) some other settings:

</td>
<td width=30%>
<a href="https://github.com/moggieuk/Happy-Hare/wiki/Blobbing-and-Stringing/Probe_Nozzle_Shoulder.png"><img src="Blobbing-and-Stringing/Probe_Nozzle_Shoulder.png" alt="Probe Nozzle Shoulder"></a>
</td>
</tr>
</table>

<br>

### Step 2: Now DIRTY the extruder:

Next heat up you extruder, and load and unload a filament:

> MMU\_LOAD

_be sure to manually extrude some filament..._

> MMU\_EJECT

This MUST be done with tip forming and not tip cutting or alternatively, after extruding some filament, manually retract the filament out of the extruder and then park the filament in the MMU gate.

<br>

### Step 3: Calibrate with DIRTY extruder

This is run with no parameters. Here is an example below.

> MMU\_CALIBRATE\_TOOLHEAD
```
...blah blah blah...
-----------------------------------
Calibration Results (dirty nozzle):
> toolhead_ooze_reduction: 3.0 (currently: 3.4)
-----------------------------------
New calibrated ooze reduction active until restart. Update mmu_parameters.cfg to persist
```

> [!TIP]  
> 1. You can run a dirty calibration as often as you like and to see if it differs with different filament types, changes you make to your tip forming macro, etc.
> 2. If you are curious you can also use it as a trick way to measure the "filament\_remaining" after tip cutting. Just remember to use the `SAVE=0` option because you DON'T want to `toolhead_ooze_reduction` to include the cut piece of filament!

<table>
<tr>
<td>

Again referring back to the earlier ilustrations, although the calibration reports measurements, these would likely be shorter because of the filament residue that is always left behind in the extruder. The difference between the clean reading and the dirty one is what `toolhead_ooze_reduction` compensates for and represents the residual filament that is always left behind in the extruder:

</td>
<td width=30%>
<a href="https://github.com/moggieuk/Happy-Hare/wiki/Blobbing-and-Stringing/Probe_Filament_Remains.png"><img src="Blobbing-and-Stringing/Probe_Filament_Remains.png" alt="Probe Filament Remains"></a>
</td>
</tr>
</table>

<br>

### Step 4: Optional: Calibrate toolhead cutting macro variables

If you have a toolhead cutter, now is a good time to calibrate the blade cutting position `variable_blade_pos` and set the `variable_retract_length` which will control the amount of cut filament left in the extruder because it pulls the filament towards the cutter prior to the cut. 

You must set this up correctly. There are two ways to do this:

1. With the extruder unloaded press and HOLD the cutter blade in the closed postion. STAY in this position until the calibration is complete.

2. Load the filament, allow the extruder to cool and then manually press the cut lever a couple of times to ensure the filament is cleanly cut. After you have cut the filament, unload/eject without further tip forming by running `MMU_EJECT SKIP_TIP=1` _(did you notice the skip tip option?)_

After your chosen method and with the filament unloaded and parked in the MMU, run:

> MMU\_CALIBRATE\_TOOLHEAD CUT=1
```
...blah blah blah...
-----------------------------------
Calibration Results (cut tip):
> variable_blade_pos: 36.2 (currently: 37.5)
> variable_retract_length: 5.0-36.2, recommend: 32.2 (currently: 32.5)
-----------------------------------
New calibrated variables active until restart. Update mmu_macro_vars.cfg to persist
```

> [!TIP]  
> The larger the `variable_retract_length` the less additional purge is necessary to clean out the prior color. However if you get too aggressive you may experience clogs because you are cutting a hot part of the filament. Experience has shown that about 5mm shorter than the blade position (i.e. 5mm cut length) is about as good as you can get. If you do still run into clogging issues, shorten this value.

<table>
<tr>
<td>

Referencing earlier ilustrations, although the calibration reports measurements, these are much be shorter because of the cut filament remains. The blade position `variable_blade_pos` can thus be established and the range of sensible values for `variable_retract_length` recommended.

</td>
<td width=30%>
<a href="https://github.com/moggieuk/Happy-Hare/wiki/Blobbing-and-Stringing/Probe_Cut_Remains.png"><img src="Blobbing-and-Stringing/Probe_Cut_Remains.png" alt="Probe Cut Remains"></a>
</td>
</tr>
</table>


<br>

### Summary of MMU\_CALIBRATE\_TOOLHEAD options

  | Order | Option | Description |
  | ----- |------ | ----------- |
  | 1 | `CLEAN=1` | This will calibrate `toolhead_extruder_to_nozzle`, `toolhead_sensor_to_nozzle`, `toolhead_entry_to_extruder` and MUST be run on clean extruder after cold-pull | 
  | 2 | _none_ | This will calibrate `toolhead_ooze_reduction` and should be run with a dirty extruder where tip has been formed for filament retracted from extruder. It must not be run after tip cutting |
  | 3 | `CUT=1` | This will calibrate `variable_blade_pos` and suggest `variable_retract_length` for the tip cutting macro. This MUST be run after loading the extruder and manually cutting the filament and running `MMU_EJECT SKIP_TIP=1` to unload without re-running the tip cutting macro |

<br>

With the toolhead now properly configured you should experience better basic loading and uploading with reduction of blobbing and thus stringing. However there is more... 

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Toolhead Retraction

Incorrect toolhead dimensions contribute most to blobbing problems but even when perfect, blobbing can still occur when the toolhead is moved fully loaded. Just like when printing it is often necessary to relax the pressure in the extruder prior to a travel move to prevent the slow oozing that would otherwise occur. The `toolchange_retraction` setting is set to the retraction distance and will be applied immediately prior to z-hop move and any travel movements during the toolchange. All the supplied macros will understand this setting and either compensate for this extruder pre movement. At the end of the toolchange process immediately following the reversal of the z-hop move, the un-retract will occur to correctly pressurise the extruder again. In this manner the extruder is never fully loaded during travel moves and thus oozing is minimized.

Note that the retraction and un-retraction speed is set with the related `toolchange_retraction_speed` parameter and can thus be set independently (often faster) than your general extruder load/unload speeds.

> [!NOTE]  
> The toolhead retract is ONLY applied during a print by Happy Hare and is independent of anything performed by the sequence macros.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Z-Hop and Ramping

When a toolchange occurs it is preferable to move the toolhead so the hot nozzle isn't left on the print. Such travel moves can graze the top of the print so you will usually want to perform a z-hop move (raise the toolhead) before travelling. This z-hop height is controlled by `z_hop_height_toolchange`. It is performed the moment after the toolchange retraction and usually 2mm is plenty to stay clear of the print.

Despite the retraction and upward movement many filaments will still have a dendency to "string". What is needed is a much larger toolhead movement to "break the string". The `z_hop_ramp` setting is thus the horizontal move to combine with the vertical (`z_hop_height`) and essentially allows for fast travel moves of a greater distance (vertical movement is generally much slower than horizontal). The horizontal movement component will be towards the center of the build plate followed by a return at the new z-height.

The speed of the z-hop move whether purely vertical or including a ramp is specified with `z_hop_speed`.

> [!TIP]  
> If employing a z-hop ramp then you will likely want to set a fast speed similar to your normal printer x/y travel speed. Klipper will always limit a move to the slowest direction and thus this will not accidently try to move faster than possible in the vertical direction. If you are not using a ramp then then `z_hop_speed` can be your desired vertical movement only.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Cleaning Extruder with a "Cold-Pull"

The cold pull method of cleaning your extruder should be in your bag of printer maintance tricks already. Generally it is a great way to clean carbon deposits that build up over time and can result in under extrusion. We are using it here to clear to prepare for accurate toolhead dimension measurements.

### General Procedure
1. Move toolhead to a convenient location, often the front middle of your build plate and at least 20mm above
2. Detatch bowden from toolhead
3. Open extruder latch, manually load a 250mm fragment of filament and close extruder latch
4. Extrude at least 20mm-30mm of filament
5. Turn of extruder heat and wait for extruder to cool
6. Keep the nozzle completely full by occassionaly extruding 1-2mm more
7. Warm extruder back to pull temp
6. At this point, pull the filament quite firmly and evenly out of the extruder in a vertical direction
7. Inspect the tip to see if it has been successful

### Using MMU\_COLD\_PULL macro
To help with the process Happy Hare includes a special macro that will guide you through the process. To run:
1. Move toolhead to a convenient location, often the front middle of your build plate and at least 20mm above
2. Detatch bowden from toolhead
3. Open extruder latch, manually load a 250mm - 300mm fragment of filament and close extruder latch
3. Run `MMU_COLD_PULL MATERIAL=nylon|pla|abs|petg`. Optionally you can add temperature overrides e.g. `PULL_TEMP=xxx` (see [Command Reference](Command-Reference#---calibration) for details) to better suite your material (see [table of defaults](#default-mmu_cold_pull-temperatures-for-different-materials) below)
4. Be ready to pull at the right time .. you will be given a little warning but it is important to pull at the correct temperature when the filament is still slightly pliable. Pull directly upwards with a consistent firm pull, the extruder stepper will aid the pull (unlatch if you want to be 100% manual). Note some extruders have enough grip/torque to do this without assistance although the manual approach allows you to "feel" the correct pull speed.

> MMU\_COLD\_PULL MATERIAL=abs
```yml
Cold Pull with pull_temp=120°C, hot_temp=255°C, min_extrude_temp=190°C, cold_temp=50°C
Heating extruder to 255°C
Cleaning nozzle tip
Allowing extruder to cool...
Stuffing nozzle at 250°C
Stuffing nozzle at 240°C
Stuffing nozzle at 230°C
Stuffing nozzle at 220°C
Stuffing nozzle at 210°C
Stuffing nozzle at 200°C
Waiting for extruder to completely cool to 50°C...
Nozzle at 180°C
Nozzle at 170°C
Nozzle at 160°C
Nozzle at 150°C
Nozzle at 140°C
Nozzle at 130°C
Nozzle at 120°C
Nozzle at 110°C
Nozzle at 100°C
Nozzle at 90°C
Nozzle at 80°C
Nozzle at 70°C
Nozzle at 60°C
Nozzle at 50°C
Re-warming extruder to 120°C
Get ready to pull...
>>>>> PULL NOW <<<<<
Cold pull is successful if you can see the shape of the nozzle at the filament end
```

**How do you know if the cold pull was successful?** The pulled end of the filament should like like one of the pictures below. You need to be able to see the impression of the nozzle to be sure. On regular nozzles it should look similar to the image on the left, while with CHT nozzles similar to the image on the right. Note that the author of that picture (@igiannakas) should be commended for an excellent result because CHT nozzles require the pull at exactly the right temperature and a bit of luck!

<p align="center"><img src="Blobbing-and-Stringing/Cold_Pull_Normal_Example.png" alt="Cold Pull Normal" width="40%"> <img src="Blobbing-and-Stringing/Cold_Pull_CHT_Example.png" alt="Cold Pull Normal" width="40%"></p>

It may take a few pulls to get suitable results...

> [!TIP]  
> - Some materials are better than others for cleaning with nylon often being found to be the best. PLA is also good. PTEG and ABS can be used but often stretch and snap rather than pulling with sufficient force. The cold pulling temperature will be different with each material type so you may need to experiment.
> - You may need to repeat the process if the purpose is to completely clean your nozzle of carbon rather than just prepare for calibration
> - Feedback is that clear filament may be the strongest. Avoid strong pigmentation.

### Default `MMU_COLD_PULL` temperatures for different materials

 | Material | hot_temp | cold_temp | pull_temp | min_extrude_temp | Suitability |
 | -------- | -------- | --------- | --------- | ---------------- | ----------- |
 | NYLON    | 260      | 50        | 120       | 190              | Best        |
 | PLA      | 250      | 42        | 100       | 160              | Good        |
 | ABS      | 255      | 50        | 120       | 190              | Ok          |
 | PETG     | 250      | 42        | 100       | 180              | Tricky?     |

The `min_extrude_temp` is the temperature above which `MMU_COLD_PULL` will keep the nozzle pressurized with filament to ensure it is completely full.

Good luck!
