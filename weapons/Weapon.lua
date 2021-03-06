local Weapon = class('Weapon')
Weapon:include(Serializeable)

function Weapon:initialize(aPlayerId)
    assert(self.image)
    assert(type(self.x) == 'number')
    assert(type(self.y) == 'number')
    assert(type(self.r) == 'number')
    assert(type(self.scale) == 'number')
    assert(type(self.ox) == 'number')
    assert(type(self.oy) == 'number')
    assert(type(self.barrelLen) == 'number')
    assert(type(self.ammo) == 'number')
    assert(type(self.capacity) == 'number')
    assert(type(self.rof) == 'number')
    assert(self.projectile)
    assert(self.sound)
    self.playerId = aPlayerId
    Serializeable.initializeMixin(self)
    self.firing = false
    self.delay = 0
end


function Weapon:draw()
    love.graphics.setColor(0,0,0)
    local yscale = self.scale
    if self.r < (-1.5) then
        yscale = 0 - self.scale
    end
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.image, self.x, self.y, self.r, self.scale, yscale, self.ox, self.oy)
end

function Weapon:fire(world)
    if self.ammo > 0 and self.delay <= 0 then
        love.audio.play(self.sound)
        local obj = self.projectile:new(self:getBarrelDeets(), self.playerId, world)
        self.ammo = self.ammo - 1
        self.delay = self.rof
        return obj
    end
end

function Weapon:getBarrelDeets()
    local anx, ay, anr = self.x, self.y, self.r
    anx = anx + self.barrelLen * math.cos(anr)
    ay = ay + self.barrelLen * math.sin(anr)
    return { x = anx, y = ay, r = anr }
end

function Weapon:update(dt, x, y)
    if self.delay > 0 then
        self.delay = self.delay - dt
    end
    if self.x ~= x or self.y ~= y then
        self.modified = true
        self.x = x
        self.y = y
    end
end

function Weapon:setR(r)
    if self.r ~= r then
        self.r = r
        self.modified = true
    end
end

function Weapon:refill()
    if self.ammo == self.capacity then return false end
    if self.ammo + self.capacity/2 < self.capacity then
        self.ammo = self.ammo + self.capacity / 2
    else
        self.ammo = self.ammo + self.capacity / 2 - ((self.ammo + self.capacity / 2) % self.capacity)
    end
    return true
end

function Weapon:getState()
    if self.modified then
        local state = Serializeable.getState(self)
        state.r = self.r
        state.x = self.x
        state.y = self.y
        state.ammo = self.ammo
        state.delay = self.delay
        state.playerId = self.playerId
        return state
    end
end

function Weapon:unpackState(state)
    self.r = state.r
    self.x = state.x
    self.y = state.y
    self.ammo = state.ammo
    self.delay = state.delay
    self.playerId = state.playerId
    Serializeable.unpackState(self, state)
end

return Weapon
