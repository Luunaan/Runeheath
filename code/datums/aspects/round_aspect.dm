/datum/round_aspect
	/// If TRUE, players will be informed of this aspect BEFORE the round begins
	var/display_in_lobby = FALSE
	/// Name of the aspect.
	var/name = "Aspect"
	/// Description of the aspect, as seen in OOC environments. (eg. "Men are weaker, and women are stronger.")
	var/description = "Aspect description"
	/// Description of the aspect seen by characters when the round begins, or when the aspect is applied.
	/// (eg. "There has been a lot of necromantic activity recently... Unattended dead have even begun to rise as undead by themselves!")
	var/start_or_apply_text = "Round start/aspect apply text"
	/// Weight used for randomised aspect selection.
	var/weight = 0

/datum/round_aspect/proc/on_selection()
	return

/datum/round_aspect/proc/on_round_start()
	return

/datum/round_aspect/proc/on_mob_spawn(mob/living/L)
	return
