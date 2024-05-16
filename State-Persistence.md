## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) State Persistence

This is considered advanced functionality, but it is incredibly useful once you are familiar with the basic operation of your MMU. Essentially the state of everything from the EndlessSpool groups to the filament position and gate selection can be persisted across restarts (selector homing is not even necessary)! The implication of using this big time saver is that you must be aware that if you modify your MMU whilst it is off-line you will need to correct the appropriate state prior to printing by using `MMU_RECOVER` or by simply homing `MMU_HOME`

Here is an example startup state:

```
2:18 AM (\_/)
        ( *,*)
        (")_(") MMU Ready
2:18 AM Gates: |#0 |#1 |#2 |#3 |#4 |#5 |#6 |#7 |#8 |
        Tools: |T0 |T1 |T2 |T3 |T4 |T5 |T6 |T7 |T8 |
        Avail: | B | B | B | ? | . | ? | S | ? | B |
        Selct: --------| * |------------------------ T4
2:18 AM MMU [T2] >>> [En] >>>>>>> [Ex] >> [Ts] >> [Nz] LOADED (@0.0 mm)
```

Aside from showing that I was up too late writing this doc, this indicates how I left my MMU the day prior... Filaments are loaded in gates 0, 1, 2, 6 & 8; Gate #2 is selected; and the filament is fully loaded. If you are astute, you can see I have remapped T4 to be on gate #2 because previously I had loaded these spools incorrectly and this saved me from regenerating g-code. Gate #6 contains filament that has never been loaded and thus it is still on the `S` spool. The filaments in other gates has been previously loaded and unloaded and therefore are available from the `B` buffer. The buffer/spool distinction effects loading speed. (This status was generated on startup by setting `log_startup_status: 1` in mmu_parameters.cfg. It can also be generated anytime with the `MMU_STATUS` command).

In addition to basic operational state the print statistics and gate health statistics are persisted and so occasionally you might want to explicitly reset them with `MMU_STATS RESET=1`. There are 5 levels of operation for this feature that you can set based on your personal preference/habits. The level is controlled by a single variable `persistence_level` in `mmu_parameters.cfg`:

```yml
# Turn on behavior ---------------------------------------------------------------------------------------------------
#
# MMU can auto-initialize based on previous persisted state. There are 5 levels with each level bringing in
# additional state information requiring progressively less inital setup. The higher level assume that you don't touch
# MMU while it is offline and it can come back to life exactly where it left off!  If you do touch it or get confused
# then issue an appropriate reset command (E.g. MMU_RESET) to get state back to the defaults.
# Enabling `startup_status` is recommended if you use persisted state at level 2 and above
# Levels: 0 = start fresh every time except calibration data (the former default behavior)
#         1 = restore persisted endless spool groups
#         2 = additionally restore persisted tool-to-gate mapping
#         3 = additionally restore persisted gate status (filament availability, material and color, spoolID) (default)
#         4 = additionally restore persisted tool, gate and filament position! (Recommended when MMU is working well)
#
persistence_level: 3
```

Generally there is no downside of setting the level to 2 or 3 (the suggested default). Really, so long as you are aware that persistence is happening and know how to adjust/reset you can set the level to 4 and enjoy immediate MMU availability.

These commands can reset state:

`MMU_RESET` - Reset all persisted state back to default/unknown except for print stats and per-gate health stats<br>
`MMU_STATS RESET=1` - Reset print stats and per-gate health stats back to 0<br>
`MMU_TTG_MAP RESET=1` - Reset just the tool-to-gate mapping<br>
`MMU_ENDLESS_SPOOL RESET=1` - Reset just the endless spool groups back to default<br>
`MMU_GATE_MAP RESET=1` - Reset information about the filament type, color and availability<br>
`MMU_RECOVER` - Automatically discover or manually reset filament position, selected gate, selected tool, filament availability (lots of options)

Needless to say, other operations can update specific state

> [!NOTE]
> <ul>
>   <li>Closely relevant to the usefulness of this functionality is the `MMU_CHECK_GATE` command that will examine all or selection of gates for presence of filament</li>
>   <li>In the graphic depictions of filament state the `*` indicates presence ('B' and 'S' represent whether the filament is buffered or pulling straight from the spool), '?' unknown and ' ' or '.' the lack of filament</li>
>   <li>With tool-to-gate mapping it is entirely possible to have multiple tools mapped to the same gate (for example to force a multi-color print to be monotone) and therefore some gates can be made inaccessible until map is reset</li>
>   <li>The default value for `gate_status`, `tool_to_gate_map` and `endless_spool_groups` can be set in `mmu_parameters.cfg`.  If not set the default will be, Tx maps to Gate#x, the status of each gate is unknown and each tool is in its own endless spool group (i.e. not part of a group)</li>
> </ul>
