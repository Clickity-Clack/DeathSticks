local player = class('player')

function player:initialize( controllable )
    self.id = uuid()
    self.commands = { direction = 'stopped', jump = false, r = 0, a = false, b = false, c = false, weaponSwitch = 'no' }
    self.controllable = controllable
    self.controllable:setPlayerId(self.id)
end

function player:update()
    self.controllable:acceptCommands(self.commands)
end

function player:getState()
    return { id = self.id, controllableId = self.controllable.id }
end

function player:getCenter()
    return self.controllable:getCenter()
end

function player:switchControllable( controllable )
    local oldControllable = self.controllable
    self.controllable = controllable
    return oldControllable
end

return player
