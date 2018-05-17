local powerup = class 'powerup'

function powerup:initialize( body, image )
    self.id = uuid()
    self.body = body
    self.image = image
    self.shape = love.physics.newRectangleShape(self.image:getHeight(), self.image:getWidth())
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
    self.fixture:setSensor(true)
    self.visible = true

end

function powerup:update()
    if not self.visible then
        self.delay = self.delay - dt
        if self.delay <= 0 then
            self.delay = 0
            self.visible = true
            self.body:isActive(true)
        end
    end
end

function powerup:draw()
    if self.visible then
        love.graphics.setColorMask()
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw( self.image, self.body:getX(), self.body:getY() )
    end
end

function powerup:used()
    self.body:isActive(false)
    self.delay = 10
end

function powerup:getState()
    return { id = self.id, visible = self.visible, bodyDeets = { x = self.body:getX(), y = self.body:getY() } }
end

function powerup:unpackState(state)
    self.isActive = state.active
    self.body:setX(state.bodyDeets.x)
    self.body:setY(state.bodyDeets.y)
end

return powerup
