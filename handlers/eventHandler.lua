local NullControllable = require 'character/NullControllable'
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
        game.objects[obj.id] = obj
    end
end

events.dead.CharacterControllable = function (event, game)
    local thePlayerId = event.subject.playerId
    local thePlayer = game.players[thePlayerId]
    local theId = event.subject.id
    thePlayer.controllable = NullControllable:new()
    event.subject:destroy()
    game.objects[theId] = nil
    game.removed[theId] = true
    table.insert(game.events, {type = 'respawn', time = 1, subject = thePlayer})
end

events.respawn.Player = function (event, game)
    event.subject:switchControllable(game:newCharacterControllable())
end

events.dead.FingerBullet = function (event, game)
    local theId = event.subject.id
    event.subject:destroy()
    game.objects[theId] = nil
    game.removed[theId] = true
end

return process
