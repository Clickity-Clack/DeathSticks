local DeadJetpack = require 'weapons/projectiles/explosive/DeadJetpack'
local Jetpack = class ('Jetpack')
Jetpack:include(Serializeable)
local Meter = require'character/Meter'
local hudBackColor = {0.01,0.01,0.1}
local hudFillColor = {0.2,0.2,0.8}

function Jetpack:initialize(aPlayerId)
    self.fuel = 100
    self.capacity = 100
    self.force = 54
    self.playerId = aPlayerId
    self.dead = false
    self.replacement = DeadJetpack
    self.blastSound = love.audio.newSource('sounds/whhh.wav', 'static')
    self.soundTime = 0.00005
    self.soundLastPlayed = 0
    Serializeable.initializeMixin(self)
end

function Jetpack:update(dt, events)
    self.soundLastPlayed = self.soundLastPlayed - dt
    if self.dead then table.insert(events, {type = 'dead', subject = self}) end
end

function Jetpack:refill(amount)
    self.fuel = self.fuel + amount
    if self.fuel > self.capacity then self.fuel = self.capacity end
    self.modified = true
end

function Jetpack:getState()
    if self.modified then
        local state = Serializeable.getState(self)
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
        Serializeable.unpackState(self)
    end
end

function Jetpack:blast(dt, body)
    if self.fuel > 0 then
        if self.soundLastPlayed <= 0 then
            love.audio.play(self.blastSound)
            self.soundLastPlayed = self.soundTime
        end
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
    self.x = x
    self.y = y
end

function Jetpack:getBarrelDeets()
    return{x = self.x, y = self.y, r = 0}
end

function Jetpack:drawHud()
    Meter.draw(10,70,self.capacity,self.fuel,hudBackColor,hudFillColor,100,20)
end

return Jetpack
