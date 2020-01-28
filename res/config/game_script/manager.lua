-- This is required to hook up the manager to the event system.
local manager = require "manager"

function data()
    return manager.script
end
