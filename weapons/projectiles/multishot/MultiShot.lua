local MultiShot = class('MultiShot', Packable)
local Pellet = require 'weapons/projectiles/Pellet'

function MultiShot:initialize(barrelDeets, aPlayerId, world)
    assert(self.shot)
    assert(self.shotCount)
    self.shots = {}
    self.time = 5
    self.blastRadius = 2
    originalRotation = barrelDeets.r
    for i = 1, self.shotCount do
        barrelDeets.r = originalRotation + (math.random() - 0.5)
        self.shots[i] = self.shot:new(barrelDeets, aPlayerId, world)
    end
    Packable.initialize(self)
end

function MultiShot:update(dt, events)
    local fakeEvents = {}
    for i in pairs(self.shots) do
        self.shots[i]:update(dt, fakeEvents)
        if fakeEvents[1] then
            self.shots[i]:destroy()
            self.shots[i] = nil
            fakeEvents[1] = nil
        end
    end
    self.time = self.time - dt
    if self.time <= 0 then 
        for i in pairs(self.shots) do
            self.shots[i]:destroy()
            self.shots[i] = nil
        end
        table.insert(events, {type = 'dead', subject = self})
    end
end

function MultiShot:draw()
    for i in pairs(self.shots) do
       self.shots[i]:draw()
    end
end

return MultiShot
