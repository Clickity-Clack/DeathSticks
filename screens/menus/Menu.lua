local Menu = class('Menu')
local OptionList = require 'screens/menus/OptionList'
local PlainOption = require 'screens/menus/PlainOption'
local LocalScreen = require 'screens/LocalScreen'
local ClientScreen = require 'screens/ClientScreen'
local HostScreen = require 'screens/HostScreen'

function Menu:initialize(upScreen, options)
    self.id = uuid()
    self.upScreen = upScreen
    self.switchSound = love.audio.newSource( 'sounds/pop1.wav', 'static' )
    love.graphics.setBackgroundColor(0,0,0)
    local dimensions = { width = love.graphics.getWidth() - (love.graphics.getWidth()/10)*2, height = love.graphics.getHeight()- (love.graphics.getHeight()/10)*2 }
    local position = { x = love.graphics.getWidth()/10, y = love.graphics.getHeight()/10}
    self.theList = OptionList(options, position, dimensions)
end

function Menu:update()

end

function Menu:draw()
    self.theList:draw()
end

function Menu:mousepressed()

end

function Menu:keypressed(key)
    if key == 'w' or key == 'up' then
        love.audio.play(self.switchSound)
        self.theList:selectPrevious()
    elseif key == 's' or key == 'down' then
        love.audio.play(self.switchSound)
        self.theList:selectNext()
    elseif key == 'return' then
        self.theList:boopCurrent(self)
    end
end

function Menu:keyreleased(key)

end

return Menu
