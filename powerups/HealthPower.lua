local Powerup = require 'powerups/Powerup'
local HealthPower = class('HealthPower', Powerup)

function HealthPower:initialize( body )
    local image = love.graphics.newImage('res/finger.png')
    Powerup.initialize(self, body, image)
    -- initCollisions(self.collisions)
    self.value = 50
end

function HealthPower:zoop(aHealth)
    if aHealth.hp < 100 then
        aHealth.hp = aHealth.hp + self.value - (aHealth.hp + self.value)%100
        self.used = true
    end
end

function HealthPower:destroy()
    self.body.destroy()
end

return HealthPower
