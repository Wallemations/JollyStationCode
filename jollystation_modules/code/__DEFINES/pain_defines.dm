// -- Defines for the pain system. --

/// Pained Limp status effect
#define STATUS_EFFECT_LIMP_PAIN /datum/status_effect/limp/pain
/// Low blood pressure
#define STATUS_EFFECT_LOWBLOODPRESSURE /datum/status_effect/low_blood_pressure
/// Sharp pain
#define STATUS_EFFECT_SHARP_PAIN /datum/status_effect/sharp_pain
/// Minimum pain
#define STATUS_EFFECT_MIN_PAIN /datum/status_effect/minimum_bodypart_pain

/// Sent when a carbon gains pain. (source = mob/living/carbon/human, obj/item/bodypart/affected_bodypart, amount, type)
#define COMSIG_CARBON_PAIN_GAINED "pain_gain"
/// Sent when a carbon loses pain. (source = mob/living/carbon/human, obj/item/bodypart/affected_bodypart, amount, type)
#define COMSIG_CARBON_PAIN_LOST "pain_loss"
/// Sent when a temperature pack runs out of juice. (source = obj/item/temperature_pack)
#define COMSIG_TEMPERATURE_PACK_EXPIRED "temp_pack_expired"

/// Various lists of body zones affected by pain.
#define BODY_ZONES_ALL list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
#define BODY_ZONES_MINUS_HEAD list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
#define BODY_ZONES_LIMBS list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
#define BODY_ZONES_MINUS_CHEST list(BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

/// List of some emotes that convey pain.
#define PAIN_EMOTES list("wince", "gasp", "grimace", "shiver", "sway", "twitch_s", "whimper", "inhale_s", "exhale_s", "groan", "moan")

/// Amount of pain gained (to chest) from dismembered limb
#define PAIN_LIMB_DISMEMBERED 90
/// Amount of pain gained (to chest) from surgically removed limb
#define PAIN_LIMB_REMOVED 30

/// Max pains for bodyparts
#define PAIN_LIMB_MAX 70
#define PAIN_CHEST_MAX 120
#define PAIN_HEAD_MAX 100

/// Keys for pain modifiers
#define PAIN_MOD_CHEMS "chems"
#define PAIN_MOD_DRUNK "drunk"
#define PAIN_MOD_SLEEP "asleep"
#define PAIN_MOD_LYING "lying"
#define PAIN_MOD_STASIS "stasis"
#define PAIN_MOD_DROWSY "drowsy"
#define PAIN_MOD_NEAR_DEATH "near-death"
#define PAIN_MOD_RECENT_SHOCK "recently-shocked"
#define PAIN_MOD_YOUTH "youth"
#define PAIN_MOD_TENACITY "tenacity"
#define PAIN_MOD_QUIRK "quirk"
#define PAIN_MOD_SPECIES "species"
#define PAIN_MOD_OFF_STATION "off-station-pain-resistance"
#define PAIN_MOD_GENETICS "gene"

/// ID for traits and modifiers gained by pain
#define PAIN_LIMB_PARALYSIS "pain_paralysis"
#define MOVESPEED_ID_PAIN "pain_movespeed"
#define ACTIONSPEED_ID_PAIN "pain_actionspeed"
#define TRAIT_EXTRA_PAIN "extra_pain"
#define TRAIT_OFF_STATION_PAIN_RESISTANCE "pain_resistance_off_station"

//Originally in pain_helpers.dm, moved here for superseding issues
/// Cause [amount] pain of default (BRUTE) damage type to [target_zone]
#define cause_pain(target_zone, amount) pain_controller?.adjust_bodypart_pain(target_zone, amount)
/// Cause [amount] pain of [type] damage type to [target_zone]
#define cause_typed_pain(target_zone, amount, dam_type) pain_controller?.adjust_bodypart_pain(target_zone, amount, dam_type)
/// Do pain related [emote] from a mob, and start a [cooldown] long cooldown before a pain emote can be done again.
#define pain_emote(emote, cooldown) pain_controller?.do_pain_emote(emote, cooldown)
/// Increase the minimum amount of pain [zone] can have for [time]
#define apply_min_pain(target_zone, amount, time) apply_status_effect(STATUS_EFFECT_MIN_PAIN, target_zone, amount, time)
/// Set [id] pain mod to [amount]
#define set_pain_mod(id, amount) pain_controller?.set_pain_modifier(id, amount)
/// Unset [id] pain mod
#define unset_pain_mod(id) pain_controller?.unset_pain_modifier(id)
