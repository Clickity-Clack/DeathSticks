describe('Projectile', function()
    local dummyProjectileObj, DummyProjectileObj
    setup(function()
        _G.class = require 'lib/middleclass'
        _G.uuid = require 'lib/uuid'
        _G.love = require 'spec/mock/love/love-mock'
        _G.Packable = require 'handlers/unpacking/Packable'
        _G.DynamicBodiedPackable = require 'handlers/unpacking/DynamicBodiedPackable'
        _G.Projectile = require 'weapons/projectiles/Projectile'
        _G.DummyWeaponObj = require 'spec/weapons/DummyWeaponObj'
        DummyProjectileObj = require 'spec/weapons/DummyProjectileObj'
        
    end)

    teardown(function()
        dummyProjectileObj = nil
        DummyProjectileObj = nil
    end)

    before_each(function()
        dummyProjectileObj = DummyProjectileObj:new(DummyWeaponObj:new())    
    end)

    describe('properties', function()
        it('should have a lastX', function()
            assert.truthy(dummyProjectileObj.lastX)
        end)
        it('should have a lastY', function()
            assert.truthy(dummyProjectileObj.lastY)       
        end)
    end)

    describe('methods', function()
        describe('update', function()
            it('should exist', function()
                assert.truthy(dummyProjectileObj.update)
                assert.same(type(dummyProjectileObj.update), 'function')
            end)
            it('should set modified to true when x or y values change', function()
                dummyProjectileObj.modified = false
                dummyProjectileObj.body.x = 12
                dummyProjectileObj.body.y = 12
                dummyProjectileObj:update(0.02)
                assert.is_true(dummyProjectileObj.modified)
            end)
        end)

        describe('getState', function()
            it('should return a corresponding state', function()
                local dynamicBodiedPackableState = dummyProjectileObj:getState()
                assert.same(dummyProjectileObj.id, dynamicBodiedPackableState.id)
                assert.same(dummyProjectileObj.class.name, dynamicBodiedPackableState.type)
                assert.same(dummyProjectileObj.body.x, dynamicBodiedPackableState.bodyDeets.x)
                assert.same(dummyProjectileObj.body.y, dynamicBodiedPackableState.bodyDeets.y)
                assert.same(dummyProjectileObj.body.xSpeed, dynamicBodiedPackableState.bodyDeets.xSpeed)
                assert.same(dummyProjectileObj.body.ySpeed, dynamicBodiedPackableState.bodyDeets.ySpeed)
                assert.same(dummyProjectileObj.body.angle, dynamicBodiedPackableState.bodyDeets.angle)
                assert.same(dummyProjectileObj.playerId, dynamicBodiedPackableState.playerId)

                dummyProjectileObj.body.x = 15
                dummyProjectileObj.body.y = 19
                dummyProjectileObj.body.xSpeed = 20
                dummyProjectileObj.body.ySpeed = 92
                dummyProjectileObj.body.angle = 1

                dynamicBodiedPackableState = dummyProjectileObj:getState()
                assert.same(dummyProjectileObj.id, dynamicBodiedPackableState.id)
                assert.same(dummyProjectileObj.class.name, dynamicBodiedPackableState.type)
                assert.same(dummyProjectileObj.body.x, dynamicBodiedPackableState.bodyDeets.x)
                assert.same(dummyProjectileObj.body.y, dynamicBodiedPackableState.bodyDeets.y)
                assert.same(dummyProjectileObj.body.xSpeed, dynamicBodiedPackableState.bodyDeets.xSpeed)
                assert.same(dummyProjectileObj.body.ySpeed, dynamicBodiedPackableState.bodyDeets.ySpeed)
                assert.same(dummyProjectileObj.body.angle, dynamicBodiedPackableState.bodyDeets.angle)
                assert.same(dummyProjectileObj.playerId, dynamicBodiedPackableState.playerId)
            end)
            it('should set modified to false', function()
                dummyProjectileObj.modified = true
                dummyProjectileObj:getState()
                assert.is_false(dummyProjectileObj.modified)
            end)
            it('should return state even if modified is false', function()
                dummyProjectileObj.modified = false
                local dynamicBodiedPackableState = dummyProjectileObj:getState()
                assert.same(dummyProjectileObj.id, dynamicBodiedPackableState.id)
                assert.same(dummyProjectileObj.class.name, dynamicBodiedPackableState.type)
                assert.same(dummyProjectileObj.body.x, dynamicBodiedPackableState.bodyDeets.x)
                assert.same(dummyProjectileObj.body.y, dynamicBodiedPackableState.bodyDeets.y)
                assert.same(dummyProjectileObj.body.xSpeed, dynamicBodiedPackableState.bodyDeets.xSpeed)
                assert.same(dummyProjectileObj.body.ySpeed, dynamicBodiedPackableState.bodyDeets.ySpeed)
                assert.same(dummyProjectileObj.body.angle, dynamicBodiedPackableState.bodyDeets.angle)
                assert.same(dummyProjectileObj.playerId, dynamicBodiedPackableState.playerId)
            end)
        end)

        describe('unpackState', function()
            it('should update relevant properties to match the state', function()
                local dynamicBodiedPackableState = { id = 'hotDang', type = 'derf-a-nerf', bodyDeets = { x = 12, y = 12, xSpeed = 43, ySpeed = 89, angle = 0.2} }
                dummyProjectileObj:unpackState(dynamicBodiedPackableState)
                assert.is_not.same(dummyProjectileObj.id, dynamicBodiedPackableState.id)
                assert.is_not.same(dummyProjectileObj.class.name, dynamicBodiedPackableState.type)
                assert.same(dummyProjectileObj.body.x, dynamicBodiedPackableState.bodyDeets.x)
                assert.same(dummyProjectileObj.body.y, dynamicBodiedPackableState.bodyDeets.y)
                assert.same(dummyProjectileObj.body.xSpeed, dynamicBodiedPackableState.bodyDeets.xSpeed)
                assert.same(dummyProjectileObj.body.ySpeed, dynamicBodiedPackableState.bodyDeets.ySpeed)
                assert.same(dummyProjectileObj.body.angle, dynamicBodiedPackableState.bodyDeets.angle)
                assert.same(dummyProjectileObj.playerId, dynamicBodiedPackableState.playerId)
            end)
        end)

        describe('reId', function()
            local dynamicBodiedPackableState = { id = 'hotDang', type = 'derf-a-nerf', bodyDeets = { x = 12, y = 12, xSpeed = 43, ySpeed = 89, angle = 0.1} }
            it('should set the id', function()
                dummyProjectileObj:reId(dynamicBodiedPackableState)
                assert.same(dummyProjectileObj.id, dynamicBodiedPackableState.id)
            end)
        end)
    end)
end)
