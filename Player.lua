local Packable = require'handlers/unpacking/Packable'
local Player = class('Player')

function Player:initialize( controllable )
    Packable.initialize(self)
    self.commands = { direction = 'stopped', jump = false, r = 0, a = false, b = false, c = false, weaponSwitch = 'no' }
    self.controllable = controllable
    self.controllable:setPlayerId(self.id)
end

function Player:update()
    self.controllable:acceptCommands(self.commands)
end

function Player:getState()
    local state = Packable.getState(self)
    state.controllableId = self.controllable.id
    return state
end

function Player:unpackState(state)
    self.controllableId = state.controllableId
    Packable.unpackState(self,state)
end

function Player:getCenter()
    return self.controllable:getCenter()
end

function Player:switchControllable( controllable )
    local oldControllable = self.controllable
    self.controllable = controllable
    return oldControllable
end

return Player
