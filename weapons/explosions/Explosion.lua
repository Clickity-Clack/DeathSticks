local Explosion = class('Explosion', BodiedPackable)

function Explosion:initialize(body, aPlayerId)
    self.playerId = aPlayerId
    self.radius = 250
    self.potentialDamage = 175
    self.shape = love.physics.newCircleShape(self.radius)
    self.duration = 0.1
    self.once = false
    self.image = love.graphics.newImage("res/flame.png")
    BodiedPackable.initialize(self, body)
    self.fixture:setSensor(true)
    Explosion.initCollisions(self)
    love.audio.play(love.audio.newSource('sounds/kaPff.wav', 'static'))
end

function Explosion:update(dt, events)
    self.duration = self.duration - dt
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
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle())
end

function Explosion:kill()
    --I'll die when I'm good and ready!!
end

function Explosion:destroy()
    self.body:destroy()
end

return Explosion
