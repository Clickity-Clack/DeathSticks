local Platform = require 'platform/Platform'
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

unpackables.Bottom = function (state, game)
    return Bottom:new(makeBody(state, game, 'kinematic'), state.width)
end

unpackables.CharacterControllable = function(state, game)
    return CharacterControllable:new(makeBody(state.character, game, 'dynamic'))
end

unpackables.NullControllable = function (state, game)
    return NullControllable:new()
end

unpackables.Explosion = function(state, game)
    return Explosion:new(makeBody(state, game, 'static'), state.playerId)
end

unpackBullet = function(type, state, game)
    return type:new(dummyBarrelDeets(state), state.playerId, game.world)
end

unpackables.FingerBullet = function (state, game)
    return unpackBullet(FingerBullet, state, game)
end

unpackables.ThirtyOdd = function (state, game)
    return unpackBullet(ThirtyOdd, state, game)
end

unpackables.NineMil = function (state, game)
    return unpackBullet(NineMil, state, game)
end

unpackables.Pellet = function (state, game)
    return unpackBullet(Pellet, state, game)
end

unpackables.Rocket = function (state, game)
    return unpackBullet(Rocket, state, game)
end

unpackables.Grenade = function (state, game)
    return unpackBullet(Grenade, state, game)
end

unpackables.DeadJetpack = function (state, game)
    return unpackBullet(DeadJetpack, state, game)
end

unpackables.Twelve = function (state, game)
    return Twelve:new({x = 0, y = 0, r = 0}, state.playerId, game.world)
end

function dummyBarrelDeets(state)
    return { x = state.bodyDeets.x, y = state.bodyDeets.y, r = state.bodyDeets.angle }
end

unpackables.Pointer = function (state, game)
    return Pointer:new()
end

unpackables.Sniper = function (state, game)
    return Sniper:new()
end

unpackables.Pistol = function (state, game)
    return Pistol:new()
end

unpackables.RocketLauncher = function (state, game)
    return RocketLauncher:new()
end

unpackables.GrenadeLauncher = function (state, game)
    return GrenadeLauncher:new()
end

unpackables.Shotgun = function (state, game)
    return Shotgun:new()
end

unpackables.Character = function (state, game)
    if not state.health then print(serpent.block(state)) end
    return Character:new(makeBody(state, game, 'dynamic'))
end

unpackables.HealthPower = function (state, game)
    return HealthPower:new(makeBody(state, game, 'kinematic'))
end

local weapons = {}
weapons.Pointer = Pointer
weapons.Sniper = Sniper
weapons.Pistol = Pistol
weapons.GrenadeLauncher = GrenadeLauncher
weapons.RocketLauncher = RocketLauncher
weapons.Shotgun = Shotgun

unpackables.WeaponPower = function (state, game)
    return WeaponPower:new(makeBody(state, game, 'kinematic'), weapons[state.weaponName])
end

unpackables.ArmorPower = function (state, game)
    return ArmorPower:new(makeBody(state, game))
end

unpackables.JetpackPower = function (state, game)
    return JetpackPower:new(makeBody(state, game))
end

unpackables.Health = function (state, game)
    return Health:new(state.hp, state.capacity)
end

unpackables.Armor = function (state, game)
    return Armor:new(state.hp, state.capacity)
end

unpackables.NullArmor = function (state, game)
    return NullArmor:new()
end

unpackables.Jetpack = function (state, game)
    return Jetpack:new()
end

unpackables.NullJetpack = function (state, game)
    return NullJetpack:new()
end

unpackables.WeaponCollection = function (state, game)
    return WeaponCollection:new()
end

return reviveObject
