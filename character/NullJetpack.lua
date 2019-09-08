local NullJetpack = class ('NullJetpack')
NullJetpack:include(Serializeable)

function NullJetpack:initialize()
    self.isNull = true
    Serializeable.initializeMixin(self)
end

function NullJetpack:update()
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
