local Powerup = require 'powerups/Powerup'
local PointerPower = class ('PointerPower', Powerup)

function PointerPower:initialize( body )
    local image = love.graphics.newImage('res/finger.png')
    Powerup.initialize(self, body, image)
end

function PointerPower:collide(b)
    b:collidePointerPower(self)
end

function PointerPower:collideCharacter(aCharacter)
    aCharacter:collidePointerPower(self)
end

function PointerPower:collideProjectile(aProjectile)

end

function PointerPower:destroy()
    self.body.destroy()
end

return PointerPower
