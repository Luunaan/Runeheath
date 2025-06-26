GLOBAL_LIST_INIT(all_aspects, build_aspect_list())

/datum/round_aspect
	/// If TRUE, players will be informed of this aspect BEFORE the round begins
	var/display_in_lobby = TRUE
	// If TRUE, players will be informed of this aspect when the round begins
	var/display_on_round_start = TRUE
	/// Name of the aspect.
	var/name = ""
	/// Description of the aspect, as seen in OOC environments. (eg. "Men are weaker, and women are stronger.")
	var/description = ""
	/// Description of the aspect seen by characters when the round begins, or when the aspect is applied.
	/// (eg. "There has been a lot of necromantic activity recently... Unattended dead have even begun to rise as undead by themselves!")
	var/round_start_text = ""
	/// Weight used for randomised aspect selection.
	var/weight = 0
	abstract_type = /datum/round_aspect

/// Called when this aspect is selected after the vote, random choice, or selection by admin.
/datum/round_aspect/proc/on_selection()
	if (display_in_lobby)
		to_chat(world, span_boldnotice(name))
		to_chat(world, span_notice(description))
	return

/// Called when the round first begins with this aspect active.
/datum/round_aspect/proc/on_round_start()
	if (display_on_round_start)
		to_chat(world, span_boldnotice(name))
		to_chat(world, span_notice(round_start_text))
	return

/// Called when the mob loads into the map.
/datum/round_aspect/proc/on_mob_spawn(mob/living/carbon/human/H, latejoin = FALSE)
	return

/// Called when the mob's job has been fully initialised.
/datum/round_aspect/proc/on_job_finalised(mob/living/carbon/human/H)
	return

/// Builds a list of all valid aspects.
/proc/build_aspect_list()
	var/list/aspects = list()
	for (var/path in subtypesof(/datum/round_aspect))
		if (is_abstract(path))
			continue
		aspects[path] = new path()
	return aspects
