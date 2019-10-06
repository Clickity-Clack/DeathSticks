local Breathes = {}
local Oxygen = require('character/Oxygen')
local HasHealth = require('character/HasHealth')

function Breathes:initializeMixin(hp,capacity)
    assert(self.health,'no health on this bad boy')
    self.oxygen = Oxygen:new(hp, capacity)
    HasHealth.addDamageModifier(self,{type = 'oxygen', func = self.oxygen.damageModifier, ref = self.oxygen})
end

function Breathes:update(dt, events)
end

function Breathes:draw(x,y)
    self.oxygen:draw(x,y)
end

function Breathes:drawHud(order)
    return self.oxygen:drawHud(order)
end

function Breathes:initCollisions()
    local oldFunction = self.collisions.Water or function() end
    self.collisions.Water = function(self, aWater)
        oldFunction(self, aWater)
        self:stopBreathing()
    end
end

function Breathes:initSeparations()
    local oldFunction = self.separations.Water or function() end
    self.separations.Water = function(self, aWater)
        oldFunction(self, aWater)
        self:startBreathing()
    end
end

function Breathes:stopBreathing()
    self.health:addTimeReleaseDamage({
        type = 'Suffocation',
        damageFunc = function(aHealth, dt)
            local oneTenthPerSecond = (aHealth.capacity / 10) * dt
            return oneTenthPerSecond
        end
    })
end

function Breathes:startBreathing()
    self.oxygen:fill()
    self.health:removeTimeReleaseDamage('Suffocation')
end

return Breathes
