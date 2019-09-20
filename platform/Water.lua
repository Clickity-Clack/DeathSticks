local Platform = require 'platform/Platform'
local Water = class("Water", Platform)

function Water:initialize( body, width, height )
    Platform.initialize(self, body, width, height)
    self.rgba = {0.05, 0.32, 0.63, 0.3}
    self.fixture:setSensor(true)
    self:initCollisions()
    self:initSeparations()
end

function Water:initCollisions()
    self.collisions.Character = function(self, aCharacter)
        --aCharacter:pushGravity(0.3)
    end
end

function Water:initSeparations()
    self.separations.Character = function(self, aCharacter)
        aCharacter:popGravity()
    end
end

return Water
