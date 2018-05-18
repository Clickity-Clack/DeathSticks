local BodiedPackable = require('handlers/unpacking/BodiedPackable')
local Powerup = class 'Powerup'

function Powerup:initialize( body, image )
    BodiedPackable.initialize(self,body)
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
    local state = BodiedPackable.getState(self)
    state.visible = self.visible
    return state
end

function Powerup:unpackState(state)
    self.isActive = state.active
    BodiedPackable.unpackState(state)
end

return Powerup
