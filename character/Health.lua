local Health = class('Health', Packable)

function Health:initialize(hp,capacity)
    self.hp = hp
    self.capacity = capacity or hp
    Packable.initialize(self)
end

function Health:getState()
    if self.modified then
        local state = Packable.getState(self)
        state.hp = self.hp
        state.capacity = self.capacity
        return state
    end
end

function Health:unpackState(state)
    if state then
        assert(state.hp, 'This Health state has no hp!')
        self.hp = state.hp
    end
end

function Health:ouch(hurtyThing)
    self.hp = self.hp - hurtyThing.damage
    if self.hp <= 0 then
        self.hp = 0
        if not self.dead then
            self.dead = true
            self.killerBullet = hurtyThing
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
        return true
    end
    return false
end

function Health:draw(x,y)
    width = 70
    height = 10
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill', x, y, width, height)
    love.graphics.setColor(1,0.2,0.4)
    love.graphics.rectangle('fill', x, y, self.hp/self.capacity *  width, height)
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.hp, x + width/2 - font:getWidth(self.hp)/2, y + height/2 - font:getHeight()/2)
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
end

return Health
