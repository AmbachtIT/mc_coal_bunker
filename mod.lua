local manager = require "manager"
local mc_supply_util = require "mc_supply_util"
local util = require "util"
local entitytracker = require "entitytracker"

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
		mc_supply_util.setup()
		mc_supply_util.registerSupplyStationType("industry/coal_bunker.con")

		addModifier("loadModel", function (fileName, data)
			mc_supply_util.registerVehicleType(fileName, data)
			return data
		end)

	end,
} end