local user = class('user')
local defaultBindings = require 'defaultBindings'

function user:initialize(bindings)
    self.bindings = defaultBindings:new()
    self.commands = { direction = 'stopped', jump = false, r = 0, a = false, b = false, c = false, weaponSwitch = 'no' }
end

function user:keypressed(key)
    self.bindings:keypressed( key, commands )
end

function user:mousepressed( x, y, number )
    self.bindings:mousepressed(  x, y, number )
end

function user:getCommands()
    self.bindings:getR(commands)
    self.bindings:getDirection(commands)
    local rval = self.commands
    self.commands = { direction = 'stopped', jump = false, r = 0, a = false, b = false, c = false, weaponSwitch = 'no' }
    return self.commands
end

return user
