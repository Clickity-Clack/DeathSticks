describe('Health', function()
    local Health, health

    setup(function()
        _G.class = require 'lib/middleclass'
        _G.uuid = require 'lib/uuid'
        _G.love = require 'spec/mock/love/love-mock'
        _G.Packable = require 'handlers/unpacking/Packable'
        Health = require 'character/Health'
    end)

    teardown(function()
        Health = nil
    end)

    before_each(function()
        health = Health:new(100)        
    end)

    describe('properties', function()
        it('should have an id', function()
            assert.truthy(health.id)
        end)
        it('should have a modified', function()
            assert.truthy(health.modified)
        end)
        it('should have an hp', function()
            assert.truthy(health.hp)
        end)
        it('should have an capacity', function()
            assert.truthy(health.capacity)
        end)
    end)

    describe('methods', function()
        describe('getState', function()
            it('should exist', function()
                assert.truthy(health.getState)
                assert.same(type(health.getState), 'function')
            end)

            it('should return a corresponding state', function()
                local healthState = health:getState()
                assert.same(health.id, healthState.id)
                assert.same(health.class.name, healthState.type)
                assert.same(health.hp, healthState.hp)
                assert.same(health.capacity, healthState.capacity)
            end)
            it('should set modified to false', function()
                health.modified = true
                health:getState()
                assert.is_false(health.modified)
            end)
        end)

        describe('unpackState', function()
            it('should exist', function()
                assert.truthy(health.unpackState)
                assert.same(type(health.unpackState), 'function')
            end)
            
            it('should update relevant properties to match the state', function()
                local newHealthState = { id = 'hotDang', type = 'derf-a-nerf', hp = 50, capacity = 100 }
                health:unpackState(newHealthState)
                local healthState = health:getState()
                assert.is_not.same(healthState.id, newHealthState.id)
                assert.is_not.same(healthState.type, newHealthState.type)
                assert.same(healthState.hp, newHealthState.hp)
                assert.same(healthState.capacity, newHealthState.capacity)
            end)
        end)

        describe('reId', function()
            local healthState = { id = 'hotDang', type = 'derf-a-nerf', hp = 50, capacity = 100 }
            it('should change the id', function()
                health:reId(healthState)
                assert.same(health.id, healthState.id)
            end)
        end)
    end)
end)
