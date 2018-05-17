local BodiedPackable = require('handlers/unpacking/BodiedPackable')
local DynamicBodiedPackable = class('DynamicBodiedPackable', BodiedPackable)

function DynamicBodiedPackable:initialize(body)
    BodiedPackable.initialize(self, body)
end

function DynamicBodiedPackable:getState()
    local state = BodiedPackable.getState(self)
    local x, y = self.body:getLinearVelocity()
    state.bodyDeets.xSpeed = x
    state.bodyDeets.ySpeed = y
    return state
end

function DynamicBodiedPackable:unpackState(state)
    self.body:selLinearVelocity(state.bodyDeets.xSpeed, state.bodyDeets.ySpeed)
end

return DynamicBodiedPackable
