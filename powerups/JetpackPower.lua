local Powerup = require 'powerups/Powerup'
local Jetpack = require 'character/Jetpack'
local JetpackPower = class('JetpackPower', Powerup)

function JetpackPower:initialize( body )
    local image = love.graphics.newImage('res/jetpack.png')
    Powerup.initialize(self, body, image)
    self.value = 50
    self.scale = 1
end

function JetpackPower:zoop(aCharacter)
    if aCharacter.jetpack.isNull then
        aCharacter:switchJetpack(Jetpack:new(aCharacter.playerId))
    else
        self.used = aCharacter.jetpack:refill(self.value)
    end
end

return JetpackPower
