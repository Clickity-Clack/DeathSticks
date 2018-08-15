local Weapon = require('weapons/Weapon')
local Shotgun = class('Shotgun', Weapon)
local Twelve = require 'weapons/projectiles/multishot/Twelve'

function Shotgun:initialize(aPlayerId)
    self.projectile = Twelve
    self.x = 0
    self.y = 0
    self.ox = 8
    self.oy = 10
    self.r = 0
    self.scale = 2
    self.barrelLen = 30
    self.ammo = 10
    self.capacity = 30
    self.rof = 1
    self.sound = love.audio.newSource('sounds/reverbbang.wav', 'static')
    Weapon.initialize(self, aPlayerId)
end

Shotgun.image = love.graphics.newImage('res/shotgun.png')

return Shotgun
