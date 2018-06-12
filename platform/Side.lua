local Side = class 'Side'

function Side:initialize(pointA, pointB)
    self.pointA = pointA
    self.pointB = pointB
    local dx = self.pointA.coord.x - self.pointB.coord.x
    local dy = self.pointA.coord.y - self.pointB.coord.y
    self.angle = math.atan2(dx,dy)
    self.slope = dx/dy
    -- print(dx)
    -- print(dy)
    -- print(self.slope)
    -- print(self.pointA.coord.x)
    -- print(self.pointA.coord.y)
    self.b = self.pointA.coord.y - (self.slope * self.pointA.coord.x)
end

function Side:distanceFromPointAtAngle(coord, angle)
    local intersectCoord = self:intersectPoint(coord, angle)
    return math.sqrt((intersectCoord.x - coord.x)*(intersectCoord.x - coord.x) + (intersectCoord.y - coord.y)*(intersectCoord.y - coord.y))
end

function Side:intersectPoint(coord, angle)
    local m, b, ix, iy

    m = math.tan(angle)
    b = coord.y - (m * coord.x)

    ix = (self.b-b)/(self.slope-m)
    iy = ix*m1 + b1

    return { x = ix, y = iy }
end

function Side:intersects(coord, angle)
    local inside = false
    local intersectCoord = self:intersectPoint(coord, angle)
    if self.pointA.coord.x == self.pointB.coord.x then
        return between(coord.x, self.pointA.x, self.pointB.x)
    elseif self.pointA.coord.y == self.pointB.coord.y then
        return between(coord.x, self.pointA.x, self.pointB.x)
    else
        local y1 = self.slope * coord.x + self.b
        local y2 = self.slope * self.pointA.x + self.b
        local y3 = self.slope * self.pointB.x + self.b
        return between(y1, y2, y3)
    end
end

function between(subj, a, b)
    return (subj < a and subj > b) or (subj > a and subj < b)
end

return Side
