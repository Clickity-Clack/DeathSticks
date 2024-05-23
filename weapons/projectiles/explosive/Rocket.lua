local ExplosiveProjectile = require 'weapons/projectiles/explosive/ExplosiveProjectile'
local Rocket = class('Rocket', ExplosiveProjectile)

function Rocket:initialize(iPosition, aPlayerId)
    self.speed = 200
    self.image = love.graphics.newImage("res/rocket.png")
    self.shape = love.physics.newRectangleShape(self.image:getHeight()/2, self.image:getWidth()/2)
    self.time = 1
    self.scale = 2
    self.timeAlive = 0
    ExplosiveProjectile.initialize(self, iPosition, aPlayerId)
    self.body:setGravityScale(0.0001)
    Rocket.initCollisions(self)
end

function Rocket:update(dt, events)
    self.time = self.time - dt
    self.timeAlive = self.timeAlive + dt
    if self.time <= 0 then
        self:kill()
    end
    self:updateSpeed(self.speed  * (1 + (self.timeAlive * 1)))
    ExplosiveProjectile.update(self, dt, events)
end

return Rocket

