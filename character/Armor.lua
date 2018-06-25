local Health = require'character/Health'
local Armor = class('Armor', Health)

function Armor:initialize(hp,capacity)
    self.hp = hp
    self.capacity = capacity or hp
    self.isNull = false
    Packable.initialize(self)
end

function Armor:getState()
    if self.modified then
        local state = Packable.getState(self)
        state.hp = self.hp
        state.capacity = self.capacity
        return state
    end
end

function Armor:unpackState(state)
    if state then
        self.hp = state.hp
        self.capacity = state.capacity
    end
end

function Armor:ouch(hurtyThing)
    self.hp = self.hp - hurtyThing.damage
    hurtyThing:kill()
    self.modified = true
    if self.hp <= 0 then
        self.dead = true
        return 0 - self.hp
    end
    return 0
end

function Armor:refill(healPoints)
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

function Armor:draw(x,y)
    width = 70
    height = 10
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill', x - width / 2, y - 20, width, height)
    love.graphics.setColor(0.5,0.5,0.5)
    love.graphics.rectangle('fill', x - width / 2, y - 20, self.hp/self.capacity *  width, height)
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.hp, x - font:getWidth(self.hp)/2, y + height/2 - font:getHeight()/2 - 19)
end

function Armor:drawHud()
    x,y = 10,50
    width = 100
    height = 20
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill', x, y, width, height)
    love.graphics.setColor(0.5,0.5,0.5)
    love.graphics.rectangle('fill', x, y, self.hp/self.capacity * width, height)
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.hp, x + width/2 - font:getWidth(self.hp)/2, y + height/2 - font:getHeight()/2)
end

return Armor
