local Projectile = require 'weapons/projectiles/Projectile'
local Bullet = class('Bullet', Projectile)

function Bullet:initialize(barrelDeets, aPlayerId, world)
    assert(self.damage)
    Projectile.initialize(self, barrelDeets, aPlayerId, world)
    Bullet.initCollisions(self)
end

function Bullet:initCollisions()
    self.collisions.Character = function(self, aCharacter)
        aCharacter:ouch(self)
        self:kill()
    end

    self.collisions.Platform = function(self, aPlatform)
        self:kill()
    end
end

return Bullet
