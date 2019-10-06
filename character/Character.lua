local Pistol = require 'weapons/Pistol'
local HasHealth = require 'character/HasHealth'
local HasArmor = require 'character/HasArmor'
local Breathes = require 'character/Breathes'
local NullJetpack = require 'character/NullJetpack'
local Animation = require 'character/Animation'
local WeaponCollection = require 'weapons/WeaponCollection'

local Character = class('Character')
Character:include(Serializeable)
Character:include(Collideable)
Character:include(DynamicCollideable)
Character:include(HasHealth)
Character:include(HasArmor)
Character:include(Breathes)

function Character:initialize(body, aPlayerId)
    self.playerId = aPlayerId
    self.size = 2
    self.direction = 1
    self.moving = false
    self.isFiring = true
    self.isBlasting = true
    self.jumptimer = 0
    self.anim = {}
    self.movementTypes = {
        walk = {
            animation = Animation:new(love.graphics.newImage('res/oldHeroWalk.png'), 16, 18, self.size, 0.5, 8, 20),
            speed = 200,
            jump = function(self)
                x, y = self.body:getLinearVelocity()
                if y == 0 then
                    self.jumping = true
                    self.body:setLinearVelocity( x, y - 1600 )
                end
            end
        },
        swim = {
            animation = Animation:new(love.graphics.newImage('res/oldHeroSwim.png'), 18, 17, self.size, 0.5, 9, 20),
            speed = 150,
            jump = function(self)
                if self.jumptimer <= 0 then
                    x, y = self.body:getLinearVelocity()
                    self.jumptimer = 0.5
                    self.jumping = true
                    self.body:setLinearVelocity( x, - 400 )
                end
            end
        }
    }
    self.currentMovementType = 'walk'
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
    Breathes.initializeMixin(self, 30)
    assert(self.collide, "WHat?! No collide method?!")
    self.fixture:setGroupIndex(-12)
    self.body:setFixedRotation(true)
    self.body:setGravityScale(4)
    assert(self.collisions, 'No collisions table')
    self:initCollisions()
    self:initSeparations()
    Breathes.initCollisions(self)
    Breathes.initSeparations(self)
end

function Character:initCollisions()
    self.collisions.Water = function(self, aWater)
        self:pushGravity(0.03)
        self.currentMovementType = 'swim'
    end
end

function Character:initSeparations()
    self.separations.Water = function(self, aWater)
        self:popGravity()
        self.currentMovementType = 'walk'
    end
end

function Character:getState()
    if self.modified then
        local state = Serializeable.getState(self)
        Collideable.getState(self, state)
        DynamicCollideable.getState(self, state)
        state.direction = self.direction
        state.currentMovementType = self.currentMovementType
        state.weapons = self.weapons:getState()
        state.health = self.health:getState()
        state.jetpack = self.jetpack:getState()
        return state
    end
end

function Character:unpackState(state, game)
    self.direction = state.direction
    self.currentMovementType = state.currentMovementType
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
    Breathes.update(self, dt, events)
    self.weapons.current:update(dt, self:getCenter())
    if self.isFiring and self.weapons.current.delay <= 0  then
        table.insert(events, { type = 'fire', subject = self })
    end
    if self.jumptimer >= 0 then
        self.jumptimer = self.jumptimer - dt
    end
    if self.moving then
        self:move(dt)
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
    self.movementTypes[self.currentMovementType].animation:draw(self.body:getX(), self.body:getY(), 0, self.direction)
    HasHealth.draw(self,self:getX(), self:getY() - 35)
    HasArmor.draw(self,self:getX(), self:getY() - 25)
    Breathes.draw(self,self:getX(), self:getY() - 45)
    self.weapons:draw()
    self.jetpack:draw(self:getX(), self:getY())
end

function Character:drawHud()
    local meterCount = 0
    meterCount = meterCount + HasHealth.drawHud(self, meterCount)
    meterCount = meterCount + self.weapons:drawHud(meterCount)
    meterCount = meterCount + HasArmor.drawHud(self, meterCount)
    meterCount = meterCount + self.jetpack:drawHud(meterCount)
    meterCount = meterCount + Breathes.drawHud(self, meterCount)
end

function Character:setFiring(firing)
    self.isFiring = firing
end

function Character:moveRight()
    self.direction = 1
    self.moving = true
end

function Character:moveLeft()
    self.direction = -1
    self.moving = true
end

function Character:stopMoving()
    x, y = self.body:getLinearVelocity()
    self.body:setLinearVelocity(0,y)
    self.moving = false
end

function Character:move(dt)
    self.movementTypes[self.currentMovementType].animation:update(dt)
    local movementSpeed = self.movementTypes[self.currentMovementType].speed

    x, y = self.body:getLinearVelocity()
    if self.direction == 1 and x < movementSpeed * 2 then
        self.body:setLinearVelocity( x + movementSpeed, y )
    elseif x > 0 - movementSpeed * 2 then
        self.body:setLinearVelocity( x - movementSpeed, y )
    end
end

function Character:jump()
    self.movementTypes[self.currentMovementType].jump(self)
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

function Character:destroy()
    self.body:destroy()
end

return Character
