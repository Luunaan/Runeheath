#define BASE_IMPREGNATION_CHANCE 25
#define KNOTTED_PENIS_IMPREGNATION_OFFSET 15
#define FERTILE_OFFSET 10

/datum/looping_sound/femhornylite
	mid_sounds = list('sound/vo/female/gen/se/horny1loop (1).ogg')
	mid_length = 470
	volume = 20
	extra_range = -4

/datum/looping_sound/femhornylitealt
	mid_sounds = list('sound/vo/female/gen/se/horny1loop (2).ogg')
	mid_length = 360
	volume = 20
	extra_range = -4

/datum/looping_sound/femhornymed
	mid_sounds = list('sound/vo/female/gen/se/horny2loop (1).ogg')
	mid_length = 420
	volume = 20
	extra_range = -4

/datum/looping_sound/femhornymedalt
	mid_sounds = list('sound/vo/female/gen/se/horny2loop (2).ogg')
	mid_length = 350
	volume = 20
	extra_range = -4

/datum/looping_sound/femhornyhvy
	mid_sounds = list('sound/vo/female/gen/se/horny3loop (1).ogg')
	mid_length = 440
	volume = 20
	extra_range = -4

/datum/looping_sound/femhornyhvyalt
	mid_sounds = list('sound/vo/female/gen/se/horny3loop (2).ogg')
	mid_length = 390
	volume = 20
	extra_range = -4

/mob/living
	var/can_do_sex = TRUE
	var/virginity = FALSE
	var/defiant = FALSE

/mob/living/carbon/human/MiddleMouseDrop_T(mob/living/target, mob/living/user)
	if(user.mmb_intent)
		return ..()
	if(!istype(target))
		return
	if(target != user)
		return
	if(!user.can_do_sex())
		to_chat(user, "<span class='warning'>I can't do this.</span>")
		return
	if(!target.client || !target.client.prefs || (target.client.prefs.sexable == FALSE)) // Don't bang someone that dosn't want it.
		to_chat(user, "<span class='warning'>[target] dosn't wish to be touched. (Their ERP preference under options)</span>")
		to_chat(target, "<span class='warning'>[user] failed to touch you. (Your ERP preference under options)</span>")
		return
	user.sexcon.start(src)

/mob/living/proc/can_do_sex()
	return TRUE

/mob/living/carbon/human/proc/make_sucking_noise()
	if(gender == FEMALE)
		playsound(src, pick('sound/misc/mat/girlmouth (1).ogg','sound/misc/mat/girlmouth (2).ogg'), 25, TRUE, ignore_walls = FALSE)
	else
		playsound(src, pick('sound/misc/mat/guymouth (1).ogg','sound/misc/mat/guymouth (2).ogg','sound/misc/mat/guymouth (3).ogg','sound/misc/mat/guymouth (4).ogg','sound/misc/mat/guymouth (5).ogg'), 35, TRUE, ignore_walls = FALSE)

/// Attempts to impregnate the given "wife". Returns TRUE if successful and FALSE otherwise.
/mob/living/carbon/human/proc/try_impregnate(mob/living/carbon/human/wife, prob_offset_percent = 0)
	var/obj/item/organ/testicles/testes = getorganslot(ORGAN_SLOT_TESTICLES)
	if(!testes)
		return FALSE
	var/obj/item/organ/vagina/vag = wife.getorganslot(ORGAN_SLOT_VAGINA)
	if(!vag)
		return FALSE
	var/impreg_chance = get_impregnation_chance(wife, prob_offset_percent)
	if(prob(impreg_chance) && wife.is_fertile() && is_virile())
		vag.be_impregnated(src)
		return TRUE
	return FALSE

/// Calculates the impregnation chance, as a percentage, of the given "wife".
/mob/living/carbon/human/proc/get_impregnation_chance(mob/living/carbon/human/wife, prob_offset_percent = 0)
	// Infertile partners never give birth. (In future we might add a trait that can override even this.)
	if (!is_virile())
		return 0
	if (!wife.is_fertile())
		return 0
	var/obj/item/organ/vagina/vag = wife.getorganslot(ORGAN_SLOT_VAGINA)
	if(!vag)
		return 0

	. = BASE_IMPREGNATION_CHANCE + prob_offset_percent

	var/obj/item/organ/penis/penis = getorganslot(ORGAN_SLOT_PENIS)
	if (penis && istype(penis, /obj/item/organ/penis/knotted))
		. += KNOTTED_PENIS_IMPREGNATION_OFFSET

	if (HAS_TRAIT(src, TRAIT_EXTREMELY_VIRILE))
		. += FERTILE_OFFSET * 3
	else if (HAS_TRAIT(src, TRAIT_VERY_VIRILE))
		. += FERTILE_OFFSET * 2
	else if (HAS_TRAIT(src, TRAIT_VIRILE))
		. += FERTILE_OFFSET
	else if (HAS_TRAIT(src, TRAIT_REDUCED_VIRILITY))
		. -= FERTILE_OFFSET

	if (HAS_TRAIT(wife, TRAIT_EXTREMELY_FERTILE))
		. += FERTILE_OFFSET * 3
	else if (HAS_TRAIT(wife, TRAIT_VERY_FERTILE))
		. += FERTILE_OFFSET * 2
	else if (HAS_TRAIT(wife, TRAIT_FERTILE))
		. += FERTILE_OFFSET
	else if (HAS_TRAIT(wife, TRAIT_REDUCED_FERTILITY))
		. -= FERTILE_OFFSET


/mob/living/carbon/human/proc/get_highest_grab_state_on(mob/living/carbon/human/victim)
	var/grabstate = null
	if(r_grab && r_grab.grabbed == victim)
		if(grabstate == null || r_grab.grab_state > grabstate)
			grabstate = r_grab.grab_state
	if(l_grab && l_grab.grabbed == victim)
		if(grabstate == null || l_grab.grab_state > grabstate)
			grabstate = l_grab.grab_state
	return grabstate

/proc/add_cum_floor(turfu)
	if(!turfu || !isturf(turfu))
		return
	new /obj/effect/decal/cleanable/coom(turfu)
