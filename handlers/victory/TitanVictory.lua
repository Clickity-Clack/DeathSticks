local TeamVictory = require 'handlers/victory/TeamVictory'
local TitanVictory = class('TitanVictory', TeamVictory)

function TitanVictory:initialize(teams)
    TeamVictory.initialize(self, teams)
    for i in pairs(teams) do
        self.score[teams[i]].points = 'no'
    end
    TitanVictory.initEvents(self)
end

function TitanVictory:initEvents()
    self.events.TeamBase = {}
    self.events.TeamBase.dead = function(event)
        for i in pairs(self.score) do
            if i == event.subject.team then 
                self.score[i].points = 'lose'
            else
                self.score[i].points = 'win'
            end
        end
        self.win = true
        self.modified = true
    end
    self.events.Player.join = function(event)
        self.contestantCount = self.contestantCount + 1
        self.score[event.subject.team].contestants[event.subject.id] = {contestant = 'Player ' .. self.contestantCount}
        self.modified = true
    end
end

function TitanVictory:draw()
    local c = 0
    love.graphics.setColor(0,0,0)
    for i in pairs(self.score) do
        c = c + 1
        love.graphics.print(i .. ': ' .. self.score[i].points, 10, 500 + c*15 )
        for j in pairs(self.score[i].contestants) do
            c = c + 1
            love.graphics.print(self.score[i].contestants[j].contestant, 10, 500 + c*15 )
        end
    end
end

return TitanVictory
