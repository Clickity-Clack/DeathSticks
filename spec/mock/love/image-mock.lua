local MockImage = class('MockImage')

function MockImage:initialize()
    self.height = 16
    self.width = 16
end

function MockImage:getWidth(userData)
    return self.width
end

function MockImage:getHeight()
    return self.height
end

return MockImage
