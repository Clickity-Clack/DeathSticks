local Bullet = require 'weapons/projectiles/Bullet'
local ThirtyOdd = class('ThirtyOdd', Bullet)

function ThirtyOdd:initialize( weapon, world )
    self.speed = 2000
    self.image = love.graphics.newImage('res/bullet.png')
    self.shape = love.physics.newRectangleShape(1, 1)
    self.damage = 50
    Bullet.initialize(self, weapon, world)
end

return ThirtyOdd
