# BoxTurtle Quickstart

<p align="center"><img src="resources/tortoise-hare.png" alt='tortoise-hare' width='20%'></p>

**Page Sections:**

- [Cloning Happy Hare Repo](#---cloning-happy-hare-repo)
- [Running Installer](#---running-installer)

This quickstart guide explains how to install Happy Hare firmware for use with the [BoxTurtle](https://github.com/ArmoredTurtle/BoxTurtle) modular multimaterial system. 

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Terminology

The terminology for BoxTurtle and HappyHare differ a bit. Terms map as follows:

| BoxTurtle Term    | Happy Hare Term |
| ----------------- | --------------- |
| Lane/Leg          | Gate            |
| Trigger           | Pre-gate sensor |
| AFC Stepper       | Gear stepper    |
| Load sensor       | Gear sensor     |
| Hub sensor        | Gate sensor     |
| Tool start sensor | Extruder sensor |
| Tool end sensor   | Toolhead sensor |

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Cloning Happy Hare Repo

First, download the Happy Hare repository onto your Raspberry Pi using the `git` tool. Log into your Raspberry Pi via SSH (PuTTy on Windows):

```
ssh pi@klippy.local
```

> [!NOTE]
> Replace `klippy.local` with your Raspberry Pi's hostname. If you use a different username than `pi`, replace `pi` with your custom username.

Now, clone the Happy Hare repository onto your Raspberry Pi:

```
cd ~
git clone https://github.com/moggieuk/Happy-Hare.git
```

Happy Hare is now downloaded onto your Raspberry Pi. The next step is installing it.

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Running Installer

To install Happy Hare firmware, run the following commands on your Raspberry Pi through SSH:

```
cd ~/Happy-Hare
./install.sh -i
```

This will open the interactive installer. You will be presented by several options, each of which are explained below.

### 1. MMU Type

This is the type of MMU you are setting up. In this case, it is a BoxTurtle v1.0. Find it in the list, and type the number located next to it.

<img width="472" alt="Screenshot 2024-11-07 at 8 47 31 PM" src="https://github.com/user-attachments/assets/0fd54a7a-32ae-48c3-8508-7e4cbdea4e9a">


### 2. Number of Gates

The installer will then ask for the number of gates you have. This corresponds to how many filament units you have set up on your BoxTurtle. Type the number and press enter.

> [!NOTE]
> In the screenshot below, four lanes are present, so the number `4` is entered.

<img width="410" alt="Screenshot 2024-11-07 at 8 51 24 PM" src="https://github.com/user-attachments/assets/203b94f1-9e71-4303-aa4b-4bddc1c12257">

### 3. Control Board

Next, the installer will ask which controller you are using. If your controller is in the list, type the number next to its name in the list, and press enter. Typical boards used with BoxTurtle are the MMB boards or AFC Lite. If not, press the number next to `Not in list / Unknown`. 

<img width="410" alt="Screenshot 2024-11-07 at 8 48 11 PM" src="https://github.com/user-attachments/assets/ca9faf84-5ba3-4f87-b256-5bd7f7d3c390">


### 4. Serial Port

The installer will attempt to locate the serial port of your selected control board. If the displayed port is correct, type `y` and press enter. If not, type `n` and press enter.

> [!TIP]
> If you're unsure about the serial port, open a new SSH window, unplug your controller board, and run:
> ```
> ls /dev/serial/by-id
> ```
> Next, plug in your controller board, and re-run the command. The newly added line is your controller's serial address.

<img width="577" alt="Screenshot 2024-11-07 at 6 07 30 PM" src="https://github.com/user-attachments/assets/1af43a57-4905-44fa-901b-c4502d877717">

### 5. LEDs

Choose whether or not you want LEDs enabled for your BoxTurtle.

<img width="433" alt="Screenshot 2024-11-07 at 6 10 05 PM" src="https://github.com/user-attachments/assets/dbaf5aa6-fcad-48c1-8d04-81b599f90a98">

### 6. EndlessSpool

Choose whether or not you want Endless Spool to be enabled. This let Happy Hare automatically load another spool if your current spool runs out.

<img width="753" alt="Screenshot 2024-11-07 at 6 11 08 PM" src="https://github.com/user-attachments/assets/5be79a54-e869-4871-b6eb-cc0b2a8afaa7">

### 7. `printer.cfg`

This is usually set to `y` on new Happy Hare installations, and `n` on existing ones.

<img width="641" alt="Screenshot 2024-11-07 at 6 11 56 PM" src="https://github.com/user-attachments/assets/20cc31a1-5452-4390-b01c-5414408dacb0">

### 8. `mmu.cfg`

Review the pin aliases in your `mmu/base/mmu.cfg` to ensure they are correct. The pin aliases for the AFC Lite board should match up with the ones used by the official AFC software. If using MMB, they may be a little different.

### 9. `mmu_hardware.cfg`

Review the generated `mmu/base/mmu_hardware.cfg` to ensure things like:

* Stepper direction pins are correct, inverting if necessary (adding/removing `!` as necessary).
* Configure LEDs
  * Standard BoxTurtle should set `chain_count: 4`
  * Set `exit_range: 1-4`
  * Remove `entry_range` and `status_index`

### 9. `mmu_parameters.cfg`

There is lots to cover here but the default *should* be sufficent to get you started. If not, follow the comments in the file or review the wiki for details on the various features.

### 10. ESpooler

Review `mmu/base/mmu_hardware.cfg`, `[mmu_espooler mmu_espooler]` section

<br>

Review `mmu/base/mmu_parameters.cfg`, `# ESpooler control ----` section

* Each lane should be configured with a `rwd` pin for each gate/lane.
* If your mcu permits you can configure a `fwd` pin for each gate/lane.
* You can also configure an `en` pin if needed (AFC Lite boards use the enable pin).
Depending on your hardware you may need to turn off `pwm` and `scale`.

A full detailed guide for setup and use can be found in the wiki[Espooler Support](Espooler-Support) section

### 11. Mainsail / Fluidd / KlipperScreen

Make life easy on yourself and setup your favorite UI:
* [Mainsail / Fluidd](Mainsail-Fluidd-Integration)
* [KlipperScreen](KlipperScreen)

### 12. Enjoy

Remember there is a lot of details in the wiki (but you might have to dig). Also don't forget to join the dedicated Happy Hare forum: https://discord.gg/98TYYUf6f2

---

🎉 Happy Hare is successfully installed!

(Quick start guide based on the 3MS template by 3DCoded)
