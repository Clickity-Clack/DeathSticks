class = require 'lib/middleclass'
local Bindings = class 'Bindings'
local isDown = love.keyboard.isDown

function Bindings:initialize()
    self.keypress = { space = 'jump', x = 'switchPrev', c = 'switchNext', lshift = 'c'}
end

function Bindings:keypressed(key, commands)
    if self[self.keypress[key]] then
        self[self.keypress[key]](self, commands)
    end
end

function Bindings:mousepressed(x, y, number, commands)
    if number == 1 then
        commands.a = true
    elseif number == 2 then
        commands.b = true
    end
end

function Bindings:jump(commands)
    commands.jump = true
end

function Bindings:switchPrev(commands)
    commands.weaponSwitch = 'previous'
end

function Bindings:switchNext(commands)
    commands.weaponSwitch = 'next'
end

function Bindings:currently(commands)
    self:getA(commands)
    self:getB(commands)
    self:getC(commands)
    self:getR(commands)
    self:getDirection(commands)
end

function Bindings:getA(commands)
    commands.a = love.mouse.isDown(1)
end

function Bindings:getB(commands)
    commands.b = love.mouse.isDown(2)
end

function Bindings:getC(commands)
    commands.c = love.keyboard.isDown('lshift')
end

function Bindings:getR(commands)
    local centerX = love.graphics.getWidth()/2
    local centerY = love.graphics.getHeight()/2
    local mouseX, mouseY =  love.mouse.getX(), love.mouse.getY() 
    local relativeX = mouseX - centerX
    local relativeY = centerY - mouseY 
    commands.r = math.atan2(relativeX, relativeY) - math.pi/2
end

function Bindings:getDirection(commands)
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

return Bindings
