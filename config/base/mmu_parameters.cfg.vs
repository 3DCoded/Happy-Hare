########################################################################################################################
# Happy Hare MMU Software
#
# EDIT THIS FILE BASED ON YOUR SETUP
#
# Copyright (C) 2022  moggieuk#6538 (discord) moggieuk@hotmail.com
# This file may be distributed under the terms of the GNU GPLv3 license.
#
# Goal: Main configuration parameters for the klipper module
#
# (\_/)
# ( *,*)
# (")_(") Happy Hare Ready
#
# Notes:
#   Macro configuration is specifed separately in 'mmu_macro_vars.cfg'.
#   Full details in https://github.com/moggieuk/Happy-Hare/tree/main/doc/configuration.md
#
[mmu]
happy_hare_version: {happy_hare_version}			# Don't mess, used for upgrade detection

# MMU Hardware Limits --------------------------------------------------------------------------------------------------
# ██╗     ██╗███╗   ███╗██╗████████╗███████╗
# ██║     ██║████╗ ████║██║╚══██╔══╝██╔════╝
# ██║     ██║██╔████╔██║██║   ██║   ███████╗
# ██║     ██║██║╚██╔╝██║██║   ██║   ╚════██║
# ███████╗██║██║ ╚═╝ ██║██║   ██║   ███████║
# ╚══════╝╚═╝╚═╝     ╚═╝╚═╝   ╚═╝   ╚══════╝
#
# Define the physical limits of your MMU. These setings will be respected regardless of individual speed settings.
#
gear_max_velocity: 300			# Never to be exceeded gear velocity regardless of specific parameters
gear_max_accel: 1500			# Never to be exceeded gear accelaration regardless of specific parameters


# Logging --------------------------------------------------------------------------------------------------------------
# ██╗      ██████╗  ██████╗  ██████╗ ██╗███╗   ██╗ ██████╗ 
# ██║     ██╔═══██╗██╔════╝ ██╔════╝ ██║████╗  ██║██╔════╝ 
# ██║     ██║   ██║██║  ███╗██║  ███╗██║██╔██╗ ██║██║  ███╗
# ██║     ██║   ██║██║   ██║██║   ██║██║██║╚██╗██║██║   ██║
# ███████╗╚██████╔╝╚██████╔╝╚██████╔╝██║██║ ╚████║╚██████╔╝
# ╚══════╝ ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
#
# log_level & logfile_level can be set to one of (0 = essential, 1 = info, 2 = debug, 3 = trace, 4 = stepper moves)
# Generally you can keep console logging to a minimal whilst still sending debug output to the mmu.log file
# Increasing the console log level is only really useful during initial setup to save having to constantly open the log file
# Note: that it is not recommended to keep logging at level greater that 2 (debug) if not debugging an issue because
# of the additional overhead
#
log_level: 1
log_file_level: 2			# Can also be set to -1 to disable log file completely
log_statistics: 1 			# 1 to log statistics on every toolchange (default), 0 to disable (but still recorded)
log_visual: 1				# 1 log visual representation of filament, 0 = disable
log_startup_status: 1			# Whether to log tool to gate status on startup, 1 = summary (default), 0 = disable


# Movement speeds ------------------------------------------------------------------------------------------------------
# ███████╗██████╗ ███████╗███████╗██████╗ ███████╗
# ██╔════╝██╔══██╗██╔════╝██╔════╝██╔══██╗██╔════╝
# ███████╗██████╔╝█████╗  █████╗  ██║  ██║███████╗
# ╚════██║██╔═══╝ ██╔══╝  ██╔══╝  ██║  ██║╚════██║
# ███████║██║     ███████╗███████╗██████╔╝███████║
# ╚══════╝╚═╝     ╚══════╝╚══════╝╚═════╝ ╚══════╝
#
# Long moves are faster than the small ones and used for the bulk of the bowden movement. Note that you can set two fast
# load speeds depending on whether MMU thinks it is pulling from the buffer or from the spool. It is often helpful to
# use a lower speed when pulling from the spool because more force is required to overcome friction and this prevents
# loosing steps. 100mm/s should be "quiet" with the NEMA14 motor but you can go lower for really low noise
#
# NOTE: Encoder cannot keep up much above 350mm/s so make sure 'bowden_apply_correction' is off at very high speeds!
#
gear_from_buffer_speed: 150		# mm/s Normal speed when loading filament. Conservative is 100mm/s, Max around 300mm/s
gear_from_buffer_accel: 400		# Normal accelaration when loading filament
gear_from_spool_speed: 80		# mm/s Use (lower) speed when loading for the first time (i.e. pulling from spool)
gear_from_spool_accel: 100		# Accelaration when loading from spool
#
gear_short_move_speed: 80		# mm/s Speed when making short moves (like incremental retracts with encoder)
gear_short_move_accel: 600		# Usually the same as gear_from_buffer_accel (for short movements)
gear_short_move_threshold: 70		# Move distance that controls application of 'short_move' speed/accel
gear_homing_speed: 50			# mm/s Speed of gear stepper only homing moves (e.g. homing to gate or extruder)

# Speeds of extruder movement. The 'sync' speeds will be used when gear and extruder steppers are moving in sync
#
extruder_load_speed: 16			# mm/s speed of load move inside extruder from homing position to meltzone
extruder_unload_speed: 16		# mm/s speed of unload moves inside of extruder (very initial move from meltzone is 50% of this)
extruder_sync_load_speed: 18		# mm/s speed of synchronized extruder load moves
extruder_sync_unload_speed: 18		# mm/s speed of synchronized extruder unload moves
extruder_homing_speed: 18		# mm/s speed of extruder only homing moves (e.g. to toolhead sensor)


# Gate loading/unloading -----------------------------------------------------------------------------------------------
#  ██████╗  █████╗ ████████╗███████╗    ██╗      ██████╗  █████╗ ██████╗ 
# ██╔════╝ ██╔══██╗╚══██╔══╝██╔════╝    ██║     ██╔═══██╗██╔══██╗██╔══██╗
# ██║  ███╗███████║   ██║   █████╗      ██║     ██║   ██║███████║██║  ██║
# ██║   ██║██╔══██║   ██║   ██╔══╝      ██║     ██║   ██║██╔══██║██║  ██║
# ╚██████╔╝██║  ██║   ██║   ███████╗    ███████╗╚██████╔╝██║  ██║██████╔╝
#  ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ 
#
# These setttings control the loading and unloading filament at the gate. The primary options are you use a endstop switch
# at the gate (ala TradRack) or an encoder (ERCF default).  You can even have both a gate sensor for loading/parking and
# still use the encoder for other move verification (see advanced 'gate_endstop_to_encoder' option).
# Note: the `encoder` method, due to the nature of its operation will overshoot a little. This is not a problem in practice
# because the overshoot will simply be compensated for in the subsequent fast bowden move.
#
# Possible gate_homing_endtop names:
#   encoder       - Detect filament position using movement of the encoder
#   mmu_gate      - Use gate endstop
#   mmu_gear      - Use individual per-gate endstop (type-B MMU's)
#   extruder      - Use extruder entry sensor (Only for some type-B designs, see [mmu_machine] require_bowden_move setting)
#
gate_homing_endstop: encoder		# Name of gate endstop, "encoder" forces use of encoder for parking
gate_homing_max: 70			# Maximum move distance to home to the gate (actual move distance for encoder parking)
gate_preload_homing_max: 70             # Maximum homing distance to the mmu_gear endstop (if MMU is fitted with one)
gate_unload_buffer: 50			# Amount to reduce the fast unload so that filament doesn't overshoot when parking
gate_parking_distance: 23 		# Parking postion in the gate (distance back from gate endstop/encoder point)
gate_endstop_to_encoder: 10		# Distance between gate endstop and encoder (IF both fitted. +ve if encoder after endstop)
gate_autoload: 1			# If pre-gate sensor fitted this controls the automatic loading of the gate
gate_final_eject_distance: 0		# Distance to eject filament on EJECT rather than UNLOAD


# Bowden tube loading/unloading ----------------------------------------------------------------------------------------
# ██████╗  ██████╗ ██╗    ██╗██████╗ ███████╗███╗   ██╗    ██╗      ██████╗  █████╗ ██████╗ 
# ██╔══██╗██╔═══██╗██║    ██║██╔══██╗██╔════╝████╗  ██║    ██║     ██╔═══██╗██╔══██╗██╔══██╗
# ██████╔╝██║   ██║██║ █╗ ██║██║  ██║█████╗  ██╔██╗ ██║    ██║     ██║   ██║███████║██║  ██║
# ██╔══██╗██║   ██║██║███╗██║██║  ██║██╔══╝  ██║╚██╗██║    ██║     ██║   ██║██╔══██║██║  ██║
# ██████╔╝╚██████╔╝╚███╔███╔╝██████╔╝███████╗██║ ╚████║    ███████╗╚██████╔╝██║  ██║██████╔╝
# ╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ 
#
# In addition to different bowden loading speeds for buffer and non-buffered filament it is possible to detect missed
# steps caused by "jerking" on a heavy spool. If bowden correction is enabled the driver with "believe" the encoder
# reading and make correction moves to bring the filament to within the 'bowden_allowable_load_delta' of the end of
# bowden position (this does require a reliable encoder and is not recommended for very high speed loading >350mm/s)
#
bowden_apply_correction: 0		# 1 to enable, 0 disabled. Requires Encoder
bowden_allowable_load_delta: 20.0	# How close in mm the correction moves will attempt to get to target. Requires Encoder

# This test verifies the filament is free of extruder before the fast bowden movement to reduce possibility of grinding filament
bowden_pre_unload_test: 1		# 1 to check for bowden movement before full pull (slower), 0 don't check (faster). Requires Encoder

# ADVANCED: If pre-unload test is enabled, this controls the detection of successful bowden pre-unload test and represents
# the fraction of allowable mismatch between actual movement and that seen by encoder. Setting to 50% tolerance usually
# works well. Increasing will make test more tolerent. Value of 100% essentially disables error detection
bowden_pre_unload_error_tolerance: 50


# Extruder homing -----------------------------------------------------------------------------------------------------
# ███████╗██╗  ██╗████████╗    ██╗  ██╗ ██████╗ ███╗   ███╗██╗███╗   ██╗ ██████╗ 
# ██╔════╝╚██╗██╔╝╚══██╔══╝    ██║  ██║██╔═══██╗████╗ ████║██║████╗  ██║██╔════╝ 
# █████╗   ╚███╔╝    ██║       ███████║██║   ██║██╔████╔██║██║██╔██╗ ██║██║  ███╗
# ██╔══╝   ██╔██╗    ██║       ██╔══██║██║   ██║██║╚██╔╝██║██║██║╚██╗██║██║   ██║
# ███████╗██╔╝ ██╗   ██║██╗    ██║  ██║╚██████╔╝██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝
# ╚══════╝╚═╝  ╚═╝   ╚═╝╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
#
# Happy Hare needs a reference "homing point" close to the extruder from which to accurately complete the loading of
# the toolhead. This homing operation takes place after the fast bowden load and it is anticipated that that load
# operation will leave the filament just shy of the homing point. If using a toolhead sensor this initial extruder
# homing is unecessary (but can be forced) because the homing will occur inside the extruder for the optimum in accuracy.
#
# In addition to an entry sensor "mmu_extruder" it is possbile for Happy Hare to "feel" for the extruder gear entry
# by colliding with it. Because this method is not completely deterministic you might find have to find the sweetspot
# for your setup by adjusting the TMC current reduction. Also, touch (stallguard) sensing is possible to configure but
# unfortunately doesn't work well with some external mcu's. Note that reduced current during collision detection can
# also prevent unecessary filament griding
#
# Possible homing_endtop names:
#   collision      - Detect the collision with the extruder gear by monitoring encoder movement (Requires encoder)
#                    Fast bowden load will move to the extruder gears
#   mmu_gear_touch - Use touch detection when the gear stepper hits the extruder (Requires stallguard)
#                    Fast bowden load will move to extruder_homing_buffer distance before extruder gear
#   extruder       - If you have a "filament entry" endstop configured (Requires 'extruder' endstop)
#                    Fast bowden load will move to extruder_homing_buffer distance before sensor
#   none           - Don't attempt to home. Only possibiliy if lacking all sensor options
#                    Fast bowden load will move to the extruder gears. Fine if using toolhead sensor
# Note: The homing_endstop will be ignored if a toolhead sensor is available unless `extruder_force_homing: 1`
#
extruder_homing_max: 80			# Maximum distance to advance in order to attempt to home the extruder
extruder_homing_endstop: collision	# Filament homing method/endstop name (fallback if toolhead sensor not available)
extruder_homing_buffer: 30		# Amount to reduce the fast bowden load so filament doesn't overshoot the extruder homing point
extruder_collision_homing_current: 30	# % gear_stepper current (10%-100%) to use when homing to extruder homing (100 to disable)

# In the absence of a toolhead sensor Happy Hare will automatically default to extruder entrance detection regardless
# of this setting, however if you have a toolhead sensor you can still force the additional (unecessary) step of
# initially homing to extruder entrance then home to the toolhead sensor
#
extruder_force_homing: 0


# Toolhead loading and unloading --------------------------------------------------------------------------------------
# ████████╗ ██████╗  ██████╗ ██╗     ██╗  ██╗███████╗ █████╗ ██████╗     ██╗      ██████╗  █████╗ ██████╗ 
# ╚══██╔══╝██╔═══██╗██╔═══██╗██║     ██║  ██║██╔════╝██╔══██╗██╔══██╗    ██║     ██╔═══██╗██╔══██╗██╔══██╗
#    ██║   ██║   ██║██║   ██║██║     ███████║█████╗  ███████║██║  ██║    ██║     ██║   ██║███████║██║  ██║
#    ██║   ██║   ██║██║   ██║██║     ██╔══██║██╔══╝  ██╔══██║██║  ██║    ██║     ██║   ██║██╔══██║██║  ██║
#    ██║   ╚██████╔╝╚██████╔╝███████╗██║  ██║███████╗██║  ██║██████╔╝    ███████╗╚██████╔╝██║  ██║██████╔╝
#    ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ 
#
# It is possible to define highly customized loading and unloading sequences, however, unless you have a specialized
# setup it is probably easier to opt for the built-in toolhead loading and unloading sequence which already offers a
# high degree of customization. If you need even more control then edit the _MMU_LOAD_SEQUENCE and _MMU_UNLOAD_SEQUENCE
# macros in mmu_sequence.cfg - but be careful!
#
# An MMU must have a known point at the end of the bowden from which it can precisely load the extruder. Generally this
# will either be the extruder extrance (which is controlled with settings above) or by homing to toolhead sensor. If
# you have toolhead sensor it is past the extruder gear and the driver needs to know the max distance (from end of
# bowden move) to attempt homing
#
toolhead_homing_max: 40			# Maximum distance to advance in order to attempt to home to defined homing endstop

# IMPORTANT: These next three settings are based on the physical dimensions of your toolhead
# Once a homing position is determined, Happy Hare needs to know the final move distance to the nozzle. There is only
# one correct value for your setup - use 'toolhead_ooze_reduction' (which corresponds to the residual filament left in
# your nozzle) to control excessive oozing on load. See doc for table of proposed values for common configurations.
#
# NOTE: If you have a toolhead sensor you can automate the calculation of these parameters! Read about the
# `MMU_CALIBRATE_TOOLHEAD` command (https://github.com/moggieuk/Happy-Hare/wiki/Blobing-and-Stringing)
#
toolhead_extruder_to_nozzle: 72		# Distance from extruder gears (entrance) to nozzle
toolhead_sensor_to_nozzle: 62		# Distance from toolhead sensor to nozzle (ignored if not fitted)
toolhead_entry_to_extruder: 8		# Distance from extruder "entry" sensor to extruder gears (ignored if not fitted)

# This setting represents how much residual filament is left behind in the nozzle when filament is removed, it is thus
# used to reduce the extruder loading length and prevent excessive blobing but also in the calculation of purge volume.
# Note that this value can also be measured with the `MMU_CALIBRATE_TOOLHEAD` procedure
#
toolhead_residual_filament: 0		# Reduction in extruder loading length because of residual filament left behind

# TUNING: Finally, this is the last resort tuning value to fix blobbing. It is expected that this value is NEAR ZERO as
# it represents a further reduction in extruder load length to fix blobbing. If using a wipetower and you experience blobs
# on it, increase this value (reduce the quantity of filament loaded). If you experience gaps, decrease this value. If gaps
# and already at 0 then perhaps the 'toolhead_extruder_to_nozzle' or 'toolhead_residual_filament' settings are incorrect.
# Similarly a value >+5mm also suggests the four settings above are not correct. Also see 'retract' setting in
# 'mmu_macro_vars.cfg' for final in-print ooze tuning.
#
toolhead_ooze_reduction: 0		# Reduction in extruder loading length to prevent ooze (represents filament remaining)

# Distance added to the extruder unload movement to ensure filament is free of extruder. This adds some degree of tolerance
# to slightly incorrect configuration or extruder slippage. However don't use as an excuse for incorrect toolhead settings
#
toolhead_unload_safety_margin: 10	# Extra movement saftey margin (default: 10mm)

# If not synchronizing gear and extruder and you experience a "false" clog detection immediately after the tool change
# it might be because of a long bowden and/or large internal diameter that causes slack in the filament. This optional
# move will tighten the filament after a load by % of current clog detection length. Gear stepper will run at 50% current
#
toolhead_post_load_tighten: 60		# % of clog detection length, 0 to disable. Ignored if 'sync_to_extruder: 1'

# ADVANCED: Controls the detection of successful extruder load/unload movement and represents the fraction of allowable
# mismatch between actual movement and that seen by encoder. Setting to 100% tolerance effectively turns off checking.
# Some designs of extruder have a short move distance that may not be picked up by encoder and cause false errors. This
# allows masking of those errors. However the error often indicates that your extruder load speed is too high or the
# friction is too high on the filament and in that case masking the error is not a good idea. Try reducing friction
# and lowering speed first!
#
toolhead_move_error_tolerance: 60


# Tip forming ---------------------------------------------------------------------------------------------------------
# ████████╗██╗██████╗     ███████╗ ██████╗ ██████╗ ███╗   ███╗██╗███╗   ██╗ ██████╗ 
# ╚══██╔══╝██║██╔══██╗    ██╔════╝██╔═══██╗██╔══██╗████╗ ████║██║████╗  ██║██╔════╝ 
#    ██║   ██║██████╔╝    █████╗  ██║   ██║██████╔╝██╔████╔██║██║██╔██╗ ██║██║  ███╗
#    ██║   ██║██╔═══╝     ██╔══╝  ██║   ██║██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██║   ██║
#    ██║   ██║██║         ██║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝
#    ╚═╝   ╚═╝╚═╝         ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
#
# Tip forming responsibity can be split between slicer (in-print) and standalone macro (not in-print) or forced to always
# be done by Happy Hare's standalone macro. Since you always need the option to form tips without the slicer so it is
# generally easier to completely turn off the slicer, force "standalone" tip forming and tune only in Happy Hare.
#
# When Happy Hare is asked to form a tip it will run the referenced macro. Two are reference examples are provided but
# you can implement your own:
#   _MMU_FORM_TIP .. default tip forming similar to popular slicers like Superslicer and Prusaslicer
#   _MMU_CUT_TIP  .. for Filametrix (ERCFv2) or similar style toolhead filament cutting system
#
# Often it is useful to increase the extruder current for the rapid movement to ensure high torque and no skipped steps
#
# If opting for slicer tip forming you MUST configure where the slicer leaves the filament in the extruder since
# there is no way to determine this. This can be ignored if all tip forming is performed by Happy Hare
#
force_form_tip_standalone: 1		 # 0 = Slicer in print else standalone, 1 = Always standalone tip forming (TURN SLICER OFF!)
form_tip_macro: _MMU_FORM_TIP            # Name of macro to call to perform the tip forming (or cutting) operation
extruder_form_tip_current: 100		 # % of extruder current (100%-150%) to use when forming tip (100 to disable)
slicer_tip_park_pos: 0			 # This specifies the position of filament in extruder after slicer completes tip forming


# Synchronized gear/extruder movement ----------------------------------------------------------------------------------
# ███╗   ███╗ ██████╗ ████████╗ ██████╗ ██████╗     ███████╗██╗   ██╗███╗   ██╗ ██████╗
# ████╗ ████║██╔═══██╗╚══██╔══╝██╔═══██╗██╔══██╗    ██╔════╝╚██╗ ██╔╝████╗  ██║██╔════╝
# ██╔████╔██║██║   ██║   ██║   ██║   ██║██████╔╝    ███████╗ ╚████╔╝ ██╔██╗ ██║██║     
# ██║╚██╔╝██║██║   ██║   ██║   ██║   ██║██╔══██╗    ╚════██║  ╚██╔╝  ██║╚██╗██║██║     
# ██║ ╚═╝ ██║╚██████╔╝   ██║   ╚██████╔╝██║  ██║    ███████║   ██║   ██║ ╚████║╚██████╗
# ╚═╝     ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚═╝  ╚═╝    ╚══════╝   ╚═╝   ╚═╝  ╚═══╝ ╚═════╝
#
# This controls whether the extruder and gear steppers are synchronized during printing operations
# If you normally run with maxed out gear stepper current consider reducing it with 'sync_gear_current'
# If equipped with TMC drivers the current of the gear and extruder motors can be controlled to optimize performance.
# This can be useful to control gear stepper temperature when printing with synchronized motor
#
sync_gear_current: 70			# % of gear_stepper current (10%-100%) to use when syncing with extruder during print

# Optionally it is possible to leverage feedback for a "compression/expansion" sensor in the bowden path from MMU to
# extruder to ensure that the two motors are kept in sync as viewed by the filament (the signal feedback state can be
# binary supplied by one or two switches: -1 (expanded) and 1 (compressed) of proportional value between -1.0 and 1.0
# Requires [mmu_sensors] setting
#
sync_feedback_enable: 0			# 0 = Turn off (even with fitted sensor), 1 = Turn on
sync_multiplier_high: 1.05		# Maximum factor to apply to gear stepper 'rotation_distance'
sync_multipler_low: 0.95		# Minimum factor to apply


# Filament Management Options ----------------------------------------------------------------------------------------
# ███████╗██╗██╗            ███╗   ███╗ ██████╗ ███╗   ███╗████████╗
# ██╔════╝██║██║            ████╗ ████║██╔════╝ ████╗ ████║╚══██╔══╝
# █████╗  ██║██║            ██╔████╔██║██║  ███╗██╔████╔██║   ██║   
# ██╔══╝  ██║██║            ██║╚██╔╝██║██║   ██║██║╚██╔╝██║   ██║   
# ██║     ██║███████╗██╗    ██║ ╚═╝ ██║╚██████╔╝██║ ╚═╝ ██║   ██║   
# ╚═╝     ╚═╝╚══════╝╚═╝    ╚═╝     ╚═╝ ╚═════╝ ╚═╝     ╚═╝   ╚═╝   
#
# - Clog detection is available when encoder is fitted and it can detect when filament is not moving and pause the print
# - EndlessSpool feature allows detection of runout on one spool and the automatic mapping of tool to an alternative
#   gate (spool). Set to '1', this feature requires clog detection or gate sensor or pre-gate sensors. EndlessSpool
#   functionality can optionally be extended to attempt to load an empty gate with 'endless_spool_on_load'. On some MMU
#   designs (with linear selector) it can also be configured to eject filament remains to a designated gate rather than
#   defaulting to current gate. A custom gate will disable pre-gate runout detection for EndlessSpool because filament
#   end must completely pass through the gate for selector to move
#
enable_clog_detection: 2		# 0 = disable, 1 = static length clog detection, 2 = automatic length clog detection
enable_endless_spool: 1			# 0 = disable, 1 = enable endless spool
endless_spool_on_load: 0		# 0 = don't apply endless spool on load, 1 = run endless spool if gate is empty
endless_spool_eject_gate: -1		# Which gate to eject the filament remains. -1 = current gate
#endless_spool_groups:			# Default EndlessSpool groups (see later in file)
#
# Spoolman support requires you to correctly enable spoolman with moonraker first. If enabled, the gate SpoolId will
# be used to load filament details and color from the spoolman database and Happy Hare will activate/deactivate
# spools as they are used. The enabled variation allows for either the local map or the spoolman map to be the
# source of truth as well as just fetching filament attributes. See this table for explanation:
#
#                    | Activate/  | Fetch filament attributes | Filament gate    | Filament gate     |
#   spoolman_support | Deactivate | attributes from spoolman  | assignment shown | assignment pulled |
#                    | spool?     | based on spool_id?        | in spoolman db?  | from spoolman db? |
#   -----------------+------------+---------------------------+------------------+-------------------+
#        off         |     no     |           no              |        no        |        no         |
#        readonly    |     yes    |           yes             |        no        |        no         |
#        push        |     yes    |           yes             |        yes       |        no         |
#        pull        |     yes    |           yes             |        yes       |        yes        |
#
spoolman_support: off			# off = disabled, readonly = enabled, push = local gate map, pull = remote gate map
pending_spool_id_timeout: 20            # Seconds after which this pending spool_id (set with rfid) is voided
#
# Mainsail/Fluid UI can visualize the color of filaments next to the extruder/tool chooser. The color is dynamic and
# can be customized to your choice:
#
#    slicer   - Color from slicer tool map (what the slicer expects)
#    allgates - Color from all the tools in the gate map after running through the TTG map
#    gatemap  - As per gatemap but hide empty tools
#
# Note: Happy Hare will also add the 'spool_id' variable to the Tx macro if spoolman is enabled
#
t_macro_color: slicer			# 'slicer' = default | 'allgates' = mmu | 'gatemap' = mmu without empty gates


# Print Statistics ---------------------------------------------------------------------------------------------------
# ███████╗████████╗ █████╗ ████████╗███████╗
# ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██╔════╝
# ███████╗   ██║   ███████║   ██║   ███████╗
# ╚════██║   ██║   ██╔══██║   ██║   ╚════██║
# ███████║   ██║   ██║  ██║   ██║   ███████║
# ╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚══════╝
#
# These parameters determine how print statistic data is shown in the console. This table can show a lot of data,
# probably more than you'd want to see. Below you can enable/disable options to your needs.
#
# +-----------+---------------------+----------------------+----------+
# |  114(46)  |      unloading      |       loading        | complete |
# |   swaps   | pre  |   -   | post | pre  |   -   | post  |   swap   |
# +-----------+------+-------+------+------+-------+-------+----------+
# | all time  | 0:07 | 47:19 | 0:00 | 0:01 | 37:11 | 33:39 |  2:00:38 |
# |     - avg | 0:00 |  0:24 | 0:00 | 0:00 |  0:19 |  0:17 |     1:03 |
# | this job  | 0:00 | 10:27 | 0:00 | 0:00 |  8:29 |  8:30 |    28:02 |
# |     - avg | 0:00 |  0:13 | 0:00 | 0:00 |  0:11 |  0:11 |     0:36 |
# |      last | 0:00 |  0:12 | 0:00 | 0:00 |  0:10 |  0:14 |     0:39 |
# +-----------+------+-------+------+------+-------+-------+----------+
#             Note: Only formats correctly on Python3
#
# Comma separated list of desired columns
# Options: pre_unload, unload, post_unload, pre_load, load, post_load, total
console_stat_columns: unload, load, post_load, total

# Comma seperated list of rows. The order determines the order in which they're shown.
# Options: total, total_average, job, job_average, last
console_stat_rows: total, total_average, job, job_average, last

# How you'd want to see the state of the gates and how they're performing
#   string     - poor, good, perfect, etc..
#   percentage - rate of success
#   emoticon   - fun sad to happy faces (python3 only)
console_gate_stat: emoticon

# Always display the full statistics table
console_always_output_full: 1	# 1 = Show full table, 0 = Only show totals out of print


# Miscellaneous, but you should review -------------------------------------------------------------------------------
# ███╗   ███╗██╗███████╗ ██████╗
# ████╗ ████║██║██╔════╝██╔════╝
# ██╔████╔██║██║███████╗██║     
# ██║╚██╔╝██║██║╚════██║██║     
# ██║ ╚═╝ ██║██║███████║╚██████╗
# ╚═╝     ╚═╝╚═╝╚══════╝ ╚═════╝
#
# Important you verify these work for you setup/workflow. Temperature and timeouts
#
timeout_pause: 72000		# Idle time out (printer shutsdown) in seconds used when in MMU pause state
disable_heater: 600		# Delay in seconds after which the hotend heater is disabled in the MMU_PAUSE state
default_extruder_temp: 200	# Default temperature for performing swaps and forming tips when not in print (overriden by gate map)
extruder_temp_variance: 2	# When waiting for extruder temperature this is the +/- permissible variance in degrees (>= 1)
#
# These are auto calibration/tuning settings. Once the gear rotation_distance and encoder are calibrated, enabling these options
# will lessen the initial calibration and will automatically tune bowden length and individual gate rotation_distance differences.
# Note: What can be tuned is based on "variable_rotation_distance" and "variable_bowden_lengths" settings in mmu_hardware.cfg
#       E.g. with fixed bowden and multiple BMG gears and encoder like the ERCF, the bowden length is tuned on gate#0 and
#            rotation_distance (MMU_CALIBRATE_GATE) is tuned for other gates.
#
autotune_bowden_length: 0       # Automated bowden length calibration/tuning. 1=automatic, 0=manual/off
autotune_rotation_distance: 0   # Automated gate calibration/tuning (requires encoder). 1=automatic, 0=manual/off
#
# Other workflow options
#
startup_home_if_unloaded: 0	# 1 = force homing of MMU on startup if unloaded, 0 = do nothing
startup_reset_ttg_map: 0	# 1 = reset TTG map on startup, 0 = do nothing
show_error_dialog: 0		# 1 = show pop-up dialog in addition to console message, 0 = show error in console
strict_filament_recovery: 0	# If enabled with MMU with toolhead sensor, this will cause filament position recovery to
				# perform extra moves to look for filament trapped in the space after extruder but before sensor
filament_recovery_on_pause: 1	# 1 = Run a quick check to determine current filament position on pause/error, 0 = disable
retry_tool_change_on_error: 0	# Whether to automatically retry a failed tool change. If enabled Happy Hare will perform
				# the equivalent of 'MMU_RECOVER' + 'Tx' commands which usually is all that is necessary
				# to recover. Note that enabling this can mask problems with your MMU
bypass_autoload: 1		# If entruder sensor fitted this controls the automatic loading of extruder for bypass operation
#
# Advanced options. Don't mess unless you fully understand. Read documentation.
#
encoder_move_validation: 1	# ADVANCED: 1 = Normally Encoder validates move distances are within given tolerance
				#           0 = Validation is disabled (eliminates slight pause between moves but less safe)
print_start_detection: 1	# ADVANCED: Enabled for Happy Hare to automatically detect start and end of print and call
				# ADVANCED: MMU_START_PRINT and MMU_END_PRINT automatically. Harmles to leave enabled but can disable
                                #           if you think it is causing problems and known START/END is covered in your macros
extruder: extruder		# ADVANCED: Name of the toolhead extruder that MMU is using
gcode_load_sequence: 0		# VERY ADVANCED: Gcode loading sequence 1=enabled, 0=internal logic (default)
gcode_unload_sequence: 0	# VERY ADVANCED: Gcode unloading sequence, 1=enabled, 0=internal logic (default)
homing_extruder: 1		# CAUTION: Normally this should be 1. 0 will disable the homing extruder capability


# ADVANCED: Klipper tuning -------------------------------------------------------------------------------------------
# ██╗  ██╗██╗     ██╗██████╗ ██████╗ ███████╗██████╗ 
# ██║ ██╔╝██║     ██║██╔══██╗██╔══██╗██╔════╝██╔══██╗
# █████╔╝ ██║     ██║██████╔╝██████╔╝█████╗  ██████╔╝
# ██╔═██╗ ██║     ██║██╔═══╝ ██╔═══╝ ██╔══╝  ██╔══██╗
# ██║  ██╗███████╗██║██║     ██║     ███████╗██║  ██║
# ╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝     ╚══════╝╚═╝  ╚═╝
#
# Timer too close is a catch all error, however it has been found to occur on some systems during homing and probing
# operations especially so with CANbus connected mcus. Happy Hare uses many homing moves for reliable extruder loading
# and unloading and enabling this option affords klipper more tolerance and avoids this dreaded error
#
update_trsync: 0		# 1 = Increase TRSYNC_TIMEOUT, 0 = Leave the klipper default
#
# Some CANbus boards are prone to this but it have been seen on regular USB boards where a comms timeout will kill
# the print. Since it seems to occur only on homing moves they can be safely retried to workaround. This has been
# working well in practice
canbus_comms_retries: 3		# Number of retries. Recommend the default of 3.
#
# Older neopixels have very finiky timing and can generate lots of "Unable to obtain 'neopixel_result' response"
# errors in klippy.log. An often cited workaround is to increase BIT_MAX_TIME in neopixel.py. This option does that
# automatically for you to save dirtying klipper
update_bit_max_time: 1		# 1 = Increase BIT_MAX_TIME, 0 = Leave the klipper default


# ADVANCED: MMU macro overrides --- ONLY SET IF YOU'RE COMFORTABLE WITH KLIPPER MACROS -------------------------------
# ███╗   ███╗ █████╗  ██████╗██████╗  ██████╗ ███████╗
# ████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔════╝
# ██╔████╔██║███████║██║     ██████╔╝██║   ██║███████╗
# ██║╚██╔╝██║██╔══██║██║     ██╔══██╗██║   ██║╚════██║
# ██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║╚██████╔╝███████║
# ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
#
# 'pause_macro' defines what macro to call on MMU error (must put printer in paused state)
# Other macros are detailed in 'mmu_sequence.cfg'
# Also see form_tip_macro in Tip Forming section
#
pause_macro: PAUSE 					# What macro to call to pause the print
action_changed_macro: _MMU_ACTION_CHANGED		# Called when action (printer.mmu.action) changes
print_state_changed_macro: _MMU_PRINT_STATE_CHANGED	# Called when print state (printer.mmu.print_state) changes
mmu_event_macro: _MMU_EVENT				# Called on useful MMU events
pre_unload_macro: _MMU_PRE_UNLOAD			# Called before starting the unload
post_form_tip_macro: _MMU_POST_FORM_TIP			# Called immediately after tip forming
post_unload_macro: _MMU_POST_UNLOAD			# Called after unload completes
pre_load_macro: _MMU_PRE_LOAD				# Called before starting the load
post_load_macro: _MMU_POST_LOAD				# Called after the load is complete
unload_sequence_macro: _MMU_UNLOAD_SEQUENCE		# VERY ADVANCED: Optionally called based on 'gcode_unload_sequence'
load_sequence_macro: _MMU_LOAD_SEQUENCE			# VERY ADVANCED: Optionally called based on 'gcode_load_sequence'
espooler_start_macro: ''				# Called to start eSpooler if fitted (params: GATE, STEP_SPEED, MAX_DISTANCE, HOMING)
espooler_stop_macro: ''					# Called to stop eSpooler if fitted (params: GATE, DISTANCE)


# ADVANCED: See documentation for use of these -----------------------------------------------------------------------
# ██████╗ ███████╗███████╗███████╗████████╗    ██████╗ ███████╗███████╗███████╗
# ██╔══██╗██╔════╝██╔════╝██╔════╝╚══██╔══╝    ██╔══██╗██╔════╝██╔════╝██╔════╝
# ██████╔╝█████╗  ███████╗█████╗     ██║       ██║  ██║█████╗  █████╗  ███████╗
# ██╔══██╗██╔══╝  ╚════██║██╔══╝     ██║       ██║  ██║██╔══╝  ██╔══╝  ╚════██║
# ██║  ██║███████╗███████║███████╗   ██║       ██████╔╝███████╗██║     ███████║
# ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝   ╚═╝       ╚═════╝ ╚══════╝╚═╝     ╚══════╝
#
# Examples...
# Gate:                #0      #1      #2      #3      #4      #5      #6      #7      #8
#gate_status:          1,      0,      1,      2,      2,     -1,     -1,      0,      1
#gate_filament_name:   one,    two,    three,  four,   five,   six,    seven,  eight,  nine
#gate_material:        PLA,    ABS,    ABS,    ABS+,   PLA,    PLA,    PETG,   TPU,    ABS
#gate_color:           red,    black,  yellow, green,  blue,   indigo, ffffff, grey,   black
#gate_temperature:     210,    240,    235,    245,    210,    200,    215,    240,    240
#gate_spool_id:        3,      2,      1,      4,      5,      6,      7,      -1,     9
#gate_speed_override:  100,    100,    100,    100,    100,    100,    100,    50,     100
#endless_spool_groups: 0,      1,      2,      1,      0,      0,      3,      4,      1
#
# Tool:                T0      T1      T2      T3      T4      T5      T6      T7      T8
#tool_to_gate_map:     0,      1,      2,      3,      4,      5,      6,      7,      8