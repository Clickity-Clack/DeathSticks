local Health = class('Health', Packable)

function Health:initialize(hp,capacity)
    self.hp = hp
    self.capacity = capacity or hp
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
