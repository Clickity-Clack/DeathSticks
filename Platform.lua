local BodiedPackable = require 'handlers/unpacking/BodiedPackable'
local Platform = class("Platform", BodiedPackable)

function Platform:initialize( body, width, height )
    self.width = width or 50
    self.height = height or 10
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    BodiedPackable.initialize(self, body)
    self.rgba = { 0.32, 0.63, 0.05 }
end

function Platform:update(dt)

end

function Platform:getState()
    if self.modified then
        local state = BodiedPackable.getState(self) 
        state.height = self.height
        state.width = self.width
        return state
    end
end

function Platform:unpackState(state)
    self.height = state.height
    self.width = state.lenght
    BodiedPackable.unpackState(state)
end


function Platform:draw()
    love.graphics.setColor( self.rgba ) -- set the drawing color to green for the ground
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

return Platform
