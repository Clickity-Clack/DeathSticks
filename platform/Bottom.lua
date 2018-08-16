local DeadlyPlatform = require 'platform/DeadlyPlatform'
local Bottom = class("Bottom", DeadlyPlatform)

function Bottom:initialize( body, width )
    DeadlyPlatform.initialize(self, body, width)
end

function Bottom:draw()
end

return Bottom
