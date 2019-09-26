local HasArmor = {}
local Armor = require('character/Armor')
local HasHealth = require('character/HasHealth')
local NullArmor = require('character/NullArmor')

function HasArmor:initializeMixin(capacity,hp)
    assert(self.health,'no health on this bad boy')
    if hp and hp > 0 then
        self.armor = Armor:new(hp, capacity)
        HasHealth.addDamageModifier(self,{type = 'armor', func = self.armor.damageModifier, ref = self.armor})
    else
        self.armor = NullArmor:new(hp,capacity)
    end
    self.armorCapacity = capacity
end

function HasArmor:update(dt, events)
    if self.armor.dead then
        self.armor.dead = false
        HasHealth.removeDamageModifier(self,'armor')
        self.armor = NullArmor:new()
    end
end

function HasArmor:draw(x,y)
    self.armor:draw(x,y)
end

function HasArmor:drawHud(order)
    return self.armor:drawHud(order)
end

function HasArmor:refillArmor(hitPoints)
    if self.armor.isNull then
        self.armor = Armor:new(hitPoints, self.armorCapacity)
        HasHealth.addDamageModifier(self,{type = 'armor', func = self.armor.damageModifier, ref = self.armor})
    else
        self.armor:heal(hitPoints)
    end
end

return HasArmor