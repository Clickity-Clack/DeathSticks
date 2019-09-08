local Powerup = class ('Powerup')
Powerup:include(Serializeable)
Powerup:include(Collideable)

function Powerup:initialize( body, image )
    self.image = image
    self.shape = love.physics.newRectangleShape(self.image:getHeight(), self.image:getWidth())
    Serializeable.initializeMixin(self)
    Collideable.initializeMixin(self,body)
    self.fixture:setSensor(true)
    self.visible = true
    Powerup.initCollisions(self)
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
        love.graphics.draw( self.image, self.body:getX() - (self.image:getWidth() * 1.5), self.body:getY() - (self.image:getHeight() * 1.5), 0, self.scale or 2.5 )
    end
end

function Powerup:used()
    self.body:isActive(false)
    self.delay = 10
end

function Powerup:initCollisions()
    self.collisions.Character = function(self, aCharacter)
        -- assert(self, "no self!")
        -- assert(self.class, "no class!")
        -- assert(self.zoop, self.class.name .. " doesn't have a zoop!\r\n" .. serpent.block(self.collisions))
        self:zoop(aCharacter)
    end
end

function Powerup:getState()
    if self.modified then
        local state = Serializeable.getState(self)
        Collideable.getState(self,state)
        state.visible = self.visible
        return state
    end
end

function Powerup:unpackState(state)
    self.visible = state.visible
    Serializeable.unpackState(self,state)
    Collideable.unpackState(self,state)
end

function Powerup:destroy()
    self.body.destroy()
end

return Powerup
