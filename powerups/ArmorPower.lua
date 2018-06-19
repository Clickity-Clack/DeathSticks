local Powerup = require 'powerups/Powerup'
local Armor = require 'character/Armor'
local ArmorPower = class ('ArmorPower', Powerup)

function ArmorPower:initialize( body )
    Powerup.initialize(self, body, love.graphics.newImage('res/grenade.png'))
    self.weapon = weapon
end

function ArmorPower:zoop(aHealth)
    if aHealth.armor.isNull then
        aHealth:setArmor(Armor:new(50, 100))
    else
        aHealth:refillArmor(50)
    end
end

return ArmorPower
