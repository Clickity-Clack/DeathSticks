local powerup = require 'powerups/powerup'
local health = class('health', powerup)

function health:initialize( body )
    local image = love.graphics.newImage('res/finger.png')
    powerup.initialize(self, body, image)
    self.value = 50
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
