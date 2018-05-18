local Projectile = require 'weapons/projectiles/Projectile'
local Bullet = class('Bullet', Projectile)

function Bullet:initialize(weapon, world)
    assert(self.damage)
    Projectile.initialize(self, weapon, world)
end

function Bullet:collide(b)
    b:collideBullet(self, events)
end

function Bullet:collideCharacter(aCharacter)
    aCharacter:collideBullet(self)
end

function Bullet:collidePlatform(Platform)
    self.dead = true
end

function Bullet:collideBullet(aBullet)

end

function Bullet:collidePointerPower(aBullet)

end

function Bullet:collideHealth(aBullet)

end

return Bullet
