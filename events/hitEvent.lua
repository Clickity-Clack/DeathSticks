local hitEvent = class 'hitEvent'

function hitEvent:initialize(character, projectile)
    self.id = uuid()
    self.character = character
    self.projectile = projectile
end

function hitEvent:handle(dt, game)
    
end

return hitEvent
