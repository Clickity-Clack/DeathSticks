local Inflater = require('weapon/interpreted/Inflater')

describe('Inflater', function() -- Should return a list of objects that match the properties and methods passed in. Error checking?
    local propertySettingMethods
    setup(function()
        _G.class = require 'lib/middleclass'
        DummyWeaponObj = require 'spec/weapons/DummyWeaponObj'
    end)



    describe('Test 1', function()
        local propertySettingMethods = {}
        local instantiator = Inflater.newObjectsOfSingleTypeInstantiator()
        it('should read true as true', function()
            assert.true(true)
        end)
    end)
    describe('Test 2', function()
        -- "Archibald":{
        --     "Type": "Asparagus",
        --     "Height": "6'3",
        --     "Clothes":[
        --         "Bow Tie",
        --         "Monacle"
        --     ]
        -- }
    end)
end)