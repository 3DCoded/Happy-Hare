## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) State Persistence

Essentially the state of everything from the EndlessSpool groups to the filament position and gate selection can be persisted across restarts (selector homing is not even necessary)! The implication of using this big time saver is that you must be aware that if you modify your MMU whilst it is off-line you may need to correct the state prior to printing by using `MMU_RECOVER` command or perhaps homing the selector with `MMU_HOME`. Note that Happy Hare will automatically recover if it detects that state doesn't match that reported by sensors (one reason why optional sensors like extruder entry are useful). In addition, if you have a Type-A MMU with selector you can opt to automatically home on startup by setting `home_on_startup: 1` in `mmu_parameters.cfg`.

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

If you ever want to reset specific state the following commands are available:

`MMU_RESET` - Reset all persisted state back to default/unknown except for print stats and per-gate health stats<br>
`MMU_STATS RESET=1` - Reset print stats and per-gate health stats back to 0<br>
`MMU_TTG_MAP RESET=1` - Reset just the tool-to-gate mapping<br>
`MMU_ENDLESS_SPOOL RESET=1` - Reset just the endless spool groups back to default<br>
`MMU_GATE_MAP RESET=1` - Reset information about the filament type, color and availability<br>
`MMU_RECOVER` - Automatically discover or manually reset filament position, selected gate, selected tool, filament availability (lots of options)

Needless to say, other operations can update specific state

> [!NOTE]
> <ul>
>   <li>Closely relevant to the usefulness of this functionality is the `MMU_CHECK_GATE` command that will examine current, all or selection of gates for presence of filament</li>
>   <li>In the graphic depictions of filament state the `*` indicates presence ('B' and 'S' represent whether the filament is buffered or pulling straight from the spool), '?' unknown and ' ' or '.' the lack of filament</li>
>   <li>With tool-to-gate mapping it is entirely possible to have multiple tools mapped to the same gate (for example to force a multi-color print to be monotone) and therefore some gates can be made inaccessible until map is reset</li>
>   <li>The default value for `gate_status`, `tool_to_gate_map` and `endless_spool_groups` can be set in `mmu_parameters.cfg`.  If not set the default will be, Tx maps to Gate#x, the status of each gate is unknown and each tool is in its own endless spool group (i.e. not part of a group)</li>
> </ul>
