local pointerPower = class 'pointerPower'

function pointerPower:initialize( body )
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

function pointerPower:update(dt, events)
    if self.used then
        self.body:isActive(false)
    end
end

function pointerPower:getState()
    return { id = self.id, used = self.used, bodyDeets = { x = self.body:getX(), y = self.body:getY() } }
end

function pointerPower:draw()
    if not self.used then
        love.graphics.draw( self.image, self.body:getX(), self.body:getY() )
    end
end

function pointerPower:collide(b)
    b:collidePointerPower(self)
end

function pointerPower:collideCharacter(aCharacter)
    aCharacter:collidePointerPower(self)
end

function pointerPower:collideProjectile(aProjectile)

end

function pointerPower:destroy()
    self.body.destroy()
end

return pointerPower
