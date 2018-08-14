local Projectile = require 'weapons/projectiles/Projectile'
local Explosion = require 'weapons/explosions/Explosion'
local ExplosiveProjectile = class('ExplosiveProjectile', Projectile)

function ExplosiveProjectile:initialize(barrelDeets, aPlayerId, world)
    Projectile.initialize(self, barrelDeets, aPlayerId, world)
    self.replacement = Explosion
end

return ExplosiveProjectile
