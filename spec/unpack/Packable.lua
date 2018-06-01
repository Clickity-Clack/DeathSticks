describe('Packable', function()
    local Packable, packable

    setup(function()
        Packable = require 'handlers/unpacking/Packable'
    end)

    teardown(function()
        Packable = nil
    end)

    before_each(function()
        packable = Packable:new()        
    end)

    describe('should have all its properties', function()
        local packableState = { id = 'fluffernutter', type = 'Packable' }
        it('should have an id', function()
            assert.truthy(packable.id)
        end)
        it('should have a modified', function()
            assert.truthy(packable.modified)
        end)
    end)

    describe('should change its id on reId', function()
        local packableState = { id = 'fluffernutter', type = 'Packable' }
        it('should have a new id', function()
            packable:reId(packableState)
            assert.same(packable.id, packableState.id)
        end)
    end)
end)
