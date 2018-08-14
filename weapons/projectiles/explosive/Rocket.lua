local ExplosiveProjectile = require 'weapons/projectiles/explosive/ExplosiveProjectile'
local Rocket = class('Rocket', ExplosiveProjectile)

function Rocket:initialize(barrelDeets, aPlayerId, world)
    self.speed = 400
    self.image = love.graphics.newImage("res/rocket.png")
    self.shape = love.physics.newRectangleShape(self.image:getHeight()/2, self.image:getWidth()/2)
    self.time = 3
    ExplosiveProjectile.initialize(self, barrelDeets, aPlayerId, world)
    self.body:setGravityScale(0.0001)
    self:initCollisions()
end

function Rocket:update(dt, events)
    self.time = self.time - dt
    if self.time <= 0 then
        self:kill()
    end
    ExplosiveProjectile.update(self, dt, events)
end

function Rocket:initCollisions()
    die = function(self, thing)
        self:kill()
    end
    self.collisions.Platform = die
    self.collisions.Character = function(self, character)
        if(character.playerId ~= self.playerId) then
            self:kill()
        end
    end
end

return Rocket
