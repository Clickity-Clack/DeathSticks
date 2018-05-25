local Character = require 'character/Character'
local Packable = require('handlers/unpacking/Packable')
local CharacterControllable = class('CharacterControllable', Packable)

function CharacterControllable:initialize(body)
    Packable.initialize(self)
    self.playerId = nil
    self.character = Character:new(body)
end

function CharacterControllable:setPlayerId(id)
    self.playerId = id
    self.character:setPlayerId(id)
end

function CharacterControllable:getState()
    local state = Packable.getState(self)
    state.character = self.character:getState()
    return state
end

function CharacterControllable:reId(state)
    Packable.reId(self)
    self.character:reId(state.character)
end

function CharacterControllable:unpackState(state)
    Packable.unpackState(self, state)
    self.character:unpackState(state.character)
end

function CharacterControllable:update(dt, events)
    self.character:update(dt, events)
    if self.character.health.dead then
        table.insert(events, { type = 'dead', subject = self })
        self.character.health.dead = false
    end
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
