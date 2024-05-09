local Projectile = require 'weapons/projectiles/Projectile'
local Bullet = class('Bullet', Projectile)

function Bullet:initialize(iPosition, aPlayerId)
    assert(self.damage)
    Projectile.initialize(self, iPosition, aPlayerId)
    Bullet.initCollisions(self)
end

function Bullet:initCollisions()
    hurt = function(self, toHurt)
        toHurt:ouch(self)
        self:kill()
    end

    self.collisions.Character = hurt
    self.collisions.DestroyablePlatform = hurt
    self.collisions.TeamBase = hurt

    self.collisions.Platform = function(self, aPlatform)
        self:kill()
    end
end

return Bullet
