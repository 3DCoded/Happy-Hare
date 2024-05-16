Happy Hare maintains a set of "maps" (exposed by printer variables) that are used to keep track of filaments:
- [Gate Map](#---gate-map)
  - The filaments currently loaded in the MMU
- [Tool to Gate Map](#---tool-to-gate-ttg-mapping)
  - The mapping of `Tx` tool numbers to gates
- [Slicer Tool Map](#---slicer-tool-map)
  - What the slicer defines for each tool of the current print

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Gate Map
**Management Command: `MMU_GATE_MAP`**<br>
**Printer Variables: `printer.mmu.gate_status`, `printer.mmu.gate_material`, `printer.mmu.gate_color`, `printer.mmu.gate_color_rgb` and `printer.mmu.gate_spool_id` (if spoolman is enabled)**

Happy Hare can keep track of the type and color for each filament you have loaded in the MMU as well as the current availability. This is leveraged in KlipperScreen visualization but also has more practical purposes because this information is made available through printer variables so you can leverage in your own macros to, for example, customize pressure advance, temperature and more. The map is persisted in `mmu_vars.cfg`.

The gate map can be viewed with the following command with no parameters:<br>

> MMU_GATE_MAP

```
    MMU Gates / Filaments:
    Gate #0: Status: Buffered, Material: PLA, Color: red
    Gate #1: Status: Buffered, Material: ABS+, Color: orange
    Gate #2: Status: Buffered, Material: ABS, Color: tomato
    Gate #3: Status: Unknown, Material: ABS, Color: green
    Gate #4: Status: Unknown, Material: PLA, Color: blue
    Gate #5: Status: Unknown, Material: PLA, Color: indigo
    Gate #6: Status: Unknown, Material: PETG, Color: violet
    Gate #7: Status: Unknown, Material: ABS, Color: ffffff
    Gate #8: Status: Buffered, Material: ABS, Color: black
```

To change for a particular gate use a command in this form:

> MMU_GATE_MAP GATE=8 MATERIAL=PLA COLOR=ff0000 AVAILABLE=1

If you remove buffered filament from a gate and want to quickly tell Happy Hare that it is loading from spool again (for slower loads) the easiest way is simply this:

> MMU_GATE_MAP GATE=8 AVAILABLE=1

Multiple gates can be specified for bulk updates. A very useful command is this, which will reset the availability status of all gates back to the default of "unknown"

> MMU_GATE_MAP GATES=0,1,2,3,4,5,6,7,8 AVAILABLE=-1

> [!IMPORTANT]
> There is no enforcement of material names but it is recommended use all capital short names like PLA, ABS+, TPU95, PETG. The color string can be one of the [w3c standard color names](https://www.w3schools.com/tags/ref_colornames.asp) or a RRGGBB red/green/blue hex value. Because of a Klipper limitation don't add `#` to the color specification.

One potentially interesting built-in functionality is the exposing of filament color and RGB values suitable for directly driving LEDs.  The `gate_color_rgb` printer value will convert any color format (string name or hex spec) into truples like this: `(0.5, 0.0, 0.0)`.  You can use this to drive LED's with the Klipper led control in your macros similar to this because "bling" is important!

Here is a snippet of a macro for reference:
```
    {% set gate_color_rgb = printer['mmu']['gate_color_rgb'] %}
    {% set rgb = gate_color_rgb[GATE] %}
    SET_LED LED={leds_name} INDEX={index} RED={rgb[0]} GREEN={rgb[1]} BLUE={rgb[2]} TRANSMIT=1
```

> [!NOTE]
> KlipperScreen Happy Hare edition has a nice editor with color picker for easy updating<br>
> [Spoolman](Spoolman-Support) integration can also be used to automatically update colors

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Tool to Gate (TTG) Mapping
**Management Command: `MMU_TTG_MAP`**<br>
**Printer Variable: `printer.mmu.ttg_map`**

When changing a tool with the `Tx` command the MMU will by default select the filament at the gate (spool) of the same number. The mapping built into this _Happy Hare_ driver allows you to modify that.

There are a few use cases for this feature:
<ul>
  <li>You have loaded your filaments differently than you sliced gcode file... No problem, just issue the appropriate remapping commands prior to printing</li>
  <li>Some of "tools" don't have filament and you want to mark them as empty to avoid selection</li>
  <li>Most importantly, for EndlessSpool - when a filament runs out on one gate (spool) then next in the sequence is automatically mapped to the original tool.  It will therefore continue to print on subsequent tool changes.  You can also replace the spool and update the map to indicate availability mid print</li>
  <li>Turning a colored print into a mono one... Remap all the tools to a single gate.</li>
</ul>

To view the current detailed mapping you can use either `MMU_STATUS DETAIL=1` or `MMU_REMAP_TTG` with no parameters

The TTG map is controlled with the `MMU_REMAP_TTG` command although the graphical user interface with Happy Hare KlipperScreen makes this trivial. For example, to remap T0 to Gate #8, issue:

> MMU_REMAP_TTG TOOL=0 GATE=8

This will cause both T0 and the original T8 tools to pull filament from gate #8. If you wanted to then change T8 to pull from gate #0 (i.e. complete the swap of the two tools) you would issue:

> MMU_REMAP_TTG TOOL=8 GATE=0

You can also use this command to mark the availability of a gate. E.g.

> MMU_REMAP_TTG TOOL=1 GATE=1 AVAILABILE=1

Would ensure T0 is mapped to gate #1 but more importantly mark the gate as available. You might do this mid print after reloading a spool for example.

It is possible to specify an entirely new map in a single command as such:

> MMU_REMAP_TTG MAP=8,7,6,5,4,3,2,1,0

Which would reverse tool to gate mapping for a 9 gate MMU!

An example of how to interpret a TTG map (this example has EndlessSpool disabled). Here tools T0 to T2 and T7 are mapped to respective gates, T3 to T5 are all mapped to gate #3, tools T6 and T8 have their gates swapped. This also tells you that gates #1 and #2 have filament available in the buffer rather than in the spool for other gates and that gate #7 is currently empty/unavailable.

```
    T0 -> Gate #0(S)
    T1 -> Gate #1(B) [SELECTED on gate #1]
    T2 -> Gate #2(B)
    T3 -> Gate #3(S)
    T4 -> Gate #3(S)
    T5 -> Gate #3(S)
    T6 -> Gate #8(S)
    T7 -> Gate #7( )
    T8 -> Gate #6(S)

    MMU Gates / Filaments:
    Gate #0(S) -> T0, Material: PLA, Color: red, Status: Available
    Gate #1(B) -> T1, Material: ABS+, Color: orange, Status: Buffered [SELECTED supporting tool T1]
    Gate #2(B) -> T2, Material: ABS, Color: tomato, Status: Buffered
    Gate #3(S) -> T3,T4,T5, Material: ABS, Color: green, Status: Available
    Gate #4(S) -> ?, Material: PLA, Color: blue, Status: Available
    Gate #5(S) -> ?, Material: PLA, Color: indigo, Status: Available
    Gate #6(S) -> T8, Material: PETG, Color: violet, Status: Available
    Gate #7(S) -> T7, Material: ABS, Color: ffffff, Status: Empty
    Gate #8(S) -> T6, Material: ABS, Color: black, Status: Available
```

The lower paragraph of the status is the gate centric view showing the mapping back to tools as well as the configured filament material type and color which is explained later in this guide.<br>

> [!NOTE]  
> The initial availability of filament (and tihe default after a reset) at each gate can also be specified in the `mmu_parameters.cfg` file by updating the `gate_status` list of the same length as the number of gates. Generally this might be useful if you have purposefully decommissioned part of you MMU. E.g.<br>

```
gate_status = 1, 1, 0, 0, 1, 0, 0, 0, 1
```

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Slicer Tool Map
**Management Command: `MMU_SLICER_TOOL_MAP`**
<br>
**Printer Variable: `printer.mmu.slicer_tool_map`**

The slicer tool map will typically be set up in the print start macros as documented in [Slicer Setup](Slicer-Setup) and it is only valid for the current print (i.e. each print replaces the old map). It represents what the slicer is expecting to see for each tool and is pulled from information stored in the slicer's g-code file.

Here is an example map stored in the printer variable:
```yml
   printer.mmu.slicer_tool_map.
      initial_tool: 0          ; Initial tool number expected to be loaded at the beginning of the print
      ; List of all the tools referenced in the print (T0 and T3)
      tools.0.color: ff0000    ; Color in RRGGBB format for T0
      tools.0.material: ABS    ; Material type for T0
      tools.0.temp: 240        ; Extruder temperature for T0
      tools.0.in_use: 1        ; Tool used in print
      tools.3.color: 00e410    ; Color in RRGGBB format for T3
      tools.3.material: ASA    ; Material type for T3
      tools.3.temp: 245        ; Extruder temperature for T3
      tools.3.in_use: 1        ; Tool used in print
      purge_volumes: [[100, 100], [100, 100]] ; NxN matrix of purge volume changing from tool X to tool Y
```

The map can be displayed on the console at any time during the print by running the `MMU_SLICER_TOOL_MAP` command without any set parameters:

> MMU_SLICER_TOOL_MAP1

```
-------- Slicer MMU Tool Summary ---------
2 color print (Purge volume map loaded)
T0 (Gate 0, ABS, ff0000, 240°C)
T3 (Gate 3, ASA, 00e410, 245°C)
Initial Tool: T0
-------------------------------------------
```

> [!NOTE]  
> The purge volume portion of the map is covered under [Tip Forming and Purging](Tip-Forming-and-Purging#---purge-volumes) and not shown here
