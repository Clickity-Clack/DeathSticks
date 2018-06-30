local NullControllable = require 'character/NullControllable'
local NullJetpack = require 'character/NullJetpack'
local events = { collide = {}, dead = {}, respawn = {}, fire = {} }
function process( dt, game )
    local event
    for i in pairs(game.events) do
        event = game.events[i]
        if not event.time or not (event.time > 0) then
            if events[event.type] then
                if events[event.type][event.subject.class.name] then
                    events[event.type][event.subject.class.name](event, game)
                end
            end
            game.events[i] = nil
        else
            event.time = event.time - dt
        end
    end
end

events.fire.Character = function (event, game)
    local obj = event.subject:fire(game.world)
    if obj then
        game.stems[obj.id] = obj
    end
end

events.dead.Jetpack = function (event, game)
    print(serpent.block(event))
    print(event.subject.playerId)
    print(game.players[event.subject.playerId])
    print(game.players[event.subject.playerId].controllable)
    print(game.players[event.subject.playerId].controllable.character)
    game.players[event.subject.playerId].controllable.character:switchJetpack(NullJetpack:new())
end

events.dead.CharacterControllable = function (event, game)
    print(serpent.block(event))
    local thePlayerId = event.subject.playerId
    local thePlayer = game.players[thePlayerId]
    local theId = event.subject.id
    local newNull = NullControllable:new()
    thePlayer:switchControllable(newNull)
    game.stems[newNull.id] = newNull
    event.subject:destroy()
    game.stems[theId] = nil
    game.removed[theId] = true
    game.removedChanged = true
    table.insert(game.events, {type = 'respawn', time = 1, subject = thePlayer})
end

events.respawn.Player = function (event, game)
    event.subject:switchControllable(game:newCharacterControllable(event.subject.id))
end

events.dead.FingerBullet = function (event, game)
    local theId = event.subject.id
    event.subject:destroy()
    game.stems[theId] = nil
    game.removed[theId] = true
end

return process
