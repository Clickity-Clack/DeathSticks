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

function Platform:getPoints()
    if not self.points then
        self:makePointsAndSides{self.body:getPoints()}
    end
    return self.points
end

function Platform:getSides()
    if not self.sides then
        self:makePointsAndSides{self.body:getPoints()}
    end
    return self.sides
end

function Platform:makePointsAndSides(args)
    self.sides = {}
    self.points = {}
    local anx, pointA, pointB
    for i, v in ipairs(args) do
        if i%2 == 1 then
            anx = v
            if pointB then
                table.insert(self.sides, Side:new(pointA, pointB))
            end
        else
            pointA = pointB
            pointB = Point:new(anx, v)
            table.insert(self.points, pointB)
        end
    end
    sides[1].pointA = pointB
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
    self.width = state.width
    BodiedPackable.unpackState(self, state)
end


function Platform:draw()
    love.graphics.setColor( self.rgba )
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

return Platform
