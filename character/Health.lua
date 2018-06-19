local NullArmor = require('character/NullArmor')
local Health = class('Health', Packable)

function Health:initialize(hp,capacity,armor)
    self.hp = hp
    self.capacity = capacity or hp
    self.armor = armor or NullArmor:new()
    Packable.initialize(self)
end

function Health:getState()
    if self.modified then
        local state = Packable.getState(self)
        state.hp = self.hp
        state.capacity = self.capacity
        state.armor = self.armor:getState()
        return state
    end
end

function Health:unpackState(state, game)
    if state then
        assert(state.hp, 'This Health state has no hp!')
        self.hp = state.hp
        self.capacity = state.capacity
        if(state.armor and self.armor.id ~= state.armor.id) then
            self.armor = game:unpackObject(state.armor)
        else
            self.armor:unpackState(state.armor)
        end
    end
end

function Health:ouch(hurtyThing)
    if(self.armor.isNull) then
        self.hp = self.hp - hurtyThing.damage
        if self.hp <= 0 then
            self:kill(hurtyThing)
        end
    else
        self.hp = self.hp - self.armor:ouch(hurtyThing)
        if (self.armor.dead) then
            self.armor = NullArmor:new()
        end
    end
    hurtyThing:kill()
    self.modified = true
end

function Health:heal(healPoints)
    if self.hp < self.capacity then
        self.hp = self.hp + healPoints
        if self.hp > self.capacity then
            self.hp = self.capacity
        end
        self.modified = true
        return true
    end
    return false
end

function Health:setArmor(anArmor)
    self.armor = anArmor
    self.modified = true
end

function Health:refillArmor(amount)
    self.armor:refill(amount)
    self.modified = true
end

function Health:kill(killer)
    self.hp = 0
    if not self.dead then
        self.dead = true
        self.killer = killer
    end
end

function Health:draw(x,y)
    width = 70
    height = 10
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill', x - width / 2, y - 30, width, height)
    love.graphics.setColor(1,0.2,0.4)
    love.graphics.rectangle('fill', x - width / 2, y - 30, self.hp/self.capacity *  width, height)
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.hp, x - font:getWidth(self.hp)/2, y + height/2 - font:getHeight()/2 - 29)
    self.armor:draw(x,y)
end

function Health:drawHud()
    x,y = 10,10
    width = 100
    height = 20
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill', x, y, width, height)
    love.graphics.setColor(1,0.2,0.4)
    love.graphics.rectangle('fill', x, y, self.hp/self.capacity * width, height)
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.hp, x + width/2 - font:getWidth(self.hp)/2, y + height/2 - font:getHeight()/2)
    self.armor:drawHud()
end

return Health
