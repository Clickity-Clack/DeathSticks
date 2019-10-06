local Serializeable = {}

function Serializeable:initializeMixin()
    self.id = uuid()
    self.modified = true
end

function Serializeable:fullReport()
    self.modified = true
end

function Serializeable:getState()
    self.modified = false
    return { id = self.id, type = self.class.name }
end

function Serializeable:reId(state)
    self.id = state.id
end

function Serializeable.getTableState(aTable)
    local state = {}
    for i in pairs(aTable) do
        state[i] = aTable[i]:getState()
    end
    return state
end

function Serializeable.unpackTableState(aTable, state, game)
    local thing
    for i in pairs(state) do
        thing = aTable[i]
        if thing then
            thing:unpackState(state[i])
        else
            aTable[i] = game:unpackObject(state[i])
        end
    end
    for i in pairs(aTable) do
        thing = state[i]
        if not thing then
            --assert(false, 'This ' .. aTable[i].class.name .. ' has not been removed from its respective table!')
        end
    end
end

function Serializeable:unpackState(state) end

return Serializeable