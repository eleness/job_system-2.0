Job = {}


/* FULL CONFIGURATION */
Job.CFG = {
	showHeader = true,
	maxDistance = 10,
	
	/* Localization */
	distance_text = 'Distance: '
}



/* JOB TYPES CONFIGURATION */

Job.NPC = {
	commerce = {
		name = "Commerce", -- type name
		headerColor = {255, 255, 255},
		showDistance = true,
		model = {"models/breen.mdl"}, -- NPC models
		pos = { -- NPC positions
		[1] = {
			pos = Vector(-633.81939697266,-1744.6571044922,16.876731872559),
			angle = Angle(0,45.31965637207,0),
		}
		},

		limit = 0.4 -- percentage limit (40% of players allowed to pick a job which has commerce type) 
	},
	crime = {
		name = "Crime",
		model = {"models/breen.mdl"},
		pos = {
 
			[1] = {
				pos = Vector(-446.437500, 165.000000, -203.968750),
				angle = Angle(0.000, 90.000, 0.000),
			}
		},
		limit = 0.5
	}
}





function Job:Get(name)
	return Job.NPC[name]
end

