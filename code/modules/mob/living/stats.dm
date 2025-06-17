	
#define STAT_STRENGTH "strength"
#define STAT_PERCEPTION "perception"
#define STAT_INTELLIGENCE "intelligence"
#define STAT_CONSTITUTION "constitution"
#define STAT_ENDURANCE "endurance"
#define STAT_SPEED "speed"
#define STAT_FORTUNE "fortune"

/mob/living
	var/STASTR = 10
	var/STAPER = 10
	var/STAINT = 10
	var/STACON = 10
	var/STAEND = 10
	var/STASPD = 10
	var/STALUC = 10
	//buffers, the 'true' amount of each stat
	var/BUFSTR = 0
	var/BUFPER = 0
	var/BUFINT = 0
	var/BUFCON = 0
	var/BUFEND = 0
	var/BUFSPE = 0
	var/BUFLUC = 0
	var/statbuf = FALSE
	var/list/statindex = list()
	var/datum/patron/patron = /datum/patron/godless
	var/obj/statdata/tempskill = new()

/mob/living/proc/init_faith()
	set_patron(/datum/patron/godless)

/mob/living/proc/set_patron(datum/patron/new_patron)
	if(!new_patron)
		return TRUE
	if(ispath(new_patron))
		new_patron = GLOB.patronlist[new_patron]
	if(!istype(new_patron))
		return TRUE
	if(istype(patron))
		patron.on_loss(src)
	patron = new_patron
	new_patron.on_gain(src)
	return TRUE

/datum/species
	// Associative list of stat (STAT_STRENGTH, etc) bonuses used to differentiate each race. They should ALWAYS be positive.
	var/list/race_bonus = list()
	var/construct = 0

/mob/living/proc/roll_stats()
	STASTR = 10
	STAPER = 10
	STAINT = 10
	STACON = 10
	STAEND = 10
	STASPD = 10
	STALUC = 10
	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		if (H.statpack)
			H.statpack.apply_to_human(H)
		if (H.dna?.species) // LETHALSTONE EDIT: apply our race bonus, if we have one
			var/datum/species/species = H.dna.species
			if (species.race_bonus)
				for (var/stat in species.race_bonus)
					var/amt = species.race_bonus[stat]
					H.change_stat(stat, amt)
		switch(H.age)
			if(AGE_MIDDLEAGED)
				change_stat("speed", -1)
				change_stat("endurance", 1)
			if(AGE_OLD)
				change_stat("strength", -1)
				change_stat("speed", -2)
				change_stat("perception", -1)
				change_stat("constitution", -2)
				change_stat("intelligence", 2)
		if(key)
			if(check_blacklist(ckey(key)))
				change_stat("strength", -5)
				change_stat("speed", -20)
				change_stat("endurance", -2)
				change_stat("constitution", -2)
				change_stat("intelligence", -20)
				change_stat("fortune", -20)
			if(check_psychokiller(ckey(key)))
				testing("foundpsych")
				H.eye_color = "ff0000"
				H.voice_color = "ff0000"

/mob/living/proc/change_stat(stat, amt, index)
	if(!stat)
		return
	if(amt == 0 && index)
		if(statindex[index])
			change_stat(statindex[index]["stat"], -1*statindex[index]["amt"])
			statindex[index] = null
		return
	if(!amt)
		return
	if(index)
		if(statindex[index])
			return //we cannot make a new index
		else
			statindex[index] = list("stat" = stat, "amt" = amt)
//			statindex[index]["stat"] = stat
//			statindex[index]["amt"] = amt

	switch(stat)
		if("strength")
			tempskill.modifystat(STASTR, BUFSTR, amt)
			STASTR = tempskill.value
			BUFSTR = tempskill.buffer

		if("perception")
			tempskill.modifystat(STAPER, BUFPER, amt)
			STAPER = tempskill.value
			BUFPER = tempskill.buffer
			update_fov_angles()

		if("intelligence")
			tempskill.modifystat(STAINT, BUFINT, amt)
			STAINT = tempskill.value
			BUFINT = tempskill.buffer

		if("constitution")
			tempskill.modifystat(STACON, BUFCON, amt)
			STACON = tempskill.value
			BUFCON = tempskill.buffer

		if("endurance")
			tempskill.modifystat(STAEND, BUFEND, amt)
			STAEND = tempskill.value
			BUFEND = tempskill.buffer

		if("speed")
			tempskill.modifystat(STASPD, BUFSPE, amt)
			STASPD = tempskill.value
			BUFSPE = tempskill.buffer
			update_move_intent_slowdown()

		if("fortune")
			tempskill.modifystat(STALUC, BUFLUC, amt)
			STALUC = tempskill.value
			BUFLUC = tempskill.buffer

/proc/generic_stat_comparison(userstat as num, targetstat as num)
	var/difference = userstat - targetstat
	if(difference > 1 || difference < -1)
		return difference * 10
	else
		return 0

/// Calculates a luck value in the range [1, 400] (calculated as STALUC^2), then maps the result linearly to the given range
/// min must be >= 0, max must be <= 100, and min must be <= max
/// For giving 
/mob/living/proc/get_scaled_sq_luck(min, max)
	if (min < 0)
		min = 0
	if (max > 100)
		max = 100
	if (min > max)
		var/temp = min
		min = max
		max = temp
	var/adjusted_luck = (src.STALUC * src.STALUC) / 400

	return LERP(min, max, adjusted_luck)

/mob/living/proc/badluck(multi = 3)
	if(STALUC < 10)
		return prob((10 - STALUC) * multi)

/mob/living/proc/goodluck(multi = 3)
	if(STALUC > 10)
		return prob((STALUC - 10) * multi)

/mob/living/proc/get_stat_level(stat_keys)
	switch(stat_keys)
		if(STATKEY_STR)
			return STASTR
		if(STATKEY_PER)
			return STAPER
		if(STATKEY_END)
			return STAEND
		if(STATKEY_CON)
			return STACON
		if(STATKEY_INT)
			return STAINT
		if(STATKEY_SPD)
			return STASPD
		if(STATKEY_LCK)
			return STALUC

/// Helper object to allow us to operate on stats without duplicating as much code
/obj/statdata
	var/value
	var/buffer

/// Modify a stat, with the given value and buffer, by the given amount
/obj/statdata/proc/modifystat(statvalue, statbuffer, amt)
	var/tempbuffer = statbuffer
	var/newamt = statvalue

	if (tempbuffer > 0 && amt < 0) // If the buffer is positive, it absorbs reductions until it's negative
		tempbuffer += amt
		if (tempbuffer < 0)
			newamt += tempbuffer // Add the excess back to the stat and reset the buffer
			tempbuffer = 0
	else if (tempbuffer < 0 && amt > 0) // Same with boosts if it's negative
		tempbuffer += amt
		if (tempbuffer > 0)
			newamt += tempbuffer
			tempbuffer = 0
	else // Otherwise, we don't need to worry about the buffer right away
		newamt += amt

	// Finally, if newamt over/underflows the limits, add the excess to the buffer for later
	if (newamt > 20)
		tempbuffer += newamt - 20
		newamt = 20
	else if (newamt < 1)
		// Need to subtract 1 from the amount since our minimum is 1, rather than 0
		tempbuffer += newamt - 1
		newamt = 1

	value = newamt
	buffer = tempbuffer


/// Helper for storing caches of stats at a given point in time
/datum/stat_set
	var/STASTR = 10
	var/STAPER = 10
	var/STAINT = 10
	var/STACON = 10
	var/STAEND = 10
	var/STASPD = 10
	var/STALUC = 10
	
	var/BUFSTR = 0
	var/BUFPER = 0
	var/BUFINT = 0
	var/BUFCON = 0
	var/BUFEND = 0
	var/BUFSPD = 0
	var/BUFLUC = 0

	var/obj/statdata/tempstat = new()

/// Creates a copy of stats and stat buffers from the given livingmob.
/// If remove_buffs is true, the stat effects of any buffs will be removed,
/// giving the original stat values; otherwise, gives the current effective stat values.
/datum/stat_set/proc/create_from(mob/living/L, remove_buffs = TRUE)
	STASTR = L.STASTR
	BUFSTR = L.BUFSTR

	STAPER = L.STAPER
	BUFPER = L.BUFPER

	STAINT = L.STAINT
	BUFINT = L.BUFINT

	STACON = L.STACON
	BUFCON = L.BUFCON

	STAEND = L.STAEND
	BUFEND = L.BUFEND

	STASPD = L.STASPD
	BUFSPD = L.BUFSPE

	STALUC = L.STALUC
	BUFLUC = L.BUFLUC

	if (remove_buffs)
		// Iterate over every status effect, and remove their effects
		for (var/datum/status_effect/effect in L.status_effects)
			for (var/affectedstat in effect.effectedstats)
				change_stat(affectedstat, -effect.effectedstats[affectedstat])

/// Modifies the given stat by the given amount
/datum/stat_set/proc/change_stat(stat, amount)
	if(!stat)
		return
	if(!amount)
		return

	switch(stat)
		if("strength")
			tempstat.modifystat(STASTR, BUFSTR, amount)
			STASTR = tempstat.value
			BUFSTR = tempstat.buffer
		if("perception")
			tempstat.modifystat(STAPER, BUFPER, amount)
			STAPER = tempstat.value
			BUFPER = tempstat.buffer
		if("intelligence")
			tempstat.modifystat(STAINT, BUFINT, amount)
			STAINT = tempstat.value
			BUFINT = tempstat.buffer
		if("constitution")
			tempstat.modifystat(STACON, BUFCON, amount)
			STACON = tempstat.value
			BUFCON = tempstat.buffer
		if("endurance")
			tempstat.modifystat(STAEND, BUFEND, amount)
			STAEND = tempstat.value
			BUFEND = tempstat.buffer
		if("speed")
			tempstat.modifystat(STASPD, BUFSPD, amount)
			STASPD = tempstat.value
			BUFSPD = tempstat.buffer
		if("fortune")
			tempstat.modifystat(STALUC, BUFLUC, amount)
			STALUC = tempstat.value
			BUFLUC = tempstat.buffer
