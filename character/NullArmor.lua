local NullArmor = class('NullArmor', Packable)

function NullArmor:initialize()
    self.isNull = true
end

function NullArmor:ouch(hurtyThing)
    assert(false, 'Tried to call NullArmor ouch')
end

function NullArmor:zoop(healPoints)
end

function NullArmor:draw(x,y)
end

function NullArmor:drawHud()
end

return NullArmor
