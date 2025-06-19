
/datum/crafting_recipe
	abstract_type = /datum/crafting_recipe
	var/name = "" //in-game display name
	var/reqs[] = list() //type paths of items consumed associated with how many are needed
	var/blacklist[] = list() //type paths of items explicitly not allowed as an ingredient
	var/result[] = list() //type path of item resulting from this craft
	/// String defines of items needed but not consumed. Lazy list.
	var/list/tool_behaviors
	var/tools[] = list() //type paths of items needed but not consumed
	var/time = 0 //time in deciseconds
	var/parts[] = list() //type paths of items that will be placed in the result
	var/chem_catalysts[] = list() //like tools but for reagents
	var/category = "Misc" // Where it shows in the recipe books
	var/subcategory = CAT_NONE
	var/always_availible = FALSE //Set to FALSE if it needs to be learned first.
	var/ontile = FALSE		//crafted on our tile instead of in front of us
	var/req_table = FALSE
	var/skillcraft = /datum/skill/craft/crafting
	var/verbage_simple = "craft"
	var/verbage = "crafts"
	var/craftsound = 'sound/foley/bandage.ogg'
	var/subtype_reqs = FALSE
	var/structurecraft = null
	var/buildsame = FALSE //allows palisades to be built on top of each other just not the same dir
	var/wallcraft = FALSE
	var/craftdiff = 1
	var/sellprice = 0
	/// Whether this recipe will transmit a message in a 7x7 column around the source.
	var/loud = FALSE
	//crafting diff, every diff removes 25% chance to craft
/*
/datum/crafting_recipe/example
	name = ""
	result = /obj/item/stuff
	reqs = list(/obj/item/gun = 1)
	parts = list(/obj/item/gun = 1)
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 5 SECONDS
	category = CAT_NONE
	subcategory = CAT_NONE
*/

/datum/crafting_recipe/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	user << browse_rsc('html/book.png')
	var/uncrafted_sellprice = 0
	if(islist(result))
		var/list/result_list = result
		if(result_list.len)
			if(istype(/atom/movable, result[1]))
				var/atom/movable/AM = result[1]
				if(AM.sellprice)
					uncrafted_sellprice = AM.sellprice
	else if(istype(result, /atom/movable))
		var/atom/movable/AM = result
		if(AM.sellprice)
			uncrafted_sellprice = AM.sellprice

	var/final_sellprice = sellprice || uncrafted_sellprice
	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
		<body>
		  <div>
		    <h1>[name]</h1>
		"}

	if(craftdiff > 0)
		html += "For those of [SSskills.level_names_plain[craftdiff]] skills<br>"
	else
		html += "Suitable for all skills<br>"	

	html += {"<div>
		      <strong>Requirements</strong>
			  <br>"}

	for(var/path as anything in reqs)
		var/count = reqs[path]
		if(ispath(path, /datum/reagent))
			var/datum/reagent/R = path
			html += "[CEILING(count / 3, 1)] oz of [initial(R.name)]<br>" // Cuz we're weird and don't use it under chem catalyst and we don't want icon crash 
		else if(ispath(path, /obj)) // Prevent a runtime from happening w/ datum atm until it is
			var/atom/atom = path
			if(subtype_reqs)
				html += "- [count] of any [initial(atom.name)]<br>"
			else
				html += "- [count] [initial(atom.name)]<br>"

	html += {"
		</div>
		<div>
		"}

	if(length(tools))
		html += {"
		<br>
		<div>
		    <strong>Required Tools</strong>
			<br>
			  "}
		for(var/atom/path as anything in tools)
			if(subtype_reqs)
				html += "[icon2html(new path, user)] any [initial(path.name)]<br>"
			else
				html += "[icon2html(new path, user)] [initial(path.name)]<br>"
		html += {"
			</div>
		<div>
		"}

	if(length(chem_catalysts))
		html += {"
		<br>
		<div>
		    <strong>Required Liquids</strong>
			<br>
			  "}
		for(var/atom/path as anything in chem_catalysts)
			var/count = chem_catalysts[path]
			html += "[CEILING(count / 3, 1)] oz of [initial(path.name)]<br>"
		html += {"
			</div>
		<div>
		"}

	if(structurecraft)
		var/obj/structure = structurecraft
		html += "<strong class=class='scroll'>start the process next to a</strong> <br>[icon2html(new structurecraft, user)] <br> [initial(structure.name)]<br>"
	if(req_table)
		html += "<strong class=class='scroll'>start the process next to a table</strong> <br>"
	if(wallcraft)
		html += "<strong class=class='scroll'>start the process next to a wall</strong> <br>"

	if(final_sellprice)
		html += "<strong class=class='scroll'>You can sell this for [final_sellprice] mammons at a normal quality</strong> <br>"
	else(
		html += "<strong class=class='scroll'>This is worthless for export</strong> <br>"
	)

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/crafting_recipe/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=new_recipe;size=500x810")

/datum/crafting_recipe/proc/construct_name()
	// type == abstract_type implies this recipe doesn't actually represent an item
	// TODO: Some of the abstract crafting recipes irritatingly do not properly define their abstract_type,
	// meaning this guard is not perfect. We will need to either fix this, or come up with another guard that
	// catches any remaining cases (and isn't too expensive to be worth bothering).
	// For now, one lookup of the names table and a call to get_result_name() shouldn't be TOO expensive...
	if (type == abstract_type)
		return null

	// If the name already exists and is cached, return it
	var/static/list/names = list()
	var/str = names[type]
	if (str)
		return str

	// Construct the name based on output, ingredients, etc. and cache it
	var/item_name = get_result_name()
	if (item_name)
		var/list/data = list()
		data += item_name
		data += get_ingredients_string(data)
		data += get_tools_string(data)
		data += get_catalyst_string(data)
		data += get_skill_level_string(data)
		name = data.Join("")
		names[type] = name
	return name

/datum/crafting_recipe/proc/get_result_name()
	if (result)
		// Multiple outputs
		if (islist(result) && length(result) > 0)
			var/current_name = null
			var/run_length = 0
			var/index = 1
			var/len = length(result)
			var/list/string = list()
			for(var/item in result)
				if (ispath(item, /obj))
					var/obj/it = item
					if (it.name != current_name)
						if (current_name != null)
							string += capitalize(it.name)
							if (run_length > 1)
								string += " x"
								string += num2text(run_length)
							if (index < len)
								string += ", "
						run_length = 0
						current_name = it.name
					++run_length
				++index
			if (current_name != null)
				string += capitalize(current_name)
				if (run_length > 1)
					string += " x"
					string += num2text(run_length)
			return string.Join("")
		// Single output
		else if (ispath(result, /obj))
			var/obj/it = result
			return capitalize(it.name)
	return null

/datum/crafting_recipe/proc/get_ingredients_string(data)
	var/list/string = list()
	var/len = length(reqs)
	if (reqs && len > 0)
		string += " ("
		var/index = 1
		for(var/item in reqs)
			if (ispath(item, /obj))
				var/obj/it = item
				string += it.name
				if (reqs[item] > 1)
					string += " x"
					string += num2text(reqs[item])
				if (index < len)
					string += "; "
			++index
		string += ")"
	return string.Join("")

/datum/crafting_recipe/proc/get_tools_string(data)
	var/list/string = list()
	var/len = length(tools)
	if (tools && len > 0)
		string += " ("
		var/index = 1
		for(var/item in tools)
			if (ispath(item, /obj))
				var/obj/it = item
				string += it.name
				if (index < len)
					string += "; "
			++index
		string += ")"
	return string.Join("")

/datum/crafting_recipe/proc/get_catalyst_string(data)
	var/list/string = list()
	var/len = length(chem_catalysts)
	if (chem_catalysts && len > 0)
		string += " ("
		var/index = 1
		for(var/item in chem_catalysts)
			if (ispath(item, /obj))
				var/obj/it = item
				string += it.name
				if (index < len)
					string += ";"
			++index
		string += ")"
	return string.Join("")

/datum/crafting_recipe/proc/get_skill_level_string(data)
	if (craftdiff > 0)
		return " ([SSskills.level_names_plain[craftdiff]])"
	else
		return ""
