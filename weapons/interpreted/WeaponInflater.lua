local WeaponInflater = {}
local Inflater = require('weapon/interpreted/Inflater')
local ProjectileInflater = require('weapon/interpreted/ProjectileInflater')
local projectiles = ProjectileInflater.getProjectileObjectTable('weapons/interpreted/Projectiles.json')

function WeaponInflater.getWeaponObjectTable()
    local instantiator = Inflater.newObjectsOfSingleTypeInstantiator(Weapon)
    local populator = Inflater.newPopulator(propertySettingMethods)
    return Inflater.Inflate(instantiator, populator, 'weapons/interpreted/Weapons.json')
end

local propertySettingMethods = {}
propertySettingMethods['ammo'] = instancePropertySet
propertySettingMethods['rof'] = basicPropertySet
propertySettingMethods['capacity'] = basicPropertySet
propertySettingMethods['projectile'] = projectilePropertySet
propertySettingMethods['sound'] = audioPropertySet
propertySettingMethods['image'] = picturePropertySet
propertySettingMethods['scale'] = basicPropertySet
propertySettingMethods['ox'] = basicPropertySet
propertySettingMethods['oy'] = basicPropertySet
propertySettingMethods['barrelLen'] = basicPropertySet
propertySettingMethods['reloadSound'] = audioPropertySet
propertySettingMethods['reloadTime'] = basicPropertySet

function basicPropertySet(self, propertyName, setting)
    self[propertyName] = setting
end

function picturePropertySet(self, propertyName, setting)
    self[propertyName] = love.graphics.newImage('res/'.. setting)
end

function audioPropertySet(self, propertyName, setting)
    self[propertyName] = love.audio.newSource('sounds/'.. setting, 'static')
end

function projectilePropertySet(self, propertyName, setting)
    self[propertyName] = projectiles[setting]
end

function instancePropertySet()
    self['initial' .. propertyName] = 
end

return WeaponInflater
