local Projectile = require 'weapons/projectiles/Projectile'
local Bullet = class('Bullet', Projectile)

function Bullet:initialize(barrelDeets, aPlayerId, world)
    assert(self.damage)
    Projectile.initialize(self, barrelDeets, aPlayerId, world)
    initCollisions(self.collisions)
end

function initCollisions(collisions)
    collisions.Platform = function(self, Platform)
        self:kill()
    end
end

return Bullet
