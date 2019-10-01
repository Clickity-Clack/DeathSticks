local Queue = class('Queue')

function Queue:initialize()
    self.first = 0
    self.last = -1
end

function Queue:pushRight(item)
    local last = self.last + 1
    self.last = last
    self[last] = item
end

function Queue:popLeft()
    local first = self.first
    if first > self.last then error("queue is empty") end
    local item = self[first]
    self[first] = nil        -- to allow garbage collection
    list.first = first + 1
    return item
end

return Queue
