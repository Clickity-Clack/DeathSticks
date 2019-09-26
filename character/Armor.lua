local Health = require'character/Health'
local Armor = class('Armor', Health)
local Meter = require 'character/Meter'

function Armor:initialize(hp,capacity)
    self.isNull = false
    Health.initialize(self, self, hp, capacity)
    self.hudBackColor = {0,0,0,1}
    self.hudFillColor = {0.5,0.5,0.5,1}
end

function Armor:damageModifier(hurtyThing)
    hurtyThing.damage = self:ouch(hurtyThing)
end

return Armor
