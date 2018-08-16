local Projectile = require 'weapons/projectiles/Projectile'
local Bullet = class('Bullet', Projectile)

function Bullet:initialize(barrelDeets, aPlayerId, world)
    assert(self.damage)
    Projectile.initialize(self, barrelDeets, aPlayerId, world)
    Bullet.initCollisions(self)
end

function Bullet:initCollisions()
    hurt = function(self, toHurt)
        toHurt:ouch(self)
        self:kill()
    end

    self.collisions.Character = hurt
    self.collisions.DestroyablePlatform = hurt

    self.collisions.Platform = function(self, aPlatform)
        self:kill()
    end
end

return Bullet
