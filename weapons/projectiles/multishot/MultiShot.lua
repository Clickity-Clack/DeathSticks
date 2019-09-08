local MultiShot = class('MultiShot')
MultiShot:include(Serializeable)

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
    Serializeable.initializeMixin(self)
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
        table.insert(events, {type = 'dead', subject = self})
    end
    self.modified = true
end

function MultiShot:destroy()
    for i in pairs(self.shots) do
        self.shots[i]:destroy()
        self.shots[i] = nil
    end
end

function MultiShot:draw()
    for i in pairs(self.shots) do
       self.shots[i]:draw()
    end
end

function MultiShot:unpackState(state, game)
    if state then
        Serializeable.unpackTableState(self.shots, state.shots, game)
        self.playerId = state.playerId
    end
end

function MultiShot:getState()
    if self.modified then
        local state = Serializeable.getState(self)
        state.shots = Serializeable.getTableState(self.shots)
        state.playerId = self.playerId
        return state
    end
end

function MultiShot:reId(state)
    Serializeable.reId(self, state)
    for i in pairs(state.shots) do
        self.shots[i]:reId(state.shots[i])
    end
end

function MultiShot:fullReport()
    Serializeable.fullReport(self)
    for i in pairs(self.shots) do
        self.shots[i]:fullReport()
    end
end

return MultiShot
