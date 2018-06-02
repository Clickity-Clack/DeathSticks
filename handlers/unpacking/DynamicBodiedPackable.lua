local BodiedPackable = require('handlers/unpacking/BodiedPackable')
local DynamicBodiedPackable = class('DynamicBodiedPackable', BodiedPackable)

function DynamicBodiedPackable:initialize(body)
    BodiedPackable.initialize(self, body)
    self.lastX = 0
    self.lastY = 0
end

function DynamicBodiedPackable:update(dt)
    if self.body:getX() ~= self.lastX or self.body:getY() ~= self.lastY then
        self.modified = true
        self.lastX = self.body:getX()
        self.lastY = self.body:getY()
    end
end

function DynamicBodiedPackable:getState()
    local state = BodiedPackable.getState(self)
    local x, y = self.body:getLinearVelocity()
    state.bodyDeets.xSpeed = x
    state.bodyDeets.ySpeed = y
    return state
end

function DynamicBodiedPackable:unpackState(state)
    self.body:setLinearVelocity(state.bodyDeets.xSpeed, state.bodyDeets.ySpeed)
    BodiedPackable.unpackState(self, state)
end

return DynamicBodiedPackable
