local Platform = class("Platform")

function Platform:initialize( body, length, width )
    self.id = uuid()
    self.width = width or 10
    self.length = length or 50
    self.body = body --place the body in the center of the world and make it dynamic, so it can move around
    self.shape = love.physics.newRectangleShape(self.length, self.width) 
    self.fixture = love.physics.newFixture(self.body, self.shape) -- Attach fixture to body and give it a density of 1.
    self.fixture:setUserData(self)
    self.rgba = { 0.32, 0.63, 0.05 }
end

function Platform:update(dt)

end

function Platform:collide(b, events)
    b:collidePlatform(self, events)
end

function Platform:collideBullet(aBullet, events)
    aBullet:collidePlatform(self, events)
end

function Platform:collideCharacter(aCharacter, events)

end

function Platform:getState()
    return { id = self.id, type = 'Platform', width = self.width, length = self.length, bodyDeets = { x = self.body:getX(), y = self.body:getY() } }
end

function Platform:reId(state)
    self.id = state.id
end

function Platform:unpackState(state)

end


function Platform:draw()
    love.graphics.setColor( self.rgba ) -- set the drawing color to green for the ground
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

return Platform
