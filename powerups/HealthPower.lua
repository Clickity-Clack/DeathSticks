local Powerup = require 'powerups/Powerup'
local HealthPower = class('HealthPower', Powerup)

function HealthPower:initialize( body )
    local image = love.graphics.newImage('res/finger.png')
    Powerup.initialize(self, body, image)
    -- initCollisions(self.collisions)
    self.value = 50
end

function HealthPower:zoop(aHealth)
    self.used = aHealth:heal(self.value)
end

function HealthPower:destroy()
    self.body:destroy()
end

return HealthPower
