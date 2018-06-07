local Platform = require 'platform/Platform'
local CharacterControllable = require 'character/CharacterControllable'
local NullControllable = require 'character/NullControllable'
local FingerBullet = require 'weapons/projectiles/FingerBullet'
local ThirtyOdd = require 'weapons/projectiles/ThirtyOdd'
local Pointer = require 'weapons/Pointer'
local Sniper = require 'weapons/Sniper'
local Character = require 'character/Character'
local HealthPower = require 'powerups/HealthPower'
local WeaponPower = require 'powerups/WeaponPower'

local newBody = love.physics.newBody

-- local unpackables = { CharacterControllable = 'unpackCharacterControllable', projectile = 'unpackProjectile', Powerup = 'unpackPowerup', Platform = 'unpackPlatform' }
-- local projectiles = { FingerBullet = FingerBullet }

local unpackables = {}

function reviveObject(state, game)
    if unpackables[state.type] then
        local zombie = unpackables[state.type](state, game)
        zombie:reId(state)
        return zombie
    end
end

function makeBody(state, game, type)
    return love.physics.newBody(game.world, state.bodyDeets.x, state.bodyDeets.y, type)
end

unpackables.Platform = function(state, game)
    return Platform:new(makeBody(state, game, 'kinematic'), state.width, state.height)
end

unpackables.CharacterControllable = function(state, game)
    return CharacterControllable:new(makeBody(state.character, game, 'dynamic'))
end

unpackables.NullControllable = function (state, game)
    return NullControllable:new()
end
unpackables.FingerBullet = function (state, game)
    return FingerBullet:new(dummyWeapon(state), game.world)
end

unpackables.ThirtyOdd = function (state, game)
    return ThirtyOdd:new(dummyWeapon(state), game)
end

function dummyWeapon(state)
    return { x = state.bodyDeets.x, y = state.bodyDeets.y, r = state.bodyDeets.angle, playerId = state.playerId }
end

unpackables.Pointer = function (state, game)
    return Pointer:new()
end

unpackables.Sniper = function (state, game)
    return Sniper:new()
end

unpackables.Character = function (state, game)
    return Character:new(makeBody(state, game, 'dynamic'))
end

unpackables.HealthPower = function (state, game)
    return HealthPower:new(makeBody(state, game, 'kinematic'))
end

local weapons = {}
weapons.Pointer = Pointer
weapons.Sniper = Sniper

unpackables.WeaponPower = function (state, game)
    return WeaponPower:new(makeBody(state, game, 'kinematic'), weapons[state.weapon])
end

unpackables.Health = function (state, game)
    return Health:new(state.hp, state.capacity)
end

unpackables.WeaponCollection = function (state, game)
    return WeaponCollection:new()
end

return reviveObject
