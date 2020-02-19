local util = require("util")
local lib = {}
local visited = {}
local listeners = {}

-- Add a function that needs to be called whenever an entity of the specified type 
-- is placed or loaded from a save
lib.track = function(type, fn)
	if listeners[type] == nil then
		listeners[type] = {}
	end
	local list = listeners[type]
	list[#list + 1] = fn
end

lib.script = {

	-- Iterate through all entities to check if there are any new ones.
	-- There should be more efficient ways of doing this, but so far
	-- this is the only robust way I have found.
	update = function() 
		for key, list in pairs(listeners) do
			local ids = game.interface.getEntities({ radius = 10e100 }, { type = key })
			for _, id in ipairs(ids) do
				if visited[id] == nil then
					visited[id] = true
					local entity = game.interface.getEntity(id)
					for _, fn in ipairs(list) do
						fn(entity)
					end
				end
			end
		end
	end
	
}

return lib