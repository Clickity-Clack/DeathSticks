local Bullet = require 'weapons/projectiles/Bullet'
local Pellet = class('Pellet', Bullet)

function Pellet:initialize( barrelDeets, aPlayerId, world )
    self.speed = 2000
    self.image = love.graphics.newImage('res/bullet.png')
    self.shape = love.physics.newCircleShape(2)
    self.damage = 20
    Bullet.initialize(self, barrelDeets, aPlayerId, world)
end

return Pellet
