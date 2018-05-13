local fireAction = class 'fireAction'

function fireAction:initialize(x,y)
    self.id = uuid()
end

function fireAction:handle( aPlayer, dt, game )
    aPlayer.controllable.character:fire(game)
end

return fireAction
