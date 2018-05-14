local nullControllable = class('nullControllable')

function nullControllable:initialize(body)
    self.id = uuid()
    self.playerId = nil
end


function characterControllable:setPlayerId(id)
    self.playerId = id
end

function characterControllable:getState()
    return { id = self.id, type = 'nullControllable' }
end


function characterControllable:reId(state)
    self.id = state.id
end

function characterControllable:unpackState(state)
end

function characterControllable:update(dt, events, cam, id)
end

function characterControllable:draw(cam, id)
end

function characterControllable:drawHud()
end

function characterControllable:walkingLeft()
end

function characterControllable:walkingRight()
end

function characterControllable:stopWalking()
end

function characterControllable:jump()
end

function characterControllable:toggleAnim()
end

function characterControllable:mousepressed()
end

function characterControllable:keypressed( key, scancode, isrepeat )
end

function characterControllable:keyreleased( key, scancode, isrepeat )
end

function characterControllable:getX()
    return 0
end

function characterControllable:getY()
    return 0
end

return nullControllable
