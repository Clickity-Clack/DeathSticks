local Weapon = require('weapons/Weapon')
local Sniper = class('Sniper', Weapon)
local ThirtyOdd = require 'weapons/projectiles/ThirtyOdd'

function Sniper:initialize(aPlayerId)
    self.projectile = ThirtyOdd
    self.x = 0
    self.y = 0
    self.ox = 6
    self.oy = 8
    self.r = 0
    self.scale = 2
    self.barrelLen = 30
    self.ammo = 10
    self.capacity = 30
    self.rof = 1
    self.sound = love.audio.newSource('sounds/pa-kew.wav', 'static')
    Weapon.initialize(self, aPlayerId)
end

Sniper.image = love.graphics.newImage('res/Sniper.png')

return Sniper
