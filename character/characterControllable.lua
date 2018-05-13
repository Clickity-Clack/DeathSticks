local character = require 'character/character'

local characterControllable = class('characterControllable')

function characterControllable:initialize(body)
    self.id = uuid()
    self.playerId = nil
    self.character = character:new(body)
    self.pressOperations = { a = self.walkingLeft, d = self.walkingRight, space = self.jump, r = self.toggleAnim }
    self.releaseOperations = { a = self.stopWalking, d = self.stopWalking }
    self.movement = { left = 'walkAction', right = 'walkAction', stopped = 'walkAction', jump = 'jumpAction', fire = 'fireAction' }
    self.direction = 'stopped'
end

function characterControllable:setPlayerId(id)
    self.playerId = id
    self.character:setPlayerId(id)
end

function characterControllable:getState()
    return { id = self.id, type = 'characterController', character = self.character:getState(), direction = self.direction }
end

function characterControllable:reId(state)
    self.id = state.id
    self.character.reId(state.character)
end

function characterControllable:unpackState(state)
    self.direction = state.direction
    self.character:unpackState(state.character)
end

function characterControllable:update(dt, events, cam, id)
    self.character:update(dt, events, cam, id)
end

function characterControllable:draw(cam, id)
    self.character:draw(cam, id)
end

function characterControllable:walkingLeft()
    return self.movement['left'], 'left'
end

function characterControllable:walkingRight()
    return self.movement['right'], 'right'
end

function characterControllable:stopWalking()
    if love.keyboard.isDown('a') then
        return self.movement['left'], 'left'
    elseif love.keyboard.isDown('d') then
        return self.movement['right'], 'right'
    else
        return self.movement['stopped'], 'stopped'
    end
end

function characterControllable:jump()
    return self.movement['jump'], 'jump'
end

function characterControllable:toggleAnim()
    --return 'toggleAnim'
end

function characterControllable:mousepressed()
    return self.movement['fire'], 'fire'
end

function characterControllable:keypressed( key, scancode, isrepeat )
    operation = self.pressOperations[key]
    if operation ~= nil then
        return self.pressOperations[key](self)
    end
end

function characterControllable:keyreleased( key, scancode, isrepeat )
    operation = self.releaseOperations[key]
    if operation ~= nil then
         return self.releaseOperations[key](self)
    end
end

function characterControllable:getX()
    return self.character:getX()
end

function characterControllable:getY()
    return self.character:getY()
end

return characterControllable
