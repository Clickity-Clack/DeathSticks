local ExplosiveProjectile = require 'weapons/projectiles/explosive/ExplosiveProjectile'
local Grenade = class('Grenade', ExplosiveProjectile)

function Grenade:initialize(barrelDeets, aPlayerId, world)
    self.speed = 650
    self.image = love.graphics.newImage("res/grenade.png")
    self.shape = love.physics.newCircleShape(5)
    self.time = 1.5
    self.scale = 2
    ExplosiveProjectile.initialize(self, barrelDeets, aPlayerId, world)
    self.fixture:setRestitution(0.9)
    self:initCollisions()
end

function Grenade:update(dt, events)
    self.time = self.time - dt
    if self.time <= 0 then
        self:kill()
    end
    ExplosiveProjectile.update(self, dt, events)
end

return Grenade
