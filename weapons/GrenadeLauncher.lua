local Weapon = require('weapons/Weapon')
local GrenadeLauncher = class('GrenadeLauncher', Weapon)
local Grenade = require 'weapons/projectiles/explosive/Grenade'

function GrenadeLauncher:initialize(aPlayerId)
    self.projectile = Grenade
    self.x = 0
    self.y = 0
    self.ox = 8
    self.oy = 10
    self.r = 0
    self.scale = 2
    self.barrelLen = 40
    self.ammo = 8
    self.capacity = 8
    self.rof = 0.5
    self.sound = love.audio.newSource('sounds/thoom.wav', 'static')
    Weapon.initialize(self, aPlayerId)
end

GrenadeLauncher.image = love.graphics.newImage('res/Launcher.png')

return GrenadeLauncher
