local BodiedPackable = require 'handlers/unpacking/BodiedPackable'
local Edge = class("Edge", BodiedPackable)

function Edge:initialize( body, width )
    self.width = width or 50
    self.height = 10
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    BodiedPackable.initialize(self, body)
    self.fixture:setSensor(true)
end

function Edge:update(dt)

end

function Edge:getState()
    if self.modified then
        local state = BodiedPackable.getState(self) 
        state.width = self.width
        return state
    end
end

function Edge:unpackState(state)
    self.width = state.width
    BodiedPackable.unpackState(self, state)
end


function Edge:draw()
end

return Edge
