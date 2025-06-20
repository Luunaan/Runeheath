/obj/item
	var/baitpenalty = 100 // Using this as bait will incurr a penalty to fishing chance. 100 makes it useless as bait. Lower values are better, but Never make it past 10.
	var/isbait = FALSE	// Is the item in question bait to be used?
	var/list/freshfishloot = null
	var/list/seafishloot = null
	var/list/mudfishloot = null
	var/list/fishloot = null
	var/list/cageloot = null	
	var/list/luckyloot = null // Non-fish rewards - lucky finds
	var/list/trashloot = null // Not NECESSARILY trash, but less desirable items

/obj/item/natural/worms
	name = "worm"
	desc = "The favorite bait of the courageous fishermen who venture these dark waters."
	icon_state = "worm1"
	throwforce = 10
	baitpenalty = 10
	isbait = TRUE
	color = "#985544"
	w_class = WEIGHT_CLASS_TINY
	freshfishloot = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 225,
		/obj/item/reagent_containers/food/snacks/fish/sunny = 325,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 190,
		/obj/item/reagent_containers/food/snacks/fish/eel = 140,
		/obj/item/grown/log/tree/stick = 3,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/ammo_casing/caseless/rogue/arrow = 1,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/reagent_containers/food/snacks/smallrat = 1, //That's not a fish...?
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/reagent_containers/glass/bottle/rogue = 1,	
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 20,			
	)
	seafishloot = list(
		/obj/item/reagent_containers/food/snacks/fish/cod = 190,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 210,
		/obj/item/reagent_containers/food/snacks/fish/sole = 340,
		/obj/item/reagent_containers/food/snacks/fish/angler = 140,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 150,
		/obj/item/reagent_containers/food/snacks/fish/bass = 210,
		/obj/item/reagent_containers/food/snacks/fish/clam = 40,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 20,
		/obj/item/grown/log/tree/stick = 3,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/ammo_casing/caseless/rogue/arrow = 1,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/reagent_containers/food/snacks/smallrat = 1, //That's not a fish...?
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/reagent_containers/glass/bottle/rogue = 1,	
		/mob/living/carbon/human/species/goblin/npc/sea = 25,
		/mob/living/simple_animal/hostile/rogue/deepone = 30,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 30,			
	)
	mudfishloot = list(
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = 200,
		/obj/item/natural/worms/leech = 50,
		/obj/item/clothing/ring/gold = 1,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 25,				
	)
	// This is super trimmed down from the ratwood list to focus entirely on shellfishes
	cageloot = list(
		/obj/item/reagent_containers/food/snacks/fish/oyster = 214,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 214,
		/obj/item/reagent_containers/food/snacks/fish/crab = 214,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 214,
	)	
	luckyloot = list(
		/obj/item/clothing/ring/gold = 80,
		/obj/item/clothing/ring/silver = 72,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 64,
		/obj/item/clothing/ring/sapphire = 64,
		/obj/item/clothing/ring/emerald = 48,
		/obj/item/clothing/ring/ruby = 40,
		/obj/item/clothing/ring/diamond = 32,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 32
	)
	trashloot = list(
		/obj/item/trash/applecore = 50,
		/obj/item/natural/fibers = 15,
		/obj/item/grown/log/tree/stick = 4,
		/obj/item/customlock = 35,
		/obj/item/clothing/head/roguetown/roguehood = 25,
		/obj/item/clothing/under/roguetown/loincloth/brown = 25,
		/obj/item/clothing/shoes/roguetown/sandals = 25,
		/obj/item/clothing/shoes/roguetown/simpleshoes = 25,
		/obj/item/clothing/gloves/roguetown/fingerless = 25,
		/obj/item/clothing/gloves/roguetown/leather = 25,
		/obj/item/clothing/shoes/roguetown/boots = 25,
		/obj/item/natural/bundle/stick = 15,
		/obj/item/natural/stone = 15,
		/obj/item/natural/cloth = 15,
		/obj/item/kitchen/spoon = 1,
		/obj/item/roguecoin/silver = 24,
		/obj/item/roguecoin/gold = 24,
	)
	drop_sound = 'sound/foley/dropsound/food_drop.ogg'
	var/amt = 1

/obj/item/natural/worms/grubs
	name = "grub"
	desc = "Bait for the desperate, or the daring."
	baitpenalty = 5
	isbait = TRUE
	color = null
	freshfishloot = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 200,
		/obj/item/reagent_containers/food/snacks/fish/sunny = 305,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 210,
		/obj/item/reagent_containers/food/snacks/fish/eel = 160,
		/obj/item/grown/log/tree/stick = 3,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/ammo_casing/caseless/rogue/arrow = 1,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/reagent_containers/food/snacks/smallrat = 1, //That's not a fish...?
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/reagent_containers/glass/bottle/rogue = 1,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 20,				
	)
	seafishloot = list(
		/obj/item/reagent_containers/food/snacks/fish/cod = 230,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 180,
		/obj/item/reagent_containers/food/snacks/fish/sole = 250,
		/obj/item/reagent_containers/food/snacks/fish/angler = 170,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 180,
		/obj/item/reagent_containers/food/snacks/fish/bass = 230,
		/obj/item/reagent_containers/food/snacks/fish/clam = 50,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 40,
		/obj/item/grown/log/tree/stick = 3,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/ammo_casing/caseless/rogue/arrow = 1,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/reagent_containers/food/snacks/smallrat = 1, //That's not a fish...?
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/reagent_containers/glass/bottle/rogue = 1,		
		/mob/living/carbon/human/species/goblin/npc/sea = 25,
		/mob/living/simple_animal/hostile/rogue/deepone = 30,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 30,		
	)
	mudfishloot = list(
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = 200,
		/obj/item/natural/worms/leech = 50,
		/obj/item/clothing/ring/gold = 1,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 25,				
	)	
	luckyloot = list(
		/obj/item/clothing/ring/gold = 80,
		/obj/item/clothing/ring/silver = 72,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 64,
		/obj/item/clothing/ring/sapphire = 64,
		/obj/item/clothing/ring/emerald = 48,
		/obj/item/clothing/ring/ruby = 40,
		/obj/item/clothing/ring/diamond = 32,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 32
	)
	trashloot = list(
		/obj/item/trash/applecore = 50,
		/obj/item/natural/fibers = 15,
		/obj/item/grown/log/tree/stick = 4,
		/obj/item/customlock = 35,
		/obj/item/clothing/head/roguetown/roguehood = 25,
		/obj/item/clothing/under/roguetown/loincloth/brown = 25,
		/obj/item/clothing/shoes/roguetown/sandals = 25,
		/obj/item/clothing/shoes/roguetown/simpleshoes = 25,
		/obj/item/clothing/gloves/roguetown/fingerless = 25,
		/obj/item/clothing/gloves/roguetown/leather = 25,
		/obj/item/clothing/shoes/roguetown/boots = 25,
		/obj/item/natural/bundle/stick = 15,
		/obj/item/natural/stone = 15,
		/obj/item/natural/cloth = 15,
		/obj/item/kitchen/spoon = 1,
		/obj/item/roguecoin/silver = 24,
		/obj/item/roguecoin/gold = 24,
	)

/obj/item/natural/worms/grubs/attack_right(mob/user)
	return

/obj/item/natural/worms/Initialize()
	. = ..()
	dir = rand(0,8)
