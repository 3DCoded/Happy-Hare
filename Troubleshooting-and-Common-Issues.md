Got problems? Here are some common solutions.  

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Klipper Issues

### <p align="left"><img src="resources/carrot.png" alt="" width="23" height="21" />Timer too close

This is generally from having the gear stepper microsteps set too high. It should match up with the extruder, in ideal circumstances. 16 microsteps is plenty for the extruder and gear. If you still get `Timer Too Close` errors, try setting your gear stepper to 8 microsteps.

Github user Dendrowen (our beloved Blobifier dev) also provided these steps ([from discord](https://discord.com/channels/460117602945990666/909743915475816458/1222875626231566396)):
- Decrease load (webcams, plugins, etc..)
- Check load: https://www.klipper3d.org/Debugging.html#generating-load-graphs
- Check wiring
- Replace rPi
- Increase Pi voltage to 5.1V
- Replace SD card  

Another issue that seems to crop up is the temperature of the rpi. If it gets too hot, it will automatically throttle performance, so consider adding a fan hat to keep it frosty.

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Slicer Errors

### <p align="left"><img src="resources/carrot.png" alt="" width="23" height="21" />Purge Volume Error
`Incorrect number of values for PURGE_VOLUMES. Expect 1, 8, 16, or 64, got XXX`
This usually happens when your number of filaments in the slicer doesn't match the number of gates in the MMU.
For instance, if you have an 8 gate MMU and your slicer only has 7 filaments:
<p align="center">
    <img src="Troubleshooting-and-Common-Issues/purge_volume_error1.png" alt="" width="422" height="195" />
</p>
Add in a placeholder filament so the number of tools and filaments matches the number of gates in the MMU:
<p align="center">
    <img src="Troubleshooting-and-Common-Issues/purge_volume_error2.png" alt="" width="419" height="153" />
</p>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) BTT MMB Issues

### <p align="left"><img src="resources/carrot.png" alt="" width="23" height="21" />No rule to make target 'flash'
This is because the Linux operating system on the Raspberry Pi doesn't know how to flash the firmware. When you do the `make` command, it compiles the firmware from a bunch of options that you entered in `make menuconfig` into machine readable code. `make flash` is used to send that compiled firmware to the MMB. Somewhere along the way, the `make` command doesn't get the right instructions for pushing the file to the board.
- Make sure you have all the correct options for the processor and communication ports set in `make menuconfig`.
- Make sure your flash device (usually the CANBUS UUID) is correct.  

The MMB is notorious for being difficult to flash. It doesn't seem to like running Katapult without Klipper installed. The instructions from BTT, well, they leave a lot to be desired. Some have had luck flashing both Katapult and Klipper (including the 8kib bootloader offset) over USB. That puts Katapult on the board so you can later flash firmware over CANBUS, as well as having the Klipper firmware running on the MMB before establishing CANBUS communications. So, try flashing both over USB. You'll need to get your UUID and save it first, so it can be put in `printer.cfg` or `mmu.cfg`.  

## Issues During Printing
### Happy Hare pauses the print for a clog when there is no clog
This typically happens when the extruder looses steps. When a stepper on the X or Y looses steps, it's loud, obnoxious, and frightens the neighbors. When an extruder looses steps, you'll probably not even notice due to the other noise the machine makes. So, look for reasons the extruder may be overloading.
- Heavy prime lines are a big cause. If your prime line exceeds the physical capacity for the extruder to melt and move plastic, it will lose steps and cause a pause due to clog.
- Extruder tension setting is off. If the tension is light and it grinds the filament, Happy Hare will see the difference between the encoder and expected movement and pause due to clog. If the tension is too heavy, and it squishes the filament into an oval shape that drags on the filament path after the extruder, this can cause the extruder to grind the filament as well. A good inspection of the filament should give you hints here.
- Poor encoder calibration. Try going back and re-doing the encoder calibration and make sure your Gate 0 calibration is correct, i.e. commanding 100mm of filament movement produces 100mm of measured movement.
