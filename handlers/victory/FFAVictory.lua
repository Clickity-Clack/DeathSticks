local Victory = require 'handlers/victory/Victory'
local FFAVictory = class('FFAVictory', Victory)

function FFAVictory:initialize(winCount)
    Victory.initialize(self)
    self.winCount = winCount
    FFAVictory.initEvents(self)
end

function FFAVictory:initEvents()
    self.events.CharacterControllable = {}
    self.events.CharacterControllable.dead = function(event)
        if event.killer.playerId ~= event.subject.playerId and event.killer.class.name ~= 'DeadlyPlatform' and event.killer.class.name ~= 'Bottom' then
            self.score[event.killer.playerId].points = self.score[event.killer.playerId].points + 1
        else
            self.score[event.subject.playerId].points = self.score[event.subject.playerId].points - 1
        end
        self.modified = true
    end
    self.events.Player.join = function(event)
        self.contestantCount = self.contestantCount + 1
        self.score[event.subject.id] = {contestant = 'Player ' .. self.contestantCount, points = 0}
        self.modified = true
    end
end

function FFAVictory:draw()
    local c = 0
    for i in pairs(self.score) do
        c = c + 1
        love.graphics.setColor(0,0,0)
        love.graphics.print(self.score[i].contestant .. ' ' .. self.score[i].points, 10, 500 + c*15 )
        if self.score[i].points >= self.winCount then
            self.win = true
        end
    end
end

return FFAVictory
