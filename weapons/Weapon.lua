local Packable = require ('handlers/unpacking/Packable')
local Weapon = class('Weapon', Packable)

function Weapon:initialize()
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
    Packable.initialize(self)
    self.firing = false
    self.delay = 0
end


function Weapon:draw()
    love.graphics.draw(self.image, self.x, self.y, self.r, self.scale, self.scale, self.ox, self.oy)
end

function Weapon:fire(world)
    if self.ammo > 0 and self.delay <= 0 then
        love.audio.play(self.sound)
        local obj = self.projectile:new(self, world)
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
    if self.ammo + self.capacity/2 < self.capacity then
        self.ammo = self.ammo + self.capacity / 2
    else
        self.ammo = self.ammo + self.capacity / 2 - ((self.ammo + self.capacity / 2) % self.capacity)
    end
end

function Weapon:setPlayerId(id)
    self.playerId = id
    self.modified = true
end

function Weapon:getState()
    if self.modified then
        local state = Packable.getState(self)
        state.r = self.r
        state.x = self.x
        state.y = self.y
        state.ammo = self.ammo
        state.delay = self.delay
        return state
    end
end

function Weapon:unpackState(state)
    self.r = state.r
    self.x = state.x
    self.y = state.y
    self.ammo = state.ammo
    self.delay = state.delay
    Packable.unpackState(self, state)
end

return Weapon
