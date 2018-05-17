local Player = require 'Player'
local Platform = require 'Platform'
local CharacterControllable = require 'character/CharacterControllable'
local FingerBullet = require 'weapons/projectiles/FingerBullet'

local unpackables = { CharacterControllable = unpackCharacterControllable, projectile = unpackProjectile, Powerup = unpackPowerup, Platform = unpackPlatform }
local projectiles = {FingerBullet = FingerBullet}

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
    --return new Player
end

function unpackCharacterControllable(CharacterControllableState, world)
    rval = CharacterControllable:new(love.physics.newBody(world, CharacterControllableState.Character.bodyDeets.rval, CharacterControllableState.Character.bodyDeets.y, 'dynamic'))
    rval:reId(CharacterControllableState)
    rval:unpackState(CharacterControllableState)
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

function unpackPowerup(PowerupState)
    
end

function unpackPlatform(PlatformState, world)
    local rval = Platform:new(love.physics.newBody(world, PlatformState.bodyDeets.x, PlatformState.bodyDeets.y), PlatformState.length, PlatformState.width)
    rval:unpackState(PlatformState)
    rval:reId(PlatformState)
    return rval
end

return unpacker
