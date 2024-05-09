local Platform = require 'platform/Platform'
local Water = class("Water", Platform)

function Water:initialize( iPosition, dimensions )
    Platform.initialize(self, iPosition, dimensions)
    self.rgba = {0.05, 0.32, 0.63, 0.3}
    self.fixture:setSensor(true)
end

return Water
