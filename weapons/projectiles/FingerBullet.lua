local Bullet = require 'weapons/projectiles/Bullet'
local FingerBullet = class('FingerBullet', Bullet)

function FingerBullet:initialize( barrelDeets, aPlayerId, world )
    self.speed = 2000
    self.image = love.graphics.newImage('res/finger.png')
    self.shape = love.physics.newRectangleShape(self.image:getHeight()/2, self.image:getWidth()/2)
    self.damage = 10
    Bullet.initialize(self, barrelDeets, aPlayerId, world)
end

return FingerBullet
