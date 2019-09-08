local Health = require'character/Health'
local Armor = class('Armor', Health)
local Meter = require 'character/Meter'
local hudBackColor = {0,0,0,1}
local hudFillColor = {0.5,0.5,0.5,1}

function Armor:initialize(hp,capacity)
    self.isNull = false
    Health.initialize(self, hp, capacity)
end

function Armor:draw(x,y)
    Meter.draw(x,y,self.capacity,self.hp,hudBackColor,hudFillColor,70,10)
end

function Armor:drawHud()
    Meter.draw(10,50,self.capacity,self.hp,hudBackColor,hudFillColor,100,20)
end

function Armor:damageModifier(hurtyThing)
    hurtyThing.damage = self:ouch(hurtyThing)
end

return Armor
