local user = class('user')
local defaultBindings = require 'defaultBindings'

function user:initialize(player)
    self.bindings = defaultBindings:new()
    self.commands = { direction = 'stopped', jump = false, r = 0, a = false, b = false, c = false, weaponSwitch = 'no' }
    self.player = player
end

function user:draw()

end

function user:keypressed(key)
    self.bindings:keypressed( key, self.commands )
end

function user:mousepressed( x, y, number )
    self.bindings:mousepressed(  x, y, number, self.commands )
end

function user:getCommands()
    self.bindings:currently(self.commands)
    local rval = self.commands
    self.commands = { direction = 'stopped', jump = false, r = 0, a = false, b = false, c = false, weaponSwitch = 'no' }
    return rval
end

return user
