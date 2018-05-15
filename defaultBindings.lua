class = require 'lib/middleclass'
local bindings = class 'bindings'
local isDown = love.keyboard.isDown

function bindings:initialize()
    self.keypress = { space = 'jump', x = 'switchPrev', c = 'switchNext', lshift = 'c'}
end

function bindings:keypressed(key, commands)
    if self[self.keypress[key]] then
        self[self.keypress[key]](self, commands)
    end
end

function bindings:mousepressed(x, y, number, commands)
    if number == 1 then
        commands.a = true
    elseif number == 2 then
        commands.b = true
    end
end

function bindings:jump(commands)
    commands.jump = true
end

function bindings:switchPrev(commands)
    commands.weaponSwitch = 'previous'
end

function bindings:switchNext(commands)
    commands.weaponSwitch = 'next'
end

function bindings:currently(commands)
    self:getA(commands)
    self:getB(commands)
    self:getC(commands)
    self:getR(commands)
    self:getDirection(commands)
end

function bindings:getA(commands)
    commands.a = love.mouse.isDown(1)
end

function bindings:getB(commands)
    commands.b = love.mouse.isDown(2)
end

function bindings:getC(commands)
    commands.c = love.keyboard.isDown('lshift')
end

function bindings:getR(commands)
    local centerX = love.graphics.getWidth()/2
    local centerY = love.graphics.getHeight()/2
    local mouseX, mouseY =  love.mouse.getX(), love.mouse.getY() 
    local relativeX = mouseX - centerX
    local relativeY = centerY - mouseY 
    commands.r = math.atan2(relativeX, relativeY) - math.pi/2
end

function bindings:getDirection(commands)
    if isDown('a') then
        if isDown('d') then
            commands.direction = 'stopped'
        else
            commands.direction = 'left'
        end
    elseif isDown('d') then
        commands.direction = 'right'
    else
        commands.direction = 'stopped'
    end
end

return bindings
