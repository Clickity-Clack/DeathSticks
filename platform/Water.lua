local Platform = require 'platform/Platform'
local Water = class("Water", Platform)

function Water:initialize( body, width, height )
    Platform.initialize(self, body, width, height)
    self.rgba = {0.05, 0.32, 0.63, 0.3}
    self.fixture:setSensor(true)
end

return Water
