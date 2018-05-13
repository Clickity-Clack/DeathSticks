local jumpAction = class 'jumpAction'

function jumpAction:initialize(direction)
    self.id = uuid()
end

function jumpAction:handle( aPlayer, dt, game )
    aPlayer.controllable.character:jump()
end

return jumpAction
