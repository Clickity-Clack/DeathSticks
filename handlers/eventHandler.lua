local NullControllable = require 'character/NullControllable'
local NullJetpack = require 'character/NullJetpack'
local events = { collide = {}, dead = {}, respawn = {}, fire = {} }
local spawnSound = love.audio.newSource('sounds/weow.wav', 'static')
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
    game.players[event.subject.playerId].controllable.character:switchJetpack(NullJetpack:new(event.subject.playerId))
    local obj = event.subject.replacement:new(event.subject:getBarrelDeets(), event.subject.playerId, game.world)
    if obj then
        game.stems[obj.id] = obj
    end
end

stemDead = function(event, game)
    local theId = event.subject.id
    event.subject:destroy()
    game.stems[theId] = nil
    game.removed[theId] = true
    game.removedChanged = true
end

events.dead.CharacterControllable = function (event, game)
    local thePlayerId = event.subject.playerId
    local thePlayer = game.players[thePlayerId]
    local newNull = NullControllable:new()
    thePlayer:switchControllable(newNull)
    game.stems[newNull.id] = newNull
    stemDead(event, game)
    table.insert(game.events, {type = 'respawn', time = 1, subject = thePlayer})
end

events.respawn.Player = function (event, game)
    love.audio.play(spawnSound)
    event.subject:switchControllable(game:newCharacterControllable(event.subject.id))
end

events.dead.FingerBullet = stemDead
events.dead.ThirtyOdd = stemDead
events.dead.Explosion = stemDead

explode = function(event, game)
    local obj = event.subject.replacement:new(love.physics.newBody(game.world, event.subject:getX(), event.subject:getY(), 'dynamic'),event.subject.plyerId)
    if obj then
        game.stems[obj.id] = obj
    end
    stemDead(event, game)
end

events.dead.DeadJetpack = explode
events.dead.Rocket = explode
events.dead.Grenade = explode

return process
