local Powerup = require 'powerups/Powerup'
local HealthPower = class('HealthPower', Powerup)
HealthPower.zoopSound = love.audio.newSource('sounds/zoop1.wav', 'static')

function HealthPower:initialize( body )
    local image = love.graphics.newImage('res/healthPowerup.png')
    Powerup.initialize(self, body, image)
    self.value = 50
end

function HealthPower:zoop(aCharacter)
    self.used = aCharacter.health:heal(self.value)
    if self.used then
        love.audio.play(HealthPower.zoopSound)
        self:hide()
    end
end

return HealthPower
