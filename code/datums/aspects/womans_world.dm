/datum/round_aspect/womans_world
	name = "Woman's World"
	description = "Female characters have slightly higher strength and constitution; male characters have slightly lower strength and constitution. These changes are inverted for dark elves."
	round_start_text = "Due to their superior strength and constitution, women dominate our world - much as men might wish otherwise..."
	weight = 10
	var/const/female_strength_mod = 1
	var/const/female_constitution_mod = 1
	var/const/male_strength_mod = -1
	var/const/male_constitution_mod = -1

/datum/round_aspect/womans_world/on_mob_spawn(mob/living/carbon/human/H, latejoin = FALSE)
	// Dark elves remain outliers in their gender dynamics - but now things are reversed
	if (isdarkelf(H))
		if (H.getorganslot(ORGAN_SLOT_VAGINA))
			H.change_stat(STATKEY_STR, male_strength_mod, "[name] [STATKEY_STR]")
			H.change_stat(STATKEY_CON, male_constitution_mod, "[name] [STATKEY_CON]")
		if (H.getorganslot(ORGAN_SLOT_PENIS))
			H.change_stat(STATKEY_STR, female_strength_mod, "[name] [STATKEY_STR]")
			H.change_stat(STATKEY_CON, female_constitution_mod, "[name] [STATKEY_CON]")
	else
		if (H.getorganslot(ORGAN_SLOT_VAGINA))
			H.change_stat(STATKEY_STR, female_strength_mod, "[name] [STATKEY_STR]")
			H.change_stat(STATKEY_CON, female_constitution_mod, "[name] [STATKEY_CON]")
		if (H.getorganslot(ORGAN_SLOT_PENIS))
			H.change_stat(STATKEY_STR, male_strength_mod, "[name] [STATKEY_STR]")
			H.change_stat(STATKEY_CON, male_constitution_mod, "[name] [STATKEY_CON]")
