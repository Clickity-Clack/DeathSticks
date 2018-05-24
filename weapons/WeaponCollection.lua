local Packable = require('handlers/unpacking/Packable')
local WeaponCollection = class('WeaponCollection', Packable)

function WeaponCollection:initialize(aWeapon)
    self.weapons = { aWeapon }
    self.current = aWeapon or nil
end

function WeaponCollection:addWeapon(aWeapon)
    self.weapons[aWeapon.class.name] = aWeapon
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
    
    love.graphics.setColor(0.01,0.1,0.01)
    x,y = 10,30
    love.graphics.rectangle('fill', x, y, 100, 20)
    love.graphics.setColor(0.2,0.8,0.2)
    love.graphics.rectangle('fill', x, y, self.current.ammo/self.current.capacity * 100, 20)
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.current.ammo, x + width/2 - font:getWidth(self.current.ammo)/2, y + height/2 - font:getHeight()/2)
end

return WeaponCollection
