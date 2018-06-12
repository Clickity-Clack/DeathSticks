describe('Side', function()
    local side, Side
    setup(function()
        _G.class = require 'lib/middleclass'
        Point = require 'platform/Point'
        Side = require 'platform/Side'
    end)

    teardown(function()
        side = nil
        Side = nil
    end)

    before_each(function()
        side = Side:new(Point:new({},{},{ x = 4, y = 3 }), Point:new({},{},{ x = 1, y = 2 }))
    end)

    describe('properties', function()
        it('should have a pointA', function()
            assert(side.pointA)
            assert.same(type(side.pointA), 'table')
            assert.same(side.pointA.class.name, 'Point')
        end)
        it('should have a pointB', function()
            assert(side.pointB)
            assert.same(type(side.pointB), 'table')
            assert.same(side.pointB.class.name, 'Point')
        end)

        describe('angle', function()
            it('should exist', function()
                assert(side.angle)
                assert.same(type(side.angle), 'number')
            end)
            it('should be calculated correctly', function()
                assert.same(side.angle, math.atan2(4-1, 3-2))
            end)
        end)

        describe('slope', function()
            it('should exist', function()
                assert(side.slope)
                assert.same(type(side.slope), 'number')
            end)
            it('should be calculated correctly', function()
                assert.same(side.slope, (4-1)/(3-2))
            end)
        end)

        describe('b', function()
            it('should exist', function()
                assert(side.b)
                assert.same(type(side.b), 'number')
            end)
            it('should be calculated correctly', function()
                assert.same(side.b, (1-(2*(4-1)/(3-2))))
            end)
        end)
    end)

    describe('methods', function()
    end)
end)