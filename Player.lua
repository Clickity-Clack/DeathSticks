local Player = class('Player')

function Player:initialize( controllable )
    self.id = uuid()
    self.commands = { direction = 'stopped', jump = false, r = 0, a = false, b = false, c = false, weaponSwitch = 'no' }
    self.controllable = controllable
    self.controllable:setPlayerId(self.id)
end

function Player:update()
    self.controllable:acceptCommands(self.commands)
end

function Player:getState()
    return { id = self.id, controllableId = self.controllable.id }
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
