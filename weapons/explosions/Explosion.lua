local Explosion = class('Explosion', BodiedPackable)

function Explosion:initialize(body, aPlayerId)
    self.playerId = aPlayerId
    self.radius = 50
    self.potentialDamage = 50
    self.body = body
    self.shape = love.physics.newCircleShape(self.radius)
    self.duration = 0.01
    BodiedPackable.initialize(self)
    initCollisions(self.collisions)
end

function Explosion:update(dt, events)
    self.duration = self.duration - dt
    if self.duration < 0 then
        table.insert(events, {type = dead, subject = self})
    end
end

function initCollisions(collisions)
    collisions.Character = function(self, character)
        self:calculateDamage(character.body)
        character.health:ouch(self)
        self.damage = nil
    end
end

function Explosion:calculateDamage(otherBody)
    local sx, sy = self.body:getCenter()
    local cx, cy = otherBody:getCenter()
    local distance = math.sqrt((sx-cx)*(sx-cx)+(sy-cy)*(sy-cy))
    local power = distance/radius
    self.damage = ( self.potentialDamage * power + (y - self.potentialDamage)) --figure out lerping for this #
end

return Explosion
