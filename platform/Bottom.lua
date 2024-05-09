local DeadlyPlatform = require 'platform/DeadlyPlatform'
local Bottom = class("Bottom", DeadlyPlatform)

function Bottom:initialize( iPosition, width )
    DeadlyPlatform.initialize(self, iPosition, {width = width})
end

function Bottom:draw()
end

return Bottom
