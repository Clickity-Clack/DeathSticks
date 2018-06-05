local Powerup = require 'powerups/Powerup'
local WeaponPower = class ('WeaponPower', Powerup)

function WeaponPower:initialize( body, weapon )
    Powerup.initialize(self, body, weapon.image)
    self.weapon = weapon
end

function WeaponPower:zoop(aWeaponCollection)
    local weapon = aWeaponCollection:contains(self.weapon)
    if weapon then
        weapon:refill()
    end
    if not reached then
        aWeaponCollection:addWeapon(self.weapon:new())
    end
end

function WeaponPower:getState()
    if self.modified then
       local state = Powerup.getState(self) 
       state.weapon = self.weapon.name
       return state
    end
end

function WeaponPower:destroy()
    self.body.destroy()
end

return WeaponPower
