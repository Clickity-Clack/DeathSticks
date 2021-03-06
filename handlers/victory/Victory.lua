local Victory = class('Victory')
Victory:include(Serializeable)

function Victory:initialize()
    Serializeable.initializeMixin(self)
    self.win = false
    self.score = {}
    self.contestantCount = 0
    self.events = {}
    Victory.initEvents(self)
end

function Victory:assess(event)
    if self.events[event.subject.class.name] and self.events[event.subject.class.name][event.type] then
        self.events[event.subject.class.name][event.type](event)
    end
end

function Victory:initEvents()
    self.events.Player = {}
    self.events.Player.join = function(event)
        self.contestantCount = self.contestantCount + 1
        self.score[event.subject.id] = {contestant = 'Player ' .. self.contestantCount}
        self.modified = true
    end
    self.events.Player.leave = function(event)
        self.contestantCount = self.contestantCount - 1
        self.score[event.subject.id] = nil
        self.modified = true
    end
end

function Victory:draw()
    local c = 0
    for i in pairs(self.score) do
        c = c + 1
        love.graphics.setColor(0,0,0)
        love.graphics.print(self.score[i].contestant, 10, 500 + c*15 )
    end
end

function Victory:getScore()
    return self.score
end

function Victory:teamLeast()
end

function Victory:getState()
    if self.modified then
        local state = Serializeable.getState(self)
        state.contestantCount = self.contestantCount
        state.score = self.score
        return state
    end
end

function Victory:unpackState(state)
    if state then
        self.contestantCount = state.contestantCount
        self.score = state.score
        Serializeable.unpackState(self)
    end
end

return Victory
