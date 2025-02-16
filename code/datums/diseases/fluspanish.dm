/datum/disease/fluspanish
	name = "Spanish inquisition Flu"
	max_stages = 3
	spread_text = "Airborne"
	cure_text = "Spaceacillin & Anti-bodies to the common flu"
	cures = list(/datum/reagent/medicine/spaceacillin)
	cure_chance = 5
	agent = "1nqu1s1t10n flu virion"
	viable_mobtypes = list(/mob/living/carbon/human)
	spreading_modifier = 0.75
	desc = "If left untreated the subject will burn to death for being a heretic."
	severity = DISEASE_SEVERITY_DANGEROUS
	required_organ = ORGAN_SLOT_LUNGS

/datum/disease/fluspanish/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			affected_mob.adjust_body_temperature(0.5 KELVIN * seconds_per_tick, max_temp = affected_mob.bodytemp_heat_damage_limit)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("sneeze")
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("cough")
			if(SPT_PROB(0.5, seconds_per_tick))
				to_chat(affected_mob, span_danger("You're burning in your own skin!"))
				affected_mob.damage_random_bodypart(5, BURN)

		if(3)
			affected_mob.adjust_body_temperature(1 KELVIN * seconds_per_tick, max_temp = affected_mob.bodytemp_heat_damage_limit + 10 KELVIN)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("sneeze")
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("cough")
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_danger("You're burning in your own skin!"))
				affected_mob.damage_random_bodypart(5, BURN)
