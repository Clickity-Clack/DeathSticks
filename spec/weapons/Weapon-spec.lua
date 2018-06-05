describe('Weapon', function()
    local DummyWeaponObj, dummyWeaponObj
    setup(function()
        _G.class = require 'lib/middleclass'
        _G.uuid = require 'lib/uuid'
        _G.love = require 'spec/mock/love/love-mock'
        _G.Packable = require 'handlers/unpacking/Packable'
        _G.Weapon = require 'weapons/Weapon'
        DummyWeaponObj = require 'spec/weapons/DummyWeaponObj'
    end)

    teardown(function()
        weapon = nil
        Weapon = nil
    end)

    before_each(function()
        dummyWeaponObj = DummyWeaponObj:new()    
    end)

    describe('properties', function()
        it('should have a firing', function()
            assert.is_not.equals(dummyWeaponObj.firing, nil)
            assert.same(type(dummyWeaponObj.firing), 'boolean')
        end)
        it('should have a delay', function()
            assert(dummyWeaponObj.delay)
            assert.same(type(dummyWeaponObj.delay), 'number')
        end)
    end)

    describe('methods', function()
        describe('getState', function()
            it('should exist', function()
                assert(dummyWeaponObj.getState)
                assert.same(type(dummyWeaponObj.getState), 'function')
            end)
            it('should return a corresponding state', function()
                local weaponState = dummyWeaponObj:getState()
                assert.same(dummyWeaponObj.id, weaponState.id)
                assert.same(dummyWeaponObj.class.name, weaponState.type)
                assert.same(dummyWeaponObj.x, weaponState.x)
                assert.same(dummyWeaponObj.y, weaponState.y)
                assert.same(dummyWeaponObj.r, weaponState.r)
                assert.same(dummyWeaponObj.ammo, weaponState.ammo)
                assert.same(dummyWeaponObj.delay, weaponState.delay)
            end)
            it('should set modified to false', function()
                dummyWeaponObj:getState()
                assert.is_false(dummyWeaponObj.modified)
            end)
            it('should return nothing if modified is false', function()
                dummyWeaponObj.modified = false
                local weaponState = dummyWeaponObj:getState()
                assert.are.equals(weaponState, nil)
            end)
        end)

        describe('unpackState', function()
            it('should exist', function()
                assert(dummyWeaponObj.unpackState)
                assert.same(type(dummyWeaponObj.unpackState), 'function')
            end)
            it('should update relevant properties to match the state', function()
                local weaponState = { id = 'hotDang', type = 'derf-a-nerf' }
                dummyWeaponObj:unpackState(weaponState)
                assert.is_not.same(dummyWeaponObj.id, weaponState.id)
                assert.is_not.same(dummyWeaponObj.class.name, weaponState.type)
                assert.same(dummyWeaponObj.x, weaponState.x)
                assert.same(dummyWeaponObj.y, weaponState.y)
                assert.same(dummyWeaponObj.r, weaponState.r)
                assert.same(dummyWeaponObj.ammo, weaponState.ammo)
                assert.same(dummyWeaponObj.delay, weaponState.delay)
                weaponState = { id = 'hotDang', type = 'derf-a-nerf' }
                dummyWeaponObj:unpackState(weaponState)
                assert.is_not.same(dummyWeaponObj.id, weaponState.id)
                assert.is_not.same(dummyWeaponObj.class.name, weaponState.type)
                assert.same(dummyWeaponObj.x, weaponState.x)
                assert.same(dummyWeaponObj.y, weaponState.y)
                assert.same(dummyWeaponObj.r, weaponState.r)
                assert.same(dummyWeaponObj.ammo, weaponState.ammo)
                assert.same(dummyWeaponObj.delay, weaponState.delay)
            end)
        end)

        describe('reId', function()
            local weaponState = { id = 'fluffernutter', type = 'BodiedPackable', bodyDeets = { x = 12, y = 12} }
            it('should set the id', function()
                dummyWeaponObj:reId(weaponState)
                assert.same(dummyWeaponObj.id, weaponState.id)
            end)
        end)
    end)
end)