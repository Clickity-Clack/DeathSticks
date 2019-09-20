local Collideable = {}

function Collideable:initializeMixin(body) -- would this work with the initialize method??? Yes. Just initalize on top of existing object
    assert(self.shape, "this " .. self.class.name .. " has no shape!")
    self.body = body
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
    self.collisions = {}
    self.separations = {}
end

function Collideable:getState(state)
    --local state = Packable.getState(self) --make sure to re-integrate serializeable functionality
    state.bodyDeets = { x = self.body:getX(), y = self.body:getY() }
    return state
end

function Collideable:unpackState(state)
    self.body:setX(state.bodyDeets.x)
    self.body:setY(state.bodyDeets.y)
end

function Collideable:collide(b)
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

function Collideable:separate(b)
    local separationMeth = self.separations[b.class.name]
    if separationMeth then
        separationMeth(self, b)
    else
        separationMeth = b.separations[self.class.name]
        if separationMeth then
            separationMeth(b,self)
        end
    end
end

function Collideable:getX()
    return self.body:getX()
end

function Collideable:getY()
    return self.body:getY()
end

function Collideable:getCenter()
    return self:getX(), self:getY()
end

function Collideable:getShapeDimensions()
    local height, width = self:averagePoints{self.shape:getPoints()}
    return width, height
end

function Collideable:averagePoints(args)
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

return Collideable
