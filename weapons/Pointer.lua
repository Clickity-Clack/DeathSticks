local Weapon = require('weapons/Weapon')
local Pointer = class('Pointer', Weapon)
local FingerBullet = require 'weapons/projectiles/FingerBullet'

function Pointer:initialize()
    self.projectile = FingerBullet
    self.x = 0
    self.y = 0
    self.ox = 8
    self.oy = 10
    self.r = 0
    self.scale = 2
    self.ammo = 10
    self.capacity = 30
    self.rof = 0.5
    self.sound = love.audio.newSource('sounds/you.mp3', 'static')
    Weapon.initialize(self)
end

Pointer.image = love.graphics.newImage('res/finger.png')

return Pointer
