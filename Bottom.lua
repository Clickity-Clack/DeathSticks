local BodiedPackable = require 'handlers/unpacking/BodiedPackable'
local Bottom = class("Bottom", BodiedPackable)

function Bottom:initialize( body, width )
    self.width = width or 50
    self.height = 10
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    BodiedPackable.initialize(self, body)
    self.fixture:setSensor(true)
end

function Bottom:update(dt)

end

function Bottom:getState()
    if self.modified then
        local state = BodiedPackable.getState(self) 
        state.width = self.width
        return state
    end
end

function Bottom:unpackState(state)
    self.width = state.width
    BodiedPackable.unpackState(self, state)
end


function Bottom:draw()
end

return Bottom
