local Powerup = require 'powerups/Powerup'
local Armor = require 'character/Armor'
local ArmorPower = class ('ArmorPower', Powerup)
ArmorPower.zoopSound = love.audio.newSource('sounds/zoop1.wav', 'static')

function ArmorPower:initialize( body )
    Powerup.initialize(self, body, love.graphics.newImage('res/grenade.png'))
    self.weapon = weapon
end

function ArmorPower:zoop(aCharacter)
    local aHealth = aCharacter.health
    if aHealth.armor.isNull then
        aHealth:setArmor(Armor:new(50, 100))
        love.audio.play(ArmorPower.zoopSound)
    else
        if aHealth:refillArmor(50) then love.audio.play(ArmorPower.zoopSound) end
    end
end

return ArmorPower
