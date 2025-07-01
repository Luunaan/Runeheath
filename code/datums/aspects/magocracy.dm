/datum/round_aspect/magocracy
	name = "Magocracy"
	description = "All nobles gain arcane skill and two random spells on round start; everyone who would normally start with arcane skill becomes a noble."
	round_start_text = "We are a magocracy - ruled by those blessed with magical aptitude..."
	weight = 25
	var/const/spells_per_noble = 2
	var/const/max_spell_level = 2
	var/list/valid_spells = list()

/datum/round_aspect/magocracy/on_selection()
	..()
	var/length = length(GLOB.learnable_spells)
	for (var/i=1; i<=length; ++i)
		var/obj/effect/proc_holder/spell/spell_item = GLOB.learnable_spells[i]
		if (spell_is_allowed(spell_item))
			valid_spells += spell_item

/datum/round_aspect/magocracy/on_job_finalised(mob/living/carbon/human/H)
	give_spells(H)

/datum/round_aspect/magocracy/proc/give_spells(mob/living/carbon/human/H)
	var/already_had_magic = FALSE
	var/is_noble = H.is_noble()

	if (H.get_skill_level(/datum/skill/magic/arcane) > 0)
		if (!HAS_TRAIT(H, TRAIT_NOBLE))
			ADD_TRAIT(H, TRAIT_NOBLE, name)
		already_had_magic = TRUE
	if (is_noble)
		H.adjust_skillrank(/datum/skill/magic/arcane, 2, TRUE)

	if (!already_had_magic && is_noble)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation) // All mages get this

		// If I ever come up with a way to do this which is fair and in-place, I will try to remember to replace this inefficient method
		var/list/choices = valid_spells.Copy()
		for (var/i = 0; i<spells_per_noble; ++i)
			var/path = pick_n_take(choices)
			if(H.mind)
				H.mind.AddSpell(new path)
	return

/datum/round_aspect/magocracy/proc/spell_is_allowed(obj/effect/proc_holder/spell/spell)
	if (spell::abstract_type == spell::type)
		return FALSE
	if (spell::type == /obj/effect/proc_holder/spell/self/learnspell)
		return FALSE
	if (spell::spell_tier > max_spell_level)
		return FALSE
	return TRUE
