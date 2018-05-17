local Packable = require('handlers/unpacking/Packable')
local BodiedPackable = class('BodiedPackable', Packable)

function BodiedPackable:initialize(body)
    Packable.initialize(self)
    self.body = body
end

function BodiedPackable:getState()
    local state = Packable.getState(self)
    state.bodyDeets = { x = self.body:getX(), y = self.body:getY() }
    return state
end

function BodiedPackable:unpackState(state)
    self.body:setX(state.bodyDeets.x)
    self.body:setX(state.bodyDeets.x)
    Packable.unpackState(self, state)
end

return BodiedPackable
