local gamera = require 'lib/gamera'
local HasCamera = {}
local winWidth = love.graphics.getWidth
local winHeight = love.graphics.getHeight

function HasCamera:initializeMixin()
    local cWorld = { w = 5000, h = 3000, columns = 24, rows = 22 }
    local offCenter = { x = cWorld.w/2 - winWidth()/2, y = cWorld.h/2 - winHeight()/2 }
    self.cam = gamera.new( 0, 0, cWorld.w, cWorld.h )
    self.cam:setWindow( 0, 0, winWidth(), winHeight() )
    self.cam:setScale(0.9)
    self.cam:setPosition( offCenter.x + 800/2, offCenter.y + 600/2 + 175 )
end

function HasCamera:resize(x,y)
    self.cam:setWindow( 0, 0, winWidth(), winHeight() )
end

function HasCamera:updateCamera()
    if not self.userPlayer.controllable.isNull then self.cam:setPosition( self.userPlayer:getCenter() ) end
end

return HasCamera