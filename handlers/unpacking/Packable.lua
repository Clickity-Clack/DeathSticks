local Packable = class ('Packable')

function Packable:initialize()
    self.id = uuid()
    self.modified = true
end

function Packable:fullReport()
    self.modified = true
end

function Packable:getState()
    self.modified = false
    return { id = self.id, type = self.class.name }
end

function Packable:reId(state)
    self.id = state.id
end

function Packable.static.getTableState(aTable)
    local state = {}
    for i in pairs(aTable) do
        state[i] = aTable[i]:getState()
    end
    return state
end

function Packable.static.unpackTableState(aTable, state, game)
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

function Packable:unpackState(state) end

return Packable
