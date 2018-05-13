local player = require 'player'
local platform = require 'platform'
local characterControllable = require 'character/characterControllable'
local fingerBullet = require 'weapons/projectiles/fingerBullet'

local unpackables = { characterControllable = unpackCharacterControllable, projectile = unpackProjectile, powerup = unpackPowerup, platform = unpackPlatform }
local projectiles = {fingerBullet = fingerBullet}

local unpacker = function(state, objects, players, removed, world)
    unpackObjects(state.objects, objects, world)
    unpackPlayers(state.players, players, objects)
    unpackRemoved(state.removed, removed)
end

function unpackObjects(stateObjects, gameObjects, world)
    local unpacked
    for v in pairs(stateObjects) do
        anObjectState = stateObjects[v]
        local correspondingObject = gameObjects[anObjectState.id]
        if correspondingObject then
            correspondingObject:unpackState(anObjectState)
        else
            typeUnpacker = unpackables[anObjectState.type]
            if typeUnpacker then
                unpacked = typeUnpacker(anObjectState, world)
                if unpacked then
                    gameObjects[unpacked.id] = unpacked
                end
            end
        end
    end
end

function unpackPlayers(statePlayers, gamePlayers, objects)
    local unpacked
    for v in pairs(statePlayers) do
        local aPlayerState = statePlayers[v]
        local correspondingPlayer = gamePlayers[aPlayerState.id]
        if correspondingPlayer then
            correspondingPlayer:unpackState(aPlayerState)
        else
            unpacked = unpackPlayer(aPlayerState, objects)
        end
    end
end

function unpackRemoved(stateRemoved, gameRemoved)
    for v in pairs(state.removed) do
        local id = state.removed[v]
        local correspondingRemoved = removed[id]
        if not correspondingRemoved then
            correspondingRemoved = objects[id]
            if correspondingRemoved then
                objects[id] = nil
                removed[id] = ''
            else
                correspondingRemoved = players[id]
                if correspondingRemoved then
                    players[id] = nil
                    removed[id] = ''
                else
                    removed[id] = ''
                end
            end
        end
    end
end

function unpackPlayer(playerState, objects)
    --return new player
end

function unpackCharacterControllable(characterControllableState, world)
    rval = characterControllable:new(love.physics.newBody(world, characterControllableState.character.bodyDeets.rval, characterControllableState.character.bodyDeets.y, 'dynamic'))
    rval:reId(characterControllableState)
    rval:unpackState(characterControllableState)
    return rval
end

function unpackProjectile(projectileState, world)
    local rval = nil
    projectileType = projectiles[projectileState.pojectileType]
    if projectileType then
        rval = projectileType:new(projectileState)
        rval:reId(projectileState)
        return rval
    end
end

function unpackPowerup(powerupState)
    
end

function unpackPlatform(platformState, world)
    local rval = platform:new(love.physics.newBody(world, platformState.bodyDeets.x, platformState.bodyDeets.y), platformState.length, platformState.width)
    rval:unpackState(platformState)
    rval:reId(platformState)
    return rval
end

return unpacker
