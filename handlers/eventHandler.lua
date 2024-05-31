-- Something about this whole file doesn't smell right - I feel like there's a more logical way to distribute these responsibilities. Idk
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
    local obj = event.subject:fire()
    if obj then
        game.world.stems[obj.id] = obj
    end
end

events.dead.Jetpack = function (event, game)
    game.players[event.subject.playerId].controllable.character:switchJetpack(NullJetpack:new(event.subject.playerId))
    local obj = event.subject.replacement:new(event.subject:getReplacementIPosition(game.world.physicsWorld), event.subject.playerId)
    if obj then
        game.world.stems[obj.id] = obj
    end
end

stemDead = function(event, game)
    local theId = event.subject.id
    event.subject:destroy()
    game.world.stems[theId] = nil
    game.world.removed[theId] = true
    game.world.removedChanged = true
end

events.dead.CharacterControllable = function (event, game)
    local thePlayerId = event.subject.playerId
    local thePlayer = game.players[thePlayerId]
    local newNull = NullControllable:new()
    thePlayer:switchControllable(newNull)
    game.world.stems[newNull.id] = newNull
    game.victory:assess(event)
    stemDead(event, game)
    table.insert(game.events, {type = 'respawn', time = 1, subject = thePlayer})
end

events.respawn.Player = function (event, game)
    love.audio.play(spawnSound)
    local oldControllableId = event.subject.controllable.id
    event.subject:switchControllable(game.world:spawnControllable(event.subject.id))
    game.world.stems[oldControllableId] = nil
end

events.dead.FingerBullet = stemDead
events.dead.ThirtyOdd = stemDead
events.dead.Explosion = stemDead
events.dead.Twelve = stemDead
events.dead.NineMil = stemDead
events.dead.DestroyablePlatform = stemDead

events.dead.TeamBase = function(event, game)
    game.victory:assess(event)
    stemDead(event, game)
end

explode = function(event, game)
    local obj = event.subject.replacement:new({physicsWorld = game.world.physicsWorld, x = event.subject:getX(), y = event.subject:getY()}, event.subject.playerId)
    if obj then
        game.world.stems[obj.id] = obj
    end
    stemDead(event, game)
end

events.dead.DeadJetpack = explode
events.dead.Rocket = explode
events.dead.Grenade = explode

return process
