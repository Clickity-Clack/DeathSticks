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
local necromancer = require 'handlers/necromancer'

local WorldFactory = class('WorldFactory')

function WorldFactory:PopulateWorld(world, mapName)
    world.backDrop = GridBackDrop:new()
    world.controllable = CharacterControllable
    world.stemTypes = {CharacterControllable = true, ThirtyOdd = true, NineMil = true, Twelve = true, Rocket = true, Grenade = true, Explosion = true, HealthPower = true, WeaponPower = true, ArmorPower = true, JetpackPower = true, FingerBullet = true, NullControllable = true, Platform = true, DestroyablePlatform = true, DeadlyPlatform = true, Bottom = true}
    loadMap(mapName, world.stems, world.physicsWorld, world.spawnPoints)
end

function loadMap(mapName, stems, physicsWorld, spawnPoints)
    local mapFile = io.open('world/maps/' .. mapName .. '.json', "r")
    local mapText = mapFile:read("all")
    mapFile:close()
    local map = json.decode(mapText)
    if not map or not map.objects then
        --TODO: Find a way to exit gracefully if a map fails to load
        print('FUCK.')
        return
    end
    for i in pairs(map.spawnPoints) do
        table.insert(spawnPoints, map.spawnPoints[i])
    end
    for i, objState in ipairs(map.objects) do
        if diag.World.printObjectTypes then
            print(objState.type)
        end
        local newObj = necromancer(objState, physicsWorld)
        local id = newObj.id
        stems[id] = newObj
    end
end

return WorldFactory