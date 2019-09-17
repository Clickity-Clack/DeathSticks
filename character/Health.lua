local NullArmor = require('character/NullArmor')
local Health = class('Health')
Health:include(Serializeable)
local Meter = require 'character/Meter'
local hudBackColor = {0,0,0}
local hudFillColor = {1,0.2,0.4}

function Health:initialize(parentId,hp,capacity)
    self.hp = hp
    self.capacity = capacity or hp
    self.parentId = parentId
    self.damageModifiers = {}
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
    local tempModifierStack = {}
    local initialCount = #self.damageModifiers
    for i = 1, initialCount, 1 do
        tempModifierStack[i] = self.damageModifiers[initialCount - (i - 1)]
        self.damageModifiers[initialCount - (i - 1)] = nil
        if tempModifierStack[i].type == type then
            tempModifierStack[i] = nil
            self:removeDamageModifier(type)
            break
        end
    end
    for i = #tempModifierStack, 1, -1 do
        self.damageModifiers[initialCount - (i + 1)] = tempModifierStack[i]
        tempModifierStack[i] = nil
    end
end

function Health:draw(x,y)
    local height = 10
    local width = 70
    Meter.draw(x - width/2,y - height/2,self.capacity,self.hp,hudBackColor,hudFillColor,width,height)
end

function Health:drawHud()
    Meter.draw(10,10,self.capacity,self.hp,hudBackColor,hudFillColor,100,20)
end

return Health
