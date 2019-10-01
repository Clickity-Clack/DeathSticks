local VisualPacket = class('VisualPacket')

function VisualPacket:initialize(packet)
    self.packet = packet
end

function VisualPacket:draw(x,y,i or 0)
    love.graphics.setcolor(0.6,1,0.6)
    love.graphics.rectangle(x,y + (i * 10),,10)
end

return VisualPacket
