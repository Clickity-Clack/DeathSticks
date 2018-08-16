local Platform = require 'platform/Platform'
local DeadlyPlatform = class("DeadlyPlatform", Platform)

function DeadlyPlatform:initialize( body, width, height )
    Platform.initialize(self, body, width, height)
    self.rgba = {0.63, 0.05, 0.32}
    self.fixture:setSensor(true)
    self:initCollisions()
end

function DeadlyPlatform:initCollisions()
    self.collisions.Character = function(self, aCharacter)
        aCharacter:kill(self)
    end
end

return DeadlyPlatform
