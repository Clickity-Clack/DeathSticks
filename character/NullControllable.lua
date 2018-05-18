local Packable = require('handlers/unpacking/Packable')
local NullControllable = class('NullControllable')

function NullControllable:initialize()
    Packable.initialize(self)
    self.playerId = nil
end


function NullControllable:setPlayerId(id)
    self.playerId = id
end

function NullControllable:getState()
    return Packable.getState(self)
end

function NullControllable:reId(state)
    Packable.reId(self)
end

function NullControllable:unpackState(state)
    Packable.unpackState(self, state)
end

function NullControllable:update(dt, events, cam, id)
end

function NullControllable:draw(cam, id)
end

function NullControllable:drawHud()
end

function NullControllable:walkingLeft()
end

function NullControllable:walkingRight()
end

function NullControllable:stopWalking()
end

function NullControllable:jump()
end

function NullControllable:toggleAnim()
end

function NullControllable:mousepressed()
end

function NullControllable:keypressed( key, scancode, isrepeat )
end

function NullControllable:keyreleased( key, scancode, isrepeat )
end

function NullControllable:getX()
    return 0
end

function NullControllable:getY()
    return 0
end

return NullControllable
