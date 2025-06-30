
/obj/item/roguegem
	name = "mother of all gems"
	icon_state = "ruby_cut"
	icon = 'icons/roguetown/items/gems.dmi'
	desc = "A debug tool to help us later"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	sellprice = 1
	static_price = FALSE
	resistance_flags = FIRE_PROOF
	var/gem_as_food = /obj/item/reagent_containers/food/snacks/gem

/obj/item/reagent_containers/food/snacks/gem
	name = "gemstone"
	desc = ""
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
	tastes = list("glass" = 1)
	foodtype = PRECIOUS
	faretype = FARE_LAVISH // They're gemstones, I couldn't justify any less even for the cheapest
	bitesize = 1
	var/quality = 0
	var/const/quality_base = 50 // Must be above this value to be of higher than base quality
	var/const/quality_increment = 10 // For each increment of additional value, nutriment goes up by 3
	var/const/healthpot_base = 80 // Must be above this amount to have 60 units of health potion
	var/const/stronghealth_base = 120 // Must be above this amount to have 60 units of STRONG health potion

/obj/item/reagent_containers/food/snacks/gem/proc/set_quality_from_value(value)
	if (value <= quality_base/2)
		faretype = FARE_IMPOVERISHED
		return
	if (value < quality_base)
		faretype = FARE_POOR
		return

	quality = floor((value - quality_base)/quality_increment)
	var/additional_nutriment = 3 * quality
	list_reagents[/datum/reagent/consumable/nutriment] += additional_nutriment
	if (value > stronghealth_base)
		reagents.add_reagent(/datum/reagent/medicine/stronghealth, 60)
	if (value > healthpot_base)
		reagents.add_reagent(/datum/reagent/medicine/healthpot, 60)

/obj/item/reagent_containers/food/snacks/gem/green
	tastes = list("lime" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS, /datum/reagent/buff/constitution/no_overdose = 27)

/obj/item/reagent_containers/food/snacks/gem/blue
	tastes = list("plum" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS, /datum/reagent/buff/intelligence/no_overdose = 27)

/obj/item/reagent_containers/food/snacks/gem/yellow
	tastes = list("banana" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS, /datum/reagent/buff/perception/no_overdose = 27)

/obj/item/reagent_containers/food/snacks/gem/red
	tastes = list("spiced apple" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS, /datum/reagent/buff/strength/no_overdose = 27)

/obj/item/reagent_containers/food/snacks/gem/white
	tastes = list("vanilla" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS, /datum/reagent/buff/speed/no_overdose = 27)

/obj/item/reagent_containers/food/snacks/gem/purple
	tastes = list("dragonwine" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS, /datum/reagent/buff/constitution/no_overdose = 27)

/obj/item/roguegem/attack(mob/living/M, mob/living/user, def_zone)
	if (user.used_intent.type != INTENT_HARM && HAS_TRAIT(M, TRAIT_GEM_EATER))
		var/obj/item/reagent_containers/food/snacks/gem/gemfood = new gem_as_food()
		gemfood.set_quality_from_value(sellprice)
		if (gemfood.attack(M, user, def_zone))
			qdel(src)
		qdel(gemfood)

/obj/item/roguegem/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -1,"sy" = 0,"nx" = 11,"ny" = 1,"wx" = 0,"wy" = 1,"ex" = 4,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = 0,"wturn" = 0,"eturn" = 39,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/roguegem/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	playsound(loc, pick('sound/items/gems (1).ogg','sound/items/gems (2).ogg'), 100, TRUE, -2)
	..()

/obj/item/roguegem/green
	name = "gemerald"
	icon_state = "emerald_cut"
	sellprice = 42
	desc = "Glints with verdant brilliance."
	gem_as_food = /obj/item/reagent_containers/food/snacks/gem/green

/obj/item/roguegem/green/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/emerald_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/blue
	name = "blortz"
	icon_state = "quartz_cut"
	sellprice = 88
	desc = "Pale blue, like a frozen tear."
	gem_as_food = /obj/item/reagent_containers/food/snacks/gem/blue

/obj/item/roguegem/blue/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/quartz_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/yellow
	name = "toper"
	icon_state = "topaz_cut"
	sellprice = 34
	desc = "Its amber hues remind you of the sunset."
	gem_as_food = /obj/item/reagent_containers/food/snacks/gem/yellow

/obj/item/roguegem/yellow/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/toper_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/violet
	name = "saffira"
	icon_state = "sapphire_cut"
	sellprice = 56
	desc = "This gem is admired by many wizards."
	gem_as_food = /obj/item/reagent_containers/food/snacks/gem/purple

/obj/item/roguegem/violet/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/sapphire_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/ruby
	name = "rontz"
	icon_state = "ruby_cut"
	sellprice = 100
	desc = "Its facets shine so brightly..."
	gem_as_food = /obj/item/reagent_containers/food/snacks/gem/red

/obj/item/roguegem/ruby/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/ruby_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/diamond
	name = "dorpel"
	icon_state = "diamond_cut"
	sellprice = 121
	desc = "Beautifully clear, it demands respect."
	gem_as_food = /obj/item/reagent_containers/food/snacks/gem/white

/obj/item/roguegem/diamond/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/diamond_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/amethyst
	name = "amythortz"
	icon_state = "amethyst"
	desc = "A deep lavender crystal, it surges with magical energy, yet it's artificial nature means it is worth little."
	gem_as_food = /obj/item/reagent_containers/food/snacks/gem/purple

/obj/item/roguegem/amethyst/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/amethyst_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/random
	name = "random gem"
	desc = "You shouldn't be seeing this."
	icon_state = null

/obj/item/roguegem/random/Initialize()
	..()
	var/newgem = list(/obj/item/roguegem/ruby = 5, /obj/item/roguegem/green = 15, /obj/item/roguegem/blue = 10, /obj/item/roguegem/yellow = 20, /obj/item/roguegem/violet = 10, /obj/item/roguegem/diamond = 5, /obj/item/riddleofsteel = 1, /obj/item/rogueore/silver = 3)
	var/pickgem = pickweight(newgem)
	new pickgem(get_turf(src))
	qdel(src)


/// riddle


/obj/item/riddleofsteel
	name = "riddle of steel"
	icon_state = "ros"
	icon = 'icons/roguetown/items/gems.dmi'
	desc = "Flesh, mind."
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	sellprice = 400

/obj/item/riddleofsteel/Initialize()
	. = ..()
	set_light(2, 2, 1, l_color = "#ff0d0d")

	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/quartz_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/pearl
	name = "pearl"
	icon_state = "pearl"
	icon = 'icons/roguetown/items/gems.dmi'
	desc = "A beautiful pearl. Can be strung up into an amulet."
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	sellprice = 20

/obj/item/pearl/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/pearlcross,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/pearl/blue
	name = "Blue pearl"
	icon_state = "bpearl"
	desc = "A beautiful blue pearl. A bounty of Abyssor. Can be strung up into amulets."
	sellprice = 60

/obj/item/pearl/blue/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/bpearlcross,
		/datum/crafting_recipe/roguetown/survival/abyssoramulet
		)
