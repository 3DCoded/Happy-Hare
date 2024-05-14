## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Endstops and MMU Movement
Happy Hare implements the MMU control as a "second toolhead" known as the MMU toolhead. The X-axis represents the selector movement and the Y-axis the filament movement until Klipper takes over the control of the extruder as normal. It offers some sophisticated stepper synching and homing options which add additional parameters to the regular klipper stepper definition.

### Multiple Endstops on MMU Steppers
In a nutshell, all steppers (MMU selector, MMU gear) defined in Happy Hare can have muliple endstops defined. Firstly the default endstop can be defined in the normal way by setting `endstop_pin`.  This would then become the default endstop and can be referenced in gcode as "default".  However it is better to give the endstop a vanity name by adding a new `endstop_name` parameter. This is the name that will appear when listing endstops (e.g. in the Mainsail interface or with `QUERY_ENDSTOPS`). Happy Hare uses a naming convention of `mmu_` so anticipated names are: `mmu_gear_touch`, `mmu_ext_touch`, `mmu_sel_home`, `mmu_sel_touch`, `toolhead`, `mmu_gate`, `extruder`

These would represent touch endstop on gear, touch on extruder, physical selector home, selector touch endstop, toolhead sensor, sensor at the gate and sensor just prior to extruder entrance. In Happy Hare, "touch" refers to stallguard based sensing feedback from the TMC driver (if avaialable).

In addition the default endstop which is only set on the selector in the out-of-the-box configuration you can specify a list of "extra" endstops each with a customized name.  These extra endstops can be switched in and out as needed. E.g.

```yml
extra_endstop_pins: tmc2209_extruder:virtual_endstop, TEST_PIN
extra_endstop_names: mmu_ext_touch, my_test_endstop
```

Defines two (non-default) endstops, the first is a virtual "touch" one leveraging stallguard and the second an example of a test switch.

> [!IMPORTANT]  
> If equipped with a toolhead sensor, gate sensor or extruder sensor, endstops will automatically be created with the name `toolhead`, `mmu_gate`,  `extruder` respectively.

### Endstop on the Extruder!
Happy Hare will automatically enhance Klipper to provide endstop(s) on the extruder stepper.  While this might not seem it has value, it can be used to sense pressure on the filament (like hitting the nozzle when loading).  Unless you have a sophisticated load cell attached to your nozzle the most likely configuration would be to define a TMC stallguard endstop. You can do this by adding `endstop_pin` to the extruder definition -- don't worry it won't confuse Klipper!

Ok, so you can define lots of endstops. Why? and what next... Let's discuss syncing and homing moves first and then bring it all together with an example.

### True stallguard based selector homing
The extra endstop `mmu_selector_touch` described in the `mmu_hardware.cfg` file is designed for "touch" movement where the selector can feel for filament blocking a gate and autmatically take recovery action. However, you might be wondering if it is possible to perform true stallguard homing on the selector?  It certainly is but you need to adjust part of the config for the selector stepper: instead of making `mmu_sel_touch` an extra endstop, make it the default like so (note it is very important to add the `homing_retract_dist: 0`):

```yml
[stepper_mmu_selector]
...
endstop_pin: tmc2209_stepper_mmu_selector:virtual_endstop
endstop_name: mmu_sel_touch
homing_retract_dist: 0
```

This will not only define `mmu_sel_touch` as a named endstop for "touch" movement but will also make it the default endstop for homing operation.  With this configuration there is no need to have an microswitch or `mmu_sel_home` endstop defined. Personally I like the reliability of a mechanical homing enstop because it requires no tuning.

### Stepper syncing
The MMU gear stepper(s) defined by Happy Hare not only enables multiple endstops but also can act as both a filament driver (gear) stepper an extruder stepper. This dual personality allows its motion queue to be synced with other extruder steppers or, but also manipulated manually as a separately controlled stepper.  The gear stepper can be synchronized to the extruder when in a print and when in this mode it follow all extruder kinematics including pressure advance.  It is also possible for the extruder to be synchronised with the gear stepper for loading and unloading operations. In this mode the extruder will follow the kinematics of the gear stepper and can participate in homing moves.

Happy have provides two test moves commands `MMU_TEST_MOVE`, `MMU_TEST_HOMING_MOVE` (and two similar commands designed for embedded gcode use). For example:

> MMU_TEST_MOVE MOVE=100 SPEED=10 MOTOR="gear+extruder"

This will advance both the MMU gear and extruder steppers in sync but +100mm at 10mm/s. If only only `gear` was specified the move would only involve the gear stepper and  obviously not be synchronized. Several `MOTOR` combinations can be sepcified with this move and are summerised here:
<ul>
  <li>gear - the default to move just the gear stepper (technically this is the Y-axis of the MMU toolhead)</li>
  <li>gear+extruder - move the gear but synchronize the extruder to it (the extruder is added to the rail supporting the Y-axis of the MMU toolhead)</li>
  <li>extruder - move the extruder only but with the mmu toolhead kinematics meaning klipper will know nothing about this movement (the extruder is the sole stepper on the Y-axis of the MMU toolhead)</li>
  <li>synced - move the extruder but synchonize the gear stepper to it (same as would occur in print if synchronized printing is enabled)</li>
  <li>both - (legacy) moves move the gear stepper and the extruder together but subject to their own kinematics and move queues</li>
</ul>

### Homing moves
Similarly it is possible to specify a homing move:

> MMU_TEST_HOMING_MOVE MOVE=100 SPEED=10 MOTOR="gear+extruder" ENDSTOP=mmu_ext_touch STOP_ON_ENDSTOP=1

This would home the filament using synchronized motors to the nozzle using stallguard! Cool hey?!?

> [!NOTE]  
> Homing moves can also be done in the reverse direction (and by therefore reversing the endstop switch) by specifying `STOP_ON_ENDSTOP=-1`. This should be familiar if you have ever used the Klipper `MANUAL_STEPPER` command.<br>If you are at all curious (and I know you will be after reading this) you can "dump" out the Happy Hare MMU toolhead with the command `_MMU_DUMP_TOOLHEAD`. I'll leave it to you to figure out the results.

<br>

For quick reference here are the two test MMU move commands:

  | Command | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Description&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Parameters |
  | ------- | ----------- | ---------- |
  | `MMU_TEST_MOVE` | Simple test move the MMU gear stepper | `MOVE=..[100]` Length of gear move in mm <br>`SPEED=..` (defaults to speed defined to type of motor/homing combination) Stepper move speed <br>`ACCEL=..` (defaults to min accel defined on steppers employed in move) Motor acceleration <br>`MOTOR=[gear\|extruder\|gear+extruder\|synced\|both]` (default: gear) The motor or motor combination to employ. gear+extruder commands the gear stepper and links extruder to movement, extruder+gear commands the extruder stepper and links gear to movement |
  | `MMU_TEST_HOMING_MOVE` | Testing homing move of filament using multiple stepper combinations specifying endstop and driection of homing move | `MOVE=..[100]` Length of gear move in mm <br>`SPEED=..` (defaults to speed defined to type of motor/homing combination) Stepper move speed <br>`ACCEL=..` Motor accelaration (defaults to min accel defined on steppers employed in homing move) <br>`MOTOR=[gear\|extruder\|gear+extruder\|synced\|both]` (default: gear) The motor or motor combination to employ. gear+extruder commands the gear stepper and links extruder to movement, extruder+gear commands the extruder stepper and links gear to movement. This is important for homing because the endstop must be on the commanded stepper <br>`ENDSTOP=..` Symbolic name of endstop to home to as defined in mmu_hardware.cfg. Must be defined on the primary stepper <br>`STOP_ON_ENDSTOP=[1\|-1]` (default 1) The direction of homing move. 1 is in the normal direction with endstop firing, -1 is in the reverse direction waiting for endstop to release. Note that virtual (touch) endstops can only be homed in a forward direction |

### What's the point?
Hopefully you can see some of the coordinated movements that are possible that are highly useful for an MMU setup.  For example, I'm current loading filament with an incredibly fast bowden load using the gear stepper followed by a synchronized homing move of the extruder and gear, homing to the nozzle using `mmu_ext_touch` (stallguard) endstop. It requires zero knowledge of extruder dimensions and no physical switches! It also has lots of uses for custom setups with filmament cutters or other purging mechanisms.

Altough this advanced functionality is already being used internally in Happy Hare. You will need to use the manual gcode commands or customize the loading and unloading gcode sequences with the provided `_MMU_STEP_MOVE` and `_MMU_STEP_HOMING_MOVE` to do highly imaginatively things - let me know how you get on.
