describe('DynamicBodiedPackable', function()
    local dummyDBPObj, DummyDBPObj
    setup(function()
        _G.class = require 'lib/middleclass'
        _G.uuid = require 'lib/uuid'
        _G.love = require 'spec/mock/love/love-mock'
        _G.Packable = require 'handlers/unpacking/Packable'
        _G.DynamicBodiedPackable = require 'handlers/unpacking/DynamicBodiedPackable'
        DummyDBPObj = require 'spec/unpack/DummyDBPObj'
        
    end)

    teardown(function()
        dummyDBPObj = nil
        DummyDBPObj = nil
    end)

    before_each(function()
        dummyDBPObj = DummyDBPObj:new()    
    end)

    describe('properties', function()
        it('should have a lastX', function()
            assert.truthy(dummyDBPObj.lastX)
        end)
        it('should have a lastY', function()
            assert.truthy(dummyDBPObj.lastY)       
        end)
    end)

    describe('methods', function()
        describe('update', function()
            it('should exist', function()
                assert.truthy(dummyDBPObj.update)
                assert.same(type(dummyDBPObj.update), 'function')
            end)
            it('should set modified to true when x or y values change', function()
                dummyDBPObj.modified = false
                dummyDBPObj.body.x = 12
                dummyDBPObj.body.y = 12
                dummyDBPObj:update(0.02)
                assert.is_true(dummyDBPObj.modified)
            end)
        end)

        describe('getState', function()
            it('should return a corresponding state', function()
                local dynamicBodiedPackableState = dummyDBPObj:getState()
                assert.same(dummyDBPObj.id, dynamicBodiedPackableState.id)
                assert.same(dummyDBPObj.class.name, dynamicBodiedPackableState.type)
                assert.same(dummyDBPObj.body.x, dynamicBodiedPackableState.bodyDeets.x)
                assert.same(dummyDBPObj.body.y, dynamicBodiedPackableState.bodyDeets.y)
                assert.same(dummyDBPObj.body.xSpeed, dynamicBodiedPackableState.bodyDeets.xSpeed)
                assert.same(dummyDBPObj.body.ySpeed, dynamicBodiedPackableState.bodyDeets.ySpeed)

                dummyDBPObj.body.x = 15
                dummyDBPObj.body.y = 19
                dummyDBPObj.body.xSpeed = 20
                dummyDBPObj.body.ySpeed = 92

                dynamicBodiedPackableState = dummyDBPObj:getState()
                assert.same(dummyDBPObj.id, dynamicBodiedPackableState.id)
                assert.same(dummyDBPObj.class.name, dynamicBodiedPackableState.type)
                assert.same(dummyDBPObj.body.x, dynamicBodiedPackableState.bodyDeets.x)
                assert.same(dummyDBPObj.body.y, dynamicBodiedPackableState.bodyDeets.y)
                assert.same(dummyDBPObj.body.xSpeed, dynamicBodiedPackableState.bodyDeets.xSpeed)
                assert.same(dummyDBPObj.body.ySpeed, dynamicBodiedPackableState.bodyDeets.ySpeed)
            end)
            it('should set modified to false', function()
                dummyDBPObj.modified = true
                dummyDBPObj:getState()
                assert.is_false(dummyDBPObj.modified)
            end)
        end)

        describe('unpackState', function()
            it('should update relevant properties to match the state', function()
                local dynamicBodiedPackableState = { id = 'hotDang', type = 'derf-a-nerf', bodyDeets = { x = 12, y = 12, xSpeed = 43, ySpeed = 89} }
                dummyDBPObj:unpackState(dynamicBodiedPackableState)
                assert.is_not.same(dummyDBPObj.id, dynamicBodiedPackableState.id)
                assert.is_not.same(dummyDBPObj.class.name, dynamicBodiedPackableState.type)
                assert.same(dummyDBPObj.body.x, dynamicBodiedPackableState.bodyDeets.x)
                assert.same(dummyDBPObj.body.y, dynamicBodiedPackableState.bodyDeets.y)
                assert.same(dummyDBPObj.body.xSpeed, dynamicBodiedPackableState.bodyDeets.xSpeed)
                assert.same(dummyDBPObj.body.ySpeed, dynamicBodiedPackableState.bodyDeets.ySpeed)
            end)
        end)
    end)
end)
