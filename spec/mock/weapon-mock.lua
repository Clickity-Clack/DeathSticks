local WeaponMock = class('WeaponMock')

function WeaponMock:initialize(udp)
    self.image = love.graphics.newImage()
    self.name = 'Mock Weapon'
    self.id = uuid()
    self.uselessDataPoint = udp or 'huhu, asah dude'
    self.modified = true
end

function WeaponMock:refill(healPoints)
    
end

function WeaponMock:reId(state)
    self.id = state.id
end

function WeaponMock:getState()
    self.modified = false
    return { type = self.type, id = self.id, udp = self.uselessDataPoint }
end

function WeaponMock:unpackState(state)
    self.uselessDataPoint = state.udp
end

return WeaponMock
