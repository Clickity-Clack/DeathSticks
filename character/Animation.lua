local Animation = class('Animation')

function Animation:initialize(image, width, height, size, duration, ox, oy)
    self.id = uuid()
    self.spriteSheet = image
    self.quads = {}
    self.width = width
    self.height = height
    self.size = size
    self.ox = ox
    self.oy = oy

    for y = 0, image:getHeight() - height, height - 1 do
        for x = 0, image:getWidth() - width, width do
            table.insert(self.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    self.duration = duration or 1
    self.currentTime = 0
end

function Animation:update(dt)
    self.currentTime = self.currentTime + dt
    if self.currentTime >= self.duration then
        self.currentTime = self.currentTime - self.duration
    end
end

function Animation:draw(x, y, r, direction)
    local spriteNum = math.floor(self.currentTime / self.duration * #self.quads) + 1
    love.graphics.draw(self.spriteSheet, self.quads[spriteNum], x, y + self.height, r, self.size*direction, self.size, self.ox, self.oy)
end

function Animation:transition(otherAnimation)
    
end

return Animation
