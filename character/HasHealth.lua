local HasHealth = {}
local Health = require('character/Health')

function HasHealth:initializeMixin(hp, capacity)
    self.health = Health:new(self.id, hp, capacity)
end

function HasHealth:update(dt, events)
    if self.health.dead then
        self.health.dead = false
        self.dead = true
        self.killer = self.health.killer
    end
    self.modified = self.modified or self.health.modified
end

function HasHealth:ouch(hurtyThing)
    self.health:ouch(hurtyThing)
end

function HasHealth:draw(x,y)
    self.health:draw(x,y)
end

function HasHealth:drawHud(order)
    return self.health:drawHud(order)
end

function HasHealth:getState(state)
    state.health = self.health:getState()
end

function HasHealth:unpackState(state, game)
    self.health:unpackState(state.health, game) 
end

function HasHealth:addDamageModifier(modifier)
    self.health:addDamageModifier(modifier)
end

function HasHealth:removeDamageModifier(type)
    self.health:removeDamageModifier(type)
end

return HasHealth
