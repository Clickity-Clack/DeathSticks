local Packable = require('handlers/unpacking/Packable')
local WeaponCollection = class('WeaponCollection', Packable)

function WeaponCollection:initialize(aWeapon)
    Packable.initialize(self)
    self.weapons = {}
    self.weapons[aWeapon.class.name] = aWeapon
    self.current = aWeapon or nil
end

function WeaponCollection:update(dt)
    for i in pairs(self.weapons) do
        --print(self.weapons[i].modified)
        self.modified = self.modified or self.weapons[i].modified
    end
end

function WeaponCollection:getState()
    if self.modified then
        local state = Packable.getState(self)
        state.weapons = Packable.getTableState(self.weapons)
        state.currentId = self.current.class.name
        return state
    end
end

function WeaponCollection:unpackState(state, game)
    if (state) then
        Packable.unpackTableState(self.weapons, state.weapons, game)
        self.current = self.weapons[state.currentId]
    end
end

function WeaponCollection:reId(state)
    Packable.reId(self, state)
    for i in pairs(self.weapons) do
        self.weapons[i]:reId(state.weapons[i])
    end
end

function WeaponCollection:fullReport()
    Packable.fullReport(self)
    for i in pairs(self.weapons) do
        self.weapons[i]:fullReport()
    end
end

function WeaponCollection:addWeapon(aWeapon)
    if not self.weapons[aWeapon.class.name] then
        self.weapons[aWeapon.class.name] = aWeapon
        self.modified = true
    end
end

function WeaponCollection:removeWeapon(aWeapon)
    if self.weapons[aWeapon.class.name] then
        self.weapons[addWeapon.class.name] = nil
        self.modified = true
    end
end

function WeaponCollection:nextWeapon()
    local nextWeapon = self.weapons[next(self.weapons, self.current.class.name)]
    self.current = nextWeapon or self.weapons[next(self.weapons)] or self.current
end

function WeaponCollection:previousWeapon()

end

function WeaponCollection:contains(aWeapon)
    for i in pairs(self.weapons) do
        if self.weapons[i].class.name == aWeapon.name then
            return self.weapons[i]
        end
    end
end

function WeaponCollection:drawHud()
    local imgSize, xBuffer, y = 30, 10, 10
    local winWidth = love.graphics.getWidth()
    local count = helper.tablelength(self.weapons)
    local x = winWidth/2 - ((imgSize * count) + (xBuffer * (count - 1)))
    love.graphics.setColor(0,0,0)
    for i in pairs(self.weapons)do
        love.graphics.draw(self.weapons[i].image, x, y, 0, 2 )
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
