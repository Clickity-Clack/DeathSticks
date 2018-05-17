local Bindings = {}
local isDown = love.keyboard.isDown

Bindings.keypress = { space = 'jump', x = 'switchPrev', c = 'switchNext', lshift = 'c'}

function Bindings.keypressed(key, commands)
    if Bindings.keypress[key] then
        Bindings.keypress[key](commands)
    end
end

function Bindings.mousepressed(x, y, number, commands)
    if number == 1 then
        commands.a = true
    elseif number == 2 then
        commands.b = true
    end
end

function Bindings.jump(commands)
    commands.jump = true
end

function Bindings.switchPrev(commands)
    commands.weaponSwitch = 'previous'
end

function Bindings.switchNext(commands)
    commands.weaponSwitch = 'next'
end

function Bindings.getR(commands)
    local centerX = love.graphics.getWidth()/2
    local centerY = love.graphics.getHeight()/2
    local mouseX, mouseY =  love.mouse.getX(), love.mouse.getY() 
    local relativeX = mouseX - centerX
    local relativeY = centerY - mouseY 
    commands.r = math.atan2(relativeX, relativeY) - math.pi/2
end

function Bindings.getDirection(commands)
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
