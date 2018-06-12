describe('Platform', function()
    local platform, Platform
    setup(function()
        _G.class = require 'lib/middleclass'
        _G.uuid = require 'lib/uuid'
        _G.love = require 'spec/mock/love/love-mock'
        _G.Packable = require 'handlers/unpacking/Packable'
        _G.BodiedPackable = require 'handlers/unpacking/BodiedPackable'
        Platform = require 'platform/Platform'
        
    end)

    teardown(function()
        platform = nil
        platform = nil
    end)

    before_each(function()
        platform = Platform:new(love.physics.newBody(), 1, 2)    
    end)

    describe('properties', function()
        it('should have a width', function()
            assert(platform.width)
            assert.same(type(platform.width), 'number')
        end)
        it('should have a height', function()
            assert(platform.height)
            assert.same(type(platform.height), 'number')
        end)
    end)

    describe('methods', function()
        describe('getState', function()
            it('should exist', function()
                assert(platform.getState)
                assert.same(type(platform.getState), 'function')
            end)
            it('should return a corresponding state', function()
                local platformState = platform:getState()
                assert.same(platform.id, platformState.id)
                assert.same(platform.class.name, platformState.type)
                assert.same(platform.body.x, platformState.bodyDeets.x)
                assert.same(platform.body.y, platformState.bodyDeets.y)
                assert.same(platform.height, platformState.height)
                assert.same(platform.width, platformState.width)
            end)
            it('should set modified to false', function()
                platform:getState()
                assert.is_false(platform.modified)
            end)
            it('should return nothing if modified is false', function()
                platform.modified = false
                local platformState = platform:getState()
                assert.are.equals(platformState, nil)
            end)
        end)

        describe('unpackState', function()
            it('should exist', function()
                assert(platform.unpackState)
                assert.same(type(platform.unpackState), 'function')
            end)
            it('should update relevant properties to match the state', function()
                local platformState = { id = 'hotDang', type = 'derf-a-nerf', height = 12, width = 11, bodyDeets = { x = 12, y = 12} }
                platform:unpackState(platformState)
                assert.is_not.same(platform.id, platformState.id)
                assert.is_not.same(platform.class.name, platformState.type)
                assert.same(platform.body.x, platformState.bodyDeets.x)
                assert.same(platform.body.y, platformState.bodyDeets.y)
                assert.same(platform.height, platformState.height)
                assert.same(platform.width, platformState.width)
                platformState = { id = 'hotDang', type = 'derf-a-nerf', bodyDeets = { x = 18, y = 93} }
                platform:unpackState(platformState)
                assert.is_not.same(platform.id, platformState.id)
                assert.is_not.same(platform.class.name, platformState.type)
                assert.same(platform.body.x, platformState.bodyDeets.x)
                assert.same(platform.body.y, platformState.bodyDeets.y)
                assert.same(platform.visible, platformState.visible)
            end)
        end)

        describe('reId', function()
            local platformState = { id = 'fluffernutter', type = 'BodiedPackable', height = 12, width = 11, bodyDeets = { x = 12, y = 12} }
            it('should set the id', function()
                platform:reId(platformState)
                assert.same(platform.id, platformState.id)
            end)
        end)
    end)
end)