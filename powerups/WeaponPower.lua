local Powerup = require 'powerups/Powerup'
local WeaponPower = class ('WeaponPower', Powerup)

function WeaponPower:initialize( body, weapon )
    local image = weapon.image
    Powerup.initialize(self, body, image)
    self.weapon = weapon
end

function WeaponPower:zoop(aWeaponCollection)
    local aWeapon
    local reached = false
    for i in pairs(aWeaponCollection.weapons) do
        aWeapon = aWeaponCollection.weapons[i]
        if aWeapon.class.name == self.weapon.name then
            if aWeapon.ammo + aWeapon.capacity/2 < aWeapon.capacity then
                aWeapon.ammo = aWeapon.ammo + aWeapon.capacity / 2
            else
                aWeapon.ammo = aWeapon.ammo + aWeapon.capacity / 2 - ((aWeapon.ammo + aWeapon.capacity / 2) % aWeapon.capacity)
            end
            reached = true
        end
    end
    if not reached then
        aWeaponCollection:addWeapon(self.weapon:new())
    end
end

function WeaponPower:destroy()
    self.body.destroy()
end

return WeaponPower
