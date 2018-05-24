local Packable = require('handlers/unpacking/Packable')
local WeaponCollection = class('WeaponCollection', Packable)

function WeaponCollection:initialize(aWeapon)
    self.weapons = { aWeapon }
    self.current = aWeapon or nil
end

function WeaponCollection:addWeapon(aWeapon)
    self.weapons[addWeapon.class.name] = aWeapon
end

function WeaponCollection:removeWeapon(aWeapon)
    self.weapons[addWeapon.class.name] = nil
end

function WeaponCollection:nextWeapon()
    
end

function WeaponCollection:previousWeapon()

end

function WeaponCollection:drawHud()
    local imgSize, xBuffer, y = 30, 10, 10
    local winWidth = love.graphics.getWidth()
    local count = helper.tablelength(self.weapons)
    local x = winWidth/2 - ((imgSize * count) + (xBuffer * (count - 1)))
    love.graphics.setColor(0,0,0)
    for i, weapon in ipairs(self.weapons)do
        love.graphics.rectangle('line', x, y, 30, 30)
        x = x + imgSize + xBuffer
    end
end

return WeaponCollection
