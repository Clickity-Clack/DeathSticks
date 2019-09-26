local NullArmor = class('NullArmor')
NullArmor:include(Serializeable)

function NullArmor:initialize()
    Serializeable.initializeMixin(self)
    self.isNull = true
    self.dead = false
end

function NullArmor:update()
end

function NullArmor:ouch(hurtyThing)
    return hurtyThing.damage
end

function NullArmor:damageModifier(hurtyThing)
end

function NullArmor:draw(x,y)
end

function NullArmor:drawHud()
    return 0
end

return NullArmor
