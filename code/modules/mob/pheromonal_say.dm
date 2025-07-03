/datum/keybinding/pheromonal_say
	category = CATEGORY_CLIENT
	weight = WEIGHT_HIGHEST
	hotkey_keys = list("Y")
	name = "LOOC"
	full_name = "LOOC Chat"
	description = "Local OOC Chat."

/datum/keybinding/pheromonal_say/down(client/user)
	user.get_pheromonal_say()
	return TRUE

/client/proc/get_pheromonal_say()
	var/msg = input(src, null, "looc \"text\"") as text|null
	do_pheromonal_say(msg)

/client/verb/pheromonal_say(msg as text)
	set name = "Pheromonally Say"
	set desc = "Communicate with pheromones, understood only by those with the same ability."
	set category = "Race"

	do_pheromonal_say(msg)

/client/proc/do_pheromonal_say(msg as text)
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(prefs.muted & MUTE_IC)
		to_chat(src, span_danger("I am muted."))
		return

	if(!mob)
		return

	if (!HAS_TRAIT(mob, TRAIT_PHEROMONE_COMMUNICATION))
		to_chat(src, "I can't emit pheromones!")
		return
	
	if(isobserver(mob))
		to_chat(src, span_danger("I cannot emit pheromones while dead."))
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
					to_chat(M, "<font color='["#997950"]'><b><span class='prefix'>[src.mob.real_name]:</span></font> <span class='message'>[msg]</span></b>")
					mobs += M
				else if (HAS_TRAIT(M, TRAIT_GOOD_NOSE))
					to_chat(M, "<font color='["#997950"]'><b><span class='message'>[src.mob.real_name] emits a subtle, but seemingly meaningful, scent!</span></b></font>")
					mobs += M

	src.mob.log_talk(msg, LOG_PHEROMONES, null, TRUE, null)
	log_seen(src.mob, null, mobs, msg, SEEN_LOG_PHEROMONES)
