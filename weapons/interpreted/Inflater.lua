local json = require 'lib/json' --WRITE A TEST FOR THIS THING, YA DINGUS
local Inflater = {}

function Inflater.getObjectTable(instantiator, populator, jsonLocation)
    local objectTable = {}
    local objectsInfo = json.decode( love.filesystem.read(jsonLocation) )
    for objectName, settings in ipairs(objectsInfo) do
        local newObject = instantiator(objectName, settings)
        populator(newObject, settings)
        objectTable[objectName] = newObject
    end
    return objectTable
end

function Inflater.newObjectsOfSingleTypeInstantiator(superclass)
    return function(name, settings)
        return class(name, superclass)
    end
end

function Inflater.newObjectsOfManyTypesInstantiator(superclasses)
    return function(name, settings)
        return class(name, superclasses[settings['Type']])
    end
end

function Inflater.newPopulator(propertySettingMethods)
    return function(object, settings)
        for propertyName in pairs(settings) do
            propertySettingMethods[propertyName](object, propertyName, settings[propertyName])
        end
    end
end

return Inflater
