local MockSource = class('MockSource')

function MockSource:initialize(where, type)
    self.where = where
    self.type = type
end

return MockSource
