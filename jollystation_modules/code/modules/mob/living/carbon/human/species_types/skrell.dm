// -- Modular Skrell species --
/// GLOB list of head tentacle sprites / options
GLOBAL_LIST_EMPTY(head_tentacles_list)

/randomize_human(mob/living/carbon/human/H)
	H.dna.features["head_tentacles"] = pick(GLOB.head_tentacles_list)
	. = ..()

// The datum for Skrell.
/datum/species/skrell
	name = "Skrell"
	id = SPECIES_SKRELL
	default_color = "4B4B4B"
	species_traits = list(MUTCOLORS, EYECOLOR, LIPS, HAS_FLESH, HAS_BONE)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_CAN_STRIP, TRAIT_LIGHT_DRINKER)
	external_organs = list(/obj/item/organ/external/head_tentacles = "Long")
	toxic_food = MEAT | RAW | DAIRY | TOXIC | SEAFOOD
	disliked_food = GROSS
	liked_food = VEGETABLES | FRUIT
	payday_modifier = 0.75
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/skrell
	say_mod = "warbles"
	exotic_bloodtype = "S"
	mutanttongue = /obj/item/organ/tongue/skrell
	species_speech_sounds = list('jollystation_modules/sound/voice/huff.ogg' = 120)
	species_speech_sounds_exclaim = list('jollystation_modules/sound/voice/huff_ask.ogg' = 120)
	species_speech_sounds_ask = list('jollystation_modules/sound/voice/huff_exclaim.ogg' = 120)
	species_pain_mod = 0.80

/datum/species/skrell/spec_life(mob/living/carbon/human/skrell_mob, delta_time, times_fired)
	. = ..()
	if(skrell_mob.nutrition > NUTRITION_LEVEL_ALMOST_FULL)
		skrell_mob.set_nutrition(NUTRITION_LEVEL_ALMOST_FULL)

/datum/species/skrell/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features["mcolor"] = sanitize_hexcolor(COLOR_BLUE_GRAY)
	human.update_body()
	human.update_body_parts()

// Preset Skrell species
/mob/living/carbon/human/species/skrell
	race = /datum/species/skrell

// Skrell bloodbag, for S type blood
/obj/item/reagent_containers/blood/skrell
	blood_type = "S"

// Skrell Tongue. Could use a sprite.
/obj/item/organ/tongue/skrell
	name = "skrellian tongue"
	desc = "The source of the Skrellian people's warbling voice."
	say_mod = "warbles"
	var/static/list/languages_possible_skrell = typecacheof(list(
		/datum/language/common,
		/datum/language/uncommon,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/nekomimetic,
		/datum/language/skrell
	))

/obj/item/organ/tongue/skrell/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_skrell

// Copper restores blood for Skrell instead of iron.
/datum/reagent/copper/on_mob_life(mob/living/carbon/C, delta_time)
	if((isskrell(C)) && (C.blood_volume < BLOOD_VOLUME_NORMAL))
		C.blood_volume += 0.5 * delta_time
	..()

// Organ for Skrell head tentacles.
/obj/item/organ/external/head_tentacles
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_HEAD_TENTACLES
	layers = EXTERNAL_FRONT | EXTERNAL_ADJACENT
	dna_block = DNA_HEAD_TENTACLES_BLOCK
	feature_key = "head_tentacles"
	preference = "feature_head_tentacles"

/obj/item/organ/external/head_tentacles/can_draw_on_bodypart(mob/living/carbon/human/human)
	. = TRUE
	if(istype(human.head) && (human.head.flags_inv & HIDEHAIR))
		. = FALSE
	if(istype(human.wear_mask) && (human.wear_mask.flags_inv & HIDEHAIR))
		. = FALSE
	var/obj/item/bodypart/head/our_head = human.get_bodypart(BODY_ZONE_HEAD)
	if(our_head?.status == BODYPART_ROBOTIC)
		. = FALSE

/obj/item/organ/external/head_tentacles/get_global_feature_list()
	return GLOB.head_tentacles_list
