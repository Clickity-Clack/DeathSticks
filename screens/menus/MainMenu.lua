local MainMenu = class('MainMenu')
local OptionList = require 'screens/menus/OptionList'
local PlainOption = require 'screens/menus/PlainOption'
local LocalScreen = require 'screens/LocalScreen'
local ClientScreen = require 'screens/ClientScreen'
local HostScreen = require 'screens/HostScreen'

function MainMenu:initialize(upScreen)
    self.id = uuid()
    self.upScreen = upScreen
    self.switchSound = love.audio.newSource( 'sounds/pop1.wav', 'static' )
    love.graphics.setBackgroundColor(0,0,0)
    local dimensions = { width = love.graphics.getWidth() - (love.graphics.getWidth()/10)*2, height = love.graphics.getHeight()- (love.graphics.getHeight()/10)*2 }
    local position = { x = love.graphics.getWidth()/10, y = love.graphics.getHeight()/10}
    local options = {
        PlainOption:new('local game',function(self, aMainMenu)
                newGame = LocalScreen:new(upScreen)
                aMainMenu.upScreen.s[newGame.id] = newGame
                aMainMenu.upScreen.current = newGame
                aMainMenu.upScreen.s[aMainMenu.id] = nil
            end),
        PlainOption:new('client game',function(self, aMainMenu)
                newGame = ClientScreen:new(upScreen)
                aMainMenu.upScreen.s[newGame.id] = newGame
                aMainMenu.upScreen.current = newGame
                aMainMenu.upScreen.s[aMainMenu.id] = nil
            end),
        PlainOption:new('host game',function(self, aMainMenu)
                newGame = HostScreen:new(upScreen)
                aMainMenu.upScreen.s[newGame.id] = newGame
                aMainMenu.upScreen.current = newGame
                aMainMenu.upScreen.s[aMainMenu.id] = nil
                end),
        PlainOption:new('quit game',function() love.event.quit() end)
    }
    self.theList = OptionList(options, position, dimensions)
end

function MainMenu:update()

end

function MainMenu:draw()
    self.theList:draw()
end

function MainMenu:mousepressed()

end

function MainMenu:keypressed(key)
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

function MainMenu:keyreleased(key)

end

return MainMenu
