// Magical mishaps
// Victim loses common, their default language, or a random language (in order of preference) for the duration
/atom/movable/screen/alert/status_effect/mishap_langloss
	name = "Forgotten Tongue"
	desc = "I can't remember how to speak in-- what was the language even called, again..?"
	icon_state = "mind_control"
	var/removed_language = null

/datum/status_effect/debuff/mishap_langloss
	id = "language_loss"
	duration = 5 MINUTES
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/mishap_langloss
	var/datum/language/removed_language

/datum/status_effect/debuff/mishap_langloss/on_apply()
	. = ..()
	var/datum/language_holder/holder = owner.mind?.language_holder
	if (holder)
		if (owner.has_language(/datum/language/common))
			// Always remove common, if the character has it
			removed_language = /datum/language/common
		else if (holder.selected_default_language != /datum/language/common)
			// Otherwise, remove their default language, if one is defined
			removed_language = holder.selected_default_language
		else
			// And if there's no default language, remove a random language
			removed_language = holder.get_random_understood_language()

		if (removed_language == /datum/language/aphasia)
			return

		// If we haven't selected a language by this point there's probably no language to select
		if (removed_language)
			owner.remove_language(removed_language)


/datum/status_effect/debuff/mishap_langloss/on_remove()
	..()
	if (removed_language)
		owner.grant_language(removed_language)


// Reduces intelligence by 20 (!!) and removes all languages except Aphasia for the duration.
/atom/movable/screen/alert/status_effect/mishap_feeblemind
	name = "Feebleminded"
	desc = "Wuh-- uh..."
	icon_state = "mind_control"

/datum/status_effect/debuff/mishap_feeblemind
	id = "feeblemind"
	duration = 7 MINUTES // This effect is really nasty but is deliberately one of the worst mishap effects, so it has a fairly long duration.
	status_type = STATUS_EFFECT_REFRESH
	// Won't necessarily force intelligence to 1, if we're really smart and have buffs
	effectedstats = list("intelligence" = -20, "speed" = -5)
	alert_type = /atom/movable/screen/alert/status_effect/mishap_feeblemind
	var/datum/language_holder/owner_language_holder
	var/datum/language_holder/old_languages

/datum/status_effect/debuff/mishap_feeblemind/on_apply()
	. = ..()
	owner_language_holder = owner.get_language_holder()
	old_languages = owner_language_holder.copy()
	owner_language_holder.remove_all_languages()
	owner.language_holder.grant_language(/datum/language/aphasia)
	ADD_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, id)

/datum/status_effect/debuff/mishap_feeblemind/tick()
	..()
	if (prob(5))
		owner.emote(pick("drools", "stares blankly"))

/datum/status_effect/debuff/mishap_feeblemind/on_remove()
	..()
	owner_language_holder.remove_language(/datum/language/aphasia)
	owner_language_holder.copy_known_languages_from(old_languages)
	REMOVE_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, id)

// Functions as Nimrod, but a bit worse, for the duration, and enforces simple speech.
/atom/movable/screen/alert/status_effect/mishap_dimwitted
	name = "Dim-witted"
	desc = "My thoughts are so slow..."
	icon_state = "mind_control"

/datum/status_effect/debuff/mishap_dimwitted
	id = "dimwitted"
	duration = 10 MINUTES
	status_type = STATUS_EFFECT_REFRESH
	effectedstats = list("intelligence" = -6, "speed" = -3) // 50% worse than the Nimrod special at the time of implementation (for 10 minutes)
	alert_type = /atom/movable/screen/alert/status_effect/mishap_dimwitted

/datum/status_effect/debuff/mishap_dimwitted/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SIMPLESPEECH, id)

/datum/status_effect/debuff/mishap_dimwitted/on_remove()
	..()
	REMOVE_TRAIT(owner, TRAIT_SIMPLESPEECH, id)

// Reduces some stats, applies a high overlay, increases slurring by 10 and keeps slurring at a minimum of 10.
/atom/movable/screen/alert/status_effect/mishap_arcane_high
	name = "Arcyne High"
	desc = ""
	icon_state = "high"

/datum/status_effect/debuff/mishap_arcane_high
	id = "arcane_high"
	duration = 5 MINUTES
	status_type = STATUS_EFFECT_REFRESH
	effectedstats = list("intelligence" = -4, "perception" = -4)
	alert_type = /atom/movable/screen/alert/status_effect/mishap_arcane_high

/datum/status_effect/debuff/mishap_arcane_high/on_apply()
	. = ..()
	owner.slurring += 10
	ADD_TRAIT(owner, TRAIT_DRUQK, id)
	owner.overlay_fullscreen("arcane_high", /atom/movable/screen/fullscreen/druqks)
	if (owner.client)
		SSdroning.area_entered(get_area(owner), owner.client)

/datum/status_effect/debuff/mishap_arcane_high/tick()
	..()
	owner.slurring = max(owner.slurring, 10)
	if (prob(5))
		owner.emote(pick("giggle", "drools", "grins", "fidgets", "twitch_s"))

/datum/status_effect/debuff/mishap_arcane_high/on_remove()
	..()
	owner.slurring = max(owner.slurring - 10, 0)
	REMOVE_TRAIT(owner, TRAIT_DRUQK, id)
	owner.clear_fullscreen("arcane_high")
	if (owner.client)
		SSdroning.play_area_sound(get_area(owner), owner.client)

// Increases drunkenness by 50. Prevents drunkenness from falling below 50.
/atom/movable/screen/alert/status_effect/mishap_arcane_drunkenness
	name = "Arcyne Drunkenness"
	desc = "I feel so drunk... But I haven't been drinking! Hah..."
	icon_state = "drunk"

/datum/status_effect/debuff/mishap_arcane_drunkenness
	id = "arcane_drunk"
	duration = 10 MINUTES // Drunkenness we add is forcibly removed on expiry
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/mishap_arcane_drunkenness
	var/mob/living/carbon/human/human_owner
	var/const/drunk_amount = 50

/datum/status_effect/debuff/mishap_arcane_drunkenness/on_apply()
	. = ..()
	if (ishuman(owner))
		human_owner = owner
		human_owner.drunkenness += drunk_amount

/datum/status_effect/debuff/mishap_arcane_drunkenness/tick()
	..()
	if (human_owner)
		human_owner.drunkenness = max(human_owner.drunkenness, drunk_amount)

/datum/status_effect/debuff/mishap_arcane_drunkenness/on_remove()
	..()
	if (human_owner)
		human_owner.drunkenness = max(human_owner.drunkenness - drunk_amount, 0)
		if (human_owner.drunkenness <= 0)
			human_owner.remove_status_effect(/datum/status_effect/buff/drunk)

// On application, each limb has a 50% chance of being paralyzed.
// At least one limb is guaranteed to be paralyzed.
/atom/movable/screen/alert/status_effect/mishap_arcane_paralysis
	name = "Arcyne Paralysis"
	desc = "I can't move parts of my body..."
	icon_state = "paralyze"

/datum/status_effect/debuff/mishap_arcane_paralysis
	id = "arcane_paralysis"
	duration = 2 MINUTES // Nasty effect, let's not have it last as long as the others.
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/mishap_arcane_paralysis
	var/list/traits_added = list()
	var/list/bodyparts_disabled = list()

/datum/status_effect/debuff/mishap_arcane_paralysis/on_apply()
	. = ..()
	var/limbs = rand(1, 15) // To be used as bits, NOT a meaningful integer value
	// This method ensures our limbs are chosen randomly,
	// that all limbs have a 50% chance of being paralyzed,
	// and at least one limb is guaranteed to be paralyzed
	if (limbs & 0x1)
		ADD_TRAIT(owner, TRAIT_PARALYSIS_L_ARM, id)
		traits_added.Add(TRAIT_PARALYSIS_L_ARM)
		bodyparts_disabled.Add(BODY_ZONE_L_ARM)
	if (limbs & 0x2)
		ADD_TRAIT(owner, TRAIT_PARALYSIS_R_ARM, id)
		traits_added.Add(TRAIT_PARALYSIS_R_ARM)
		bodyparts_disabled.Add(BODY_ZONE_R_ARM)
	if (limbs & 0x4)
		ADD_TRAIT(owner, TRAIT_PARALYSIS_L_LEG, id)
		traits_added.Add(TRAIT_PARALYSIS_L_LEG)
		bodyparts_disabled.Add(BODY_ZONE_L_LEG)
	if (limbs & 0x8)
		ADD_TRAIT(owner, TRAIT_PARALYSIS_R_LEG, id)
		traits_added.Add(TRAIT_PARALYSIS_R_LEG)
		bodyparts_disabled.Add(BODY_ZONE_R_LEG)

	for (var/bp in bodyparts_disabled)
		var/obj/item/bodypart/bodypart = owner.get_bodypart(bp)
		if (bodypart && bodypart.can_disable())
			bodypart.update_disabled()

/datum/status_effect/debuff/mishap_arcane_paralysis/on_remove()
	..()
	for (var/trait in traits_added)
		REMOVE_TRAIT(owner, trait, id)

	for (var/part in bodyparts_disabled)
		var/obj/item/bodypart/bodypart = owner.get_bodypart(part)
		if (bodypart && bodypart.can_disable() && bodypart.disabled == BODYPART_DISABLED_PARALYSIS)
			bodypart.update_disabled()

// Makes the victim blind... Obviously
/atom/movable/screen/alert/status_effect/mishap_blindness
	name = "Arcyne Blindness"
	desc = "Arcyne darkness clouds my eyes!"
	icon_state = "blind"

/datum/status_effect/debuff/mishap_blindness
	id = "arcane_blindness"
	duration = 2 MINUTES // Another nasty effect - victim will need to be led around until it expires.
	status_type = STATUS_EFFECT_REFRESH
	effectedstats = list("perception" = -100) // Blind, can't see
	alert_type = /atom/movable/screen/alert/status_effect/mishap_blindness
	var/const/blindness_amount = 20 // 20 should be plenty to keep the victim blind between tick()s

/datum/status_effect/debuff/mishap_blindness/on_apply()
	. = ..()
	owner.adjust_blindness(blindness_amount)

/datum/status_effect/debuff/mishap_blindness/tick()
	..()
	owner.set_blindness(max(owner.eye_blind, blindness_amount))

/datum/status_effect/debuff/mishap_blindness/on_remove()
	..()
	owner.adjust_blindness(-blindness_amount)

// Keep putting the user to sleep for the duration.
/atom/movable/screen/alert/status_effect/mishap_sleepy
	name = "Arcyne Sleep"
	desc = "I can't keep myself awake..."
	icon_state = "hypnosis"

/datum/status_effect/debuff/mishap_sleepy
	id = "arcane_sleep"
	duration = 15 SECONDS // Sleep amount is 60 seconds, so effectively ~75 seconds. User is completely incapacitated so this shouldn't be too long.
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/mishap_sleepy
	var/const/sleeping_amount = 60 SECONDS

/datum/status_effect/debuff/mishap_sleepy/on_apply()
	. = ..()
	owner.eyesclosed = TRUE
	for(var/atom/movable/screen/eye_intent/eyet in owner.hud_used.static_inventory)
		eyet.update_icon(owner)
	owner.become_blind("eyelids")
	owner.Sleeping(sleeping_amount)

/datum/status_effect/debuff/mishap_sleepy/tick()
	..()
	owner.Sleeping(sleeping_amount)

// Makes the victim confused for 5 minutes
/atom/movable/screen/alert/status_effect/mishap_confused
	name = "Arcyne Confusion"
	desc = "Where-- where am I..?"
	icon_state = "mind_control"

/datum/status_effect/debuff/mishap_confused
	id = "arcane_confusion"
	duration = 5 MINUTES
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/mishap_confused
	var/const/confusion_amount = 15

/datum/status_effect/debuff/mishap_confused/on_apply()
	. = ..()
	owner.confused += confusion_amount

/datum/status_effect/debuff/mishap_confused/tick()
	owner.confused = max(owner.confused, confusion_amount)
	if (prob(5))
		owner.emote(pick("babbles", "murmurs", "stares", "frowns"))
	..()

/datum/status_effect/debuff/mishap_confused/on_remove()
	owner.confused = max(owner.confused - confusion_amount, 0)
	..()
