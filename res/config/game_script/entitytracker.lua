-- This is required to hook up the manager to the event system.
local entitytracker = require "entitytracker"

function data()
    return entitytracker.script
end
