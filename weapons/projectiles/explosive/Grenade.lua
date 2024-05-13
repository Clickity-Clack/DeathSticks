local ExplosiveProjectile = require 'weapons/projectiles/explosive/ExplosiveProjectile'
local Grenade = class('Grenade', ExplosiveProjectile)

function Grenade:initialize(iPosition, aPlayerId)
    self.speed = 850
    self.image = love.graphics.newImage("res/grenade.png")
    self.shape = love.physics.newCircleShape(2.5)--, 1.25)
    self.time = 1.5
    self.scale = 4
    ExplosiveProjectile.initialize(self, iPosition, aPlayerId)
    self.fixture:setRestitution(0.9)
    self.body:setGravityScale(2)
    self.body:setInertia(1.75)
    Grenade.initCollisions(self)
end

function Grenade:update(dt, events)
    self.time = self.time - dt
    if self.time <= 0 then
        self:kill()
    end
    ExplosiveProjectile.update(self, dt, events)
end

function Grenade:initCollisions()
    self.collisions.Platform = nil
    self.collisions.DestroyablePlatform = nil
    self.collisions.Character = self.die
end

return Grenade
