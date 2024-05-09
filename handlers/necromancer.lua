local Platform = require 'platform/Platform'
local DestroyablePlatform = require 'platform/DestroyablePlatform'
local Water = require 'platform/Water'
local TeamBase = require 'platform/TeamBase'
local DeadlyPlatform = require 'platform/DeadlyPlatform'
local Bottom = require 'platform/Bottom'
local CharacterControllable = require 'character/CharacterControllable'
local NullControllable = require 'character/NullControllable'
local Character = require 'character/Character'
local Health = require 'character/Health'
local Armor = require 'character/Armor'
local NullArmor = require 'character/NullArmor'
local Jetpack = require 'character/Jetpack'
local NullJetpack = require 'character/NullJetpack'
local FingerBullet = require 'weapons/projectiles/FingerBullet'
local ThirtyOdd = require 'weapons/projectiles/ThirtyOdd'
local Pellet = require 'weapons/projectiles/Pellet'
local NineMil = require 'weapons/projectiles/NineMil'
local Rocket = require 'weapons/projectiles/explosive/Rocket'
local Grenade = require 'weapons/projectiles/explosive/Grenade'
local DeadJetpack = require 'weapons/projectiles/explosive/DeadJetpack'
local Twelve = require 'weapons/projectiles/multishot/Twelve'
local Pointer = require 'weapons/Pointer'
local Sniper = require 'weapons/Sniper'
local Pistol = require 'weapons/Pistol'
local Shotgun = require 'weapons/Shotgun'
local RocketLauncher = require 'weapons/RocketLauncher'
local GrenadeLauncher = require 'weapons/GrenadeLauncher'
local Explosion = require 'weapons/explosions/Explosion'
local HealthPower = require 'powerups/HealthPower'
local WeaponPower = require 'powerups/WeaponPower'
local JetpackPower = require 'powerups/JetpackPower'
local ArmorPower = require 'powerups/ArmorPower'

local newBody = love.physics.newBody

-- local serializeables = { CharacterControllable = 'unpackCharacterControllable', projectile = 'unpackProjectile', Powerup = 'unpackPowerup', Platform = 'unpackPlatform' }
-- local projectiles = { FingerBullet = FingerBullet }

local serializeables = {}

function reviveObject(state, game)
    if serializeables[state.type] then
        local zombie = serializeables[state.type](state, game)
        zombie:reId(state)
        return zombie
    end
end

function makeIPosition(state, game)
    return {physicsWorld = game.physicsWorld, x = state.position.x, y = state.position.y}
end

serializeables.Platform = function(state, game)
    return Platform:new(makeIPosition(state, game), state.width, state.height)
end

serializeables.DestroyablePlatform = function(state, game)
    return DestroyablePlatform:new(makeIPosition(state, game), state.width, state.height)
end

serializeables.Water = function(state, game)
    return Water:new(makeIPosition(state, game), state.width, state.height)
end

serializeables.TeamBase = function(state, game)
    return TeamBase:new(makeIPosition(state, game), state.width, state.height, state.team)
end

serializeables.DeadlyPlatform = function(state, game)
    return DeadlyPlatform:new(makeIPosition(state, game), state.width, state.height)
end

serializeables.Bottom = function (state, game)
    return Bottom:new(makeIPosition(state, game), state.width, state.height)
end

serializeables.CharacterControllable = function(state, game)
    return CharacterControllable:new(makeIPosition(state.character, game), state.playerId)
end

serializeables.NullControllable = function (state, game)
    return NullControllable:new()
end

serializeables.Explosion = function(state, game)
    return Explosion:new(makeIPosition(state, game, 'static'), state.playerId)
end

unpackBullet = function(type, state, game)
    return type:new(dummyBarrelDeets(state), state.playerId, game.physicsWorld)
end

serializeables.FingerBullet = function (state, game)
    return unpackBullet(FingerBullet, state, game)
end

serializeables.ThirtyOdd = function (state, game)
    return unpackBullet(ThirtyOdd, state, game)
end

serializeables.NineMil = function (state, game)
    return unpackBullet(NineMil, state, game)
end

serializeables.Pellet = function (state, game)
    return unpackBullet(Pellet, state, game)
end

serializeables.Rocket = function (state, game)
    return unpackBullet(Rocket, state, game)
end

serializeables.Grenade = function (state, game)
    return unpackBullet(Grenade, state, game)
end

serializeables.DeadJetpack = function (state, game)
    return unpackBullet(DeadJetpack, state, game)
end

serializeables.Twelve = function (state, game)
    return Twelve:new({x = 0, y = 0, r = 0}, state.playerId, game.physicsWorld)
end

function dummyBarrelDeets(state)
    return { x = state.position.x, y = state.position.y, r = state.position.angle }
end

serializeables.Pointer = function (state, game)
    return Pointer:new()
end

serializeables.Sniper = function (state, game)
    return Sniper:new()
end

serializeables.Pistol = function (state, game)
    return Pistol:new()
end

serializeables.RocketLauncher = function (state, game)
    return RocketLauncher:new()
end

serializeables.GrenadeLauncher = function (state, game)
    return GrenadeLauncher:new()
end

serializeables.Shotgun = function (state, game)
    return Shotgun:new()
end

serializeables.Character = function (state, game)
    if not state.health then print(serpent.block(state)) end
    return Character:new(makeIPosition(state, game, 'dynamic'))
end

serializeables.HealthPower = function (state, game)
    return HealthPower:new(makeIPosition(state, game))
end

local weapons = {}
weapons.Pointer = Pointer
weapons.Sniper = Sniper
weapons.Pistol = Pistol
weapons.GrenadeLauncher = GrenadeLauncher
weapons.RocketLauncher = RocketLauncher
weapons.Shotgun = Shotgun

serializeables.WeaponPower = function (state, game)
    return WeaponPower:new(makeIPosition(state, game), weapons[state.weaponName])
end

serializeables.ArmorPower = function (state, game)
    return ArmorPower:new(makeIPosition(state, game))
end

serializeables.JetpackPower = function (state, game)
    return JetpackPower:new(makeIPosition(state, game))
end

serializeables.Health = function (state, game)
    return Health:new(state.hp, state.capacity)
end

serializeables.Armor = function (state, game)
    return Armor:new(state.hp, state.capacity)
end

serializeables.NullArmor = function (state, game)
    return NullArmor:new()
end

serializeables.Jetpack = function (state, game)
    return Jetpack:new()
end

serializeables.NullJetpack = function (state, game)
    return NullJetpack:new()
end

serializeables.WeaponCollection = function (state, game)
    return WeaponCollection:new()
end

return reviveObject
