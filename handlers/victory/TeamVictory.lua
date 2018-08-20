local Victory = require('handlers/victory/Victory')
local TeamVictory = class('TeamVictory', Victory)

function TeamVictory:initialize(teams)
    Victory.initialize(self)
    for i in pairs(teams) do
        self.score[teams[i]] = {contestant = teams[i], contestants = {}}
    end
    TeamVictory.initEvents(self)
end

function TeamVictory:initEvents()
    self.events.Player.join = function(event)
        self.contestantCount = self.contestantCount + 1
        self.score[event.subject.team].contestants[event.subject.id] = {contestant = 'Player ' .. self.contestantCount}
        self.modified = true
    end
    self.events.Player.leave = function(event)
        self.contestantCount = self.contestantCount - 1
        self.score[event.subject.team].contestants[event.subject.id] =  nil
        self.modified = true
    end
end

function TeamVictory:whichTeam(aPlayerId)
    for i in pairs(self.score)do
        for j in pairs(self.score[i].contestants) do
            if j == aPlayerId then return i end
        end
    end
end

function TeamVictory:draw()
    local c = 0
    love.graphics.setColor(0,0,0)
    for i in pairs(self.score) do
        c = c + 1
        love.graphics.print(i, 10, 500 + c*15 )
        for j in pairs(self.score[i].contestants) do
            c = c + 1
            love.graphics.print(self.score[i].contestants[j].contestant, 20, 500 + c*15 )
        end
    end
end

function TeamVictory:teamLeast()
    local leastCount = -1
    local leastName = ''
    local currentCount = 0
    for i in pairs(self.score) do
        currentCount = helper.tableLength(self.score[i].contestants)
        if leastCount == -1 then leastCount = currentCount end
        if currentCount <= leastCount then
            leastCount = currentCount
            leastName = i
        end
    end
    if leastCount ~= -1 then
        return leastName
    end
end

function TeamVictory:getTeams()
    return self.score
end

return TeamVictory
