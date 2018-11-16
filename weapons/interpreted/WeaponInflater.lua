local WeaponInflater = {}
local json = require 'lib/json'
local InterpretedWeapon = require('weapon/interpreted/InterpretedWeapon')

function WeaponInflater.getWeaponObjectTable()
    local weaponObjectTable = {}
    local settingDeets = json.decode( love.filesystem.read('weapons/interpreted/Weapons.json') )
    for i, v in ipairs(settingsDeets) do
        local thing = class(i,Weapon)
        for j in pairs(v) do
            propertySettingMethods[j](thing, j, v[j])
        end
        weaponObjectTable[i] = thing
    end
    return weaponObjectTable
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
    -- self[propertyName] = 
end

function instancePropertySet()
    self['initial' .. propertyName] = 
end

return WeaponInflater
