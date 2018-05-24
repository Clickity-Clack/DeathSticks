local Animation = require 'character/Animation'
local Pointer = require 'weapons/Pointer'
local WeaponCollection = require 'weapons/WeaponCollection'
local DynamicBodiedPackable = require('handlers/unpacking/DynamicBodiedPackable')

local Character = class('Character', DynamicBodiedPackable)

function Character:initialize(body)
    self.playerId = nil
    self.size = 2
    self.direction = 1
    self.walking = false
    self.isfiring = true
    self.anim = {}
    self.anim['walk'] = Animation:new(love.graphics.newImage('res/oldHeroWalk.png'), 16, 18, self.size, 1, 8, 20) --duration of 1 means the Animation will play through each quad once per second
    self.anim['swim'] = Animation:new(love.graphics.newImage('res/oldHeroSwim.png'), 18, 17, self.size, 1, 9, 20)
    self.currentAnim = 'swim'
    self.weapons = WeaponCollection:new(Pointer:new())
    self.Health = 100
    self.dead = false

    self.shape = love.physics.newRectangleShape(self.size * 16, self.size * 16)
    DynamicBodiedPackable.initialize(self, body)
    assert(self.collide, "WHat?! No collide method?!")
    self.body:setFixedRotation(true)
    self.body:setGravityScale(4)
    assert(self.collisions, 'No collisions table')
    initCollisons(self.collisions)
end

function Character:setPlayerId(id)
    self.playerId = id
    self.weapons.current:setPlayerId(id)
end

function Character:getState()
    local state = DynamicBodiedPackable.getState(self)
    state.direction = self.direction
    state.currentAnim = self.currentAnim
    state.weapon = self.weapons.current:getState()
    return state
end

function Character:reId(state)
    DynamicBodiedPackable.reId(state)
    self.weapons.current.reId(state.weapons.current)
end

function unpackState(state)
    self.direction = state.direction
    self.currentAnim = state.currentAnim
    DynamicBodiedPackable.unpackState(self)
end



function initCollisons(collisions)
    collisions.Health = function(self, HealthPower)
        HealthPower:zoop(self.Health)
    end
    
    collisions.WeaponPower = function(self, WeaponPower)
        WeaponPower:zoop(self.WeaponCollection)
    end
    
    collisions.Bullet = function(self, bullet)
        
    end
end

function Character:update(dt, events)
    self.weapons.current:update(dt, self:getCenter())
    if self.dead then
        table.insert(events, { type = 'dead', subject = self }) -- doest't actually remove the Character
        self.dead = false
    end
    if self.isfiring and self.weapons.current.delay <= 0  then
        table.insert(events, { type = 'fire', subject = self }) -- doest't actually remove the Character
    end
    if self.walking then
        self:walk(dt)
    end
end

function Character:draw(cam)
    self:drawHealth()
    love.graphics.setColorMask()
    love.graphics.setColor(1,1,1,1)
    self.anim[self.currentAnim]:draw(self.body:getX(), self.body:getY(), 0, self.direction)
    self.weapons.current:draw()
end

function Character:getCenter()
    return self.body:getX() + 16, self.body:getY() + 16
end

function Character:drawHud()
    self:drawHudHealth()
    self:drawHudAmmo()
end

function Character:drawHealth()
    x = self.body:getX()
    y = self.body:getY() - 15
    width = 70
    height = 10
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill', x, y, width, height)
    love.graphics.setColor(1,0.2,0.4)
    love.graphics.rectangle('fill', x, y, self.Health/100 *  width, height)
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.Health, x + width/2 - font:getWidth(self.Health)/2, y + height/2 - font:getHeight()/2)

end

function Character:drawHudHealth()
    x,y = 10,10
    width = 100
    height = 20
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill', x, y, width, height)
    love.graphics.setColor(1,0.2,0.4)
    love.graphics.rectangle('fill', x, y, self.Health, height)
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.Health, x + width/2 - font:getWidth(self.Health)/2, y + height/2 - font:getHeight()/2)
end

function Character:drawHudAmmo()
    love.graphics.setColor(0.01,0.1,0.01)
    x,y = 10,30
    love.graphics.rectangle('fill', x, y, 100, 20)
    love.graphics.setColor(0.2,0.8,0.2)
    love.graphics.rectangle('fill', x, y, self.weapons.current.ammo/self.weapons.current.capacity * 100, 20)
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.weapons.current.ammo, x + width/2 - font:getWidth(self.weapons.current.ammo)/2, y + height/2 - font:getHeight()/2)
end

function Character:getX()
    return self.body:getX()
end

function Character:getY()
    return self.body:getY()
end

function Character:setFiring(firing)
    self.isfiring = firing
end

function Character:destroy()

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
    self.weapons.current:fire(game)
end

function Character:toggleAnim()
    if self.currentAnim == 'walk' then
        self.currentAnim = 'swim'
    else
        self.currentAnim = 'walk'
    end
end

return Character
