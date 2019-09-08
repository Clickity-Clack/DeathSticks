local Explosion = class('Explosion')
Explosion:include(Serializeable)
Explosion:include(Collideable)

function Explosion:initialize(body, aPlayerId)
    self.playerId = aPlayerId
    self.radius = 250
    self.potentialDamage = 175
    self.shape = love.physics.newCircleShape(self.radius)
    self.duration = 0.5
    self.image = love.graphics.newImage("res/flame.png")
    self.scale = 6
    self.r = 0
    Serializeable.initializeMixin(self)
    Collideable.initializeMixin(self, body)
    self.fixture:setSensor(true)
    Explosion.initCollisions(self)
    love.audio.play(love.audio.newSource('sounds/kaPff.wav', 'static'))
end

function Explosion:update(dt, events)
    self.r = self.r + dt*10000
    self.duration = self.duration - dt
    self.modified = true
    if (self.duration <= 0) then
        table.insert(events, {type = 'dead', subject = self})
    end
end

function Explosion:initCollisions()
    self.collisions.Character = function(self, character)
        self:calculateDamage(character.body)
        character:ouch(self)
        self.damage = nil
    end
end

function Explosion:calculateDamage(otherBody)
    local sx, sy = self:getCenter()
    local cx, cy = otherBody:getX(), otherBody:getY()
    local distance = math.sqrt((sx-cx)*(sx-cx)+(sy-cy)*(sy-cy))
    local power = 1 - distance/self.radius
    self.damage = self.potentialDamage * power --( self.potentialDamage * power + (y - self.potentialDamage)) --figure out lerping for this #
end

function Explosion:draw(cam, user)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.r, self.scale, self.scale, self.image:getWidth()/2, self.image:getHeight()/2)
    love.graphics.circle('line', self.body:getX(), self.body:getY(), self.radius)
end

function Explosion:kill()
    --I'll die when I'm good and ready!!
end

function Explosion:getState()
    if self.modified then
        local state = Serializeable.getState(self)
        Collideable.getState(self, state)
        state.r = self.r
        state.duration = self.duration
        state.playerId = self.playerId
        return state
    end
end

function Explosion:unpackState(state, game)
    if state then
        Serializeable.unpackState(self)
        Collideable.unpackState(self, state)
        self.r = state.r
        self.duration = state.duration
        self.playerId = state.playerId
    end
end

function Explosion:destroy()
    self.body:destroy()
end

return Explosion
