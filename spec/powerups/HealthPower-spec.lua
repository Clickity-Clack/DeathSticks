describe('BodiedPackable', function()
    local healthPower, HealthPower, HealthMock
    setup(function()
        _G.class = require 'lib/middleclass'
        _G.uuid = require 'lib/uuid'
        _G.love = require 'spec/mock/love/love-mock'
        _G.Packable = require 'handlers/unpacking/Packable'
        _G.BodiedPackable = require 'handlers/unpacking/BodiedPackable'
        HealthMock = require 'spec/mock/health-mock'
        HealthPower = require 'powerups/HealthPower'
        
    end)

    teardown(function()
        healthPower = nil
        HealthPower = nil
    end)

    before_each(function()
        healthPower = HealthPower:new()    
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
                local aHealth = HealthMock:new()
                local s = spy.on(aHealth, 'heal')
                healthPower:zoop(aHealth)
                assert.spy(s).was.called()
                assert.spy(s).was.called_with(aHealth,healthPower.value)
            end)
        end)
    end)
end)