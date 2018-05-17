local Character = require 'character/Character'

local CharacterControllable = class('CharacterControllable')

function CharacterControllable:initialize(body)
    self.id = uuid()
    self.playerId = nil
    self.Character = Character:new(body)
end

function CharacterControllable:setPlayerId(id)
    self.playerId = id
    self.Character:setPlayerId(id)
end

function CharacterControllable:getState()
    return { id = self.id, type = 'CharacterControllable', Character = self.Character:getState() }
end

function CharacterControllable:reId(state)
    self.id = state.id
    self.Character.reId(state.Character)
end

function CharacterControllable:unpackState(state)
    self.Character:unpackState(state.Character)
end

function CharacterControllable:update(dt, events)
    self.Character:update(dt, events)
end

function CharacterControllable:draw(cam, id)
    self.Character:draw(cam, id)
end

function CharacterControllable:drawHud()
    self.Character:drawHud()
end

function CharacterControllable:acceptCommands(commands)
    if commands.direction == 'left' then
        self.Character:walkLeft()
    elseif commands.direction == 'right' then
        self.Character:walkRight()
    else
        self.Character:stopWalking()
    end

    if commands.jump then
        self.Character:jump()
    end

    self.Character.weapons.current:setR(commands.r)

    self.Character:setFiring(commands.a)

end

function CharacterControllable:toggleAnim()
    --return 'toggleAnim'
end

function CharacterControllable:getCenter()
    return self.Character:getCenter()
end

return CharacterControllable
