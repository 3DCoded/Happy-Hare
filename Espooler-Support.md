#### Page Sections:
- [Hardware Config](#---hardware-config)
- [Software Config](#---software-config)
- [MMU_ESPOOLER Command](#---mmu-espooler-command)
- [Espooler UI](#---espooler-ui)

Happy Hare now can optionally drive a DC "espooler" for each gate. Typically this will be a DC20 (e.g. in the Box Turtle design). The primary value of this is to respool the filament when it unloads, however it can also be used to assist movement when loading or even relieve friction when printing.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Hardware Config
If you need to control an espooler, you will need to ensure that `mmu_hardware.cfg` and `mmu.cfg` are setup up correctly. On a fresh installation this should be added automatically but you can add manually if missing:


### `mmu_hardware.cfg`
Add this section to you `mmu_hardware.cfg` file. The commented lines can be left commented and are there to remind you of some advanced configuration options. Note that the choice of pwm/digital motor control, hardware/software pwm, scaling, etc are applied to all gates because the assumption is that configuration will be consistent. It is recommended that you leave the pin aliases and define the actual pins in the pins alias file `mmu.cfg`

```yml
# ESPOOLER (OPTIONAL) -------------------------------------------------------------------------------------------------
# ███████╗███████╗██████╗  ██████╗  ██████╗ ██╗     ███████╗██████╗
# ██╔════╝██╔════╝██╔══██╗██╔═══██╗██╔═══██╗██║     ██╔════╝██╔══██╗
# █████╗  ███████╗██████╔╝██║   ██║██║   ██║██║     █████╗  ██████╔╝
# ██╔══╝  ╚════██║██╔═══╝ ██║   ██║██║   ██║██║     ██╔══╝  ██╔══██╗
# ███████╗███████║██║     ╚██████╔╝╚██████╔╝███████╗███████╗██║  ██║
# ╚══════╝╚══════╝╚═╝      ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝
#
# An espooler controls DC motors (typically NC-20) that are able to rewind a filament spool and optionally provide
# forward assist to overcome spooler rotation friction. This should define pins for each of the gates on your mmu
# starting with '_0'. 
# An empty pin can be deleted, commented or simply left blank. If you mcu has a separate "enable" pin
#
[mmu_espooler mmu_espooler]
pwm: 1                                          # 1=PWM control (typical), 0=digital on/off control
#hardware_pwm: 0                                # See klipper doc
#cycle_time: 0.100                              # See klipper doc
scale: 1                                        # Scales the PWM output range
#value: 0                                       # See klipper doc
#shutdown_value: 0                              # See klipper doc

respool_motor_pin_0: mmu:MMU_ESPOOLER_RWD_0     # PWM (or digital) pin for rewind/respool movement
assist_motor_pin_0: mmu:MMU_ESPOOLER_FWD_0      # PWM (or digital) pin for forward motor movement
enable_motor_pin_0: mmu:MMU_ESPOOLER_EN_0       # Digital output for Afc mcu

respool_motor_pin_1: mmu:MMU_ESPOOLER_RWD_1
assist_motor_pin_1: mmu:MMU_ESPOOLER_FWD_1
enable_motor_pin_1: mmu:MMU_ESPOOLER_EN_1

respool_motor_pin_2: mmu:MMU_ESPOOLER_RWD_2
assist_motor_pin_2: mmu:MMU_ESPOOLER_FWD_2
enable_motor_pin_2: mmu:MMU_ESPOOLER_EN_2

respool_motor_pin_3: mmu:MMU_ESPOOLER_RWD_3
assist_motor_pin_3: mmu:MMU_ESPOOLER_FWD_3
enable_motor_pin_3: mmu:MMU_ESPOOLER_EN_3
```

### `mmu.cfg` (pin alias file):
Define your pins here. Typically you will either be using just the "_RWD" pins to implement respooling or both "_RWD" and "_FWD" if you have the ability to drive in a forward (extrude) direction. Optionally some MCUs require the setup of an enable pin (e.g. Afc Lite board)
```yml
    MMU_ESPOOLER_RWD_0=,
    MMU_ESPOOLER_FWD_0=,
    MMU_ESPOOLER_EN_0=,
    MMU_ESPOOLER_RWD_1=,
    MMU_ESPOOLER_FWD_1=,
    MMU_ESPOOLER_EN_1=,
    MMU_ESPOOLER_RWD_2=,
    MMU_ESPOOLER_FWD_2=,
    MMU_ESPOOLER_EN_2=,
    MMU_ESPOOLER_RWD_3=,
    MMU_ESPOOLER_FWD_3=,
    MMU_ESPOOLER_EN_3=,
```

> [!NOTE]  
> - If you were using the previous macro based respooler then you might need to remove the old pin aliases

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Software Config

The upgrade process should have added the following section to your `mmu_parameters.cfg`
```yml
# ESpooler control -----------------------------------------------------------------------------------------------------
# ███████╗███████╗██████╗  ██████╗  ██████╗ ██╗     ███████╗██████╗ 
# ██╔════╝██╔════╝██╔══██╗██╔═══██╗██╔═══██╗██║     ██╔════╝██╔══██╗
# █████╗  ███████╗██████╔╝██║   ██║██║   ██║██║     █████╗  ██████╔╝
# ██╔══╝  ╚════██║██╔═══╝ ██║   ██║██║   ██║██║     ██╔══╝  ██╔══██╗
# ███████╗███████║██║     ╚██████╔╝╚██████╔╝███████╗███████╗██║  ██║
# ╚══════╝╚══════╝╚═╝      ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝
#                                                                  
# If your MMU has a dc motor (ofter N20) controlled respooler/assist then how it operates can be controlled with these
# settings. Typically the espooler will be controlled with PWM signal. This will be at the maximum at speeds equal or
# above 'espooler.max_stepper_speed'. The PWM signal will scale downwards towards 0 for slower speeds. The falloff being
# controlled by the 'espooler_speed_exponent' setting according to this formula and allows for non-linear characteristics
# the DC motor (0.5 is a good starting value).
# 
#     espooler_pwm = {stepper_speed} / {max_stepper_speed}) ^ {speed_exponent}
#
# Regardless of h/w configuration you can enable/disable actions with the 'espooler_operations' list. E.g. remove 'play' to
# turn off operation while printing. Options are:
#
#    rewind - when filament is being unloaded under MMU control (aka respool)
#    assist - when filament is being loaded under MMU control
#    print  - while printing. Generally set 'espooler_printing_power' to a low percentage just to allow motor to be turned freely
#
# If using a digitally controlled espooler motor (not PWM) then you should turn off the "print" mode and set
# 'espooler_min_stepper_speed' to prevent "over movement"
#
espooler_min_distance: 30                       # Individual stepper movements less than this distance will not active espooler
espooler_max_stepper_speed: 300                 # Gear stepper speed at which espooler will be at maximum power
espooler_min_stepper_speed: 0                   # Gear stepper speed at which espooler will become inactive (useful for non PWM control)
espooler_speed_exponent: 0.5                    # Controls non-linear espooler power relative to stepper speed (see notes)
espooler_printing_power: 10                     # If >0, fixes the % of PWM power while printing.
espooler_operations: rewind, assist, print      # List of operational modes (allows disabling even if h/w is configured)
```

The supplied defaults are generally a good starting point. Note that unsed options are ignored so it is advised to leave them in place (upgrade will likely reinstall them anyway). For example, if you don't have "assist" motors configured in the hardware, the `espooler_operations` "assist" and "print" will be ignored -- this option is useful if you wanted to turn off the functionality even if the hardware is configured.

Most of the settings are self explanatory but a couple of worth further explanation:

#### `espooler_speed_exponent`
This adjusts the speed conversion ratio meaning the profile of how the DC motor speed is adjusted over the speed range of the MMU gear (filament drive) stepper.

For the following examples, let's assume `espooler_max_stepper_speed = 50`<br>
And remember actual eSpooler pwm speed values are between 0.0 (off) and 1.0 (full speed) inclusive

The formula looks like this:<br>
```yml
    ({stepper_speed} / {espooler_max_stepper_speed}) ^ {espooler_speed_exponent}
```
With `stepper_speed_exponent` of 1 would have a linear ratio:<br>
If I am running with a step speed of 50mm/s, the eSpooler would run at full speed (1.0)<br>
Calculated via (50/50)^1<br>
If I am running with a step speed of 25mm/s, the eSpooler would run at half speed (0.5)<br>
Calculated via (25/50)^1<br>

With `stepper_speed_exponent` of 0.2 would have a non-linear ratio:<br>
If I am running with a step speed of 50mm/s, the eSpooler would run at full speed (1.0)<br>
Calculated via (50/50)^0.2<br>
If I am running with a step speed of 25mm/s, the eSpooler would run at half speed (0.87)<br>
Calculated via (25/50)^0.2<br>

#### `espooler_min_stepper_speed`
This defines the stepper speed at which the espooler will start. It is generally most useful with digital controlled DC motors when you want to set a threshold below which the espooler doesn't run

### `espooler_printer_power`
This is a % of the maximum power (max pwm signal) that is applied to the espooler motor while printing. This should not be large enough to sping the spool but rather acts as "releasing the braking effort" so there is less strain pulling from the spool while printing. It is recommended that you exclude "print" from `espooler_operations` initially until you determine that it is causing too much of a braking effect.

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) MMU_ESPOOLER Command

The `MMU_ESPOOLER` command is idea for testing but may have uses elsewhere where you want direct control of the motors. Examples:
```yml
MMU_ESPOOLER GATE=0 OPERATION="rewind" POWER=50
```
This turns on the espooler in the rewind (retract) direction at 50% power/speed for gate 0.

```yml
MMU_ESPOOLER GATE=0 OPERATION="off"
```
This will turn off the epooler for gate 0

```yml
MMU_ESPOOLER GATE=2 OPERATION="print"
```
This will energise the gate 2 espooler ready for printing at the default configured power level.. perhaps useful when purging out of a print

```yml
MMU_ESPOOLER
```
Without options this will give a status of all espooler motors

> [!TIP]  
> - `MMU_ESPOOLER ALLOFF=1` will quickly turn off ALL espoolers

<br>

## ![#f03c15](resources/f03c15.png) ![#c5f015](resources/c5f015.png) ![#1589F0](resources/1589F0.png) Espooler UI

The Mainsail and Fluidd support will render the operation of the espooler motor in their UIs with an arrow on the spool.
<table>
  <tr>
    <td>
      <img src="Espooler-Support/rewind.png" alt='Respooling' width='20%'>
      Rewinding (respooling)
    </td>
    <td>
      <img src="Espooler-Support/assist.png" alt='Assist' width='20%'>
      Assisting
    </td>
  </tr>
</table>

Don't forget you can get a quick summary with this command without options:
```yml
MMU_ESPOOLER
0 : off     (0%)
1 : rewind  (50%)
2 : off     (0%)
3 : off     (0%)
```
