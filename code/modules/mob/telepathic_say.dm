/datum/keybinding/telepathic_say
	category = CATEGORY_CLIENT
	weight = WEIGHT_HIGHEST
	hotkey_keys = list("Y")
	name = "Telepathically Say"
	full_name = "Speak telepathically"
	description = "A telepathic message, heard only by the recipient."

/datum/keybinding/telepathic_say/down(client/user)
	user.telepathic_say()

/client/verb/telepathic_say(char as text)
	set name = "Telepathically Say"
	set desc = "Speak telepathically. Who is the recipient?"
	set category = "Race"

	if (!HAS_TRAIT(mob, TRAIT_TELEPATH))
		to_chat(usr, "I'm not a telepath!")
		return

	var/mob/target = null
	// Figure out who the user is - iterate over all characters
	if (src.mob?.mind && !src.mob.mind.do_i_know(char))
		to_chat(usr, "I don't know anybody by that name.")
		return

	for (var/mob/player in GLOB.player_list)
		if (player.real_name == char || player.name == char)
			target = player
			break

	if (target)
		var/msg = input(src, "What is your message?", "Telepathic Message", "")
		if (msg && msg != "")
			do_telepathic_say(target, msg, TRUE)
	else
		to_chat(usr, "<font color='["#7851A9"]'><b><span class='message'>I fail to make a mental connection.</span></b></font>")

/client/proc/do_telepathic_say(mob/target, msg as text, wp)
	if (GLOB.say_disabled)
		to_chat(usr, "<span class='danger'> Speech is currently admin-disabled.</span>")

	if(prefs.muted & MUTE_IC)
		to_chat(src, span_danger("I am muted."))
		return
	
	if (!mob)
		return

	if (!target)
		return

	var/turf/T1 = get_turf(mob)
	var/turf/T2 = get_turf(target)
	if (T1.Distance(T2) > 14)
		to_chat(usr, "<font color='["#7851A9"]'><b><span class='message'>I fail to make a mental connection.</span></b></font>")
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if (!msg)
		return
	
	to_chat(usr, "<font color='["#7851A9"]'><b><span class='prefix'>Your words enter <EM>[target.name]</EM>'s mind:</span></b> <span class='message'>[msg]</span></font>")
	if (HAS_TRAIT(target, TRAIT_TELEPATH))
		to_chat(target, "<font color='["#7851A9"]'><b><span class='prefix'>You hear [src.mob.name]'s voice in your mind:</span></b> <span class='message'>[msg]</span></font>")
	else
		to_chat(target, "<font color='["#7851A9"]'><b><span class='prefix'>You hear a voice in your mind:</span></b> <span class='message'>[msg]</span></font>")
	
	src.mob.log_talk(msg, LOG_TELEPATHY, "To [key_name(target)]", TRUE, null)
	log_seen(src.mob, target, null, msg, SEEN_LOG_TELEPATHY)
