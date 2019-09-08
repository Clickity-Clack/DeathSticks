local DynamicCollideable = {}

function DynamicCollideable:initializeMixin() -- just run initalize after collideable
    self.lastX = 0
    self.lastY = 0
end

function DynamicCollideable:update(dt)
    if self.body:getX() ~= self.lastX or self.body:getY() ~= self.lastY then
        self.modified = true
        self.lastX = self.body:getX()
        self.lastY = self.body:getY()
    end
end

function DynamicCollideable:getState(state)
    local x, y = self.body:getLinearVelocity()
    state.bodyDeets.xSpeed = x
    state.bodyDeets.ySpeed = y
    return state
end

function DynamicCollideable:unpackState(state)
    self.body:setLinearVelocity(state.bodyDeets.xSpeed, state.bodyDeets.ySpeed)
end

return DynamicCollideable
