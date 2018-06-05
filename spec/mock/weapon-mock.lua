local WeaponMock = class('WeaponMock')

function WeaponMock:initialize()
    self.image = love.graphics.newImage()
    self.name = 'Mock Weapon'
end

function WeaponMock:refill(healPoints)
    
end

return WeaponMock
