// -- Implements and equipment to help reduce pain. --
// Temperature pack stuff - things you can press to people to help reduce pain.
/// Heal rate and modifier for generic items that are frozen.
#define FROZEN_ITEM_PAIN_RATE 1
#define FROZEN_ITEM_PAIN_MODIFIER 0.5
#define FROZEN_ITEM_TEMPERATURE_CHANGE -5

/// do_after key for using emergency blankets.
#define DOAFTER_SOURCE_BLANKET "doafter_blanket"

// Holding a beer to your busted arm, now that's classic
/obj/item/reagent_containers/food/drinks/beer/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/temperature_pack, pain_heal_rate = 0.3, pain_modifier_on_limb = 0.9, temperature_change = -2)

// Frozen items become usable temperature packs.
/obj/item/make_frozen_visual()
	. = ..()
	if(obj_flags & FROZEN)
		AddElement(/datum/element/temperature_pack, FROZEN_ITEM_PAIN_RATE, FROZEN_ITEM_PAIN_MODIFIER, FROZEN_ITEM_TEMPERATURE_CHANGE)

/obj/item/make_unfrozen()
	. = ..()
	if(!(obj_flags & FROZEN))
		RemoveElement(/datum/element/temperature_pack, FROZEN_ITEM_PAIN_RATE, FROZEN_ITEM_PAIN_MODIFIER, FROZEN_ITEM_TEMPERATURE_CHANGE)

/// Temperature packs (heat packs, cold packs). Apply to hurt limb to un-hurty.
/obj/item/temperature_pack
	name = "temperature pack"
	desc = "A temperature pack, to soothe pain."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'jollystation_modules/icons/obj/pain_items.dmi'
	lefthand_file = 'jollystation_modules/icons/mob/inhands/pain_items_lhand.dmi'
	righthand_file = 'jollystation_modules/icons/mob/inhands/pain_items_rhand.dmi'
	icon_state = "cold_pack"
	throwforce = 0
	throw_speed = 2
	throw_range = 5
	attack_verb_continuous = list("pads")
	attack_verb_simple = list("pads")
	/// Whether our pack has been used.
	var/used = FALSE
	/// Whether our pack is active.
	var/active = FALSE
	/// The amount of pain that our pack heals when used.
	var/pain_heal_amount = 0
	/// The modifier put onto the limb when used.
	var/pain_limb_modifier = 1
	/// The change in temperature applied to the user while our pack is in use.
	var/temperature_change = 0

/obj/item/temperature_pack/Initialize()
	. = ..()
	update_appearance()

/obj/item/temperature_pack/attack_self(mob/user, modifiers)
	. = ..()
	if(!used)
		used = !used
		activate_pack(user)
		return TRUE

/obj/item/temperature_pack/examine(mob/user)
	. = ..()
	if(used)
		if(active)
			. += span_notice("It's used, but emanating [temperature_change > 0 ? "heat" : "a chill"].")
		else
			. += span_notice("It's used up and empty.")
	else
		. += span_notice("Use it in hand to activate the pack, [temperature_change > 0 ? "heating it up" : "cooling it down"].")

/obj/item/temperature_pack/update_overlays()
	. = ..()
	if(!used || active)
		if(temperature_change > 0)
			. += "heat_overlay"
			if(active)
				. += "active_heat_overlay"
		else
			. += "cold_overlay"
			if(active)
				. += "active_cold_overlay"

/*
 * Activate [src] from [user], making it into a temperature pack that can be used, that expires in 5 minutes.
 */
/obj/item/temperature_pack/proc/activate_pack(mob/user)
	addtimer(CALLBACK(src, .proc/deactivate_pack), 5 MINUTES)
	to_chat(user, span_notice("You crack [src], [temperature_change > 0 ? "heating it up" : "cooling it down"]."))
	AddElement(/datum/element/temperature_pack, pain_heal_amount, pain_limb_modifier, temperature_change)
	active = TRUE
	update_appearance()

/*
 * Deactivate [src], making it unusable, and sending signal [COMSIG_TEMPERATURE_PACK_EXPIRED].
 */
/obj/item/temperature_pack/proc/deactivate_pack()
	SEND_SIGNAL(src, COMSIG_TEMPERATURE_PACK_EXPIRED)
	visible_message(span_notice("[src] fizzles as the last of its [temperature_change > 0 ? "heat" : "chill"] runs out."))
	RemoveElement(/datum/element/temperature_pack, pain_heal_amount, pain_limb_modifier, temperature_change)
	active = FALSE
	name = "used [name]"
	desc = "A used up [name]. It's no use to anyone anymore."
	update_appearance()

// Head packs have a stronger modifier, but heals less.
/obj/item/temperature_pack/heat
	name = "heat pack"
	desc = "A heat pack. Crack it to turn it on and apply it to an aching limb to reduce joint stress and moderate pain."
	temperature_change = 5
	pain_heal_amount = 1.2
	pain_limb_modifier = 0.5

// Cold packs heal more, but have a weaker modifier.
/obj/item/temperature_pack/cold
	name = "cold pack"
	desc = "A cold pack. Crack it on and apply it to a hurt limb to abate sharp pain."
	temperature_change = -5
	pain_heal_amount = 2
	pain_limb_modifier = 0.75

/obj/item/reagent_containers/pill/aspirin
	name = "aspirin pill"
	desc = "Used to treat moderate pain and fever. Metabolizes slowly. Best at treating chest pain."
	icon_state = "pill7"
	list_reagents = list(/datum/reagent/medicine/painkiller/aspirin = 10) // Lasts ~4 minutes, heals ~20 pain in chest (lower in other parts)
	rename_with_volume = TRUE

/obj/item/reagent_containers/syringe/aspirin
	name = "syringe (aspirin)"
	desc = "Contains fiteen units of aspirin. Used to treat chest pain and fever. Metabolizes slowly."
	list_reagents = list(/datum/reagent/medicine/painkiller/aspirin = 15)

/obj/item/reagent_containers/pill/ibuprofen
	name = "ibuprofen pill"
	desc = "Used to treat mild pain, headaches, and fever. Metabolizes slowly. Best at treating head pain."
	icon_state = "pill8"
	list_reagents = list(/datum/reagent/medicine/painkiller/ibuprofen = 10) // Lasts ~4 minutes, heals ~20 pain in head (lower in other parts)
	rename_with_volume = TRUE

/obj/item/reagent_containers/syringe/ibuprofen
	name = "syringe (ibuprofen)"
	desc = "Contains fiteen units of ibuprofen. Used to treat head pain headaches, and fever. Metabolizes slowly."
	list_reagents = list(/datum/reagent/medicine/painkiller/ibuprofen = 15)

/obj/item/reagent_containers/pill/paracetamol
	name = "paracetamol pill"
	desc = "Used to treat moderate pain and headaches. Metabolizes slowly. Good as a general painkiller."
	icon_state = "pill9"
	list_reagents = list(/datum/reagent/medicine/painkiller/paracetamol = 10) // Lasts ~4 minutes, heals ~15 pain per bodypart
	rename_with_volume = TRUE

/obj/item/reagent_containers/syringe/paracetamol
	name = "syringe (paracetamol)"
	desc = "Contains fiteen units of Paracetamol. Used to treat general pain. Metabolizes slowly."
	list_reagents = list(/datum/reagent/medicine/painkiller/paracetamol = 15)

/obj/item/reagent_containers/pill/morphine/diluted
	desc = "Used to treat major to severe pain. Causes moderate drowsiness. Mildly addictive."
	icon_state = "pill11"
	list_reagents = list(/datum/reagent/medicine/morphine = 5) // Lasts ~1 minute, heals ~10 pain per bodypart (~100 pain)
	rename_with_volume = TRUE

/obj/item/reagent_containers/syringe/morphine
	name = "syringe (morphine)"
	desc = "Contains three injections of Morphine. Used to treat major to severe pain. Causes moderate drowsiness. Mildly addictive."
	list_reagents = list(/datum/reagent/medicine/morphine = 15)

/obj/item/reagent_containers/pill/oxycodone
	name = "oxycodone pill"
	desc = "Used to treat severe to extreme pain. Rapid acting, may cause delirium. Very addictive."
	icon_state = "pill12"
	list_reagents = list(/datum/reagent/medicine/oxycodone = 5) // Lasts ~1 minute, heals ~20 pain per bodypart (~200 pain)
	rename_with_volume = TRUE

/obj/item/reagent_containers/syringe/oxycodone
	name = "syringe (oxycodone)"
	desc = "Contains three injections of Oxycodone. Used to treat severe to extreme pain. Rapid acting, may cause delirium. Very addictive."
	list_reagents = list(/datum/reagent/medicine/oxycodone = 15)

/obj/item/reagent_containers/pill/aspirin_para_coffee
	name = "aspirin/paracetamol/caffeine pill"
	desc = "A mix of Aspirin, Paracetamol and Coffee to produce an effective, but short lasting painkiller with little to no side effects. Do not take multiple at once."
	list_reagents = list(/datum/reagent/medicine/painkiller/aspirin_para_coffee = 10)

/obj/item/storage/pill_bottle/prescription
	name = "prescription pill bottle"
	desc = "Contains prescription pills."
	/// Typepath of pill type to spawn
	var/obj/item/reagent_containers/pill/pill_type = null
	/// Number of pills to spawn
	var/num_pills = 0

/obj/item/storage/pill_bottle/prescription/Initialize()
	. = ..()
	if(pill_type)
		name = "[initial(pill_type.name)] bottle"
	if(num_pills)
		var/datum/component/storage/STR = GetComponent(/datum/component/storage)
		STR.max_items = num_pills
		STR.max_combined_w_class = num_pills

/obj/item/storage/pill_bottle/prescription/PopulateContents()
	if(num_pills && pill_type)
		for(var/i in 1 to num_pills)
			new pill_type(src)

/obj/item/storage/pill_bottle/painkillers
	name = "bottle of painkillers"
	desc = "Contains multiple pills used to treat anywhere from mild to extreme pain. CAUTION: Do not take in conjunction with alcohol."
	icon = 'jollystation_modules/icons/obj/chemical.dmi'
	custom_premium_price = PAYCHECK_HARD * 1.5

/obj/item/storage/pill_bottle/painkillers/Initialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 14
	STR.max_combined_w_class = 14

/obj/item/storage/pill_bottle/painkillers/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/pill/aspirin(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/pill/ibuprofen(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/pill/paracetamol(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/pill/morphine/diluted(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/pill/oxycodone(src)

/// Miner pen. Heals about 30 pain to all limbs, causes ~150 addiction
/obj/item/reagent_containers/hypospray/medipen/survival/painkiller
	name = "survival painkiller medipen"
	desc = "A medipen that contains a dosage of painkilling chemicals. WARNING: Do not use in combination with alcohol. Can cause drowsiness."
	icon = 'jollystation_modules/icons/obj/syringe.dmi'
	icon_state = "painkiller_stimpen"
	base_icon_state = "painkiller_stimpen"
	volume = 20
	amount_per_transfer_from_this = 20
	list_reagents = list(/datum/reagent/medicine/painkiller/paracetamol = 7.5, /datum/reagent/medicine/painkiller/aspirin_para_coffee = 5, /datum/reagent/medicine/morphine = 5, /datum/reagent/medicine/modafinil = 2.5)

/// Medkit pen. Heals about 35 pain to all limbs, causes ~450 addiction
/obj/item/reagent_containers/hypospray/medipen/painkiller
	name = "emergency painkiller medipen"
	desc = "A medipen that contains a dosage of heavy painkilling chemicals. WARNING: Do not use in combination with alcohol. Can cause drowsiness and addiction."
	icon = 'jollystation_modules/icons/obj/syringe.dmi'
	icon_state = "painkiller"
	base_icon_state = "painkiller"
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/medicine/oxycodone = 7.5, /datum/reagent/medicine/morphine = 5, /datum/reagent/medicine/modafinil = 2.5)

/*
 * Shock blanket item. Hit someone to cover them with the blanket.
 * If they lie down and stay still, it will regulate their body temperature.
 */
/obj/item/shock_blanket
	name = "shock blanket"
	desc = "A metallic looking plastic blanket specifically designed to well insulate anyone seeking comfort underneath."
	icon = 'jollystation_modules/icons/obj/pain_items.dmi'
	worn_icon = 'jollystation_modules/icons/mob/pain_items.dmi'
	lefthand_file = 'jollystation_modules/icons/mob/inhands/pain_items_lhand.dmi'
	righthand_file = 'jollystation_modules/icons/mob/inhands/pain_items_rhand.dmi'
	icon_state = "shockblanket"
	worn_icon_state = "shockblanket"
	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound =  'sound/items/handling/cloth_pickup.ogg'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_OCLOTHING
	body_parts_covered = CHEST
	resistance_flags = FIRE_PROOF
	heat_protection = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	armor = list(MELEE = 0, BULLET = 0, LASER = 20, ENERGY = 20, BOMB = 20, BIO = 10, FIRE = 100, ACID = 50)
	equip_delay_self = 2 SECONDS
	slowdown = 1.5
	throwforce = 0
	throw_speed = 1
	throw_range = 2
	custom_price = PAYCHECK_MEDIUM

/obj/item/shock_blanket/Initialize(mapload)
	. = ..()
	if(prob(5))
		name = pick("space blanket", "safety blanket")

	AddElement(/datum/element/bed_tuckable, 0, 0, 0)

/obj/item/shock_blanket/examine(mob/user)
	. = ..()
	. += span_notice("To use: Apply to a patient experiencing shock or loss of body temperature. Keep patient still and lying down for maximum effect.")

/obj/item/shock_blanket/pickup(mob/user)
	. = ..()
	icon_state = initial(icon_state)
	layer = initial(layer)

/obj/item/shock_blanket/dropped(mob/user)
	. = ..()
	if(locate(/obj/structure/bed) in loc)
		icon_state = "[initial(icon_state)]_dropped"
		layer = MOB_LAYER

/obj/item/shock_blanket/attack_self(mob/user, modifiers)
	if(!user.dropItemToGround(src))
		return

	var/obj/structure/bed/bed_below = locate(/obj/structure/bed) in loc
	to_chat(user, span_notice("You lay out [src] on [bed_below ? "[bed_below]" : "the floor"]."))
	icon_state = "[initial(icon_state)]_dropped"
	layer = MOB_LAYER

	return ..()

/obj/item/shock_blanket/pre_attack(atom/target, mob/living/user, params)
	. = ..()

	if(ishuman(target))
		try_shelter_mob(target, user)
		return TRUE

	return

/*
 * Try to equip [target] with [src], done by [user].
 * Basically, the ability to equip someone just by hitting them with the blanket,
 * instead of needing to use the strip menu.
 *
 * target - the mob being hit with the blanket
 * user - the mob hitting the target
 */
/obj/item/shock_blanket/proc/try_shelter_mob(mob/living/carbon/human/target, mob/living/user)
	if(DOING_INTERACTION(user, DOAFTER_SOURCE_BLANKET))
		return FALSE

	if(target.wear_suit)
		to_chat(user, span_warning("You need to take off [target == user ? "your" : "their"] [target.wear_suit.name] first!"))
		return FALSE

	to_chat(user, span_notice("You begin wrapping [target == user ? "yourself" : "[target]"] with [src]..."))
	visible_message(span_notice("[user] begins wrapping [target == user ? "[user.p_them()]self" : "[target]"] with [src]..."), ignored_mobs = list(user))
	if(!do_after(user, (target == user ? equip_delay_self : equip_delay_other), target, interaction_key = DOAFTER_SOURCE_BLANKET))
		return FALSE

	do_shelter_mob(target, user)
	return TRUE

/*
 * Actually equip [target] with [src], done by [user].
 *
 * target - the mob being equipped
 * user - the mob equipping the target
 */
/obj/item/shock_blanket/proc/do_shelter_mob(mob/living/carbon/human/target, mob/living/user)
	if(target.equip_to_slot_if_possible(src, ITEM_SLOT_OCLOTHING, disable_warning = TRUE, bypass_equip_delay_self = TRUE))
		to_chat(user, span_notice("You wrap [target == user ? "yourself" : "[target]"] with [src], helping regulate body temperature."))
		user.update_inv_hands()
	else
		to_chat(user, span_warning("You can't quite reach and fail to wrap [target == user ? "yourself" : "[target]"] with [src]."))

/obj/item/shock_blanket/equipped(mob/user, slot)
	. = ..()
	if(slot_flags & slot)
		enable_protection(user)
		RegisterSignal(user, list(COMSIG_LIVING_SET_BODY_POSITION, COMSIG_LIVING_SET_BUCKLED), .proc/check_protection)
		RegisterSignal(user, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_PRE_MOVE), .proc/disable_protection)

/obj/item/shock_blanket/dropped(mob/user, silent)
	. = ..()
	disable_protection(user)
	UnregisterSignal(user, list(COMSIG_LIVING_SET_BODY_POSITION, COMSIG_LIVING_SET_BUCKLED, COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_PRE_MOVE))

/*
 * Check if we should be recieving temperature protection.
 * We only give protection if we're lying down or buckled - if we're moving, we don't get anything.
 */
/obj/item/shock_blanket/proc/check_protection(mob/living/source)
	SIGNAL_HANDLER

	if(source.body_position == LYING_DOWN)
		enable_protection(source)
		return
	if(source.buckled)
		enable_protection(source)
		return

	disable_protection(source)

/*
 * Enable the temperature protection.
 */
/obj/item/shock_blanket/proc/enable_protection(mob/living/source)
	SIGNAL_HANDLER

	if(istype(source) && !(datum_flags & DF_ISPROCESSING))
		var/temp_change = "warmer"
		if(source.bodytemperature > source.get_body_temp_normal(apply_change = FALSE))
			temp_change = "colder"

		to_chat(source, span_notice("You feel [temp_change] as [src] begins regulating your body temperature."))
		START_PROCESSING(SSobj, src)

/*
 * Disable the temperature protection.
 */
/obj/item/shock_blanket/proc/disable_protection(mob/living/source)
	SIGNAL_HANDLER

	if(istype(source) && (datum_flags & DF_ISPROCESSING))
		var/temp_change = "freezing"
		if(source.bodytemperature > source.get_body_temp_normal(apply_change = FALSE))
			temp_change = "hotter"

		to_chat(source, span_notice("You feel [temp_change] again as [src] stops regulating your body temperature."))

	STOP_PROCESSING(SSobj, src)

/obj/item/shock_blanket/process(delta_time)
	var/mob/living/carbon/wearer = loc
	if(!istype(wearer))
		disable_protection()
		return

	var/target_temp = wearer.get_body_temp_normal(apply_change = FALSE)
	if(wearer.bodytemperature > target_temp)
		wearer.adjust_bodytemperature(-12 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, target_temp)
	else if(wearer.bodytemperature < (target_temp + 1))
		wearer.adjust_bodytemperature(12 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, 0, target_temp)
	if(ishuman(wearer))
		var/mob/living/carbon/human/human_wearer = wearer
		if(human_wearer.coretemperature > target_temp)
			human_wearer.adjust_coretemperature(-12 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, target_temp)
		else if(human_wearer.coretemperature < (target_temp + 1))
			human_wearer.adjust_coretemperature(12 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, 0, target_temp)

/obj/item/shock_blanket/emergency
	desc = "An emergency variant shock blanket intended to be placed in medkits for field treatment. Faster to apply to patients, but more restrictive to movement."
	slowdown = 2.5
	equip_delay_self = 1.2 SECONDS
	equip_delay_other = 1.2 SECONDS

/obj/item/shock_blanket/emergency/Initialize()
	. = ..()
	name = "emergency [name]"

// Change the contents of emergency first-aid kids.
/obj/item/storage/firstaid/emergency/Initialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 12
	STR.max_combined_w_class = 12

/obj/item/storage/firstaid/emergency/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/healthanalyzer/wound = 1,
		/obj/item/stack/medical/gauze = 1,
		/obj/item/stack/medical/suture/emergency = 1,
		/obj/item/stack/medical/ointment = 1,
		/obj/item/reagent_containers/hypospray/medipen/ekit = 2,
		/obj/item/reagent_containers/hypospray/medipen/painkiller = 2,
		/obj/item/storage/pill_bottle/iron = 1,
		/obj/item/shock_blanket/emergency = 1,
	)
	generate_items_inside(items_inside, src)


// Pain implements added to various vendors.
/obj/machinery/vending/drugs
	added_premium = list(/obj/item/storage/pill_bottle/painkillers = 2)

/obj/machinery/vending/medical
	added_products = list(
		/obj/item/shock_blanket = 3,
		/obj/item/temperature_pack/cold = 2,
		/obj/item/temperature_pack/heat = 2,
		)

/obj/machinery/vending/wallmed
	added_products = list(
		/obj/item/shock_blanket/emergency = 2,
		/obj/item/temperature_pack/cold = 1,
		/obj/item/temperature_pack/heat = 1,
		)

#undef FROZEN_ITEM_PAIN_RATE
#undef FROZEN_ITEM_PAIN_MODIFIER
#undef FROZEN_ITEM_TEMPERATURE_CHANGE

#undef DOAFTER_SOURCE_BLANKET
