describe('WeaponPower', function()
    local weaponPower, WeaponPower, WeaponMock
    setup(function()
        _G.class = require 'lib/middleclass'
        _G.uuid = require 'lib/uuid'
        _G.love = require 'spec/mock/love/love-mock'
        _G.Packable = require 'handlers/unpacking/Packable'
        _G.BodiedPackable = require 'handlers/unpacking/BodiedPackable'
        WeaponPower = require 'powerups/WeaponPower'
        WeaponMock = require 'spec/mock/weapon-mock'
    end)

    teardown(function()
        weaponPower = nil
        WeaponPower = nil
    end)

    before_each(function()
        weaponPower = WeaponPower:new(love.physics.newBody(), WeaponMock:new())    
    end)

    describe('properties', function()
        it('should have a visible', function()
            assert(weaponPower.visible)
            assert.same(type(weaponPower.visible), 'boolean')
        end)
    end)

    describe('methods', function()
        describe('getState', function()
            it('should exist', function()
                assert(weaponPower.getState)
                assert.same(type(weaponPower.getState), 'function')
            end)
            it('should return a corresponding state', function()
                local weaponPowerState = weaponPower:getState()
                assert.same(weaponPower.id, weaponPowerState.id)
                assert.same(weaponPower.class.name, weaponPowerState.type)
                assert.same(weaponPower.body.x, weaponPowerState.bodyDeets.x)
                assert.same(weaponPower.body.y, weaponPowerState.bodyDeets.y)
                assert.same(weaponPower.visible, weaponPowerState.visible)
                assert.same(weaponPower.weapon.name, weaponPowerState.weaponName)
            end)
            it('should set modified to false', function()
                weaponPower:getState()
                assert.is_false(weaponPower.modified)
            end)
            it('should return nothing if modified is false', function()
                weaponPower.modified = false
                local weaponPowerState = weaponPower:getState()
                assert.are.equals(weaponPowerState, nil)
            end)
        end)

        describe('unpackState', function()
            it('should exist', function()
                assert(weaponPower.unpackState)
                assert.same(type(weaponPower.unpackState), 'function')
            end)
            it('should update relevant properties to match the state', function()
                local weaponPowerState = { id = 'hotDang', type = 'derf-a-nerf', bodyDeets = { x = 12, y = 12} }
                weaponPower:unpackState(weaponPowerState)
                assert.is_not.same(weaponPower.id, weaponPowerState.id)
                assert.is_not.same(weaponPower.class.name, weaponPowerState.type)
                assert.same(weaponPower.body.x, weaponPowerState.bodyDeets.x)
                assert.same(weaponPower.body.y, weaponPowerState.bodyDeets.y)
                assert.same(weaponPower.visible, weaponPowerState.visible)
                weaponPowerState = { id = 'hotDang', type = 'derf-a-nerf', bodyDeets = { x = 18, y = 93} }
                weaponPower:unpackState(weaponPowerState)
                assert.is_not.same(weaponPower.id, weaponPowerState.id)
                assert.is_not.same(weaponPower.class.name, weaponPowerState.type)
                assert.same(weaponPower.body.x, weaponPowerState.bodyDeets.x)
                assert.same(weaponPower.body.y, weaponPowerState.bodyDeets.y)
                assert.same(weaponPower.visible, weaponPowerState.visible)
            end)
        end)

        describe('reId', function()
            local weaponPowerState = { id = 'fluffernutter', type = 'BodiedPackable', bodyDeets = { x = 12, y = 12} }
            it('should set the id', function()
                weaponPower:reId(weaponPowerState)
                assert.same(weaponPower.id, weaponPowerState.id)
            end)
        end)
    end)
end)