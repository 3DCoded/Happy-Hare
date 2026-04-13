## ![#f03c15](assets/f03c15.png) ![#c5f015](assets/c5f015.png) ![#1589F0](assets/1589F0.png) Macro Configuration (mmu_macro_vars.cfg)

This is where you'll likely spend most of your time tuning the MMU after the initial setup is done.  It allows for configuration of all the supplied default macros in one place.

You will need to consult the [Configuring mmu_macro_var.cfg](Configuring-mmu_macro_vars.cfg) reference page for full details, but essentially the file is broken up into sections where each section contains the configuration for the respective macro. These include:

| Section | Macro Filename | Description |
| ------- | -------------- | ----------- |
| _MMU_SOFTWARE_VARS | `base/mmu_software.cfg` | Controls the behavior of the print start and finalization |
| _MMU_STATE_VARS | `base/mmu_state.cfg` | Customization of behavior when state changes |
| _MMU_LED_VARS | `base/mmu_leds.cfg` | Configuration of LED actions |
| _MMU_SEQUENCE_VARS | `base/mmu_sequence.cfg` | Control the movement of the toolhead during a tool change |
| _MMU_CUT_TIP_VARS | `base/mmu_cut_tip.cfg` | Controls the tip cutting procedure |
| _MMU_FORM_TIP_VARS | `base/mmu_form_tip.cfg` | Control Happy Hare's implementation of tip forming |
| _MMU_CLIENT_VARS | `optional/client_macros.cfg` | Customization of Happy Hare's pause, resume and cancel_print macros |

<br>

### More essential config setup:
- [Hardware Configuration](Hardware-Configuration)
  - [Endstops, Movement and Homing](Movement-and-Homing)
- [Happy Hare Parameters](Happy-Hare-Parameters)
- Macro Configuration
