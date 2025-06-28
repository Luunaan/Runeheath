//Stores several modifiers in a way that isn't cleared by changing species

/datum/physiology
	var/brute_mult = 1   	// damage multiplier for brute damage
	var/burn_mult = 1    	// damage multiplier for burn damage
	var/tox_mult = 1     	// damage multiplier for tox damage
	var/oxy_mult = 1     	// damage multiplier for oxy damage
	var/clone_mult = 1   	// damage multiplier for clone damage
	var/stamina_mult = 1 	// damage multiplier for stamina damage
	var/brain_mult = 1   	// damage multiplier for brain damage

	var/pressure_mult = 1	// damage multiplier for low or high pressure (stacks with brute_mod)
	var/heat_mult = 1    	// damage multiplier for heat (stacks with burn_mult)
	var/cold_mult = 1    	// damage multiplier for cold (stacks with burn_mult)

	var/global_damage_mult = 1 // damage multiplier for all sources

	var/siemens_coeff = 1 	// resistance to shocks

	var/stun_mult = 1      	// stun multiplier
	var/bleed_mult = 1     	// bleed multiplier
	var/pain_mult = 1		// pain multiplier
	var/datum/armor/armor 	// internal armor datum

	var/hunger_mult = 1		// hunger multiplier

	var/do_after_speed = 1 //Speed mod for do_after. Lower is better. If temporarily adjusting, please only modify using *= and /=, so you don't interrupt other calculations.

/datum/physiology/New()
	armor = new
