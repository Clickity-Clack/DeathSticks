local class = require("lib/middleclass")
local Ball = class("Ball")

function Ball:initialize( name, body, radius, density, restitution )
    self.name = name
    self.body = body --place the body in the center of the world and make it dynamic, so it can move around
    self.shape = love.physics.newCircleShape(radius or 20) --the ball's shape has a radius of 20
    self.fixture = love.physics.newFixture(self.body, self.shape, density or 1) -- Attach fixture to body and give it a density of 1.
    self.fixture:setRestitution(restitution or 0.9) --let the ball bounce
    self.rgba = { 0.76, 0.18, 0.05 }
end

function Ball:update(dt)

end

function Ball:setColor( rgba )
    self.rgba = rgba
end


function Ball:draw()
    love.graphics.setColor(self.rgba) --set the drawing color to red for the ball
    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

function Ball:expire(objects)
    objects.remove(self.name)
end

return Ball
