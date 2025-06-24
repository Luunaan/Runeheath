/datum/point_buy
	var/const/starting_points = 3 // Points to start with
	var/const/max_positive_adjustments = 5 // Maximum POSITIVE adjustments
	var/const/max_total_adjustments = 12 // Maximum TOTAL adjustments (sum of magnitudes)
	var/const/points_for_second_virtue = 4
	var/current_points = starting_points

	var/list/stats = list(
		STATKEY_STR = 0,
		STATKEY_PER = 0,
		STATKEY_CON = 0,
		STATKEY_INT = 0,
		STATKEY_SPD = 0,
		STATKEY_LCK = 0
	)

/datum/point_buy/proc/deserialize(text)
	var/list/data = splittext(text, ",")
	if (length(data) != length(stats))
		return FALSE
	
	stats[STATKEY_STR] = text2num(data[1])
	stats[STATKEY_PER] = text2num(data[2])
	stats[STATKEY_CON] = text2num(data[3])
	stats[STATKEY_INT] = text2num(data[4])
	stats[STATKEY_SPD] = text2num(data[5])
	stats[STATKEY_LCK] = text2num(data[6])

	if (!validate())
		reset_points()

	current_points -= get_total_point_cost()
	return TRUE

/datum/point_buy/proc/serialize()
	var/data
	// Do this in manual order rather than a loop.
	// We need to be 100% certain the serialization and deserialization match.
	data += "[num2text(stats[STATKEY_STR])],"
	data += "[num2text(stats[STATKEY_PER])],"
	data += "[num2text(stats[STATKEY_CON])],"
	data += "[num2text(stats[STATKEY_INT])],"
	data += "[num2text(stats[STATKEY_SPD])],"
	data += "[num2text(stats[STATKEY_LCK])]"

	return data

/// Attempts to modify the point buy associated with the given statkey by the given diff.
/// Returns TRUE if the value could be modified with the available point budget and FALSE otherwise.
/datum/point_buy/proc/try_buy_point(statkey, diff)
	// If we're moving towards zero, ignore any adjustment checks - we are reducing our number of adjustments
	// so this should always be allowed
	var/away_from_zero = ((SIGN(stats[statkey] == 0)) || (SIGN(stats[statkey]) == SIGN(diff)))
	if (away_from_zero)
		if (max_positive_adjustments > 0 && diff > 0 && get_positive_adjustments() >= max_positive_adjustments)
			return FALSE
		if (max_total_adjustments > 0 && get_all_adjustments() >= max_total_adjustments)
			return FALSE

	var/value = stats[statkey]
	var/newvalue = value + diff
	if (current_points + get_point_cost_for(value) - get_point_cost_for(newvalue) >= 0)
		current_points += get_point_cost_for(value)
		current_points -= get_point_cost_for(newvalue)
		stats[statkey] = newvalue
		return TRUE
	return FALSE

/// Returns TRUE if the bought stats are value given current point buy rules, and FALSE otherwise.
/datum/point_buy/proc/validate()
	if (get_positive_adjustments() > max_positive_adjustments)
		return FALSE
	if (get_all_adjustments() > max_total_adjustments)
		return FALSE
	return (get_total_point_cost() <= starting_points)

/// Returns the number of positive adjustmenets.
/datum/point_buy/proc/get_positive_adjustments()
	var/count = 0
	for (var/stat in stats)
		var/value = stats[stat]
		if (value > 0)
			count += value
	return count

/// Returns the combined number of positive and negative adjustments.
/datum/point_buy/proc/get_all_adjustments()
	var/count = 0
	for(var/stat in stats)
		var/value = stats[stat]
		count += abs(value)
	return count

/// Returns the point cost for a given stat value (relative to a value of 0).
/datum/point_buy/proc/get_point_cost_for(statvalue)
	if (statvalue <= -5)
		return 999
	if (statvalue <= 0)
		return statvalue
	if (statvalue > 3)
		return 999
	var/result = (1 + ((statvalue-1) * 2)) // 1, 3, 5
	return result

/// Returns the total cost, in points, of all bought stats.
/datum/point_buy/proc/get_total_point_cost()
	var/total = 0
	for(var/stat in stats)
		total += get_point_cost_for(stats[stat])
	return total

/// Resets all bought stats to 0 and refunds all points.
/datum/point_buy/proc/reset_points()
	for (var/statkey in stats)
		stats[statkey] = 0
	current_points = starting_points

/// Applies all stat adjustments to the target mob.
/datum/point_buy/proc/apply_to(mob/living/L)
	remove_from(L) // Remove the effects of any prior bought stats
	for(var/statkey in stats)
		L.change_stat(statkey, stats[statkey], "pointbuy_[statkey]")

/// Applies the inverse of all stat adjustmenet to the target mob.
/datum/point_buy/proc/apply_inverse_to(mob/living/L)
	for(var/statkey in stats)
		L.change_stat(statkey, -stats[statkey], "pointbuy_[statkey]")

/// Removes all pointbuy adjustments from the target mob, even if they don't match this pointbuy's adjustments.
/datum/point_buy/proc/remove_from(mob/living/L)
	for(var/statkey in stats)
		L.change_stat(statkey, 0, "pointbuy_[statkey]")

/datum/point_buy/proc/can_afford_second_virtue()
	return current_points >= points_for_second_virtue
