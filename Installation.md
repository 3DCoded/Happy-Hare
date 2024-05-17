The Happy Hare Klipper and Moonraker extensions must frst be cloned from Github and then installed into an existing Klipper installation using the supplied the install script. Once installed it will be added to Moonraker update-manager to easy updates like other Klipper plugins:

```yml
cd ~
git clone https://github.com/moggieuk/Happy-Hare.git
cd Happy-Hare
```

<br>
 
## ![#f03c15](/doc/resources/f03c15.png) ![#c5f015](/doc/resources/c5f015.png) ![#1589F0](/doc/resources/1589F0.png) Creating Base Klipper Config
The module can be installed into an existing Klipper installation with the install script. Once installed it will be added to Moonraker update-manager to easy updates like other Klipper plugins:

```
cd ~
git clone https://github.com/moggieuk/Happy-Hare.git
cd Happy-Hare

./install.sh -i
```

The `-i` option will bring up an interactive installer to aid setting some confusing parameters. For popular external mcu boards it will also configure all the pins for you. If run without with the `-i` flag it defaults to updating the current installation which is sometimes necessary for significant version updates (see [here](doc/update.md)). Note that if an existing install is found it will never be overwritten, it will be moved to a numbered backup folder with a `<file>.<date>` extension and current configuration defaults carried over. If you still choose not to install the new `mmu*.cfg` files automatically you can copy the templates and fill in all the tokens and blank parameters by hand. Frankly it is much easier to run through an initial install and use the generated config files as a starting point.
<br>

Note that the installer will look for Klipper install and config in standard locations. If you have customized locations or multiple Klipper instances on the same rpi, or the installer fails to find Klipper you can use the `-k` and `-c` flags to override the Klipper home directory and Klipper config directory respectively. Also, if installing on Repetier-Server add the `-r` option. E.g.
```
./install.sh -k /opt/klipper/LK5_Pro_ERCF -c /var/lib/Repetier-Server/database/klipper -m /opt/klipper/LK5_Pro_ERCF/moonraker -r LK5_Pro_ERCF -i
```

If you have multiple Klipper instances installed with for example Kiauh. You can use the `-a` flag to specify the service name. E.g.
```
./install-sh -a klipper-two -k <klipper_home_dir> -c <klipper_config_dir>
```

<br>

> [!IMPORTANT]  
> `mmu.cfg`, `mmu_hardware.cfg`, `mmu_macro_vars.cfg` & `mmu_parameters.cfg` (and other base config files) must all be referenced by your `printer.cfg` master config file with `mmu.cfg` and `mmu_hardware.cfg` listed first (the recommended way to achieve this is simply with `[include mmu/base/*.cfg]`). `mmu/optional/client_macros.cfg` should also explicitly be referenced if you don't already have working PAUSE / RESUME / CANCEL_PRINT macros (but be sure to read the section beforehand regarding macro expectations and review the default macros). The install script can also include these optional config files for you.
<br>

> [!TIP]  
> If you are concerned about running `install.sh -i` then run like this: `install.sh -i -c /tmp -k /tmp` This will build the `*.cfg` files for you but put then in /tmp rather than overwriting your active configuration. You can then refer to them, pulling out the bits you need to augment your existing install or simply see what answers to the various questions will do...

```
Usage: ./install.sh [-k <klipper_home_dir>] [-c <klipper_config_dir>] [-m <moonraker_home_dir>] [-b <branch>] [-r <Repetier-Server stub>] [-i] [-d] [-z]

-i for interactive install
-d for uninstall
-z skip github check (nullifies -b <branch>)
-r specify Repetier-Server <stub> to override printer.cfg and klipper.service names
(no flags for safe re-install / upgrade)
```

> [!WARNING]  
> TCRT 5000 encoders on ERCFv1.1 can be problematic. A new backward compatible alternative "Binky" is available and is strongly recommended (standard in ERCFv2). If you insist on fighting with the original encoder be sure to read my [notes on Encoder problems](/doc/ercf_encoder_v11.md) - the better the encoder the better this software will work for MMU's with encoders.
> Hall effect toolhead sensors can be problematic in a heated chamber because their characteristics change with temperature. Microswitch versions are preferred.



### 7. Pause / Resume / Cancel_print macros:

Regardless of whether you use your own PAUSE / RESUME / CANCEL_PRINT macros or use the ones provided in `client_macros.cfg`, Happy Hare will automatically wrap anything defined so that it can inject the necessary steps to control the MMU.

<details>
<summary><sub>🔹 Read more about what Happy Hare adds to these macros...</sub></summary><br>

During a print, if Happy Hare detects a problem, it will record the print position, safely lift the nozzle up to `z_hop_height_error` at `z_hop_speed` (to prevent a blob). It will then call the user's PAUSE macro (which can be the example one supplied in `mmu_software.cfg`). As can be seen with the provided examples it is expected that pause will save it's starting position (GCODE_SAVE_STATE) and move the toolhead to a park area, often above a purge bucket, at fast speed.<br>

The user then addresses the issue and calls `RESUME` to continue with the print.<br>

The user's RESUME macro may do some purging or nozzle cleaning but is expected to return the toolhead to where it was left when the pause macro was called. At this point the Happy Hare wrapper takes over and is responsible for dropping the toolhead back down to the print and resumes printing.<br>

Happy Hare will always return the toolhead to the correct position, but if you leave it in your park area will will move it back very slowly. You can to follow the above sequence to make this operation fast to prevent oozing from leaking on your print.

</details>



### 11. Useful pre-print functionality

There are a couple of commands (`MMU_PRELOAD` and `MMU_CHECK_GATE`) that are useful to ensure MMU readiness prior to printing.

<details>
<summary><sub>🔹 Read more on pre-print readiness...</sub></summary><br>

The `MMU_PRELOAD` is an aid to loading filament into the MMU.  The command works a bit like the Prusa's functionality and spins gear with servo depressed until filament is fed in.  It then parks the filament nicely. This is the recommended way to load filament into your MMU and ensures that filament is not under/over inserted potentially preventing pickup or blocking the gate.<br>

Similarly the `MMU_CHECK_GATE` command will run through all the gates (or the one specified), checks that filament is loaded, correctly parks and updates the "gate status" map so the MMU knows which gates have filament available.<br>

> [!NOTE]
> The `MMU_CHECK_GATE` command has a special option that is designed to be called from your `PRINT_START` macro. When called as in this example: `MMU_CHECK_GATE TOOLS=0,3,5`. Happy Hare will validate that tools 0, 3 & 5 are ready to go else generate an error prior to starting the print. This is a really useful pre-print check! See [Gcode Preprocessing](/doc/gcode_preprocessing.md) for more details.

</details>
