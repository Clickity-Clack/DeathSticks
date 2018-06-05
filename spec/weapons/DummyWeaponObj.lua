local DummyWeaponObj = class('dummyWeapon', Weapon)
local Weapon = require 'weapons/Weapon'

function DummyWeaponObj:initialize()
    self.image = love.graphics.newImage()
    self.x = 12
    self.y = 12
    self.r = 12
    self.scale = 12
    self.ox = 12
    self.oy = 12
    self.ammo = 12
    self.capacity = 12
    self.rof = 12
    self.projectile = {}
    self.sound = {}
    Weapon.initialize(self)
end

return DummyWeaponObj
