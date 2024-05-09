local Projectile = require 'weapons/projectiles/Projectile'
local Explosion = require 'weapons/explosions/Explosion'
local ExplosiveProjectile = class('ExplosiveProjectile', Projectile)

function ExplosiveProjectile:initialize(iPosition, aPlayerId)
    Projectile.initialize(self, iPosition, aPlayerId)
    self.replacement = Explosion
end

return ExplosiveProjectile
