local Character = require 'character/Character'

local CharacterControllable = class('CharacterControllable')

function CharacterControllable:initialize(body)
    self.id = uuid()
    self.playerId = nil
    self.character = Character:new(body)
end

function CharacterControllable:setPlayerId(id)
    self.playerId = id
    self.character:setPlayerId(id)
end

function CharacterControllable:getState()
    return { id = self.id, type = 'CharacterControllable', character = self.character:getState() }
end

function CharacterControllable:reId(state)
    self.id = state.id
    self.character.reId(state.character)
end

function CharacterControllable:unpackState(state)
    self.character:unpackState(state.character)
end

function CharacterControllable:update(dt, events)
    self.character:update(dt, events)
end

function CharacterControllable:draw(cam, id)
    self.character:draw(cam, id)
end

function CharacterControllable:drawHud()
    self.character:drawHud()
end

function CharacterControllable:acceptCommands(commands)
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
    self.character:setFiring(commands.a)
end

function CharacterControllable:getCenter()
    return self.character:getCenter()
end

return CharacterControllable
