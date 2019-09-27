local Health = require'character/Health'
local Oxygen = class('Oxygen', Health)
local Meter = require 'character/Meter'

function Oxygen:initialize(hp,capacity)
    Health.initialize(self, self, hp, capacity)
    self.hudBackColor = {0,0,0,1}
    self.hudFillColor = {0.5,0.5,0.7,1}
end

function Oxygen:draw(x,y)
    if self.capacity == self.hp then
        return
    end
    Health.draw(self,x,y)
end

function Oxygen:drawHud(order)
    if self.capacity == self.hp then
        return 0
    end
    return Health.drawHud(self, order)
end

function Oxygen:damageModifier(hurtyThing)
    if hurtyThing.class.name == 'Suffocation' then
        hurtyThing.damage = self:ouch(hurtyThing)
    end
end

function Oxygen:fill()
    self.hp = self.capacity
end

return Oxygen
