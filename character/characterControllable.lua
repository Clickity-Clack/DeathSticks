local character = require 'character/character'

local characterControllable = class('characterControllable')

function characterControllable:initialize(body)
    self.id = uuid()
    self.playerId = nil
    self.character = character:new(body)
end

function characterControllable:setPlayerId(id)
    self.playerId = id
    self.character:setPlayerId(id)
end

function characterControllable:getState()
    return { id = self.id, type = 'characterControllable', character = self.character:getState() }
end

function characterControllable:reId(state)
    self.id = state.id
    self.character.reId(state.character)
end

function characterControllable:unpackState(state)
    self.character:unpackState(state.character)
end

function characterControllable:update(dt, events)
    self.character:update(dt, events)
end

function characterControllable:draw(cam, id)
    self.character:draw(cam, id)
end

function characterControllable:drawHud()
    self.character:drawHud()
end

function characterControllable:acceptCommands(commands)
    if commands.direction == 'left' then
        self.character:walkLeft()
    elseif commands.direction == 'right' then
        self.character:walkRight()
    else
        self.character:stopWalking()
    end

    if commands.jump then
        self.character:jump()
    end

    self.character.weapons.current:setR(commands.r)

    if commands.a then
        self.character:fire()
    end
end

function characterControllable:toggleAnim()
    --return 'toggleAnim'
end

function characterControllable:getCenter()
    return self.character:getCenter()
end

return characterControllable
