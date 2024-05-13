local ExplosiveProjectile = require 'weapons/projectiles/explosive/ExplosiveProjectile'
local DeadJetpack = class('DeadJetpack', ExplosiveProjectile)

function DeadJetpack:initialize(iPosition, aPlayerId)
    self.speed = 0
    self.image = love.graphics.newImage("res/jetpack.png")
    self.shape = love.physics.newRectangleShape(self.image:getHeight()/2, self.image:getWidth()/2)
    ExplosiveProjectile.initialize(self, iPosition, aPlayerId)
end

function DeadJetpack:initCollisions()
    self.collisions.Platform = self.die
    self.collisions.DestroyablePlatform = self.die
end

return DeadJetpack
