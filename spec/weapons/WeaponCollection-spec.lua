describe('WeaponCollection', function()
    local WeaponCollection, weaponCollection, WeaponMock, Game

    setup(function()
        _G.class = require 'lib/middleclass'
        _G.uuid = require 'lib/uuid'
        _G.love = require 'spec/mock/love/love-mock'
        _G.Packable = require 'handlers/unpacking/Packable'
        _G.serpent = require 'lib/serpent'
        WeaponCollection = require 'weapons/WeaponCollection'
        WeaponMock = require 'spec/mock/weapon-mock'
        Game = require 'spec/mock/game-mock'
    end)

    teardown(function()
        WeaponCollection = nil
    end)

    before_each(function()
        weaponCollection = WeaponCollection:new(WeaponMock:new('hOtDAwg!'))
        mock1 = class('mock1', WeaponMock)
        mock1.initialize = function (self)  end
        mock2 = class('mock2', WeaponMock)
        weaponCollection:addWeapon(mock1:new())
        weaponCollection:addWeapon(mock2:new('thumtax'))
    end)

    describe('properties', function()
        it('should have an id', function()
            assert.truthy(weaponCollection.id)
        end)
        it('should have a modified', function()
            assert.truthy(weaponCollection.modified)
            assert.same(type(weaponCollection.modified), 'boolean')
        end)
        it('should have weapons', function()
            assert.truthy(weaponCollection.weapons)
            assert.same(type(weaponCollection.weapons), 'table')
        end)
        it('should have a current', function()
            assert.truthy(weaponCollection.current)
            assert.same(weaponCollection.current.class.name, 'WeaponMock')
        end)
    end)

    describe('methods', function()
        describe('getState', function()
            it('should exist', function()
                assert.truthy(weaponCollection.getState)
                assert.same(type(weaponCollection.getState), 'function')
            end)

            it('should return a corresponding state', function()
                local weaponCollectionState = weaponCollection:getState()
                assert.same(weaponCollection.id, weaponCollectionState.id)
                assert.same(weaponCollection.class.name, weaponCollectionState.type)
                assert.same(weaponCollection.current.class.name, weaponCollectionState.currentId)
                assert.same(weaponCollection.weapons['WeaponMock'].uselessDataPoint, weaponCollection.weapons['WeaponMock'].uselessDataPoint)
            end)
            it('should set modified to false', function()
                assert.is_true(weaponCollection.modified)
                weaponCollection:getState()
                assert.is_false(weaponCollection.modified)
            end)
        end)

        describe('unpackState', function()
            it('should exist', function()
                assert.truthy(weaponCollection.unpackState)
                assert.same(type(weaponCollection.unpackState), 'function')
            end)
            
            it('should update relevant properties to match the state', function()
                local newWeaponCollectionState = { id = 'hotDang', type = 'derf-a-nerf', weapons = { WeaponMock = { id = 'WeaponMock', type = 'WeaponMock', udp = 'say Whaaaat?' }, mock1 = { id = 'mock1', type = 'mock1', udp = 'no, you first' }, mock2 = { id = 'mock2', type = 'mock2', udp = 'oh, but I insist' } }, currentId = 'mock1' }
                weaponCollection:unpackState(newWeaponCollectionState, Game:new())
                local weaponCollectionState = weaponCollection:getState()
                assert.is_not.same(weaponCollectionState.id, newWeaponCollectionState.id)
                assert.is_not.same(weaponCollectionState.type, newWeaponCollectionState.type)
                assert.same(weaponCollection.current.class.name, weaponCollectionState.currentId)
                assert.same(weaponCollection.weapons['WeaponMock'].uselessDataPoint, weaponCollection.weapons['WeaponMock'].uselessDataPoint)
                assert.truthy(weaponCollection.weapons['mock1'])
                assert.same(weaponCollection.weapons['mock1'].uselessDataPoint, weaponCollection.weapons['mock1'].uselessDataPoint)
                assert.truthy(weaponCollection.weapons['mock2'])
                assert.same(weaponCollection.weapons['mock2'].uselessDataPoint, weaponCollection.weapons['mock2'].uselessDataPoint)
            end)
        end)

        describe('reId', function()
            local weaponCollectionState = { id = 'hotDang', type = 'derf-a-nerf', weapons = { WeaponMock = { id = 'doof', type = 'WeaponMock', udp = 'say Whaaaat?' }, mock1 = { id = 'dorf', type = 'mock1', udp = 'no, you first' }, mock2 = { id = 'norg', type = 'mock2', udp = 'oh, but I insist' } }, currentId = 'mock1' }
            it('should change the id', function()
                weaponCollection:reId(weaponCollectionState)
                assert.same(weaponCollection.id, weaponCollectionState.id)
                assert.same(weaponCollection.weapons['WeaponMock'].id, weaponCollectionState.weapons['WeaponMock'].id)
                assert.same(weaponCollection.weapons['mock1'].id, weaponCollectionState.weapons['mock1'].id)
                assert.same(weaponCollection.weapons['mock2'].id, weaponCollectionState.weapons['mock2'].id)
            end)
        end)

        describe('update', function()
            it('should set modified to true when any children are modified', function()
                weaponCollection:getState()
                weaponCollection.weapons['mock1'].modified = true
                weaponCollection:update()
                assert.is_true(weaponCollection.modified)
            end)
        end)
    end)
end)
