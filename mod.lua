local manager = require "manager"

function data() return {
	info = {
	 	majorVersion = 0,
		minorVersion = 1,
		severityAdd = "NONE",
		severityRemove = "WARNING",
		name = _("MC Coal Bunker"),
		description = _("A coal bunker that supplies steam trains. Mainly used as a proof of concept, but it can be used in a stand-alone fashion."),
		tags = {"Industry", "Script Mod" },
		authors =
		{
			{
				name = 'Bram Fokke',
				role = 'CREATOR',
				text = 'Mod',
			}
		}
		
		
	},
	runFn = function (settings)
		game.config.industryButton = true

		addModifier("loadModel", function (fileName, data)
			if (string.find(fileName, "vehicle") == nil) then
				return data
			end
			if (data.metadata) then
				if (data.metadata.roadVehicle) then
					if (data.metadata.roadVehicle.topSpeed) then

					end


					-- RELEVANT PROPS
					-- float airVehicle.weight
					-- float airVehicle.topSpeed (m/s)

					-- float railVehicle.weight
					-- float railVehicle.topSpeed (m/s)
					-- string railVehicle.engines.*.type: HORSE, STEAM, ELECTRIC, DIESEL

					-- float roadVehicle.weight
					-- float roadVehicle.topSpeed (m/s)
					-- string roadVehicle.engine.type: HORSE, STEAM, ELECTRIC, DIESEL

					-- float waterVehicle.weight
					-- float waterVehicle.topSpeed (m/s)

					-- int cost.price

					-- string description.name




				end
			end
			return data
		end)

	end
} end