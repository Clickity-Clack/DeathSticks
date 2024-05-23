local FreeLookControllable = class('FreeLookControllable')

FreeLookControllable:include(Serializeable)

function FreeLookControllable:initialize(iPosition, aPlayerId)
    Serializeable.initializeMixin(self)
    self.playerId = aPlayerId
    self.movementSpeed = 500
    self.isNull = false
    self.position = {x = iPosition.x, y = iPosition.y}
    self.horizontalDirection = 0
    self.verticalDirection = 0
    self.once = true
end

function FreeLookControllable:getState()
    if self.modified then
        local state = Serializeable.getState(self)
        state.playerId = self.playerId
        return state
    end
end

function FreeLookControllable:reId(state)
    Serializeable.reId(self,state)
end

function FreeLookControllable:unpackState(state, game)
    Serializeable.unpackState(self, state)
end

function FreeLookControllable:fullReport()
    Serializeable.fullReport(self)
end

function FreeLookControllable:update(dt, events)
    self:move(dt)
end

function FreeLookControllable:move(dt)
    local dx = self.movementSpeed * dt * self.horizontalDirection
    local dy = self.movementSpeed * dt * self.verticalDirection
    self.position.x = self.position.x + dx
    self.position.y = self.position.y + dy
end

function FreeLookControllable:draw(cam, id)
    return
end

function FreeLookControllable:drawHud()
    return
end

function FreeLookControllable:acceptCommands(commands)
    if self.once then
        print('FreeLook Commands Accepted')
        print('commands.horizontalDirection: ' .. commands.horizontalDirection .. ', commands.verticalDirection: ' .. commands.verticalDirection)
        self.once = false
    end
    if commands.horizontalDirection == 'left' then
        self.horizontalDirection = -1
    elseif commands.horizontalDirection == 'right' then
        self.horizontalDirection = 1
    else
        self.horizontalDirection = 0
    end
    
    if commands.verticalDirection == 'up' then
        self.verticalDirection = -1
    elseif commands.verticalDirection == 'down' then
        self.verticalDirection = 1
    else
        self.verticalDirection = 0
    end
end

function FreeLookControllable:getCenter()
    return self.position.x, self.position.y
end

function FreeLookControllable:getX()
    return self.position.x
end

function FreeLookControllable:getY()
    return self.position.y
end

function FreeLookControllable:destroy()
    return
end

return FreeLookControllable
