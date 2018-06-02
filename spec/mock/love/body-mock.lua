local Body = class('Body')

function Body:initialize(x,y)
    self.x = x or 0
    self.y = y or 0
    self.xSpeed = 0
    self.ySpeed = 0
end

function Body:getX()
    return self.x
end

function Body:getY()
    return self.y
end

function Body:setX(x)
    self.x = x
end

function Body:setY(y)
    self.y = y
end

function Body:getLinearVelocity()
    return self.xSpeed, self.ySpeed
end

function Body:setLinearVelocity(x,y)
    self.xSpeed = x
    self.ySpeed = y
end

function Body:destroy()
    
end

return Body
