local Packable = class ('Packable')

function Packable:initialize()
    self.id = uuid()
end

function Packable:getState()
    return { id = self.id, type = self.class.name }
end

function Packable:reId(id)
    self.id = id
end

function Packable:unpackState(state) end

return Packable