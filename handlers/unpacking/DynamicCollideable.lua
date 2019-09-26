local DynamicCollideable = {}

function DynamicCollideable:initializeMixin() -- just run initalize after collideable
    self.lastX = 0
    self.lastY = 0
    self.gravities = {}
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

function DynamicCollideable:pushGravity(number)
    if not self.gravities then 
        self.gravities = {}
    end
    self.gravities[#self.gravities + 1] = self.body:getGravityScale()
    self.body:setGravityScale(number)
end

function DynamicCollideable:popGravity()
    if self.gravities then
        local returnGravity = self.gravities[#self.gravities]
        self.body:setGravityScale(self.gravities[#self.gravities])
        self.gravities[#self.gravities] = nil
        return returnGravity
    end
end

function DynamicCollideable:unpackState(state)
    self.body:setLinearVelocity(state.bodyDeets.xSpeed, state.bodyDeets.ySpeed)
end

return DynamicCollideable
