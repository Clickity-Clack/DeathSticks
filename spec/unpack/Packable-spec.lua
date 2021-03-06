describe('Packable', function()
    local Packable, packable

    setup(function()
        _G.uuid = require 'lib/uuid'
        _G.class = require 'lib/middleclass'
        Packable = require 'handlers/unpacking/Packable'
    end)

    teardown(function()
        Packable = nil
    end)

    before_each(function()
        packable = Packable:new()        
    end)

    describe('properties', function()
        it('should have an id', function()
            assert.truthy(packable.id)
        end)
        it('should have a modified', function()
            assert.truthy(packable.modified)
        end)
    end)

    describe('methods', function()
        it('should have a getState method', function()
            assert.truthy(packable.getState)
            assert.same(type(packable.getState), 'function')
        end)
        it('should have an unpackState method', function()
            assert.truthy(packable.unpackState)
            assert.same(type(packable.unpackState), 'function')
        end)

        describe('getState', function()
            it('should return a corresponding state', function()
                local packableState = packable:getState()
                assert.same(packable.id, packableState.id)
                assert.same(packable.class.name, packableState.type)
            end)
            it('should set modified to false', function()
                assert.is_true(packable.modified)
                packable:getState()
                assert.is_false(packable.modified)
            end)
        end)

        describe('unpackState', function()
            local newPackableState = { id = 'fluffernutter', type = 'grunk' }
            it('should change nothing', function()
                packable:unpackState(newPackableState)
                local packableState = packable:getState()
                assert.is_not.same(packableState.id, newPackableState.id)
                assert.is_not.same(packableState.type, newPackableState.type)
            end)
        end)

        describe('reId', function()
            local packableState = { id = 'fluffernutter', type = 'grunk' }
            it('should change the id', function()
                packable:reId(packableState)
                assert.same(packable.id, packableState.id)
                assert.is_not.same(packable.class.name, packableState.type)
            end)
        end)
    end)
end)
