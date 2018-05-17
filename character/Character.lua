local Animation = require 'character/Animation'
local Pointer = require 'weapons/Pointer'

local Character = class('Character')

function Character:initialize(body)
    self.id = uuid()
    self.playerId = nil
    self.size = 2
    self.direction = 1
    self.walking = false
    self.isfiring = true
    self.anim = {}
    self.anim['walk'] = Animation:new(love.graphics.newImage('res/oldHeroWalk.png'), 16, 18, self.size, 1, 8, 20) --duration of 1 means the Animation will play through each quad once per second
    self.anim['swim'] = Animation:new(love.graphics.newImage('res/oldHeroSwim.png'), 18, 17, self.size, 1, 9, 20)
    self.currentAnim = 'swim'
    self.weapons = { one = Pointer:new(playerId) }
    self.weapons.current = self.weapons[next(self.weapons, one)]
    self.Health = 100
    
    self.body = body
    self.body:setFixedRotation(true)
    self.shape = love.physics.newRectangleShape(self.size * 16, self.size * 16)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
    self.body:setGravityScale(4)

    self.dead = false
end

function Character:setPlayerId(id)
    self.playerId = id
    self.weapons.current:setPlayerId(id)
end

function Character:getState()
    return { id = self.id, direction = self.direction, currentAnim = self.currentAnim, weapon = self.weapons.current:getState(), bodyDeets = { x = self.body:getX(), y = self.body:getY(), xSpeed, ySpeed = self.body:getLinearVelocity() } }
end

function Character:reId(state)
    self.id = state.id
    self.weapons.current.reId(state.weapons.current)
end

function unpackState(state)
    self.direction = state.direction
    self.currentAnim = state.currentAnim
    self.body:setX(state.bodyDeets.x)
    self.body:setY(state.bodyDeets.y)
    self.body:selLinearVelocity(state.bodyDeets.xSpeed, state.bodyDeets.ySpeed)
end

function Character:collide(b)
    b:collideCharacter(self)
end

function Character:collideHealth(Health)
    if self.Health < 100 then
        self.Health = self.Health + Health.value - (self.Health + Health.value)%100
        Health.used = true
    end
end

function Character:collidePointerPower(pointer)
    for i in pairs(self.weapons) do
        if self.weapons[i].class.name == 'Pointer' then
            if self.weapons[i].ammo + self.weapons[i].capacity/2 < self.weapons[i].capacity then
                self.weapons[i].ammo = self.weapons[i].ammo + self.weapons[i].capacity / 2
            else
                self.weapons[i].ammo = self.weapons[i].ammo + self.weapons[i].capacity / 2 - ((self.weapons[i].ammo + self.weapons[i].capacity / 2) % self.weapons[i].capacity)
            end
        end
    end
end

function Character:collidePlatform(aPlatform)

end

function Character:collideCharacter(aCharacter)

end

function Character:collideBullet(bullet)
    if bullet.playerId ~= self.playerId then
        self.Health = self.Health - bullet.damage
        if self.Health <= 0 then
            self.dead = true
            self.lastBullet = bullet
        end
        bullet.dead = true
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