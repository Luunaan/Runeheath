/mob/living/proc/telepathic_say()
	set name = "Telepathically Say"
	set desc = "Speak telepathically. Who is the recipient?"
	set category = "Race"

	if (!HAS_TRAIT(src, TRAIT_TELEPATH))
		to_chat(usr, "I'm not a telepath!")
		return

	if (isobserver(src))
		to_chat(usr, "I can't use telepathy now that I'm a spirit.")
		return

	var/char = input(src, "Whose mind do you seek?", "Telepathic Message", "")
	if (!char || length(char) == 0)
		return

	var/mob/target = null
	for (var/mob/player in GLOB.player_list)
		if (player.real_name == char || player.name == char)
			target = player
			break

	if (src == target)
		to_chat(src, "I can hear my own thoughts even without telepathy!")
		return

	// Figure out who the user is - iterate over all characters
	if (src.mind && !src.mind.do_i_know(target.mind, char))
		to_chat(usr, "I don't know anybody by that name.")
		return

	if (target)
		var/msg = input(src, "What is your message?", "Telepathic Message", "")
		if (msg && msg != "")
			do_telepathic_say(target, msg, TRUE)
	else
		to_chat(usr, "<font color='["#7851A9"]'><b><span class='message'>I fail to make a mental connection.</span></b></font>")

/mob/living/proc/do_telepathic_say(mob/target, msg as text, wp)
	if (GLOB.say_disabled)
		to_chat(usr, "<span class='danger'> Speech is currently admin-disabled.</span>")

	if(client.prefs.muted & MUTE_IC)
		to_chat(src, span_danger("I am muted."))
		return

	if (!target)
		return

	var/turf/T1 = get_turf(src)
	var/turf/T2 = get_turf(target)
	if (T1.Distance(T2) > 14)
		to_chat(usr, "<font color='["#7851A9"]'><b><span class='message'>I fail to make a mental connection.</span></b></font>")
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if (!msg)
		return
	
	to_chat(usr, "<font color='["#7851A9"]'><b><span class='prefix'>Your words enter <EM>[target.name]</EM>'s mind:</span></b> <span class='message'>[msg]</span></font>")
	if (HAS_TRAIT(target, TRAIT_TELEPATH))
		to_chat(target, "<font color='["#7851A9"]'><b><span class='prefix'>You hear [src.real_name]'s voice in your mind:</span></b> <span class='message'>[msg]</span></font>")
	else
		to_chat(target, "<font color='["#7851A9"]'><b><span class='prefix'>You hear a voice in your mind:</span></b> <span class='message'>[msg]</span></font>")
	
	src.log_talk(msg, LOG_TELEPATHY, "To [key_name(target)]", TRUE, null)
	log_seen(src, target, null, msg, SEEN_LOG_TELEPATHY)
