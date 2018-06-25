local Powerup = require 'powerups/Powerup'
local HealthPower = class('HealthPower', Powerup)

function HealthPower:initialize( body )
    local image = love.graphics.newImage('res/healthPowerup.png')
    Powerup.initialize(self, body, image)
    self.value = 50
end

function HealthPower:zoop(aHealth)
    self.used = aHealth:heal(self.value)
end

return HealthPower
