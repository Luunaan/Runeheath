/datum/reagent/lizardfolk_venom
	name = "Sissean Venom"
	description = ""
	reagent_state = LIQUID
	color = "#98fb98"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	harmful = TRUE
	addiction_threshold = 20
	var/const/max_drunkenness = 50

/datum/reagent/lizardfolk_venom/on_mob_life(mob/living/carbon/M)
	if (volume > 0.09)
		if (TRUE)
			if (current_cycle < 30)
				++current_cycle
				return
			M.adjust_drugginess(2)
			M.slurring += 2
			if(M.has_flaw(/datum/charflaw/addiction/junkie))
				M.sate_addiction()
			M.apply_status_effect(/datum/status_effect/buff/lizardfolk_venom)
	return ..()

/datum/reagent/lizardfolk_venom/addiction_act_stage1(mob/living/carbon/human/C)
	C.add_stress(/datum/stressevent/withdrawal_minor)
	if (prob(20))
		to_chat(C, span_danger("I feel the need for a Sissean's fangs..."))

/datum/reagent/lizardfolk_venom/addiction_act_stage2(mob/living/carbon/human/C)
	C.remove_stress(/datum/stressevent/withdrawal_minor)
	C.add_stress(/datum/stressevent/withdrawal_moderate)
	if (prob(20))
		to_chat(C, span_danger("I crave a Sissean's fangs..."))

/datum/reagent/lizardfolk_venom/addiction_act_stage3(mob/living/carbon/human/C)
	C.remove_stress(/datum/stressevent/withdrawal_moderate)
	C.add_stress(/datum/stressevent/withdrawal_severe)
	if (prob(20))
		to_chat(C, span_danger("I need it! Sissean venom, flowing through my body!"))

/datum/reagent/lizardfolk_venom/addiction_act_stage4(mob/living/carbon/human/C)
	C.remove_stress(/datum/stressevent/withdrawal_severe)
	C.add_stress(/datum/stressevent/withdrawal_critical)
	if (prob(20))
		to_chat(C, span_danger("I need a Sissean... Any Sissean! I can't live without their venom!"))
