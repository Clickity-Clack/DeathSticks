local Weapon = require('weapons/Weapon')
local Pistol = class('Pistol', Weapon)
local NineMil = require 'weapons/projectiles/NineMil'
local reloadSound = love.audio.newSource('sounds/chk.wav', 'static')

function Pistol:initialize(aPlayerId)
    self.projectile = NineMil
    self.x = 0
    self.y = 0
    self.ox = 8
    self.oy = 10
    self.r = 0
    self.scale = 2
    self.barrelLen = 30
    self.ammo = 10
    self.capacity = 10
    self.rof = 0.10
    self.reloadTime = 0.5
    self.sound = love.audio.newSource('sounds/pop3.wav', 'static')
    Weapon.initialize(self, aPlayerId)
end

function Pistol:update(dt, x, y)
    if self.ammo == 0 then
        if not self.reloadElapsed then
            self.reloadElapsed = self.reloadTime
        else
            self.reloadElapsed = self.reloadElapsed - dt
            if self.reloadElapsed <= 0 then
                love.audio.play(reloadSound)
                self.ammo = self.capacity
                self.reloadElapsed = nil
            end
        end
    end
    Weapon.update(self, dt, x, y)
end

Pistol.image = love.graphics.newImage('res/Pistol.png')

return Pistol
