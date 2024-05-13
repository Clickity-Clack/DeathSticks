local ExplosiveProjectile = require 'weapons/projectiles/explosive/ExplosiveProjectile'
local Rocket = class('Rocket', ExplosiveProjectile)

function Rocket:initialize(iPosition, aPlayerId)
    self.speed = 400
    self.image = love.graphics.newImage("res/rocket.png")
    self.shape = love.physics.newRectangleShape(self.image:getHeight()/2, self.image:getWidth()/2)
    self.time = 3
    self.scale = 2
    ExplosiveProjectile.initialize(self, iPosition, aPlayerId)
    self.body:setGravityScale(0.0001)
    Rocket.initCollisions(self)
end

function Rocket:update(dt, events)
    self.time = self.time - dt
    if self.time <= 0 then
        self:kill()
    end
    ExplosiveProjectile.update(self, dt, events)
end

return Rocket
