local WeaponCollection = class('WeaponCollection')
WeaponCollection:include(Serializeable)
local Meter = require 'character/Meter'
local hudBackColor = {0.01,0.1,0.01}
local hudFillColor = {0.2,0.8,0.2}

function WeaponCollection:initialize(aPlayerId, aWeapon)
    Serializeable.initializeMixin(self)
    self.playerId = aPlayerId
    self.weapons = {}
    if aWeapon then 
        self:addWeapon(aWeapon)
        self.current = aWeapon or nil
    end
end

function WeaponCollection:update(dt)
    for i in pairs(self.weapons) do
        self.modified = self.modified or self.weapons[i].modified
    end
end

function WeaponCollection:getState()
    if self.modified then
        local state = Serializeable.getState(self)
        state.weapons = Serializeable.getTableState(self.weapons)
        state.currentId = self.current.class.name
        state.playerId = self.playerId
        return state
    end
end

function WeaponCollection:unpackState(state, game)
    if (state) then
        Serializeable.unpackTableState(self.weapons, state.weapons, game)
        self.current = self.weapons[state.currentId]
        self.playerId = state.playerId
    end
end

function WeaponCollection:reId(state)
    Serializeable.reId(self, state)
    for i in pairs(self.weapons) do
        self.weapons[i]:reId(state.weapons[i])
    end
end

function WeaponCollection:fullReport()
    Serializeable.fullReport(self)
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

function WeaponCollection:draw()
    self.current:draw()
end

function WeaponCollection:drawHud(order )
    local imgSize, xBuffer, y = 30, 5, 5
    local winWidth = love.graphics.getWidth()
    local count = helper.tableLength(self.weapons)
    local scale = 2
    local x = winWidth/2 - ((imgSize * count)/2 + (xBuffer * (count))/2)
    love.graphics.setColor(0.5,0.5,0.5)
    for i in pairs(self.weapons)do
        if self.current.id == self.weapons[i].id then
            x = x + xBuffer
            scale = 4
            love.graphics.setColor(1,1,1)
            love.graphics.draw(self.weapons[i].image, x, y, 1.85*(math.pi), scale, scale, (self.weapons[i].ox * scale * 1/2), 0 - (self.weapons[i].oy / scale) )
            love.graphics.setColor(0.5,0.5,0.5)
            scale = 2
            x = x + xBuffer
        else
            love.graphics.draw(self.weapons[i].image, x, y, 0, scale, scale)
        end
        x = x + imgSize + xBuffer
    end
    
    Meter.draw(10,10 + 20*(order or 0),self.current.capacity,self.current.ammo,hudBackColor,hudFillColor,100,20)
    return 1
end

return WeaponCollection
