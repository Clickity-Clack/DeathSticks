local removeEvent = class 'removeEvent'

function removeEvent:initialize(subject)
    self.id = uuid()
    self.subject = subject
end

function removeEvent:handle(dt, game)
    --game.players[self.subject.playerId].controllable.character = nil
    game.objects[self.subject.id] = nil
    game.removed[self.subject.id] = ''
    self.subject:destroy()
end

return removeEvent
