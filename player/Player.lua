local NullControllable = require 'character/NullControllable'
local Player = class('Player')
Player:include(Serializeable)

function Player:initialize( controllable, team )
    Serializeable.initializeMixin(self)
    self.commands = { direction = 'stopped', jump = false, r = 0, a = false, b = false, c = false, weaponSwitch = 'no' }
    self.controllable = controllable or NullControllable()
    self.team = team
end

function Player:update()
    self.controllable:acceptCommands(self.commands)
end

function Player:getState()
    if self.modified then
        local state = Serializeable.getState(self)
        state.controllableId = self.controllable.id
        return state
    end
end

function Player:unpackState(state, game)
    self.controllable = game.stems[state.controllableId]
    Serializeable.unpackState(self,state)
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
