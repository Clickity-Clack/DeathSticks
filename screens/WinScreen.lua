local WinScreen = class('WinScreen')
local x = love.graphics.getWidth() /2
local y = love.graphics.getHeight() /2
local count = 0

function WinScreen:initialize(upScreen, score)
    self.upScreen = upScreen
    self.time = 3
    self.score = score
    love.graphics.setBackgroundColor(0,0,0)
end

function WinScreen:update(dt)
    --Lord, send me a Mechanic if I'm not beyond repair
    self.time = self.time - dt
    if self.time <= 0 then
        local aMainMenu = MainMenu:new(self.upScreen)
        self.upScreen.current = aMainMenu
    end
end

function WinScreen:resize(newX, newY)
    x = love.graphics.getWidth() /2
    y = love.graphics.getHeight() /2
end

function WinScreen:draw()
    local count = 0
    local text = ''
    for i in pairs(self.score) do
        love.graphics.setColor(1,1,1)
        text = self.score[i].contestant .. ' ' .. self.score[i].points or ''
        love.graphics.print(text, x, y + count * 15)
        count = count + 1
    end
end

return WinScreen
