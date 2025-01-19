# QuattroBox Quickstart

**Page Sections:**

- [Cloning Happy Hare Repo](#---cloning-happy-hare-repo)
- [Running Installer](#---running-installer)
- [Configuration](#---configuration)

This quickstart guide explains how to install Happy Hare firmware for use with the [Quattrobox](https://github.com/Batalhoti/QuattroBox) modular multimaterial system. 


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

This is the type of MMU you are setting up. In this case, it is a QuattroBox. Find it in the list, and type the number located next to it.

<p align="left"><img src="Installation/quattrobox_questions.png"></p>


### 2. Number of Gates

The installer will then ask for the number of gates you have. This corresponds to how many filament units you have set up on your QuattroBox. Type the number and press enter.

> [!NOTE]
> In the screenshot below, four lanes are present, so the number `4` is entered.

<p align="left"><img src="Installation/quattrobox_gates.png"></p>

### 3. Control Board

Next, the installer will ask which controller you are using. If your controller is in the list, type the number next to its name in the list, and press enter. The typical board used with Quattrobox is the MMB board. If not, press the number next to `Not in list / Unknown`. 

<p align="left"><img src="Installation/quattrobox_mcu.png"></p>


### 4. LEDs

Choose whether or not you want LEDs enabled for your Quattrobox.

<p align="left"><img src="Installation/quattrobox_led.png"></p>

### 5. EndlessSpool

Choose whether or not you want Endless Spool to be enabled. This let Happy Hare automatically load another spool if your current spool runs out.

<p align="left"><img src="Installation/quattrobox_endless.png"></p>

### 6. `printer.cfg`

This is usually set to `y` on new Happy Hare installations, and `n` on existing ones.

<p align="left"><img src="Installation/quattrobox_include.png"></p>


---

🎉 Happy Hare is successfully installed!

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Configuration

###  `mmu.cfg`

Review the pin aliases in your `mmu/base/mmu.cfg`, you need to add some pins for the buttons to work. If you are using an MMB, you can copy the following configuration:

```
EJECT_BUTTON_0=PC15,
EJECT_BUTTON_1=PC13,
EJECT_BUTTON_2=PC14,
EJECT_BUTTON_3=PB12,
```
> [!NOTE]
> If these pins are applied in `MMU_POST_GEAR`, they must be deleted

If you are using another board, set the correct pins

###  `mmu_hardware.cfg`

Review the generated `mmu/base/mmu_hardware.cfg` to ensure things like:

* Stepper direction pins are correct, inverting if necessary (adding/removing `!` as necessary).
  * If you are using a Nema 14 stepper, you need to change the `run_current` and `gear_ratio`
    ```
    [tmc2209 stepper_mmu_gear]
    run_current: 0.7

    [stepper_mmu_gear]
    gear_ratio: 50:10
    ```

* Configure LEDs
  * By default, the LEDs are configured with `Quattro` as the logo and `Box` as the status.
    ```
    [mmu_leds]
    exit_leds:   neopixel:mmu_leds (1-4)
    #entry_leds:  
    status_leds: neopixel:mmu_leds (5-14)
    logo_leds:   neopixel:mmu_leds (15-32)  
    frame_rate: 24
    ```
  * We have the option to set the entire `QuattroBox` as status as well, like this:
    ```
    [mmu_leds]
    exit_leds:   neopixel:mmu_leds (1-4)
    #entry_leds:  
    status_leds: neopixel:mmu_leds (5-32)
    #logo_leds:     
    frame_rate: 24
    ```


### Eject Buttons

Add the button include in your `printer.cfg`

 >[include mmu/addons/mmu_eject_buttons.cfg]

---

(Quick start guide based on the 3MS template by 3DCoded)
