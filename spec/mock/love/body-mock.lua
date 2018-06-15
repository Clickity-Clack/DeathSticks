local Body = class('BodyMock')

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

function Body:setAngle(angle)
    self.angle = angle
end

function Body:getAngle()
    return self.angle
end

function Body:setFixedRotation(fixedRotation)
    self.fixedRotation = fixedRotation
end

function Body:setGravityScale(gravityScale)
    self.gravityScale = gravityScale
end

function Body:isBullet(bool)
    self.bullet = bool
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
