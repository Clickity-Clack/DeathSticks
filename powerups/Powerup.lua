local BodiedPackable = require('handlers/unpacking/BodiedPackable')
local Powerup = class ('Powerup', BodiedPackable)

function Powerup:initialize( body, image )
    self.image = image
    self.shape = love.physics.newRectangleShape(self.image:getHeight(), self.image:getWidth())
    BodiedPackable.initialize(self,body)
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
        self.modified = true
    end
end

function Powerup:draw()
    if self.visible then
        love.graphics.setColorMask()
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw( self.image, self.body:getX() - (self.image:getWidth() * 1.5), self.body:getY() - (self.image:getHeight() * 1.5), 0, 2.5 )
    end
end

function Powerup:used()
    self.body:isActive(false)
    self.delay = 10
end

function Powerup:getState()
    if self.modified then
        local state = BodiedPackable.getState(self)
        state.visible = self.visible
        return state
    end
end

function Powerup:unpackState(state)
    self.visible = state.visible
    BodiedPackable.unpackState(self,state)
end

function Powerup:destroy()
    self.body.destroy()
end

return Powerup
