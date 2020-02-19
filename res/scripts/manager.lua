local util = require("util")

-- Manager object
local t = {
	isFirstTime = true,
	ignoreInitially = { 
		ANIMAL = true, 
		ASSET_GROUP = true,
		BASE_NODE = true,
		BASE_EDGE = true,
		CONSTRUCTION = true,
		SIM_BUILDING = true,
		TOWN = true,
		TOWN_BUILDING = true,
	},
	ignoreAlways = {
		SIM_PERSON = true
	},
	visited = {}
}



-- Manager state
local state = {
    eventsProcessed = 0
}

-- Manager handlers
t.script = {
	init = function() 
	end,

	guiInit = function() 
	end,

	-- Return state that will be serialized in the save game
	save = function()
		return state
	end,

	-- Load state that was deserialized from the save game
	load = function(loadedstate)
		state = loadedstate or state
	end,

	update = function() 
	end,

	guiUpdate = function() 
	end,

	-- Handle game event
    handleEvent = function (src, id, name, param)
		if src == "guidesystem.lua" and id == "saveevent" then return end
		if id == "SimCargoSystem" then
			if name == "OnToArriveAtDestination" then return end
		end
		if id == "missionCallback" then
			if name == "JOURNAL_ENTRY" then 
				if param then
					if param.type == "VEHICLE_INCOME" or param.type == "VEHICLE_MAINTENANCE" then
						return
					end
				end
			end
		end

        state.eventsProcessed = state.eventsProcessed + 1
		print("MC handleEvent(src, id, name, param): (" .. util.safetostring(src) .. ", ".. util.safetostring(id) .. ", ".. util.safetostring(name) .. ", " .. util.safetostring(param) .. ")")
	end,

	-- Handle UI event
	guiHandleEvent = function (id, name, param)
		if name == "destroy" or name == "hover" or name == "visibilityChange" or name == "trackEnded" then return end
		if name == "builder.apply" or name == "builder.proposalCreate" or name == "builder.rotate" then return end
		if name == "button.click" or name == "toggleButton.toggle" or name == "window.close" then return end
		if name == "camera.keyScroll" or name == "camera.mouseWheel" or name == "camera.mouseRotateTilt" then return end
		if name == "tabWidget.currentChanged" then return end
		

        state.eventsProcessed = state.eventsProcessed + 1
		print("MC guiHandleEvent(id, name, param): (" .. util.safetostring(id) .. ", ".. util.safetostring(name) .. ", " .. util.safetostring(param) .. ")")
	end,
}

return t