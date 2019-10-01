local PacketVisualizer = class('PacketVisualizer')
local Queue = require('Queue')
local itemColorArray = {
    character = {0,0,0}
}

function PacketVisualizer:initialize(width, height, capacity)
    self.width = width
    self.height = height
    self.count = 0
    self.capacity = capacity
    self.queue = Queue:new()
end

function PacketVisualizer:pushPacket(aPacket)
    self.queue:pushRight(aPacket)
    if self.count >= self.capacity then
        self.queue:popLeft()
    else
        self.count = self.count + 1
    end
end

function PacketVisualizer:draw(x,y)
    for i = self.queue.first, self.queue.last do
        self.queue[i]:print(x,y,i)
    end
end

return PacketVisualizer
