local NullControllable = class('NullControllable', Packable)

function NullControllable:initialize(body)
    Packable.initialize(self)
    self.playerId = nil
end

function NullControllable:setPlayerId(id)
    self.playerId = id
end

function NullControllable:update(dt, events)
end

function NullControllable:draw(cam, id)
end

function NullControllable:drawHud()
end

function NullControllable:acceptCommands(commands)
end

function NullControllable:getCenter()
    return 0,0
end

return NullControllable
