//The code execution of the emote datum is located at code/datums/emotes.dm
/mob/proc/emote(act, m_type = null, message = null, intentional = FALSE, forced = FALSE, targetted = FALSE, custom_me = FALSE, animal = FALSE)
	var/oldact = act
	act = lowertext(act)
	var/param = message
	var/custom_param = findchar(act, " ")
//	if(custom_param)
//		param = copytext(act, custom_param + 1, length(act) + 1)
//		act = copytext(act, 1, custom_param)

	if(intentional || !forced)
		if(custom_me)
			if(world.time < next_me_emote)
				return
		else
			if(world.time < next_emote)
				return

	var/list/key_emotes = GLOB.emote_list[act]
	var/mute_time = 0
	if(!length(key_emotes) || custom_param)
		if(intentional)
			var/list/custom_emote = GLOB.emote_list["me"]
			for(var/datum/emote/P in custom_emote)
				mute_time = P.mute_time
				P.run_emote(src, oldact, m_type, intentional, targetted, (animal ? animal : P.is_animal))
				break
	else
		for(var/datum/emote/P in key_emotes)
			mute_time = P.mute_time
			if(P.run_emote(src, param, m_type, intentional, targetted, (animal ? animal : P.is_animal)))
				break

	if(custom_me)
		next_me_emote = world.time + mute_time
	else
		next_emote = world.time + mute_time

/atom/movable/proc/send_speech_emote(message, range = 7, obj/source = src, bubble_type, list/spans, datum/language/message_language = null, message_mode, original_message)
	for(var/_AM in get_hearers_in_view(range, source))
		var/atom/movable/AM = _AM
		AM.Hear(src, message_language, message, , spans, message_mode)
