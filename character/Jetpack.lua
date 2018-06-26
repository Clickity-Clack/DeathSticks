local Jetpack = class ('Jetpack', Packable)

function Jetpack:initialize()
    self.fuel = 100
    self.capacity = 100
    self.force = 20
    Packable.initialize(self)
end

function Jetpack:refill(amount)
    self.fuel = self.fuel + amount
    if self.fuel > self.capacity then self.fuel = self.capacity end
    self.modified = true
end

function Jetpack:blast(dt, body)
    if self.fuel > 0 then
        local x,y = body:getLinearVelocity()
        self.modified = true
        self.fuel = self.fuel - (self.capacity/10)
        body:setLinearVelocity(x, ( self.force * 0.85 + (y - self.force)))
    end
end

function Jetpack:draw(x,y)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill', x-10, y, 5,10)
end

function Jetpack:drawHud(x,y)
    local x, y = 10, 70
    love.graphics.setColor(0.01,0.01,0.1)
    love.graphics.rectangle('fill', x, y, 100, 20)
    love.graphics.setColor(0.2,0.2,0.8)
    love.graphics.rectangle('fill', x, y, self.fuel/self.capacity * 100, 20)
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.fuel, x + width/2 - font:getWidth(self.fuel)/2, y + height/2 - font:getHeight()/2)
end

return Jetpack
