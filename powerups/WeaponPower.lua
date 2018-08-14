local Powerup = require 'powerups/Powerup'
local WeaponPower = class ('WeaponPower', Powerup)
WeaponPower.zoopSound = love.audio.newSource('sounds/zoop2.wav', 'static')

function WeaponPower:initialize( body, weapon )
    Powerup.initialize(self, body, weapon.image)
    self.weapon = weapon
end

function WeaponPower:zoop(aCharacter)
    local aWeaponCollection = aCharacter.weapons
    local weapon = aWeaponCollection:contains(self.weapon)
    if weapon then
        if weapon:refill() then love.audio.play(WeaponPower.zoopSound) end
    else
        aWeaponCollection:addWeapon(self.weapon:new())
        love.audio.play(WeaponPower.zoopSound) 
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
