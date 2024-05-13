local Projectile = require 'weapons/projectiles/Projectile'
local Explosion = require 'weapons/explosions/Explosion'
local ExplosiveProjectile = class('ExplosiveProjectile', Projectile)

function ExplosiveProjectile:initialize(iPosition, aPlayerId)
    Projectile.initialize(self, iPosition, aPlayerId)
    self.replacement = Explosion
    ExplosiveProjectile.initCollisions(self)
end

function ExplosiveProjectile:initCollisions()
    self.collisions.Platform = self.die
    self.collisions.DestroyablePlatform = self.die
    self.collisions.Character = self.die
end

return ExplosiveProjectile
