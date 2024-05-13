local Projectile = require 'weapons/projectiles/Projectile'
local Bullet = class('Bullet', Projectile)

function Bullet:initialize(iPosition, aPlayerId)
    assert(self.damage)
    Projectile.initialize(self, iPosition, aPlayerId)
    Bullet.initCollisions(self)
end

function Bullet:initCollisions()
    self.collisions.Character = self.hurt
    self.collisions.DestroyablePlatform = self.hurt
    self.collisions.TeamBase = self.hurt
    self.collisions.Platform = self.die
end

return Bullet
