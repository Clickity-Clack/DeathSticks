local Bullet = require 'weapons/projectiles/Bullet'
local Pellet = class('Pellet', Bullet)

function Pellet:initialize( iPosition, aPlayerId )
    self.speed = 2000
    self.image = love.graphics.newImage('res/bullet.png')
    self.shape = love.physics.newCircleShape(2)
    self.damage = 5
    self.scale = 1.5
    Bullet.initialize(self, iPosition, aPlayerId)
end

return Pellet
