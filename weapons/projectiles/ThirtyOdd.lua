local Bullet = require 'weapons/projectiles/Bullet'
local ThirtyOdd = class('ThirtyOdd', Bullet)

function ThirtyOdd:initialize( barrelDeets, aPlayerId, world )
    self.speed = 2000
    self.image = love.graphics.newImage('res/bullet.png')
    self.shape = love.physics.newRectangleShape(1, 1)
    self.damage = 45
    Bullet.initialize(self, barrelDeets, aPlayerId, world)
end

return ThirtyOdd
