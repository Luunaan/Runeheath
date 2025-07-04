/mob/dead/observer/check_emote(message, forced)
	if(message == "*spin" || message == "*flip")
		emote(copytext(message, 2), intentional = !forced)
		return 1

/mob/dead/observer/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
	if (!message)
		return

	var/message_mode = get_message_mode(message)
	if(client && (message_mode == MODE_ADMIN || message_mode == MODE_DEADMIN))
		message = copytext(message, 3)
		if(findtext(message, " ", 1, 2))
			message = copytext(message, 2)

		if(message_mode == MODE_ADMIN)
			client.cmd_admin_say(message)
		else if(message_mode == MODE_DEADMIN)
			client.dsay(message)
		return

	if(check_emote(message, forced))
		return

	. = say_dead(message)

/mob/dead/observer/rogue/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	return

/mob/dead/observer/rogue/say_dead(message)
	return

/mob/dead/observer/screye/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	return

/mob/dead/observer/screye/say_dead(message)
	return

/*
/mob/dead/observer/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	. = ..()
	var/atom/movable/to_follow = speaker
	if(radio_freq)
		var/atom/movable/virtualspeaker/V = speaker

		if(isAI(V.source))
			var/mob/living/silicon/ai/S = V.source
			to_follow = S.eyeobj
		else
			to_follow = V.source
	var/link = FOLLOW_LINK(src, to_follow)
// Create map text prior to modifying message for goonchat
	if (client?.prefs.chat_on_map && (client.prefs.see_chat_non_mob || ismob(speaker)))
		create_chat_message(speaker, message_language, raw_message, spans, message_mode)
	// Recompose the message, because it's scrambled by default
	message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mode)
	to_chat(src, "[link] [message]")*/

/mob/dead/observer/Hear(atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	. = ..()
// Create map text prior to modifying message for goonchat
	if(client?.prefs)
		if (client?.prefs.chat_on_map && (client.prefs.see_chat_non_mob || ismob(speaker)))
			create_chat_message(speaker, message_language, raw_message, spans, message_mode)
	// Recompose the message, because it's scrambled by default
	var/message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mode)
	to_chat(src, "[message]")
