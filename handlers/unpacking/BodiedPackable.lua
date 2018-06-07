local Packable = require('handlers/unpacking/Packable')
local BodiedPackable = class('BodiedPackable', Packable)

function BodiedPackable:initialize(body)
    assert(self.shape, "this " .. self.class.name .. " has no shape!")
    Packable.initialize(self)
    self.body = body
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
    self.collisions = {}
end

function BodiedPackable:getState()
    local state = Packable.getState(self)
    state.bodyDeets = { x = self.body:getX(), y = self.body:getY() }
    return state
end

function BodiedPackable:unpackState(state)
    self.body:setX(state.bodyDeets.x)
    self.body:setY(state.bodyDeets.y)
    Packable.unpackState(self, state)
end

function BodiedPackable:collide(b)
    local collisionMeth = self.collisions[b.class.name]
    if collisionMeth then
        collisionMeth(self, b)
    else
        collisionMeth = b.collisions[self.class.name]
        if collisionMeth then
            collisionMeth(b,self)
        end
    end
end

function BodiedPackable:getX()
    return self.body:getX()
end

function BodiedPackable:getY()
    return self.body:getY()
end

function BodiedPackable:getCenter()
    return self:getX(), self:getY()
end

function BodiedPackable:getShapeDimensions()
    local height, width = self:averagePoints{self.shape:getPoints()}
    return width, height
end

function BodiedPackable:averagePoints(args)
    local totalx = 0
    local totaly = 0
    for i in pairs(args) do
        if i%2 == 1 then 
            totalx = totalx + args[i]
        else
            totaly = totaly + args[i]
        end
    end
    return totalx / (#arg / 2), totaly / (#arg / 2)
end

return BodiedPackable
