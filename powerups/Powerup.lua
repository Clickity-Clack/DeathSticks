local Powerup = class 'Powerup'

function Powerup:initialize( body, image )
    self.id = uuid()
    self.body = body
    self.image = image
    self.shape = love.physics.newRectangleShape(self.image:getHeight(), self.image:getWidth())
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
    self.fixture:setSensor(true)
    self.visible = true

end

function Powerup:update()
    if not self.visible then
        self.delay = self.delay - dt
        if self.delay <= 0 then
            self.delay = 0
            self.visible = true
            self.body:isActive(true)
        end
    end
end

function Powerup:draw()
    if self.visible then
        love.graphics.setColorMask()
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw( self.image, self.body:getX(), self.body:getY() )
    end
end

function Powerup:used()
    self.body:isActive(false)
    self.delay = 10
end

function Powerup:getState()
    return { id = self.id, visible = self.visible, bodyDeets = { x = self.body:getX(), y = self.body:getY() } }
end

function Powerup:unpackState(state)
    self.isActive = state.active
    self.body:setX(state.bodyDeets.x)
    self.body:setY(state.bodyDeets.y)
end

return Powerup