local vec3 = require "vec3"
local util = require "util"
local industryutil = require "industryutil"
local entitytracker = require "entitytracker"

local lib = {
    entities = {},
    stationTypes = {}
}

-- State that will be persisted in the save game
local state = {
    -- vehicle state
    vehicles = {},
    -- supply station state
    stations = {},
}

-- Enables supply station functionality on an industry
-- parms = {  
--    inputs = { COAL = 1 },
--    demand = 20,
-- }   
lib.makeSupplyStation = function(name, fileName, constr, generatedData)
    local parms = constr.mcSupplyStation
    local stockListConfig = {
        stocks = {},
        rule = { input = { {} }, output = {}, capacity = parms.demand },
    }

    local n = 1
    for type, amount in pairs(parms.inputs) do
        stockListConfig.stocks[n] = type
        stockListConfig.rule.input[1][n] = amount
        n = n + 1
    end
    industryutil.addIndustryData(name, "a", generatedData, constr, stockListConfig)
end

lib.registerSupplyStationType = function(fileName)
    lib.stationTypes[fileName] = true
end

local getVehicleTypeData = function(fileName, data)
    if (string.find(fileName, "vehicle") == nil) then return end
    if data.metadata then 
        if data.metadata.railVehicle then
            return {
                weight = data.metadata.railVehicle.weight,
                topSpeed = data.metadata.railVehicle.topSpeed
            }
        end
    end
    return nil
end

lib.registerVehicleType = function(fileName, data)
    local supplyData = getVehicleTypeData(fileName, data)
    if supplyData ~= nil then
        -- print("Found supply vehicle data " .. fileName)
        -- print("supply data")
        -- print(util.indentedlua(supplyData))
        -- print("")
        -- print("data")
        -- print(util.indentedlua(data.metadata))
        -- print("")
    end
end

lib.isSupplyStation = function(entity)
    return lib.stationTypes[entity.fileName] ~= nil
end

lib.isSupplyVehicle = function(entity)
    return true
end

lib.setup = function() 
    entitytracker.track("CONSTRUCTION", function(entity)
        if lib.isSupplyStation(entity) then
            print("Found supply station with id " .. entity.id)
            print(util.indentedlua(entity))
            lib.entities[entity.id] = entity
            if state.stations[entity.id] == nil then
                state.stations[entity.id] = {}
            end

            print(util.indentedlua(lib.stationTypes))
        end
    end)

    entitytracker.track("VEHICLE", function(entity)
        if lib.isSupplyVehicle(entity) then
            print("Found vehicle that needs resupply with id " .. entity.id)
            print(util.indentedlua(entity))
            lib.entities[entity.id] = entity
            if state.vehicles[entity.id] == nil then
                state.vehicles[entity.id] = {}
            end
        end
    end)

end

lib.script = {

    init = function() 
	end,

	guiInit = function() 
	end,

	-- Return state that will be serialized in the save game
    save = function()
        return {} -- Don't save any state yet
		--return state
    end,
    
    	-- Load state that was deserialized from the save game
	load = function(loadedstate)
		state = loadedstate or state
	end,

    update = function() 
        for id, vehicleState in pairs(state.vehicles) do
            local vehicle = game.interface.getVehicle(id)
            local position = vec3.new(table.unpack(vehicle.position))
            if vehicleState.lastPosition == nil then
                -- Set initial range
                vehicleState.range = 100

                print(util.indentedlua(vehicle))
            else
                local traveled = vec3.distance(vehicleState.lastPosition, position)
                vehicleState.range = vehicleState.range - traveled
                if vehicleState.range < 0 then
                    vehicle.speed = 0
                end
            end
            vehicleState.lastPosition = position

        end
    end,

    guiUpdate = function()
    end,
    
    handleEvent = function (src, id, name, param)
    end

}

return lib