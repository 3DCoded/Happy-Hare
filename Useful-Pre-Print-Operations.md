There are a couple of commands (`MMU_PRELOAD` and `MMU_CHECK_GATE`) that are useful to ensure MMU readiness prior to printing.

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) MMU\_PRELOAD

The `MMU_PRELOAD` is an aid to loading filament into the MMU.  The command works a bit like the Prusa's functionality and spins gear with servo depressed until filament is fed in.  It then parks the filament at the perfect postion in the gate. This is the recommended way to load filament into your MMU and ensures that filament is not under/over inserted potentially preventing pickup or blocking the gate.

> [!TIP]
> If you have pre-gate sensors installed they will automatically run this command when triggered outside of a print. This really helps with loading up your MMU. Note that if new filament is inserted while in a print it's presence will be noted but it will not be loaded.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) MMU\_PRELOAD

Similarly the `MMU_CHECK_GATE` command will run through all the gates (or the one specified), checks that filament is available, correctly parks and updates the [Gate Map](Tool-and-Gate-Maps#---gate-map) including the "gate status" so the MMU knows which gates have filament available.

> [!NOTE]
> The `MMU_CHECK_GATE` command has a special option that is designed to be called from your `PRINT_START` macro. When called as in this example: `MMU_CHECK_GATE TOOLS=0,3,5`. Happy Hare will validate that tools 0, 3 & 5 are ready to go else generate an error prior to starting the print. This is a really useful pre-print check! See [Slicer Setup](Slicer-Setup) for more details.
