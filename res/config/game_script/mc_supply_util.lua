-- This is required to hook up the manager to the event system.
local mc_supply_util = require "mc_supply_util"

function data()
    return mc_supply_util.script
end
