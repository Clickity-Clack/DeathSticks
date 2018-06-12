local Point = class 'Point'

function Point:initialize(sideA, sideB, coord)
    self.sideA = sideA
    self.sideB = sideB
    self.coord = coord
end

return Point
