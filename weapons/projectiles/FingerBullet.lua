local FingerBullet = class 'FingerBullet'

function FingerBullet:initialize( weapon, world )
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

function FingerBullet:collide(b)
    b:collideBullet(self, events)
end

function FingerBullet:collideCharacter(aCharacter)
    aCharacter:collideBullet(self)
end

function FingerBullet:collidePlatform(Platform)
    self.dead = true
end

function FingerBullet:collideBullet(aBullet)

end

function FingerBullet:collidePointerPower(aBullet)

end

function FingerBullet:collideHealth(aBullet)

end

function FingerBullet:update(dt, events)
    if self.dead then
        table.insert(events, {type = 'dead', subject = self})
        self.dead = false
    end
end

function FingerBullet:getState()
    return { id = self.id, type = 'projectile', pojectileType = 'FingerBullet', x = self.x, y = self.y, r = self.r }
end

function FingerBullet:reId(state)
    self.id = state.id
end

function FingerBullet:unpackState(state)
    self.x = state.x
    self.y = state.y
    self.r = state.r
end

function FingerBullet:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle())
end

function FingerBullet:destroy()
    self.body:destroy()
end

return FingerBullet
