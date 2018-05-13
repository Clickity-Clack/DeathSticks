local walkAction = class 'walkAction'

function walkAction:initialize(direction)
    self.id = uuid()
    self.direction = direction
    self.movement = { left = 'walkLeft', right = 'walkRight', stopped = 'stopWalking' }
end

function walkAction:handle( aPlayer, dt, game )
    operation = self.movement[self.direction]
    if operation ~= nil then
        aPlayer.controllable.character[operation](aPlayer.controllable.character)
    end
end

return walkAction
