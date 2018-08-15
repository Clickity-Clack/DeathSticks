local Bullet = require 'weapons/projectiles/Bullet'
local NineMil = class('NineMil', Bullet)

function NineMil:initialize( barrelDeets, aPlayerId, world )
    self.speed = 2000
    self.image = love.graphics.newImage('res/bullet.png')
    self.shape = love.physics.newRectangleShape(1, 1)
    self.damage = 15
    Bullet.initialize(self, barrelDeets, aPlayerId, world)
end

return NineMil
