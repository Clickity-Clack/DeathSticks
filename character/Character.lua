local Pistol = require 'weapons/Pistol'
local HasHealth = require 'character/HasHealth'
local HasArmor = require 'character/HasArmor'
local NullJetpack = require 'character/NullJetpack'
local Animation = require 'character/Animation'
local WeaponCollection = require 'weapons/WeaponCollection'

local Character = class('Character')
Character:include(Serializeable)
Character:include(Collideable)
Character:include(DynamicCollideable)
Character:include(HasHealth)
Character:include(HasArmor)

function Character:initialize(body, aPlayerId)
    self.playerId = aPlayerId
    self.size = 2
    self.direction = 1
    self.walking = false
    self.isFiring = true
    self.isBlasting = true
    self.anim = {}
    self.anim['walk'] = Animation:new(love.graphics.newImage('res/oldHeroWalk.png'), 16, 18, self.size, 0.5, 8, 20) --duration of 1 means the Animation will play through each quad once per second
    self.anim['swim'] = Animation:new(love.graphics.newImage('res/oldHeroSwim.png'), 18, 17, self.size, 0.5, 9, 20)
    self.currentAnim = 'walk'
    self.dead = false
    self.weapons = WeaponCollection:new(self.playerId,Pistol:new(self.playerId))
    self.jetpack = NullJetpack:new()

    self.shape = love.physics.newRectangleShape(self.size * 16, self.size * 16)
    Serializeable.initializeMixin(self)
    Collideable.initializeMixin(self, body)
    DynamicCollideable.initializeMixin(self)
    HasHealth.initializeMixin(self, 100)
    HasHealth.addDamageModifier(self, {type = 'CharacterDamageModifier', func = CharacterDamageModifier, ref = self})
    HasArmor.initializeMixin(self, 100)
    assert(self.collide, "WHat?! No collide method?!")
    self.fixture:setGroupIndex(-12)
    self.body:setFixedRotation(true)
    self.body:setGravityScale(4)
    assert(self.collisions, 'No collisions table')
end

function Character:getState()
    if self.modified then
        local state = Serializeable.getState(self)
        Collideable.getState(self, state)
        DynamicCollideable.getState(self, state)
        state.direction = self.direction
        state.currentAnim = self.currentAnim
        state.weapons = self.weapons:getState()
        state.health = self.health:getState()
        state.jetpack = self.jetpack:getState()
        return state
    end
end

function Character:unpackState(state, game)
    self.direction = state.direction
    self.currentAnim = state.currentAnim
    self.health:unpackState(state.health, game)
    self.weapons:unpackState(state.weapons, game)
    if(state.jetpack and self.jetpack.id ~= state.jetpack.id) then
        self.jetpack = game:unpackObject(state.jetpack)
    else
        self.jetpack:unpackState(state.jetpack)
    end
    Serializeable.unpackState(self)
    Collideable.unpackState(self, state)
    DynamicCollideable.unpackState(self, state)
end

function Character:reId(state)
    Serializeable.reId(self,state)
    self.weapons:reId(state.weapons)
    self.health:reId(state.health)
    self.jetpack:reId(state.jetpack)
end

function Character:fullReport()
    Serializeable.fullReport(self)
    self.health:fullReport()
    self.weapons:fullReport()
    self.jetpack:fullReport()
end

function CharacterDamageModifier(self, hurtyThing)
    if hurtyThing.playerId == self.playerId and hurtyThing.class.name ~= 'Explosion' then hurtyThing.damage = 0 end
end

function Character:kill(killer)
    self.health:kill(killer)
end

function Character:update(dt, events)
    DynamicCollideable.update(self)
    HasHealth.update(self, dt, events)
    HasArmor.update(self, dt, events)
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
    self.jetpack:update(dt, events)
    self.modified = self.modified or self.health.modified or self.weapons.modified or self.jetpack.modified
end

function Character:draw(cam)
    love.graphics.setColorMask()
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('line', self.body:getX() - (self.size * 8), self.body:getY() - (self.size * 8), self.size * 16, self.size * 16)
    self.anim[self.currentAnim]:draw(self.body:getX(), self.body:getY(), 0, self.direction)
    HasHealth.draw(self,self:getX(), self:getY() - 35)
    HasArmor.draw(self,self:getX(), self:getY() - 25)
    self.weapons:draw()
    self.jetpack:draw(self:getX(), self:getY())
end

function Character:drawHud()
    HasHealth.drawHud(self)
    HasArmor.drawHud(self)
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
