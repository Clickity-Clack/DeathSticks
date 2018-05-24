local Projectile = require 'weapons/projectiles/Projectile'
local Bullet = class('Bullet', Projectile)

function Bullet:initialize(weapon, world)
    assert(self.damage)
    Projectile.initialize(self, weapon, world)
end

function Bullet:doop(aCharacter)
    if self.playerId ~= aCharacter.playerId then
        aCharacter.Health = aCharacter.Health - self.damage
        if aCharacter.Health <= 0 then
            aCharacter.dead = true
            aCharacter.lastBullet = self
        end
        self.dead = true
    end
end

function Bullet:collidePlatform(Platform)
    self.dead = true
end

return Bullet
