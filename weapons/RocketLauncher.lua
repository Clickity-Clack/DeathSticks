local Weapon = require('weapons/Weapon')
local RocketLauncher = class('RocketLauncher', Weapon)
local Rocket = require 'weapons/projectiles/explosive/Rocket'

function RocketLauncher:initialize(aPlayerId)
    self.projectile = Rocket
    self.x = 0
    self.y = 0
    self.ox = 8
    self.oy = 10
    self.r = 0
    self.scale = 2
    self.barrelLen = 40
    self.ammo = 4
    self.capacity = 4
    self.rof = 1
    self.sound = love.audio.newSource('sounds/sh-ffffff.wav', 'static')
    Weapon.initialize(self, aPlayerId)
end

RocketLauncher.image = love.graphics.newImage('res/Bazooka.png')

return RocketLauncher
