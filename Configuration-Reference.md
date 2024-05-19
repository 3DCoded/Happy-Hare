#### Page Sections:
- [mmu.cfg](Configuring-mmu.cfg)
- [mmu_hardware.cfg](Configuring-mmu_hardware.cfg)
- [mmu_parameters.cfg](Configuring-mmu_parameters.cfg)
- [mmu_macro_vars.cfg](Configuring-mmu_macro_vars.cfg)

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Location of Configuration Files

The Klipper configuration files for Happy Hare are modular and can be found in this layout in the Klipper config directory (typically `~printer_data/config/`:

```yml
mmu/
  mmu_vars.cfg

  base/
    mmu.cfg
    mmu_hardware.cfg
    mmu_parameters.cfg
    mmu_macro_vars.cfg
    mmu_software.cfg        # READ-ONLY
    mmu_sequence.cfg        # READ-ONLY
    mmu_leds.cfg            # READ-ONLY
    mmu_form_tip.cfg        # READ-ONLY
    mmu_cut_tip.cfg         # READ-ONLY
    mmu_state.cfg           # READ-ONLY

  optional/
    mmu_menu.cfg            # READ-ONLY
    mmu_ercf_compat.cfg     # READ-ONLY
    client_macros.cfg       # READ-ONLY

  addons/
    blobifier_hw.cfg
    blobifier.cfg           # READ-ONLY
    mmu_erec_cutter_hw.cfg
    mmu_erec_cutter.cfg     # READ-ONLY
```

This makes the minimal include into your printer.cfg easy and guarantees the correct load order!
> [include mmu/base/\*.cfg]

If you are using optional modules they should appear after the above, for example:
> [include mmu/base/\*.cfg]<br>
> [include mmu/optional/client\_macros.cfg]<br>
> [include mmu/optional/menu.cfg]<br>
> [include mmu/optional/blobifier\*.cfg]<br>

> [!IMPORTANT]  
> Some of the configuration files are marked as `READ-ONLY`. These are not designed to be edited by the user - if you desired to change the behavior outside of the built-in extensibility you should copy the logic into macros of your own name and set the options in `mmu_parameters.cfg` to point to them instead.<br>
> The remainder of the `cfg` files are designed to be edited to allow for configuration and customization.

  | File | Description | Edit? |
  | ---- | ----------- | ----- |
  | `mmu_vars.cfg` | Used to persist state and certain dynamic configuration. | |
  | `mmu.cfg` | Configuration for control board (mcu) device location and aliases for control board pins. | Yes |
  | `mmu_hardware.cfg` | User adjustable hardware based parameters are stored. | Yes |
  | `mmu_parameters.cfg` | Main configuration parameters for the Klipper module. | Yes |
  | `mmu_macro_vars.cfg` | Modular config file that controls the operation of all the supplied macros. | Yes |
  | `mmu_software.cfg` | Contains core macros leveraged by Happy Hare. | |
  | `mmu_sequence.cfg` | Core macros for customization of loading and unload sequences. | |
  | `mmu_leds.cfg` | Core macros for controlling LEDs. | |
  | `mmu_form_tip.cfg` | Default macros for tip forming logic. | |
  | `mmu_cut_tip.cfg` | Default macros toolhead based filament cutting logic. | |
  | `mmu_state.cfg` | Default macros for handling state changes. | |
  | `mmu_menu.cfg` | Optional config for adding MMU functions to 12864 style displays. | |
  | `mmu_ercf_compat.cfg` | Optional config to retain only ERCF sytle command sytax. **DEPRECATED** | |
  | `client_macros.cfg` | Recommended but still optional set of PAUSE/RESUME/CANCEL_PRINT macros. | |
  | `blobifier_hw.cfg` | Contains h/w setup options for Blobifier. | Yes |
  | `blobifier.cfg` | Default macros for controlling Blobifier blob purging mechanism. | |
  | `mmu_erec_cutter_hw.cfg` | Contains h/w setup options for EREC filament cutter. | Yes |
  | `mmu_erec_cutter.cfg` | Default macros for controlling ERCF filament cutter. | |

Now that you understand the layout and purpose of each file, you can follow the links at the top of this wiki for detailed guides on each config file...
