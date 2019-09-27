local NullArmor = require('character/NullArmor')
local Health = class('Health')
Health:include(Serializeable)
local Meter = require 'character/Meter'

function Health:initialize(parentId,hp,capacity)
    self.hp = hp
    self.capacity = capacity or hp
    self.parentId = parentId
    self.damageModifiers = {}
    self.timeReleaseDamages = {}
    self.hudBackColor = {0,0,0}
    self.hudFillColor = {1,0.2,0.4}
    Serializeable.initializeMixin(self)
end

function Health:getState()
    if self.modified then
        local state = Serializeable.getState(self)
        state.parentId = parentId
        state.hp = self.hp
        state.capacity = self.capacity
        return state
    end
end

function Health:unpackState(state, game)
    if state then
        assert(state.hp, 'This Health state has no hp!')
        self.parentId = state.parentId
        self.hp = state.hp
        self.capacity = state.capacity
    end
end

function Health:update(dt, events)
    local damageAmount, damageType
    for i in pairs(self.timeReleaseDamages) do
        damageAmount = self.timeReleaseDamages[i].damageFunc(self, dt)
        damageType = self.timeReleaseDamages[i].type
        self:ouch({
                damage = damageAmount,
                class = {
                    name = damageType
                },
                playerId = 0
            }
        )
    end
end

function Health:setParentId(anId)
    self.parentId = anId
end

function Health:ouch(hurtyThing)
    for i = 1, #self.damageModifiers, 1 do
        self.damageModifiers[i].func(self.damageModifiers[i].ref, hurtyThing)
    end
    self.hp = self.hp - math.ceil(hurtyThing.damage)
    if(self.hp <= 0) then
        self:kill(hurtyThing)
        return 0 - self.hp
    end
    self.modified = true
    return 0
end

function Health:heal(healPoints)
    if self.hp < self.capacity then
        self.hp = self.hp + healPoints
        if self.hp > self.capacity then
            self.hp = self.capacity
        end
        self.modified = true
        return true
    end
    return false
end

function Health:kill(killer)
    if not self.dead then
        self.dead = true
        self.killer = killer
    end
end

function Health:addDamageModifier(modifier)
    self.damageModifiers[#self.damageModifiers + 1] = modifier
end

function Health:removeDamageModifier(type)
    helper.removeFromTableByType(self.damageModifiers, type)
end

function Health:addTimeReleaseDamage(timeReleaseDamage)
    self.timeReleaseDamages[#self.timeReleaseDamages + 1] = timeReleaseDamage
end

function Health:removeTimeReleaseDamage(type)
    helper.removeFromTableByType(self.timeReleaseDamages, type)
end

function Health:draw(x,y)
    local height = 10
    local width = 70
    Meter.draw(x - width/2,y - height/2,self.capacity,self.hp,self.hudBackColor,self.hudFillColor,width,height)
end

function Health:drawHud(order)
    Meter.draw(10,10 + 20 * (order or 0),self.capacity,self.hp,self.hudBackColor,self.hudFillColor,100,20)
    return 1
end

return Health
