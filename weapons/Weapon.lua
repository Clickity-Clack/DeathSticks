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

function Weapon:update(dt, x, y)
    if self.delay > 0 then
        self.delay = self.delay - dt
    end
    self.x = x
    self.y = y
end

function Weapon:setR(r)
    self.r = r
end

function Weapon:setPlayerId(id)
    self.playerId = id
end

function Weapon:getState()
    local state = Packable.getState(self)
    state.r = self.r
    return state
end

function Weapon:unpackState(state)
    self.r = state.r
    Packable.unpackState(self, state)
end

return Weapon
