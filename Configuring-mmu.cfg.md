Let's go ahead and start with walking through `mmu.cfg`. This file contains the mmu control board device location and aliases for control board pins. If you did the interactive install with one of the supported boards, this should be mostly configured for you.

If you have a custom setup, enter your pins here. Don't add pin modifiers such as `!` or `^` here. Just the pin name.

<br>

## ![#f03c15](assets/f03c15.png) ![#c5f015](assets/c5f015.png) ![#1589F0](assets/1589F0.png) MCU Device Location

This is where you're going to place your device location. If you have a usb connected MMU control board like the EZBRD, you'll enter something like:  

![image](Configuring-mmu/serial_mcu.png)

It's important to include `/dev/serial/by-id/` because Klipper and Linux need the full path name to make the connection. One way to find this info is with the new Mainsail `DEVICES` button. It's in the top right of the screen when editing a config file.

![image](Configuring-mmu/mainsail_save_config.png)

Otherwise, you'll need to ssh into the rpi and do a `ls /dev/serial/by-id/` to find your serial device (usually connected to the rpi with a USB cable). This is very similar to how you connected your main MCU to klipper in `printer.cfg`.  

If you use CANBUS, then you'll enter your CANBUS UUID in the same location, but the line will look something like this:  

![image](Configuring-mmu/canbus_mcu.png)

We're not going to go into retrieving the UUID, but [Esoterical has a good guide](https://canbus.esoterical.online/) if you need help. The Mainsail button will try to find the CANBUS UUID, but it doesn't work if Klipper is already flashed to it.

That's pretty much it for setting up the MMU control board. Simple, right? (Ok, I know just copying and pasting is simple and getting the correct stuff to copy and paste is the hard part. I feel for you. If you need help, I would suggest hitting up discord and asking in the `Klipper` channel.

---

<p align="center"><img src="Configuring-mmu/raise_glass.gif" alt="" width="220" height="220" /></p>
