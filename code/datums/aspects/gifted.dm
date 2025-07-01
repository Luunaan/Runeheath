/datum/round_aspect/gifted
	name = "Gifted"
	description = "Each character's highest-ranked non-legendary skill becomes Legendary."
	round_start_text = "This place is legendary for its wide assortment of gifted people - it's the envy of the world."
	weight = 50

/datum/round_aspect/gifted/on_job_finalised(mob/living/carbon/human/H)
	if (H.mind == null)
		return

	// Make a list of the highest-ranked non-legendary skills on the target mob,
	// then choose one at random and make it legendary.
	// In future we might choose to make this a list.
	var/highest_non_legendary_level = 0
	var/list/datum/skill/highest_non_legendary_skill_paths = list()
	for (var/skill in H.skills?.known_skills)
		var/level = H.skills?.known_skills[skill]
		if (level > highest_non_legendary_level && level < SKILL_LEVEL_LEGENDARY)
			highest_non_legendary_level = level

	// Second pass - copy any skills at the given level into the candidate list.
	for (var/datum/skill/skill in H.skills?.known_skills)
		var/level = H.skills?.known_skills[skill]
		if (level == highest_non_legendary_level)
			highest_non_legendary_skill_paths += skill
	
	if (highest_non_legendary_level < SKILL_LEVEL_LEGENDARY)
		var/datum/skill/skill_to_raise = pick(highest_non_legendary_skill_paths)
		if (skill_to_raise)
			H.adjust_skillrank_up_to(skill_to_raise.type, SKILL_LEVEL_LEGENDARY, TRUE)
