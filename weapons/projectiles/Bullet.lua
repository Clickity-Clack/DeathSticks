local Projectile = require 'weapons/projectiles/Projectile'
local Bullet = class('Bullet', Projectile)

function Bullet:initialize(weapon, world)
    assert(self.damage)
    Projectile.initialize(self, weapon, world)
    initCollisions(self.collisions)
end

function initCollisions(collisions)
    collisions.Platform = function(self, Platform)
        self.dead = true
    end
end

return Bullet
