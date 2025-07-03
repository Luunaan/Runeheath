/mob/living/proc/pheromonal_say()
	set name = "Pheromonally Say"
	set desc = "Communicate with pheromones, understood only by those with the same ability."
	set category = "Race"

	if (!HAS_TRAIT(src, TRAIT_PHEROMONE_COMMUNICATION))
		to_chat(src, "I can't emit pheromones!")
		return

	if(isobserver(src))
		to_chat(src, span_danger("I cannot emit pheromones without a physical body."))
		return

	var/msg = input(src, "What do you want to say?", "Pheromonal Message", "")
	if (msg)
		do_pheromonal_say(msg)

/mob/living/proc/do_pheromonal_say(msg as text)
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(client.prefs.muted & MUTE_IC)
		to_chat(src, span_danger("I am muted."))
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	var/list/mobs = list()
	for(var/mob/M in GLOB.player_list)
		if(!M.client)
			continue
		else if(isobserver(M))
			continue
		if(istype(usr,/mob/living))
			var/turf/speakturf = get_turf(M)
			var/turf/sourceturf = get_turf(usr)
			if(speakturf in get_hear(7, sourceturf))
				if (HAS_TRAIT(M, TRAIT_PHEROMONE_COMMUNICATION))
					to_chat(M, "<font color='["#997950"]'><b><span class='prefix'>[src.real_name]:</span></b> <span class='message'>[msg]</span></font>")
					mobs += M
				else if (HAS_TRAIT(M, TRAIT_GOOD_NOSE))
					to_chat(M, "<font color='["#997950"]'><b><span class='message'>[src.real_name]</b> emits a subtle, but seemingly meaningful, scent!</span></font>")
					mobs += M

	src.log_talk(msg, LOG_PHEROMONES, null, TRUE, null)
	log_seen(src, null, mobs, msg, SEEN_LOG_PHEROMONES)
