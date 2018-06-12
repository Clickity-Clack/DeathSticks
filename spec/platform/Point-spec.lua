describe('Point', function()
    local point, Point
    setup(function()
        _G.class = require 'lib/middleclass'
        Point = require 'platform/Point'
    end)

    teardown(function()
        point = nil
        Point = nil
    end)

    before_each(function()
        point = Point:new({}, {}, { x = 1, y = 2 })
    end)

    describe('properties', function()
        it('should have a sideA', function()
            assert(point.sideA)
            assert.same(type(point.sideA), 'table')
        end)
        it('should have a sideB', function()
            assert(point.sideB)
            assert.same(type(point.sideB), 'table')
        end)
        describe('coord', function()
            it('should exist', function()
                assert(point.coord)
                assert.same(type(point.coord), 'table')
            end)
            it('should have x and y properties', function()
                assert.same(point.coord.x, 1)
                assert.same(point.coord.y, 2)
            end)
        end)
    end)

    describe('methods', function()
    end)
end)