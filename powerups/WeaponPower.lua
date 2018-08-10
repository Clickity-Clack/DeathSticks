local Powerup = require 'powerups/Powerup'
local WeaponPower = class ('WeaponPower', Powerup)

function WeaponPower:initialize( body, weapon )
    Powerup.initialize(self, body, weapon.image)
    self.weapon = weapon
end

function WeaponPower:zoop(aCharacter)
    local aWeaponCollection = aCharacter.weapons
    local weapon = aWeaponCollection:contains(self.weapon)
    if weapon then
        weapon:refill()
    else
        aWeaponCollection:addWeapon(self.weapon:new())
    end
end

function WeaponPower:getState()
    if self.modified then
       local state = Powerup.getState(self) 
       state.weaponName = self.weapon.name
       return state
    end
end

return WeaponPower
