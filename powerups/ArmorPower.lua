local Powerup = require 'powerups/Powerup'
local Armor = require 'character/Armor'
local ArmorPower = class ('ArmorPower', Powerup)
ArmorPower.zoopSound = love.audio.newSource('sounds/zoop1.wav', 'static')

function ArmorPower:initialize( body )
    Powerup.initialize(self, body, love.graphics.newImage('res/grenade.png'))
    self.weapon = weapon
end

function ArmorPower:zoop(aCharacter)
    aCharacter:refillArmor(50)
end

return ArmorPower
