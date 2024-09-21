#### Page Sections:
- [EREC](#---erec-filament-cutter)
- [Blobifer](#---blobifier)

This directory contains possible addons for your MMU setup that have support shipped with Happy Hare

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) EREC Filament Cutter
An addon used to control filament cutting at the MMU rather than the toolhead
<img src="Addon-Feature-Setup/erec_logo.png" width=60%>

### Compatibility
**MMU:** ERCFv2<br>
**Printer:** _Any_

### Github
https://github.com/kevinakasam/ERCF_Filament_Cutter

### Config
1. Add `[include mmu/addons/mmu_erec_cutter.cfg]` to your `printer.cfg`
1. Edit `mmu_erec_cutter.cfg` and `mmu_erec_cutter_hw.cfg` to work with your setup
1. In `mmu_macro_vars.cfg` set `variable_user_post_unload_extension : "EREC_CUTTER_ACTION"`

<hr>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Blobifier
An addon used to create purge blobs instead of using a wipe tower
<img src="Addon-Feature-Setup/blobifier.png" width=60%>

### Compatibility
**MMU:** _Any_<br>
**Printer:** Voron v2, others in the works

### Github
https://github.com/Dendrowen/Blobifier

### Config
1. Add `[include mmu/addons/blobifier.cfg]` to your `printer.cfg`
1. Edit `blobifier.cfg` and `blobifier_hw.cfg` to work with your setup
1. Set `variable_user_post_load_extension : "BLOBIFIER"` in `mmu_macro_vars.cfg`
1. Optionally set `variable_user_post_form_tip_extension : "BLOBIFIER_PARK"` in `mmu_macro_vars.cfg` to park the nozzle on the tray during a swap. Note that it is always recommended that you at least z-hop on toolchange so that the toolhead is immediately lifted off the print. Read [Toolchange Movement](Toolchange-Movement) for more details.

<br>

> [!IMPORTANT] 
> For all add-on extensions, ensure that you always use the "cfg" files from Happy Hare and not those sourced elsewhere so you have the most recent changes and fixes.
