local Pointer = class 'Pointer'
local fingerBullet = require 'weapons/projectiles/fingerBullet'

function Pointer:initialize()
    self.id = uuid()
    self.playerId = playerId
    self.type = 'pointer'
    self.projectile = fingerBullet
    self.image = love.graphics.newImage('res/finger.png')
    self.x = 0
    self.y = 0
    self.ox = 0
    self.oy = 0
    self.r = 0
    self.width = 16
    self.height = 16
    self.size = 1
    self.poking = false
    self.ammo = 10
    self.capacity = 30
    self.rof = 0.5
    self.delay = 0
    self.sound = love.audio.newSource('sounds/you.mp3', 'static')

    self.currentTime = 0
end

function Pointer:fire(world)
    if self.ammo > 0 then
        love.audio.play(self.sound)
        local obj = self.projectile:new(self, world)
        self.ammo = self.ammo - 1
        return obj
    end
end

function Pointer:update(dt, x, y)
    if self.delay > 0 then
        self.delay = self.delay - dt
    end
    self.x = x
    self.y = y
end

function Pointer:setR(r)
    self.r = r
end

function Pointer:setPlayerId(id)
    self.playerId = id
end

function Pointer:getState()
    return { id = self.id, r = self.r, type = 'pointer' }
end

function Pointer:reId(state)
    self.id = state.id
end

function Pointer:unpackState(state)
    self.r = state.r
end

function Pointer:draw()
    love.graphics.draw(self.image, self.x + self.ox + 2, self.y + self.oy, self.r, self.size, self.size, 0, self.height/2 + 1)
end

return Pointer
