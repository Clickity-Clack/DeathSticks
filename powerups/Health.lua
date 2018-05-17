local Powerup = require 'powerups/Powerup'
local Health = class('Health', Powerup)

function Health:initialize( body )
    local image = love.graphics.newImage('res/finger.png')
    Powerup.initialize(self, body, image)
    self.value = 50
end

function Health:collide(b)
    if self.visible then
        b:collideHealth(self)
    end
end

function Health:collideCharacter(aCharacter)
    if self.visible then
        aCharacter:collideHealth(self)
    end
end

function Health:collideProjectile(aProjectile)

end

function Health:destroy()
    self.body.destroy()
end

return Health
