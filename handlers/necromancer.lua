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

function reviveObject(state, physicsWorld)
    if serializeables[state.type] then
        local iPosition = makeIPosition(state.position, physicsWorld)
        local zombie = serializeables[state.type](state, iPosition)
        -- zombie:reId(state)
        return zombie
    end
end

function makeIPosition(position, physicsWorld)
    if position then
        return {physicsWorld = physicsWorld, x = position.x, y = position.y}
    else
        return {physicsWorld = physicsWorld}
    end
end

serializeables.Platform = function(state, iPosition)
    local pf = Platform:new(iPosition, state.dimensions)
    return pf
end

serializeables.DestroyablePlatform = function(state, iPosition)
    return DestroyablePlatform:new(iPosition, state.dimensions)
end

serializeables.Water = function(state, iPosition)
    return Water:new(iPosition, state.dimensions)
end

serializeables.TeamBase = function(state, iPosition)
    return TeamBase:new(iPosition, state.dimensions, state.team)
end

serializeables.DeadlyPlatform = function(state, iPosition)
    return DeadlyPlatform:new(iPosition, state.dimensions)
end

serializeables.Bottom = function (state, iPosition)
    return Bottom:new(iPosition, state.width)
end

serializeables.CharacterControllable = function(state, iPosition)
    return CharacterControllable:new(makeIPosition(state.character, iPosition.physicsWorld), state.playerId)
end

serializeables.NullControllable = function (state, iPosition)
    return NullControllable:new()
end

serializeables.Explosion = function(state, iPosition)
    return Explosion:new(iPosition, state.playerId)
end

unpackBullet = function(type, state, iPosition)
    return type:new(makeProjectileIPosition(state, iPosition), state.playerId)
end

serializeables.FingerBullet = function (state, iPosition)
    return unpackBullet(FingerBullet, state, iPosition)
end

serializeables.ThirtyOdd = function (state, iPosition)
    return unpackBullet(ThirtyOdd, state, iPosition)
end

serializeables.NineMil = function (state, iPosition)
    return unpackBullet(NineMil, state, iPosition)
end

serializeables.Pellet = function (state, iPosition)
    return unpackBullet(Pellet, state, iPosition)
end

serializeables.Rocket = function (state, iPosition)
    return unpackBullet(Rocket, state, iPosition)
end

serializeables.Grenade = function (state, iPosition)
    return unpackBullet(Grenade, state, iPosition)
end

serializeables.DeadJetpack = function (state, iPosition)
    return unpackBullet(DeadJetpack, state, iPosition)
end

serializeables.Twelve = function (state, iPosition)
    return Twelve:new(makeProjectileIPosition(state, iPosition), state.playerId)
end

function makeProjectileIPosition(state, iPosition)
    iPosition.rotation = state.position.angle
    return iPosition
end

serializeables.Pointer = function (state, iPosition)
    return Pointer:new()
end

serializeables.Sniper = function (state, iPosition)
    return Sniper:new()
end

serializeables.Pistol = function (state, iPosition)
    return Pistol:new()
end

serializeables.RocketLauncher = function (state, iPosition)
    return RocketLauncher:new()
end

serializeables.GrenadeLauncher = function (state, iPosition)
    return GrenadeLauncher:new()
end

serializeables.Shotgun = function (state, iPosition)
    return Shotgun:new()
end

serializeables.Character = function (state, iPosition)
    if not state.health then print(serpent.block(state)) end
    return Character:new(iPosition)
end

serializeables.HealthPower = function (state, iPosition)
    return HealthPower:new(iPosition)
end

local weapons = {}
weapons.Pointer = Pointer
weapons.Sniper = Sniper
weapons.Pistol = Pistol
weapons.GrenadeLauncher = GrenadeLauncher
weapons.RocketLauncher = RocketLauncher
weapons.Shotgun = Shotgun

serializeables.WeaponPower = function (state, iPosition)
    return WeaponPower:new(iPosition, weapons[state.weaponName])
end

serializeables.ArmorPower = function (state, iPosition)
    return ArmorPower:new(iPosition)
end

serializeables.JetpackPower = function (state, iPosition)
    return JetpackPower:new(iPosition)
end

serializeables.Health = function (state, iPosition)
    return Health:new(state.hp, state.capacity)
end

serializeables.Armor = function (state, iPosition)
    return Armor:new(state.hp, state.capacity)
end

serializeables.NullArmor = function (state, iPosition)
    return NullArmor:new()
end

serializeables.Jetpack = function (state, iPosition)
    return Jetpack:new()
end

serializeables.NullJetpack = function (state, iPosition)
    return NullJetpack:new()
end

serializeables.WeaponCollection = function (state, iPosition)
    return WeaponCollection:new()
end

return reviveObject
