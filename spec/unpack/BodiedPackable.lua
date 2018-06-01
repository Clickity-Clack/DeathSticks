describe('BodiedPackable', function()
    local dummyBPObj, DummyBPObj
    setup(function()
        _G.class = require 'lib/middleclass'
        _G.uuid = require 'lib/uuid'
        _G.love = require 'spec/unpack/love-mock'
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

    describe('reId', function()
        local bodiedPackableState = { id = 'fluffernutter', type = 'BodiedPackable', bodyDeets = { x = 12, y = 12} }
        it('should set the id', function()
            dummyBPObj:reId(bodiedPackableState)
            assert.same(dummyBPObj.id, bodiedPackableState.id)
        end)
    end)
end)
