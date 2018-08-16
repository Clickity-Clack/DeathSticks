local Character = require 'character/Character'
local Packable = require('handlers/unpacking/Packable')
local CharacterControllable = class('CharacterControllable', Packable)
local spawnSound = love.audio.newSource('sounds/weow.wav', 'static')

function CharacterControllable:initialize(body, aPlayerId)
    Packable.initialize(self)
    self.playerId = aPlayerId
    self.character = Character:new(body,self.playerId)
    self.isNull = false
    love.audio.play(spawnSound)
end

function CharacterControllable:getState()
    if self.modified then
        local state = Packable.getState(self)
        state.playerId = self.playerId
        state.character = self.character:getState()
        return state
    end
end

function CharacterControllable:reId(state)
    Packable.reId(self,state)
    self.character:reId(state.character)
end

function CharacterControllable:unpackState(state, game)
    Packable.unpackState(self, state)
    self.playerId = state.playerId
    self.character:unpackState(state.character, game)
end

function CharacterControllable:fullReport()
    Packable.fullReport(self)
    self.character:fullReport()
end

function CharacterControllable:update(dt, events)
    self.character:update(dt, events)
    if self.character.health.dead then
        table.insert(events, { type = 'dead', subject = self, killer = self.character.health.killer })
        self.character.health.dead = false
    end
    self.modified = self.modified or self.character.modified
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

    if commands.weaponSwitch == 'next' then
        self.character.weapons:nextWeapon()
    end

    self.character.weapons.current:setR(commands.r)
    self.character:setFiring(commands.a)
    self.character:setBlasting(commands.c)
end

function CharacterControllable:getCenter()
    return self.character:getCenter()
end

function CharacterControllable:getX()
    return self.character:getX()
end

function CharacterControllable:getY()
    return self.character:getY()
end

function CharacterControllable:destroy()
    self.character:destroy()
end

return CharacterControllable
