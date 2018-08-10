local DynamicBodiedPackable = require('handlers/unpacking/DynamicBodiedPackable')
local Projectile = class('Projectile', DynamicBodiedPackable)

function Projectile:initialize(barrelDeets, aPlayerId, world)
    assert (self.speed)
    assert (self.shape)
    assert (self.image)
    DynamicBodiedPackable.initialize(self, love.physics.newBody(world, barrelDeets.x, barrelDeets.y, 'dynamic'))
    self.body:setAngle(barrelDeets.r)
    self.body:isBullet(true)
    self.body:setLinearVelocity(self.speed * math.cos(self.body:getAngle()), self.speed * math.sin(self.body:getAngle()))
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setUserData(self)
    self.fixture:setGroupIndex(-2)
    self.dead = false
    self.playerId = aPlayerId
    Projectile.initCollisions(self)
end

function Projectile:update(dt, events)
    DynamicBodiedPackable.update(self)
    if self.dead then
        table.insert(events, {type = 'dead', subject = self})
        self.dead = false
    end
end

function Projectile:getState()
    local state = DynamicBodiedPackable.getState(self)
    state.bodyDeets.angle = self.body:getAngle()
    state.playerId = self.playerId
    return state
end

function Projectile:unpackState(state)
    self.body:setAngle(state.bodyDeets.angle)
    self.playerId = state.playerId
    DynamicBodiedPackable.unpackState(self, state)
end

function Projectile:initCollisions()
    self.collisions.Bottom = function(self, Bottom)
        print("yo")
        self:kill()
    end
end

function Projectile:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle())
end

function Projectile:kill()
    self.dead = true
    self.modified = true
end

function Projectile:destroy()
    self.body:destroy()
end

return Projectile
