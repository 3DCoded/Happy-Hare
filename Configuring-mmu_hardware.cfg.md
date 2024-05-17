This is where all the user adjustable hardware based parameters are stored. Things that relate to the actual physical parts of the MMU unit.  

- [Gear Stepper Setup](#---gear-stepper-setup)
- [Selector Stepper Setup](#---selector-stepper-setup)
- [Servo Setup](#---servo-setup)
- [Encoder Setup](#---encoder-setup)
- [Filament Sensor Setup](#---filament-sensor-setup)
- [LED Setup](#---led-or-neopixel-setup)

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Gear Stepper Setup

The first item you'll see in `mmu_hardware.cfg` is the gear stepper configuration section. The gear stepper is the motor that drives the filament through the MMU. There are various mechanisms which accomplish this based on the MMU type. However, they all have a motor that provides the force to move the filament. This section is where you set that up. It's very similar to the rest of Klipper motor and driver setup. [Klipper's documentaton](https://www.klipper3d.org/TMC_Drivers.html) has a pretty good explanation of how the driver settings work.
The defaults are fairly good for most setups. We'll go ahead and walk through the settings anyway:  

`uart_pin` is the communication pin for the stepper motor. This uses the alias setup in `mmu.cfg`. You can change this to the actual pin call out if the default doesn't work for some reason or you're seting up a custom MMU and don't use the aliases. __It's important to understand that, when using aliases, the pin modifiers `!`, `^`, etc., are used in the config file, not in `mmu.cfg`.__  

 `run_current` is important to set correctly. This is the maximum amount of current the driver will provide to the motor. More current means more power. However, it also means more heat. Heat destroys stepper motors in a hurry. Check the specs on your particular motor and use that as a starting place. You can adjust it based on how much heat the motor is generating. If you can't hold your finger on it more than about two seconds, it's too hot. Move the current down. If your stepper consistently makes a whistling sound without moving the filament, consider adjusting the current up 10% or so. Keep in mind, speeds and accelerations have a lot to do with how much force is required to move the filament, so adjust the current up as a last resort, after you've adjusted speed and accelerations. Only adjust it up carefully and monitor your motor temp carefully. Burning out a stepper is a bad day all together.  

 `hold_current` is the current the stepper driver provides to the stepper motor to hold position. Typically, Klipper suggests not to specify a hold current. However, when using the stallguard to home the filament to the extruder gears, you'll want to adjust the hold current. This is more art than science. If your filament homes before the extruder gears, it's probably a bit low. If it jams into the extruder gears and grinds the MMU gears, then it's too high. Of course, using a toolhead entry sensor alleviates this adjustment all together.  

 `interpolate` is a feature of the stepper driver which tries to reduce noise by interpolating between full and no current as the motor rotates. It reduces accuracy (which isn't really a big thing on the gear motor) and also reduces torque slightly. Most of the noise from the gear motor is due to the drive gears in the filament path anyway, so leaving this set to false is a good idea.  

 `sense_resistor` is set to match your stepper driver's specs.  

 `stealthchop_threshold` is the speed, under which, the driver turns on stealthchop. Stealthchop reduces noise, accuracy, and torque. Since driving the filament through a long path from the spool, through the MMU, and on to the extruder takes a lot of power, you'll be best served to set this to zero and force spreadcycle operation all the time.  

 `step_pin` is an alias from `mmu.cfg`.
 `dir_pin`is an alias from `mmu.cfg`.
 `enable_pin` is an alias from `mmu.cfg`.  

 `rotation_distance` is explained in [Klipper documentation](https://www.klipper3d.org/Rotation_Distance.html). This should be set to a reasonable value for initial setup. It will be tuned later on in hardware configuration. Happy Hare uses the encoder to figure it out for you, and does so for each gate as well. So, just set this to a something close or use the defaults.  

`gear_ratio` is the ratio from the gear motor shaft to the drive gear. This should be set to match your hardware. In  the basic ERCF V2 setup, there is an80 tooth driven gear  and an 20 tooth driving gear, so the ratio is `80:20`. Pretty simple to just put the number of teeth in for your gear ratio. If you don't know this, consult your MMU's docs for the numbers.  

`microsteps` is the stepper driver's way to divide up currents in each coil to position the motor somewhere between the reluctor teeth. Increasing this setting reduces noise and torque. It's generally best to match this to your extruder. Considering both steppers to be 1.8° stepper motors, they should be the same. If they aren't, you can run into some issues with synching the gear motor and extruder down the line. Devices like the [Annex engineering Belay](https://github.com/Annex-Engineering/Belay) can help with that, especially if your MMU doesn't have a filament encoder. The best idea here is to keep this matched up with the extruder.  

`full_steps_per_rotation` is set the same way you do in Klipper for any stepper motor. 1.8° steppers are 200, 0.9°motors are 400.  

That's all for the gear stepper. If you've setup any stepper motors in Klipper, it's probably a breeze for you. Now, lets move on to:  

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Selector Stepper Setup

The next section deals with setting up the selector motor. This is very similar to the gear motor setup, so I will only hit the points which differ:  

`stealthchop_threshold` will need tuning if you use touch homing on the selector. Some drivers require stealthchop for the sensorless homing routine to work. So, set this to a number which works. The selector doesn't have a lot of resistance (if you built the MMU correctly) and stealthchop is OK here. That being said, if your selector moves at 1500mm/s (or rpm) consider using spreadcycle here at high speeds. Generally, the default works but tune as you see fit.  

`diag_pin` is an alias pointing to the diag pin of your stepper used in sensorless or touch homing.  

`driver_SGTHRS` is how much sensitivity the touch homing has. This will need tuned well. There is a lot of information in [Klipper's sensorless homing](https://www.klipper3d.org/TMC_Drivers.html#sensorless-homing) section of the TMC driver documentation. A lot of that information will apply here. Tune it carefully if you plan on using selector touch homing.  

`extra_endstop_pins` is where the virtual endstop pin is called out for selector touch homing. This can work in conjunction with a microswitch endstop. This just tells Klipper where to find the virtual endstop.  Generally defaults work if you used the `-i` switch in Happy Hare's install script.

`extra_endstop_names` gives the extra endstop a unique name so Klipper can use it. Generally defaults work if you used the `-i` switch in Happy Hare's install script.  

That's all for the selector setup. Let's move on to the servo:  

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Servo Setup  

There are two supported servos, the TowerPro MG90S and the Savox SH-0255MG. If you select one or the other during `./install.sh -i` the defaults will be set up well for you. If you have a custom servo selection, you'll want to consult the documentation for that servo.  

`pin` is an alias for the PWM pin used to drive the servo.  

`maximum_servo_angle` defines the range of maximum servo movement. The MG90S and Savox options are 180º. Some servos have 150º or 120º ranges. Set this to match, otherwise, when you configure your servo to move 30°, it won't be 30°.

`minimum_pulse_width` is the pulse width at the low end of what your servo can process. This is in microseconds. If your servo manufacturer states the pulsewidth low end is 800 µs, enter 0.00080.  

`maximum_pulse_width` similar to above, just on the other end.  

*__Note: if your servo moves the wrong direction, this is NOT the place to change things. That can be handled in `mmu_parameters.cfg`__*  

If you have a gantry servo for the filament cutter, you can uncomment the section for that and configure your servo settings similar to above.  
That's about it for servo hardware config, so let's get to the encoder.  

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Encoder Setup

If your MMU has an encoder, this is where you set it up. The encoder is used to keep track of the filament position. It can detect filament clogs and runouts, and is used to synch the gear motor, as well as in calibrating gate rotation distance. If you chose the encoder during `./install.sh -i` the defaults should all be in place for your encoder.

`encoder_pin` is an alias for the data pin used to read the encoder.  

`encoder_resolution` is the length of filament per encoder signal. Just get this one close. It will be calibrated more precisely later on.  

`desired_headroom` is the allowed distance between extruder filament use and the measured filament position. This gives a buffer for clog detection and filament runout. Set too low, there will be many false clog errors. Set to high and it will grind the extruder gears before Happy Hare pauses the print.  

`average_samples` helps with adjusting dynamic clog detection length. As the printer operates, Happy Hare will keep track of how well the encoder and extruder track together. If they are very close, it will reduce the clog length detection for better, more accurate, clog detection. This number is the amount of samples it uses to reduce clog length. More samples means it takes longer to update clog length. The default usually works fine here.  

`flowrate_samples` tells Happy Hare how many extruder movements to use when correlating encoder movement to flow rate. The default is good.  

That's it for the encoder. The defaults are usually pretty good for this section. You should only need to adjust things if you have a custom MMU. Let's talk about sensors next:  

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Filament Sensor Setup

Happy Hare can utilize a plethora of sensors to determine where the filament is in the filament path.  

`pre_gate_switch_pin_#` pre gate switch aliases. Pre-gate swtiches are used to determine if filament is available at a gate. They also help with auto loading the filament into the gate. If the MMU selector is homed, tripping the gate switch by inserting filament will pull the filament into parking position and mark that gate as available in Happy Hare.

`gate_switch_pin` is an alias for the gate switch. This tells Happy Hare the filament is loaded through the gate and ready to send to the extruder.  

`extruder_switch_pin` is the toolhead sensor just before the extruder gears. It is used to home the filament in the tool head. This eliminates the need for the gear stepper to crash the filament into the extruder gears to home the filament.  Note that there is no alias here and the pin callout must be done directly. This will likely be on a toolhead board or on the main MCU.

`toolhead_switch_pin` This is the switch just after the extruder gears. Happy Hare uses it to confirm the filament is loaded into the extruder and also determine how much farther to move the filament to the nozzle. If you only have one sensor in a toolhead, this one is preferred. This is also not an alias and must be entered directly.

`sync_feedback_tension_pin` is the pin related to the tension side of something like the Belay sensor. Not an alias.
`sync_feedback_compression_pin` similar to above, but for compression. Also not an alias.

That's all for sensors. LED setup is next.  

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) LED or Neopixel Setup

This section allows you to configure neopixel chains in the MMU.

`pin` is the alias for the neopixel drive pin.

`chain_count` is the number of individual LEDs in the neopixel chain. Note, if you use entry, exit, and status LEDs, the can all be chained together as one neopixel chain. You'll need to keep track of the order from the MMU board to the end of the chain.

`color_order` this is specified by the neopixel manufacturer. Match this with the documentation from your neopixel supplier.

`num_gates` is the number of gates your MMU has.

`led_strip` is used to direct the MMU effects to the correct neopixel chain.

`exit_range` the indices for the exit LEDs.

`entry_range` the indices for the entry LEDs.

`status_index` the led index for the status LED.

`frame_rate` how fast the neopixel chain is updated. Leave it at 24 for smooth operation without putting excess load on the MMU board processor.  

Review the main [Led-Support](Led-Support) for more details - there are lots of pictures and detailed info there.

That pretty much sums up `mmu_hardware.cfg`.

---

<p align="center">
 <img src="https://c.tenor.com/dJD2iLU0qGEAAAAC/high-five-top-gun.gif" alt="" width="244" height="146" />
</p>
