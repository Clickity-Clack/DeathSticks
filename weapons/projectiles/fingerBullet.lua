local fingerBullet = class 'fingerBullet'
local removeEvent = require 'events/removeEvent'

function fingerBullet:initialize( weapon, world )
    self.id = uuid()
    self.playerId = weapon.playerId
    self.body = love.physics.newBody(world, weapon.x, weapon.y, 'dynamic')
    self.body:setAngle(weapon.r)
    self.body:isBullet(true)
    self.speed = 2000
    self.body:setLinearVelocity(self.speed * math.cos(self.body:getAngle()), self.speed * math.sin(self.body:getAngle()))
    self.image = love.graphics.newImage('res/finger.png')
    self.shape = love.physics.newRectangleShape(self.image:getHeight()/2, self.image:getWidth()/2)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setUserData(self)
    self.damage = 10
    self.dead = false
end

function fingerBullet:collide(b)
    b:collideBullet(self, events)
end

function fingerBullet:collideCharacter(aCharacter)
    aCharacter:collideBullet(self)
end

function fingerBullet:collidePlatform(platform)
    self.dead = true
end

function fingerBullet:collideBullet(aBullet)

end

function fingerBullet:collidePointerPower(aBullet)

end

function fingerBullet:collideHealth(aBullet)

end

function fingerBullet:update(dt, events)
    if self.dead then
        table.insert(events, removeEvent:new(self))
    end
end

function fingerBullet:getState()
    return { id = self.id, type = 'projectile', pojectileType = 'fingerBullet', x = self.x, y = self.y, r = self.r }
end

function fingerBullet:reId(state)
    self.id = state.id
end

function fingerBullet:unpackState(state)
    self.x = state.x
    self.y = state.y
    self.r = state.r
end

function fingerBullet:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle())
end

function fingerBullet:destroy()
    self.body:destroy()
end

return fingerBullet
