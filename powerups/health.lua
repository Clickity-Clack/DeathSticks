local health = class 'health'

function health:initialize( body )
    self.id = uuid()
    self.body = body
    self.image = love.graphics.newImage('res/finger.png')
    self.shape = love.physics.newRectangleShape(self.image:getHeight(), self.image:getWidth())
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
    self.fixture:setSensor(true)
    self.spawned = true
    self.value = 50
    self.used = false
end

function health:update(dt, events)
    if self.used then
        self.body:isActive(false)
    end
end

function health:draw()
    if not self.used then
        love.graphics.draw( self.image, self.body:getX(), self.body:getY() )
    end
end

function health:collide(b)
    b:collideHealth(self)
end

function health:collideCharacter(aCharacter)
    aCharacter:collideHealth(self)
end

function health:collideProjectile(aProjectile)

end

function health:destroy()
    self.body.destroy()
end

return health
