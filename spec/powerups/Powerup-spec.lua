describe('Powerup', function()
    local powerup, Powerup
    setup(function()
        _G.class = require 'lib/middleclass'
        _G.uuid = require 'lib/uuid'
        _G.love = require 'spec/mock/love/love-mock'
        _G.Packable = require 'handlers/unpacking/Packable'
        _G.BodiedPackable = require 'handlers/unpacking/BodiedPackable'
        Powerup = require 'powerups/Powerup'
        
    end)

    teardown(function()
        powerup = nil
        Powerup = nil
    end)

    before_each(function()
        powerup = Powerup:new(love.physics.newBody(), love.graphics.newImage())    
    end)

    describe('properties', function()
        it('should have a visible', function()
            assert(powerup.visible)
            assert.same(type(powerup.visible), 'boolean')
        end)
    end)

    describe('methods', function()
        describe('getState', function()
            it('should exist', function()
                assert(powerup.getState)
                assert.same(type(powerup.getState), 'function')
            end)
            it('should return a corresponding state', function()
                local powerupState = powerup:getState()
                assert.same(powerup.id, powerupState.id)
                assert.same(powerup.class.name, powerupState.type)
                assert.same(powerup.body.x, powerupState.bodyDeets.x)
                assert.same(powerup.body.y, powerupState.bodyDeets.y)
                assert.same(powerup.visible, powerupState.visible)
            end)
            it('should set modified to false', function()
                powerup:getState()
                assert.is_false(powerup.modified)
            end)
            it('should return nothing if modified is false', function()
                powerup.modified = false
                local powerupState = powerup:getState()
                assert.are.equals(powerupState, nil)
            end)
        end)

        describe('unpackState', function()
            it('should exist', function()
                assert(powerup.unpackState)
                assert.same(type(powerup.unpackState), 'function')
            end)
            it('should update relevant properties to match the state', function()
                local powerupState = { id = 'hotDang', type = 'derf-a-nerf', bodyDeets = { x = 12, y = 12} }
                powerup:unpackState(powerupState)
                assert.is_not.same(powerup.id, powerupState.id)
                assert.is_not.same(powerup.class.name, powerupState.type)
                assert.same(powerup.body.x, powerupState.bodyDeets.x)
                assert.same(powerup.body.y, powerupState.bodyDeets.y)
                assert.same(powerup.visible, powerupState.visible)
                powerupState = { id = 'hotDang', type = 'derf-a-nerf', bodyDeets = { x = 18, y = 93} }
                powerup:unpackState(powerupState)
                assert.is_not.same(powerup.id, powerupState.id)
                assert.is_not.same(powerup.class.name, powerupState.type)
                assert.same(powerup.body.x, powerupState.bodyDeets.x)
                assert.same(powerup.body.y, powerupState.bodyDeets.y)
                assert.same(powerup.visible, powerupState.visible)
            end)
        end)

        describe('reId', function()
            local powerupState = { id = 'fluffernutter', type = 'BodiedPackable', bodyDeets = { x = 12, y = 12} }
            it('should set the id', function()
                powerup:reId(powerupState)
                assert.same(powerup.id, powerupState.id)
            end)
        end)
    end)
end)