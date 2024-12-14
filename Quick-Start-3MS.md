# 3MS Quickstart

**Page Sections:**

- [Cloning Happy Hare Repo](#---cloning-happy-hare-repo)
- [Running Installer](#---running-installer)
- [Configuration](#---configuration)

This quickstart guide explains how to install Happy Hare firmware for use with the [3MS](https://github.com/3DCoded/3MS) modular multimaterial system. 

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Cloning Happy Hare Repo

First, download the Happy Hare repository onto your Raspberry Pi using the `git` tool. Log into your Raspberry Pi via SSH (PuTTy on Windows):

```
ssh pi@klippy.local
```

> [!NOTE]
> Replace `klippy.local` with your Raspberry Pi's hostname. If you use a different username than `pi`, replace `pi` with your custom username.

Now, clone the Happy Hare repository onto your Raspberry Pi:

> [!IMPORTANT]
> K1 series users (K1, K1C, K1 Max, etc.) should instead perform the following steps (thank you **@trandanhlam**!):
> 1. Upgrade Klipper using [this guide]( https://github.com/K1-Klipper/installer_script_k1_and_max
) .
> 2. Upgrade Klipper Firmware using [this guide](https://github.com/cryoz/k1_mcu_flasher) and [this firmware](https://github.com/pellcorp/klipper/tree/master/fw/K1) .

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

This is the type of MMU you are setting up. In this case, it is a 3MS. Find it in the list, and type the number located next to it.

<img width="386" alt="Screenshot 2024-11-07 at 5 56 31 PM" src="https://github.com/user-attachments/assets/c37ef647-cf1d-4649-b9b4-b64341cf01f0">

### 2. Number of Gates

The installer will then ask for the number of gates you have. This corresponds to how many filament units you have set up on your 3MS. Type the number and press enter.

> [!NOTE]
> In the screenshot below, three filament units are present, so the number `3` is entered.

<img width="389" alt="Screenshot 2024-11-07 at 5 59 20 PM" src="https://github.com/user-attachments/assets/ff437c53-152e-4fb7-8e3e-22876569673b">

### 3. Control Board

Next, the installer will ask which controller you are using. If your controller is in the list, type the number next to its name in the list, and press enter. If not, press the number next to `Not in list / Unknown`. 

<img width="304" alt="Screenshot 2024-11-07 at 6 02 14 PM" src="https://github.com/user-attachments/assets/8a38becd-926d-4940-a25f-987172d0b435">

### 4. Serial Port

The installer will attempt to locate the serial port of your selected control board. If the displayed port is correct, type `y` and press enter. If not, type `n` and press enter.

<img width="577" alt="Screenshot 2024-11-07 at 6 07 30 PM" src="https://github.com/user-attachments/assets/1af43a57-4905-44fa-901b-c4502d877717">

> [!TIP]
> If you're unsure about the serial port, open a new SSH window, unplug your controller board, and run:
> ```
> ls /dev/serial/by-id
> ```
> Next, plug in your controller board, and re-run the command. The newly added line is your controller's serial address.

### 5. LEDs

Choose whether or not you want LEDs enabled for your 3MS.

<img width="433" alt="Screenshot 2024-11-07 at 6 10 05 PM" src="https://github.com/user-attachments/assets/dbaf5aa6-fcad-48c1-8d04-81b599f90a98">

### 6. EndlessSpool

Choose whether or not you want Endless Spool to be enabled. This let Happy Hare automatically load another spool if your current spool runs out.

<img width="753" alt="Screenshot 2024-11-07 at 6 11 08 PM" src="https://github.com/user-attachments/assets/5be79a54-e869-4871-b6eb-cc0b2a8afaa7">

### 7. printer.cfg

This is usually set to `y` on new Happy Hare installations, and `n` on existing ones.

<img width="641" alt="Screenshot 2024-11-07 at 6 11 56 PM" src="https://github.com/user-attachments/assets/20cc31a1-5452-4390-b01c-5414408dacb0">

---

🎉 Happy Hare is successfully installed! If you selected one of the default control boards, you don't need to follow the rest of this guide. If you selected `Not in list / Unknown`, read on.

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Configuration

If you aren't using one of the default Happy Hare provided control boards, you will have to select a 3MS-specific configuration for your control board.

### Controller Configuration

First, open the folder located in the 3MS repository [here](https://github.com/3DCoded/3MS/tree/main/happy-hare/configurations). This folder contains several other folders, each with a consistent naming scheme. The naming scheme is as follows:

1. **MCU name:**
    - **`MMU`**: external mainboard
    - **`MAIN`**: your printer's existing mainboard
2. **Tool numbers:** The first number should be `0` for a new setup, or be one higher than your previous controller's last tool number if adding to an existing 3MS.
3. **Mainboard name:** Specifies the controller model, e.g. `btt_skr_pico`.

Here are a few examples of this naming scheme:

`MMU_0_3_btt_skr_pico`: External SKR Pico controlling four tools numbered `0` to `3`.

`MMU_0_6_gtm32_103_v1`: External GTM32 103 V1 controlling seven tools numbered `0` to `6`.

`MAIN_0_3_btt_octopus`: Internal BTT Octopus controlling four tools numbered `0` to `3`.

> [!NOTE]
> If you can't find a configuration for your control board on the 3MS repository, you can [open an issue](https://github.com/3DCoded/3MS/issues/new/choose) to get a configuration created for your control board.

### Installing Configuration

Once you find your controller's configuration, open its folder. Inside there are two files:

- `mmu.cfg`
- `mmu_hardware.cfg`

If this is a **NEW** setup:

1. Copy the online `mmu.cfg`
2. Delete everything in your local `mmu.cfg` except your `mcu` configuration
3. Paste below the `mcu` configuration
4. Copy the online `mmu_hardware.cfg`
5. Replace your gear section in your local `mmu_hardware.cfg`. 

    The `GEAR` section starts with:

    ```
    # FILAMENT DRIVE GEAR STEPPER(S)  --------------------------------------------------------------------------------------
    #  ██████╗ ███████╗ █████╗ ██████╗ 
    # ██╔════╝ ██╔════╝██╔══██╗██╔══██╗
    # ██║  ███╗█████╗  ███████║██████╔╝
    # ██║   ██║██╔══╝  ██╔══██║██╔══██╗
    # ╚██████╔╝███████╗██║  ██║██║  ██║
    #  ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
    ```

    and ends right **before**:
    ```
    # SERVOS ---------------------------------------------------------------------------------------------------------------
    # ███████╗███████╗██████╗ ██╗   ██╗ ██████╗ ███████╗
    # ██╔════╝██╔════╝██╔══██╗██║   ██║██╔═══██╗██╔════╝
    # ███████╗█████╗  ██████╔╝██║   ██║██║   ██║███████╗
    # ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║   ██║╚════██║
    # ███████║███████╗██║  ██║ ╚████╔╝ ╚██████╔╝███████║
    # ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝   ╚═════╝ ╚══════╝
    ```

---

For **EXISTING** setups (using more than one control board):

1. Add the contents of the online `mmu.cfg` to your local `mmu.cfg`
2. Add the contents of the online `mmu_hardware.cfg` to your local `mmu_hardware.cfg`'s gear section.