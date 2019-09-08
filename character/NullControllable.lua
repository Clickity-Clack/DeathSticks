local NullControllable = class('NullControllable')
NullControllable:include(Serializeable)

function NullControllable:initialize(body)
    Serializeable.initializeMixin(self)
    self.playerId = nil
    self.isNull = true
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

function NullControllable:destroy()
end

return NullControllable
