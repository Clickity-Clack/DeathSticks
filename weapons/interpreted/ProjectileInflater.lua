local ProjectileInflater = {}
local Inflater = require('weapon/interpreted/Inflater')

local projectileTypes = {}
projectileTypes['Bullet'] = require 'weapons/projectiles/Bullet'
projectileTypes['MultiShot'] = require 'weapons/projectiles/multishot/MultiShot'
projectileTypes['Explosive'] = require 'weapons/projectiles/explosive/ExplosiveProjectile'

function ProjectileInflater.getProjectileObjectTable(fileName)
    local instantiator = Inflater.newObjectsOfManyTypesInstantiator(projectileTypes)
    local populator = Inflater.newPopulator(propertySettingMethods)
    return Inflater.Inflate(instantiator, populator, 'weapons/interpreted/Weapons.json')
end

local propertySettingMethods = {}
propertySettingMethods['speed'] = basicPropertySet
propertySettingMethods['scale'] = basicPropertySet
propertySettingMethods['damage'] = basicPropertySet
propertySettingMethods['time'] = basicPropertySet
propertySettingMethods['image'] = picturePropertySet
propertySettingMethods['shape'] = shapePropertySet
propertySettingMethods['collisions'] = laterPropertySet
propertySettingMethods['gravity'] = laterPropertySet
propertySettingMethods['restitution'] = laterPropertySet

function basicPropertySet(self, propertyName, setting)
    self[propertyName] = setting
end

function picturePropertySet(self, propertyName, setting)
    self[propertyName] = love.graphics.newImage('res/'.. setting)
end

local shapeTypes = {}
shapeTypes['square'] = function(size) return love.physics.newRectangleShape(size, size) end
shapeTypes['circle'] = function(size) return love.physics.newCircleShape(size) end

function shapePropertySet(self, propertyName, setting)
    self[propertyName] = shapeTypes[setting.type](setting.size)
end

function instancePropertySet(self, propertyName, setting)
    self['initial' .. propertyName] = 
end

function laterPropertySet(self, propertyName, setting)
    self.later[propertyName] = setting
end

local afterInitializingMethods = {}
afterInitializingMethods['gravity'] = gravityPropertySet
afterInitializingMethods['restitution'] = restitutionPropertySet
afterInitializingMethods['collision'] = collisionsSet

function setAfterInitializing(self)
    for i, v in ipairs(self.later) do
        afterInitializingMethods[i](self, i, v)
    end
end

function gravityPropertySet(self, propertyName, setting)
    self.body:setGravityScale(setting)
end

function restitutionPropertySet(self, propertyName, setting)
    self.body:setRestitution(setting)
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
    for i, v in ipairs(setting) do
        self.collisions[i] = collisionMethods[v]
    end
end

function fakeout()

end

return ProjectileInflater
