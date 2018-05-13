local player = class('player')

function player:initialize( controllable )
    self.id = uuid()
    self.commands = {}
    self.controllable = controllable
    self.controllable:setPlayerId(self.id)
end

function player:getState()
    return { id = self.id, controllableId = self.controllable.id }
end

function player:getX()
    return self.controllable:getX()
end

function player:getY()
    return self.controllable:getY()
end

function player:switchControllable( controllable )
    local oldControllable = self.controllable
    self.controllable = controllable
    return oldControllable
end

return player
