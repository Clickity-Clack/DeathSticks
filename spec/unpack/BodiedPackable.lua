describe('BodiedPackable', function()
    local dummyBPObj, DummyBPObj
    setup(function()
        _G.class = require 'lib/middleclass'
        _G.uuid = require 'lib/uuid'
        _G.love = require 'spec/mock/love-mock'
        _G.Packable = require 'handlers/unpacking/Packable'
        _G.BodiedPackable = require 'handlers/unpacking/BodiedPackable'
        DummyBPObj = require 'spec/unpack/DummyBPObj'
        
    end)

    teardown(function()
        dummyBPObj = nil
        DummyBPObj = nil
    end)

    before_each(function()
        dummyBPObj = DummyBPObj:new()    
    end)

    describe('properties', function()
        local bodiedPackableState = { id = 'fluffernutter', type = 'BodiedPackable', bodyDeets = { x = 12, y = 12} }
        it('should have an id', function()
            assert.truthy(dummyBPObj.id)
        end)
        it('should have a modified', function()
            assert.truthy(dummyBPObj.modified)
        end)
        it('should have a body', function()
            assert.truthy(dummyBPObj.body)
        end)
        it('should have a shape', function()
            assert.truthy(dummyBPObj.shape)
        end)
        it('should have a fixture', function()
            assert.truthy(dummyBPObj.fixture)
        end)
        it('fixture userdata should be itself', function()
            assert.same(dummyBPObj.fixture:getUserData(), dummyBPObj)
        end)
    end)

    describe('methods', function()
        describe('getState', function()
            it('should return a corresponding state', function()
                local bodiedPackableState = dummyBPObj:getState()
                assert.same(dummyBPObj.id, bodiedPackableState.id)
                assert.same(dummyBPObj.class.name, bodiedPackableState.type)
                assert.same(dummyBPObj.body.x, bodiedPackableState.bodyDeets.x)
                assert.same(dummyBPObj.body.y, bodiedPackableState.bodyDeets.y)
            end)
            it('should set modified to false', function()
                dummyBPObj.modified = true
                dummyBPObj:getState()
                assert.is_false(dummyBPObj.modified)
            end)
        end)

        describe('unpackState', function()
            it('should update relevant properties to match the state', function()
                local bodiedPackableState = { id = 'hotDang', type = 'derf-a-nerf', bodyDeets = { x = 12, y = 12} }
                dummyBPObj:unpackState(bodiedPackableState)
                assert.is_not.same(dummyBPObj.id, bodiedPackableState.id)
                assert.is_not.same(dummyBPObj.class.name, bodiedPackableState.type)
                assert.same(dummyBPObj.body.x, bodiedPackableState.bodyDeets.x)
                assert.same(dummyBPObj.body.y, bodiedPackableState.bodyDeets.y)
                bodiedPackableState = { id = 'hotDang', type = 'derf-a-nerf', bodyDeets = { x = 18, y = 93} }
                dummyBPObj:unpackState(bodiedPackableState)
                assert.is_not.same(dummyBPObj.id, bodiedPackableState.id)
                assert.is_not.same(dummyBPObj.class.name, bodiedPackableState.type)
                assert.same(dummyBPObj.body.x, bodiedPackableState.bodyDeets.x)
                assert.same(dummyBPObj.body.y, bodiedPackableState.bodyDeets.y)
            end)
        end)

        describe('reId', function()
            local bodiedPackableState = { id = 'fluffernutter', type = 'BodiedPackable', bodyDeets = { x = 12, y = 12} }
            it('should set the id', function()
                dummyBPObj:reId(bodiedPackableState)
                assert.same(dummyBPObj.id, bodiedPackableState.id)
            end)
        end)
    end)
end)
