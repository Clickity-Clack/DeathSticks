local TeamVictory = require 'handlers/victory/TeamVictory'
local TeamDeathMatchVictory = class('TeamDeathMatchVictory', TeamVictory)

function TeamDeathMatchVictory:initialize(teams, winCount)
    TeamVictory.initialize(self, teams)
    self.winCount = winCount
    for i in pairs(teams) do
        self.score[teams[i]].points = 0
    end
    TeamDeathMatchVictory.initEvents(self)
end

function TeamDeathMatchVictory:initEvents()
    self.events.CharacterControllable = {}
    self.events.CharacterControllable.dead = function(event)
        local killerTeam = self:whichTeam(event.killer.playerId)
        local subjectTeam = self:whichTeam(event.subject.playerId)
        if event.killer.playerId ~= event.subject.playerId and killerTeam ~= subjectTeam and event.killer.class.name ~= 'DeadlyPlatform' and event.killer.class.name ~= 'Bottom' then
            self.score[killerTeam].points = self.score[killerTeam].points + 1
            print(self.score[killerTeam].contestants[event.killer.playerId])
            self.score[killerTeam].contestants[event.killer.playerId].points = self.score[killerTeam].contestants[event.killer.playerId].points + 1
        else
            self.score[killerTeam].points = self.score[killerTeam].points + 1
            self.score[killerTeam].contestants[event.killer.playerId].points = self.score[killerTeam].contestants[event.killer.playerId].points - 1
        end
        self.modified = true
    end
    self.events.Player.join = function(event)
        self.contestantCount = self.contestantCount + 1
        self.score[event.subject.team].contestants[event.subject.id] = {contestant = 'Player ' .. self.contestantCount, points = 0}
        self.modified = true
    end
end

function TeamDeathMatchVictory:draw()
    local c = 0
    love.graphics.setColor(0,0,0)
    for i in pairs(self.score) do
        c = c + 1
        love.graphics.print(i .. ': ' .. self.score[i].points, 10, 500 + c*15 )
        for j in pairs(self.score[i].contestants) do
            c = c + 1
            love.graphics.print(self.score[i].contestants[j].contestant .. ': ' .. self.score[i].contestants[j].points, 10, 500 + c*15 )
        end
        if self.score[i].points >= self.winCount then
            self.win = true
            self.modified = true
        end
    end
end

return TeamDeathMatchVictory
