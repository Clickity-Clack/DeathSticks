local Projectile = class('Projectile')
Projectile:include(Serializeable)
Projectile:include(Collideable)
Projectile:include(DynamicCollideable)

function Projectile:initialize(iPosition, aPlayerId)
    assert (self.speed)
    assert (self.shape)
    assert (self.image)
    Serializeable.initializeMixin(self)
    Collideable.initializeMixin(self, iPosition, 'dynamic')
    DynamicCollideable.initializeMixin(self)
    self.body:setAngle(iPosition.rotation)
    self.body:isBullet(true)
    self.body:setLinearVelocity(self.speed * math.cos(self.body:getAngle()), self.speed * math.sin(self.body:getAngle()))
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setUserData(self)
    self.fixture:setGroupIndex(-2)
    self.imageOffset = self.imageOffset or {x=8,y=8}
    self.dead = false
    self.playerId = aPlayerId
    Projectile.initCollisions(self)
end

function Projectile:update(dt, events)
    DynamicCollideable.update(self)
    if self.dead then
        table.insert(events, {type = 'dead', subject = self})
        self.dead = false
    end
end

function Projectile:getState()
    local state = Serializeable.getState(self)
    Collideable.getState(self, state)
    DynamicCollideable.getState(self, state)
    state.position.angle = self.body:getAngle()
    state.playerId = self.playerId
    return state
end

function Projectile:unpackState(state)
    self.body:setAngle(state.position.angle)
    self.playerId = state.playerId
    Serializeable.unpackState(self)
    Collideable.unpackState(self, state)
    DynamicCollideable.unpackState(self, state)
end

function Projectile:initCollisions()
    self.collisions.Bottom = function(self, Bottom)
        self:kill()
    end
end

function Projectile:draw()
    love.graphics.setColor(1,1,1)
    local scale = self.scale or 2
    local anx, ay = doTrig(self.body:getX(), self.body:getY(), self.body:getAngle())
    love.graphics.draw(self.image, anx, ay, self.body:getAngle(), scale, scale, self.imageOffset.x, self.imageOffset.y)
end

function doTrig(x,y,r,len)
    len = len or 0
    local anx, ay = x, y
    anx = anx + len * math.cos(r)
    ay = ay + len * math.sin(r)
    return anx, ay
end

function Projectile:kill()
    self.dead = true
    self.modified = true
end

function Projectile:die(thing)
    self:kill()
end

function Projectile:hurt(toHurt)
    toHurt:ouch(self)
    self:kill()
end

function Projectile:destroy()
    self.body:destroy()
end

return Projectile
