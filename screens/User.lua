local User = class('User')
local DefaultBindings = require 'screens/DefaultBindings'

function User:initialize(player)
    self.bindings = DefaultBindings:new()
    self.commands = { direction = 'stopped', jump = false, r = 0, a = false, b = false, c = false, weaponSwitch = 'no' }
    self.player = player
end

function User:draw()

end

function User:keypressed(key)
    self.bindings:keypressed( key, self.commands )
end

function User:mousepressed( x, y, number )
    self.bindings:mousepressed(  x, y, number, self.commands )
end

function User:getCommands()
    self.bindings:currently(self.commands)
    local rval = self.commands
    self.commands = { direction = 'stopped', jump = false, r = 0, a = false, b = false, c = false, weaponSwitch = 'no' }
    return rval
end

return User
