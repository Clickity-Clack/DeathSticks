local ExplosiveProjectile = require 'weapons/projectiles/explosive/ExplosiveProjectile'
local DeadJetpack = class('DeadJetpack', ExplosiveProjectile)

function DeadJetpack:initialize(barrelDeets, aPlayerId, world)
    self.speed = 0
    self.image = love.graphics.newImage("res/jetpack.png")
    self.shape = love.physics.newRectangleShape(self.image:getHeight()/2, self.image:getWidth()/2)
    ExplosiveProjectile.initialize(self, barrelDeets, aPlayerId, world)
    self:initCollisions()
end

function DeadJetpack:initCollisions()
    die = function(self, thing)
        self:kill()
    end
    self.collisions.Platform = die
end

return DeadJetpack
