/client/var/direct_message_timer_id = 0

/datum/keybinding/direct_message
	category = CATEGORY_CLIENT
	weight = WEIGHT_HIGHEST
	hotkey_keys = list("P")
	name = "Direct Message"
	full_name = "Direct message to player"
	description = "Direct message, visible only to the recipient"

/datum/keybinding/direct_message/down(client/user)
	user.direct_message()

/client/verb/direct_message(char as text)
	set name = "Direct Message"
	set desc = "Send a direct message. Who is the recipient?"
	set category = "OOC"

	var/mob/target = null
	// Figure out who the user is - iterate over all characters
	for (var/mob/player in GLOB.player_list)
		if (player.real_name == char || player.name == char)
			target = player
			break

	if (target)
		var/msg = input(src, "What is your message?", "Direct Message", "")
		if (msg && msg != "")
			send_direct_message(target, msg, TRUE)
	else
		to_chat(usr, "<font color='["#6699CC"]'><b><span class='message'>Player was not found.</span></b></font>")

/client/proc/send_direct_message(mob/target, msg as text, wp)
	if (GLOB.say_disabled)
		to_chat(usr, "<span class='danger'> Speech is currently admin-disabled.</span>")
	
	if (is_banned_from(ckey, "Direct Messages"))
		to_chat(src, "<span class='danger'>I cannot use Direct Messages (perma muted).</span>")
	
	if (!mob)
		return

	if (!target)
		return

	var/turf/T1 = get_turf(mob)
	var/turf/T2 = get_turf(target)
	if (T1.Distance(T2) > 10)
		to_chat(usr, "<font color='["#6699CC"]'><b><span class='message'>Player is too far away.</span></b></font>")
		return

	if (target == src.mob)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if (!msg)
		return

	if (!holder)
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			return

	verbs -= /client/verb/direct_message
	direct_message_timer_id = addtimer(CALLBACK(src, TYPE_PROC_REF(/client, return_direct_message_verb)), 1200, TIMER_STOPPABLE) //2 minute cooldown
	
	src.mob.log_talk(msg, LOG_DIRECT_MESSAGE, "To [key_name(target)]", TRUE, null)
	log_direct_message("[key_name(src)] sent a direct message to [key_name(target)]: [msg]")
	to_chat(usr, "<font color='["#6699CC"]'><b><span class='prefix'>Direct Message to</span> <EM>[target.name]:</EM> <span class='message'>[msg]</span></b></font>")
	to_chat(target, "<font color='["#6699CC"]'><b><span class='prefix'>Direct Message from</span> <EM>[src.mob.name]:</EM> <span class='message'>[msg]</span></b></font>")

/client/proc/return_direct_message_verb()
	verbs |= /client/verb/direct_message
	deltimer(direct_message_timer_id)
	direct_message_timer_id = 0
