local Player = require 'Player'
local Platform = require 'Platform'
local CharacterControllable = require 'character/CharacterControllable'
local NullControllable = require 'character/NullControllable'
local FingerBullet = require 'weapons/projectiles/FingerBullet'
local Pointer = require 'weapons/Pointer'
local Character = require 'character/Character'
local HealthPower = require 'powerups/HealthPower'
local WeaponPower = require 'powerups/WeaponPower'

-- local unpackables = { CharacterControllable = 'unpackCharacterControllable', projectile = 'unpackProjectile', Powerup = 'unpackPowerup', Platform = 'unpackPlatform' }
-- local projectiles = { FingerBullet = FingerBullet }
local objects, players, removed, world

local init = function(objectsTable, playersTable, removedTable, world)
    objects = objectsTable
    players = playersTable
    removed = removedTable
    world = world
end

local unpacker = function(state, removed)
    unpackObjects(state.objects, objects)
    unpackPlayers(state.players, players, objects)
    unpackRemoved(state.removed, removed)
end

function unpackObjects(stateObjects)
    local unpacked
    for v in pairs(stateObjects) do
        anObjectState = stateObjects[v]
        local correspondingObject = gameObjects[anObjectState.id]
        if correspondingObject then
            correspondingObject:unpackState(anObjectState)
        else        
            unpackObject(anObjectState)
        end
    end
end

function unpackPlayers(statePlayers, gamePlayers)
    local unpacked
    for v in pairs(statePlayers) do
        local aPlayerState = statePlayers[v]
        local correspondingPlayer = gamePlayers[aPlayerState.id]
        if correspondingPlayer then
            correspondingPlayer:unpackState(aPlayerState)
        else
            unpacked = unpackPlayer(aPlayerState)
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

function unpackObject(objectState)
    local rval = objects[objectState.id]
    if not rval then
       rval = unpackables[objectState.type](objectState)
    end
    return rval
end

function finalize(object, objectState)
    object:reId(objectState)
    object:unpackState(objectState, unpackObject)
end

function unpackPlayer(playerState)
    --make new player, finalize, return
end

return init, unpacker
