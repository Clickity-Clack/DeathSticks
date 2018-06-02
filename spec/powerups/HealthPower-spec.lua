describe('BodiedPackable', function()
    local dummyBPObj, DummyBPObj
    setup(function()
        _G.class = require 'lib/middleclass'
        _G.uuid = require 'lib/uuid'
        _G.love = require 'spec/mock/love/love-mock'
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
        it('should have a value', function()
            assert(healthPower.value)
            assert.same(type(healthPower.value), 'number')
        end)
    end)

    describe('methods', function()
        describe('zoop', function()
            it('should exist', function()
                assert(healthPower.zoop)
                assert.same(type(healthPower.zoop), 'function')
            end)

            it('should modify the passed in health appropriately', function()
                assert(healthPower.zoop)
                assert.same(type(healthPower.zoop), 'function')
            end)
        end)
    end)
end)