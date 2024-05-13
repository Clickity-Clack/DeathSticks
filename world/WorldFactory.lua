local Platform = require 'platform/Platform'
local DestroyablePlatform = require 'platform/DestroyablePlatform'
local TeamBase = require 'platform/TeamBase'
local DeadlyPlatform = require 'platform/DeadlyPlatform'
local Water = require 'platform/Water'
local Bottom = require 'platform/Bottom'
local CharacterControllable = require 'character/CharacterControllable'
local NullControllable = require 'character/NullControllable'
local FingerBullet = require 'weapons/projectiles/FingerBullet'
local ThirtyOdd = require 'weapons/projectiles/ThirtyOdd'
local Pointer = require 'weapons/Pointer'
local Sniper = require 'weapons/Sniper'
local Shotgun = require 'weapons/Shotgun'
local RocketLauncher = require 'weapons/RocketLauncher'
local GrenadeLauncher = require 'weapons/GrenadeLauncher'
local Character = require 'character/Character'
local HealthPower = require 'powerups/HealthPower'
local WeaponPower = require 'powerups/WeaponPower'
local ArmorPower = require 'powerups/ArmorPower'
local JetpackPower = require 'powerups/JetpackPower'
local winWidth = love.graphics.getWidth
local winHeight = love.graphics.getHeight
local GridBackDrop = require 'world/backdrops/GridBackDrop'

local WorldFactory = class('WorldFactory')

function WorldFactory:PopulateWorld(world, map)
    if map == 'TestMap' then
        testPopulate(world.stems, world.physicsWorld, world.spawnPoints)
        world.backDrop = GridBackDrop:new()
        world.controllable = CharacterControllable
        world.stemTypes = {CharacterControllable = true, ThirtyOdd = true, NineMil = true, Twelve = true, Rocket = true, Grenade = true, Explosion = true, HealthPower = true, WeaponPower = true, ArmorPower = true, JetpackPower = true, FingerBullet = true, NullControllable = true, Platform = true, DestroyablePlatform = true, DeadlyPlatform = true, Bottom = true}
    end
end

function testPopulate(stems, physicsWorld, spawnPoints)
    cWorld = { w = 5000, h = 3000, columns = 24, rows = 22 }
    offCenter = { x = cWorld.w/2 - winWidth()/2, y = cWorld.h/2 - winHeight()/2 }
    local x = DestroyablePlatform:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x, 800-55/2 + offCenter.y}, {width = 800, height = 50})
    stems[x.id] = x
    x = TeamBase:new({physicsWorld = physicsWorld, x = (800/2 + offCenter.x - 700) , y = (800-55/2 + offCenter.y)}, 'red')
    stems[x.id] = x
    x = TeamBase:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x + 700 , y = 800-55/2 + offCenter.y}, 'blue')
    stems[x.id] = x
    x = HealthPower:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x, y = 800-55/2 + offCenter.y - 40})
    stems[x.id] = x
    x = WeaponPower:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x, y = 800/2 + offCenter.y - 140}, Sniper)
    stems[x.id] = x
    x = ArmorPower:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x - 500, y = 800/2 + offCenter.y + 600})
    stems[x.id] = x
    x = JetpackPower:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x + 500, y = 800/2 + offCenter.y + 600})
    stems[x.id] = x
    x = WeaponPower:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x + 180, y = 800/2 + offCenter.y + 600}, RocketLauncher)
    stems[x.id] = x
    x = WeaponPower:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x + 220, y = 800-55/2 + offCenter.y - 40}, Shotgun)
    stems[x.id] = x
    x = WeaponPower:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x + 260, y = 800-55/2 + offCenter.y - 40}, GrenadeLauncher)
    stems[x.id] = x
    x = Platform:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x, y = 600/2 + offCenter.y})
    stems[x.id] = x
    x = Platform:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x - 500, y = 600/2 + offCenter.y + 750}, {width = 800, height = 50})
    stems[x.id] = x
    x = Platform:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x + 500, y = 600/2 + offCenter.y + 750}, {width = 800, height = 50})
    stems[x.id] = x
    x = Platform:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x, y = 600/2 + offCenter.y + 700}, {width = 50, height = 500})
    stems[x.id] = x
    x = DeadlyPlatform:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x, y = 600/2 + offCenter.y + 1055}, {width = 800, height = 50})
    stems[x.id] = x
    x = Water:new({physicsWorld = physicsWorld, x = offCenter.x - 40, y = offCenter.y + 1000}, {width = 800, height = 800})
    stems[x.id] = x
    x = Platform:new({physicsWorld = physicsWorld, x = 800/2 + offCenter.x, y = 600/2 + offCenter.y + 1024}, {width = 500, height = 30})
    stems[x.id] = x
    x = Bottom:new({physicsWorld = physicsWorld, x = cWorld.w/2, y = 600/2 + offCenter.y + 2500}, cWorld.w)
    stems[x.id] = x
    --spawnPoints[1] = { x = 800/2 + offCenter.x, y = 600/2 + offCenter.y + 25}
    spawnPoints[1] = { x = 800/2 + offCenter.x + 450, y = 600/2 + offCenter.y + 25}
    spawnPoints[2] = { x = 800/2 + offCenter.x + 350, y = 600/2 + offCenter.y + 25}
end

return WorldFactory