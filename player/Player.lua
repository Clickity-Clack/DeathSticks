local Packable = require'handlers/unpacking/Packable'
local NullControllable = require 'character/NullControllable'
local Player = class('Player', Packable)

function Player:initialize( controllable )
    Packable.initialize(self)
    self.commands = { direction = 'stopped', jump = false, r = 0, a = false, b = false, c = false, weaponSwitch = 'no' }
    self.controllable = controllable or NullControllable()
end

function Player:update()
    self.controllable:acceptCommands(self.commands)
end

function Player:getState()
    if self.modified then
        local state = Packable.getState(self)
        state.controllableId = self.controllable.id
        return state
    end
end

function Player:unpackState(state, game)
    self.controllable = game.stems[state.controllableId]
    Packable.unpackState(self,state)
end

function Player:getCenter()
    return self.controllable:getCenter()
end

function Player:switchControllable( controllable )
    local oldControllable = self.controllable
    self.controllable = controllable
    self.modified = true
    return oldControllable
end

return Player
