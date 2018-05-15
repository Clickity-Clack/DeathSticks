local health = class 'health'

function health:initialize( body )
    self.id = uuid()
    self.body = body
    self.image = love.graphics.newImage('res/finger.png')
    self.shape = love.physics.newRectangleShape(self.image:getHeight(), self.image:getWidth())
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
    self.fixture:setSensor(true)
    self.visible = true
    self.value = 50
    self.used = false
end

function health:update(dt, events)
    if not self.visible then
        self.delay = self.delay - dt
        if self.delay <= 0 then
            self.delay = 0
            self.visible = true
            self.body:isActive(true)
        end
    end
end

function health:used()
    self.body:isActive(false)
    self.delay = 10
end

function health:draw()
    if self.visible then
        love.graphics.setColorMask()
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw( self.image, self.body:getX(), self.body:getY() )
    end
end

function health:collide(b)
    if self.visible then
        b:collideHealth(self)
    end
end

function health:collideCharacter(aCharacter)
    if self.visible then
        aCharacter:collideHealth(self)
    end
end

function health:collideProjectile(aProjectile)

end

function health:destroy()
    self.body.destroy()
end

return health
