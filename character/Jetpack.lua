local Jetpack = class ('Jetpack', Packable)

function Jetpack:initialize(aPlayerId)
    self.fuel = 100
    self.capacity = 100
    self.force = 54
    self.playerId = aPlayerId
    self.dead = false
    Packable.initialize(self)
end

function Jetpack:update(dt, events)
    if self.dead then table.insert(events, {type = 'dead', subject = self}) end
end

function Jetpack:refill(amount)
    self.fuel = self.fuel + amount
    if self.fuel > self.capacity then self.fuel = self.capacity end
    self.modified = true
end

function Jetpack:getState()
    if self.modified then
        local state = Packable.getState(self)
        state.fuel = self.fuel
        state.dead = self.dead
        state.playerId = self.playerId
        return state
    end
end

function Jetpack:unpackState(state,game)
    if state then
        self.fuel = state.fuel
        self.dead = state.dead
        Packable.unpackState(self)
    end
end

function Jetpack:blast(dt, body)
    if self.fuel > 0 then
        local x,y = body:getLinearVelocity()
        self.modified = true
        self.fuel = math.ceil(self.fuel - (self.capacity/60))
        body:setLinearVelocity(x, ( self.force * 0.00000000000000000000000000000000000000000005 + (y - self.force)))
        if self.fuel <= 0 then 
            self.fuel = 0 
            self.dead = true
        end
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
