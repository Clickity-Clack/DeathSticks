local CharacterControllable = require 'character/CharacterControllable'
local GridBackDrop = require 'world/backdrops/GridBackDrop'
local necromancer = require 'handlers/necromancer'

local WorldFactory = class('WorldFactory')

function WorldFactory:PopulateWorld(world, mapName)
    world.backDrop = GridBackDrop:new()
    world.controllable = CharacterControllable
    loadMap(mapName, world.stems, world.physicsWorld, world.spawnPoints)
end

function loadMap(mapName, stems, physicsWorld, spawnPoints)
    local mapLocation = 'world/maps/' .. mapName .. '.json'
    local mapText = love.filesystem.read('world/maps/' .. mapName .. '.json')
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