local NullJetpack = class ('NullJetpack', Packable)

function NullJetpack:initialize()
    self.isNull = true
    Packable.initialize(self)
end

function NullJetpack:refill(amount)
end

function NullJetpack:blast(dt)
    return 1
end

function NullJetpack:draw()
end

function NullJetpack:drawHud()
end

return NullJetpack
