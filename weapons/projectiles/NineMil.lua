local Bullet = require 'weapons/projectiles/Bullet'
local NineMil = class('NineMil', Bullet)

function NineMil:initialize( iPosition, aPlayerId )
    self.speed = 2000
    self.image = love.graphics.newImage('res/bullet.png')
    self.shape = love.physics.newRectangleShape(1, 1)
    self.damage = 10
    Bullet.initialize(self, iPosition, aPlayerId)
end

return NineMil
