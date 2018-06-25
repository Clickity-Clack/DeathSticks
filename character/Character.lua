local Pointer = require 'weapons/Pointer'
local Health = require 'character/Health'
local NullJetpack = require 'character/NullJetpack'
local Animation = require 'character/Animation'
local WeaponCollection = require 'weapons/WeaponCollection'
local DynamicBodiedPackable = require('handlers/unpacking/DynamicBodiedPackable')

local Character = class('Character', DynamicBodiedPackable)

function Character:initialize(body, aPlayerId)
    self.playerId = aPlayerId
    self.size = 2
    self.direction = 1
    self.walking = false
    self.isFiring = true
    self.isBlasting = true
    self.anim = {}
    self.anim['walk'] = Animation:new(love.graphics.newImage('res/oldHeroWalk.png'), 16, 18, self.size, 1, 8, 20) --duration of 1 means the Animation will play through each quad once per second
    self.anim['swim'] = Animation:new(love.graphics.newImage('res/oldHeroSwim.png'), 18, 17, self.size, 1, 9, 20)
    self.currentAnim = 'swim'
    self.dead = false
    self.weapons = WeaponCollection:new(self.playerId,Pointer:new(self.playerId))
    self.health = Health:new(self.playerId, 100)
    self.jetpack = NullJetpack:new()

    self.shape = love.physics.newRectangleShape(self.size * 16, self.size * 16)
    DynamicBodiedPackable.initialize(self, body)
    assert(self.collide, "WHat?! No collide method?!")
    self.fixture:setGroupIndex(-12)
    self.body:setFixedRotation(true)
    self.body:setGravityScale(4)
    assert(self.collisions, 'No collisions table')
    initCollisons(self.collisions)
end

function Character:getState()
    if self.modified then
        local state = DynamicBodiedPackable.getState(self)
        state.direction = self.direction
        state.currentAnim = self.currentAnim
        state.weapons = self.weapons:getState()
        state.health = self.health:getState()
        return state
    end
end

function Character:unpackState(state, game)
    self.direction = state.direction
    self.currentAnim = state.currentAnim
    self.health:unpackState(state.health, game)
    self.weapons:unpackState(state.weapons, game)
    self.jetpack:unpackState(state.jetpack, game)
    DynamicBodiedPackable.unpackState(self, state)
end

function Character:reId(state)
    DynamicBodiedPackable.reId(self,state)
    self.weapons:reId(state.weapons)
    self.health:reId(state.health)
end

function Character:fullReport()
    DynamicBodiedPackable.fullReport(self)
    self.health:fullReport()
    self.weapons:fullReport()
end

function initCollisons(collisions)
    collisions.HealthPower = function(self, HealthPower)
        HealthPower:zoop(self.health)
    end
    
    collisions.WeaponPower = function(self, WeaponPower)
        WeaponPower:zoop(self.weapons)
    end
    
    collisions.ArmorPower = function(self, ArmorPower)
        ArmorPower:zoop(self.health)
    end
    
    collisions.JetpackPower = function(self, JetpackPower)
        JetpackPower:zoop(self)
    end
    
    collisions.FingerBullet = function(self, bullet)
        self.health:ouch(bullet)
    end

    collisions.Bottom = function(self, Bottom)
        self.health:kill(Bottom)
    end
end

function Character:update(dt, events)
    DynamicBodiedPackable.update(self)
    self.weapons.current:update(dt, self:getCenter())
    if self.isFiring and self.weapons.current.delay <= 0  then
        table.insert(events, { type = 'fire', subject = self })
    end
    if self.walking then
        self:walk(dt)
    end
    if self.isBlasting then
        self.jetpack:blast(dt, self.body)
    end
    self.weapons:update()
    self.modified = self.modified or self.health.modified or self.weapons.modified
end

function Character:draw(cam)
    love.graphics.setColorMask()
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('line', self.body:getX() - (self.size * 8), self.body:getY() - (self.size * 8), self.size * 16, self.size * 16)
    self.anim[self.currentAnim]:draw(self.body:getX(), self.body:getY(), 0, self.direction)
    self.health:draw(self:getX(), self:getY())
    self.weapons:draw()
    self.jetpack:draw(self:getX(), self:getY())
end

function Character:drawHud()
    self.health:drawHud()
    self.weapons:drawHud()
    self.jetpack:drawHud()
end

function Character:setFiring(firing)
    self.isFiring = firing
end

function Character:walkRight()
    self.direction = 1
    self.walking = true
end

function Character:walkLeft()
    self.direction = -1
    self.walking = true
end

function Character:stopWalking()
    x, y = self.body:getLinearVelocity()
    self.body:setLinearVelocity(0,y)
    self.walking = false
end

function Character:walk(dt)
    self.anim[self.currentAnim]:update(dt)

    x, y = self.body:getLinearVelocity()
    if self.direction == 1 then
        if x < 400 then
            self.body:setLinearVelocity( x + 200, y )
        end
    elseif x > -400 then
        self.body:setLinearVelocity( x - 200, y )
    end
end

function Character:jump()
    x, y = self.body:getLinearVelocity()
    if y == 0 then
        self.jumping = true
        self.body:setLinearVelocity( x, y - 1600 )
    end
end

function Character:fire(game)
    return self.weapons.current:fire(game)
end

function Character:setBlasting(tf)
    self.isBlasting = tf
end

function Character:switchJetpack(aJetpack)
    self.jetpack = aJetpack
    self.modified = true
end

function Character:toggleAnim()
    if self.currentAnim == 'walk' then
        self.currentAnim = 'swim'
    else
        self.currentAnim = 'walk'
    end
end

function Character:destroy()
    self.body:destroy()
end

return Character
