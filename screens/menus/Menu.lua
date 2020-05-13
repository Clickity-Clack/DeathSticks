local Menu = class('Menu')
local VisualOptionList = require 'screens/menus/VisualOptionList'

function Menu:initialize(upScreen, options)
    self.id = uuid()
    self.upScreen = upScreen
    self.switchSound = love.audio.newSource( 'sounds/pop1.wav', 'static' )
    love.graphics.setBackgroundColor(0,0,0)
    local dimensions = { width = love.graphics.getWidth() - (love.graphics.getWidth()/10)*2, height = love.graphics.getHeight()- (love.graphics.getHeight()/10)*2 }
    local position = {auto = true, bounds = {0, love.graphics.getWidth(), 0, love.graphics.getHeight()}}
    self.optionList = VisualOptionList(options, position, dimensions)
end

function Menu:update()

end

function Menu:resize(x,y)
    local dimensions = { width = love.graphics.getWidth() - (love.graphics.getWidth()/10)*2, height = love.graphics.getHeight()- (love.graphics.getHeight()/10)*2 }
    local position = {auto = true, bounds = {0, love.graphics.getWidth(), 0, love.graphics.getHeight()}}
    self.optionList:resize(dimensions, position)
end

function Menu:draw()
    self.optionList:draw()
end

function Menu:mousepressed()

end

function Menu:keypressed(key)
    if key == 'w' or key == 'up' then
        love.audio.play(self.switchSound)
        self.optionList:selectPrevious()
    elseif key == 's' or key == 'down' then
        love.audio.play(self.switchSound)
        self.optionList:selectNext()
    elseif key == 'return' then
        self.optionList:boopCurrent(self)
    else
        self.optionList:keypressed(key)
    end
end

-- function Menu:textinput(t)
--     self.optionList:textinput(t)
-- end

function Menu:keyreleased(key)

end

return Menu
