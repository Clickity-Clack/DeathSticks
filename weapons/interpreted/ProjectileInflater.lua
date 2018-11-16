local ProjectileInflater = {}
local json = require 'lib/json'
local json = require 'lib/json'

local projectileTypes = {}
projectileTypes['Bullet'] = require 'weapons/projectiles/Bullet'
projectileTypes['MultiShot'] = require 'weapons/projectiles/multishot/MultiShot'
projectileTypes['Explosive'] = require 'weapons/projectiles/explosive/ExplosiveProjectile'

function ProjectileInflater.getProjectileObjectList()
    local objects = {}
    local settingsDeets = json.decode( love.filesystem.read('weapons/interpreted/Projectiles.json') )
    for i, v in ipairs(settingsDeets) do
        local thing = class(i,projectileTypes[v['Type']]) -- This is probably the least readable piece of code I've ever written. 
        for j in pairs(v) do
            propertySettingMethods[j](thing, j, v[j])
        end
        weaponObjectTable[i] = thing
    end
    return weaponObjectTable
end

local propertySettingMethods = {}
propertySettingMethods['speed'] = basicPropertySet
propertySettingMethods['image'] = picturePropertySet
propertySettingMethods['shape'] = shapePropertySet
propertySettingMethods['scale'] = basicPropertySet
propertySettingMethods['damage'] = basicPropertySet
propertySettingMethods['collisions'] = collisionsSet
propertySettingMethods['gravity'] = placeholder
propertySettingMethods['restitution'] = placeholder
propertySettingMethods['time'] = placeholder

function basicPropertySet(self, propertyName, setting)
    self[propertyName] = setting
end

function picturePropertySet(self, propertyName, setting)
    self[propertyName] = love.graphics.newImage('res/'.. setting)
end

local shapeTypes = {}
shapeTypes['square']

function shapePropertySet(self, propertyName, setting)
    self[propertyName] = love.physics.newShape()
end

function instancePropertySet(self, propertyName, setting)
    self['initial' .. propertyName] = 
end

function gravityPropertySet(self, propertyName, setting)
    
end

function restitutionPropertySet(self, propertyName, setting)

end

local collisionMethods = {}
collisionMethods['hurt'] = function(self, toHurt)
    toHurt:ouch(self)
    self:kill()
end
collisionMethods['die'] = function()
    self:kill()
end
function collisionsSet(self, propertyName, setting)
    self.laterCollisions = {}
    for i, v in ipairs() do
        self.laterCollisions[i] = collisionMethods[v]
    end
end

function fakeout()

end

return ProjectileInflater
