local powerup = require 'powerups/powerup'
local pointerPower = class ('pointerPower', powerup)

function pointerPower:initialize( body )
    local image = love.graphics.newImage('res/finger.png')
    powerup.initialize(self, body, image)
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
