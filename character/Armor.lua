local Health = require'character/Health'
local Armor = class('Armor', Health)
local Meter = require 'character/Meter'
local hudBackColor = {0,0,0,1}
local hudFillColor = {0.5,0.5,0.5,1}

function Armor:initialize(hp,capacity)
    self.isNull = false
    Health.initialize(self, self, hp, capacity)
end

function Armor:draw(x,y)
    local height = 10
    local width = 70
    Meter.draw(x - width/2,y - height/2,self.capacity,self.hp,hudBackColor,hudFillColor,width,height)
end

function Armor:drawHud()
    Meter.draw(10,50,self.capacity,self.hp,hudBackColor,hudFillColor,100,20)
end

function Armor:damageModifier(hurtyThing)
    hurtyThing.damage = self:ouch(hurtyThing)
end

return Armor
