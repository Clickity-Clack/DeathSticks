local NullControllable = class('NullControllable')

function NullControllable:initialize(body)
    self.id = uuid()
    self.playerId = nil
end


function NullControllable:setPlayerId(id)
    self.playerId = id
end

function NullControllable:getState()
    return { id = self.id, type = 'NullControllable' }
end

function NullControllable:reId(state)
    self.id = state.id
end

function NullControllable:unpackState(state)
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
