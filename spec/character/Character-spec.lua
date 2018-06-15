describe('Projectile', function()
    local character, Character, Game
    setup(function()
        _G.class = require 'lib/middleclass'
        _G.uuid = require 'lib/uuid'
        _G.serpent = require 'lib/serpent'
        _G.love = require 'spec/mock/love/love-mock'
        _G.Packable = require 'handlers/unpacking/Packable'
        _G.BodiedPackable = require 'handlers/unpacking/BodiedPackable'
        _G.DynamicBodiedPackable = require 'handlers/unpacking/DynamicBodiedPackable'
        Character = require 'character/Character'
        Game = require 'spec/mock/game-mock'
    end)

    teardown(function()
        character = nil
        Character = nil
    end)

    before_each(function()
        character = Character:new(love.physics.newBody(10,10))    
    end)

    describe('properties', function()
        it('should have a lastX', function()
            assert.truthy(character.lastX)
            assert.same(type(character.lastX), 'number')
        end)
        it('should have a lastY', function()
            assert.truthy(character.lastY)
            assert.same(type(character.lastY), 'number')
        end)
        it('should have a size', function()
            assert.truthy(character.size)
            assert.same(type(character.size), 'number')
        end)
        it('should have a direction', function()
            assert.truthy(character.direction)
            assert.same(type(character.direction), 'number')
        end)
        it('should have a walking', function()
            assert.is_equal(character.walking, false)
        end)
        it('should have a dead', function()
            assert.is_equal(character.dead, false)
        end)
        it('should have an isFiring', function()
            assert.truthy(character.isFiring)
            assert.same(type(character.isFiring), 'boolean')
        end)
        it('should have an anim', function()
            assert.truthy(character.anim)
            assert.same(type(character.anim), 'table')
        end)
        it('should have a currentAnim', function()
            assert.truthy(character.currentAnim)
            assert.same(type(character.currentAnim), 'string')
        end)
        it('should have a WeaponCollection', function()
            assert.truthy(character.weapons)
            assert.same(character.weapons.class.name, 'WeaponCollection')
        end)
        it('should have a health', function()
            assert.truthy(character.health)
            assert.same(character.health.class.name, 'Health')
        end)
        it('should have a shape', function()
            assert.truthy(character.shape)
            assert.same(character.shape.class.name, 'MockShape')
        end)
        it('should have a body', function()
            assert.truthy(character.body)
            assert.same(character.body.class.name, 'BodyMock')
        end)
    end)

    describe('methods', function()
        describe('update', function()
            it('should exist', function()
                assert.truthy(character.update)
                assert.same(type(character.update), 'function')
            end)
            it('should set modified to true when x or y values change', function()
                character.modified = false
                character.body.x = 12
                character.body.y = 12
                character:update(0.02, {})
                assert.is_true(character.modified)
            end)
        end)

        describe('getState', function()
            it('should return a corresponding state', function()
                local characterState = character:getState()
                assert.same(character.id, characterState.id)
                assert.same(character.class.name, characterState.type)
                assert.same(character.body.x, characterState.bodyDeets.x)
                assert.same(character.body.y, characterState.bodyDeets.y)
                assert.same(character.body.xSpeed, characterState.bodyDeets.xSpeed)
                assert.same(character.body.ySpeed, characterState.bodyDeets.ySpeed)
                assert.same(character.direction, characterState.direction)
                assert.same(character.currentAnim, characterState.currentAnim)
                assert.same(character.weapons.id, characterState.weapons.id)
                assert.same(character.health.id, characterState.health.id)

                character.body.x = 15
                character.body.y = 19
                character.body.xSpeed = 20
                character.body.ySpeed = 92
                character.body.angle = 1
                character.modified = true

                characterState = character:getState()
                assert.same(character.id, characterState.id)
                assert.same(character.class.name, characterState.type)
                assert.same(character.body.x, characterState.bodyDeets.x)
                assert.same(character.body.y, characterState.bodyDeets.y)
                assert.same(character.body.xSpeed, characterState.bodyDeets.xSpeed)
                assert.same(character.body.ySpeed, characterState.bodyDeets.ySpeed)
            end)
            it('should set modified to false', function()
                character:getState()
                assert.is_false(character.modified)
            end)
            it('should return nothing if modified is false', function()
                character.modified = false
                local characterState = character:getState()
                assert.same(characterState, nil)
            end)
        end)

        describe('unpackState', function()
            it('should update relevant properties to match the state', function()
                local healthState = { id = 'hotDang', type = 'derf-a-nerf', hp = 50, capacity = 100 }
                local weaponState = { id = 'hotDang', type = 'derf-a-nerf', weapons = { WeaponMock = { id = 'doof', type = 'WeaponMock', udp = 'say Whaaaat?' }, mock1 = { id = 'dorf', type = 'mock1', udp = 'no, you first' }, mock2 = { id = 'norg', type = 'mock2', udp = 'oh, but I insist' } }, currentId = 'mock1' }
                local characterState = { id = 'hotDang', type = 'derf-a-nerf', bodyDeets = { x = 12, y = 12, xSpeed = 43, ySpeed = 89}, health = healthState, weapons = weaponState }
                character:unpackState(characterState, Game:new())
                assert.is_not.same(character.id, characterState.id)
                assert.is_not.same(character.class.name, characterState.type)
                assert.same(character.body.x, characterState.bodyDeets.x)
                assert.same(character.body.y, characterState.bodyDeets.y)
                assert.same(character.body.xSpeed, characterState.bodyDeets.xSpeed)
                assert.same(character.body.ySpeed, characterState.bodyDeets.ySpeed)
                assert.same(character.direction, characterState.direction)
                assert.same(character.currentAnim, characterState.currentAnim)
                assert.same(character.weapons.current.class.name, characterState.weapons.currentId)
                assert.same(character.health.hp, characterState.health.hp)
            end)
        end)

        describe('reId', function()
            local healthState = { id = 'hotDang', type = 'derf-a-nerf', hp = 50, capacity = 100 }
            local weaponState = { id = 'hotDang', type = 'derf-a-nerf', weapons = { Pointer = { id = 'doof', type = 'WeaponMock', udp = 'say Whaaaat?' }, mock1 = { id = 'dorf', type = 'mock1', udp = 'no, you first' }, mock2 = { id = 'norg', type = 'mock2', udp = 'oh, but I insist' } }, currentId = 'mock1' }
            local characterState = { id = 'hotDang', type = 'derf-a-nerf', bodyDeets = { x = 12, y = 12, xSpeed = 43, ySpeed = 89}, health = healthState, weapons = weaponState }
            it('should change the id', function()
                character:reId(characterState)
                assert.same(character.id, characterState.id)
                assert.same(character.health.id, characterState.health.id)
                assert.same(character.weapons.id, characterState.weapons.id)
            end)
        end)

        describe('update', function()
            it('should set modified to true when any children are modified', function()
                character:getState()
                character.health.modified = true
                character:update(1,{})
                assert.is_true(character.modified)
                character:getState()
                character.weapons.modified = true
                character:update(1,{})
                assert.is_true(character.modified)
            end)
        end)
    end)
end)
