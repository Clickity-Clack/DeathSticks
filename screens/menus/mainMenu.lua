local mainMenu = class('mainMenu')
local optionList = require 'screens/menus/optionList'
local plainOption = require 'screens/menus/plainOption'
local localScreen = require 'screens/localScreen'
local clientScreen = require 'screens/clientScreen'
local hostScreen = require 'screens/hostScreen'

function mainMenu:initialize(upScren)
    self.id = uuid()
    self.upScren = upScren
    self.switchSound = love.audio.newSource( 'sounds/you.mp3', 'static' )
    love.graphics.setBackgroundColor(0,0,0)
    local dimensions = { width = love.graphics.getWidth() - (love.graphics.getWidth()/10)*2, height = love.graphics.getHeight()- (love.graphics.getHeight()/10)*2 }
    local position = { x = love.graphics.getWidth()/10, y = love.graphics.getHeight()/10}
    local options = { 
        plainOption:new('beep',function()
                local doot = love.audio.newSource( 'sounds/you.mp3', 'static' )
                love.audio.play(doot)
             end),
        plainOption:new('nothing',function() end),
        plainOption:new('launch the lame normal game',function(self, aMainMenu)
                newGame = localScreen:new(upScren)
                aMainMenu.upScren.s[newGame.id] = newGame
                aMainMenu.upScren.current = newGame
                aMainMenu.upScren.s[aMainMenu.id] = nil
            end),
        plainOption:new('launch the crazy client game',function(self, aMainMenu)
                newGame = clientScreen:new(upScren)
                aMainMenu.upScren.s[newGame.id] = newGame
                aMainMenu.upScren.current = newGame
                aMainMenu.upScren.s[aMainMenu.id] = nil
            end),
        plainOption:new('launch the bonkers host game',function(self, aMainMenu)
                newGame = hostScreen:new(upScren)
                aMainMenu.upScren.s[newGame.id] = newGame
                aMainMenu.upScren.current = newGame
                aMainMenu.upScren.s[aMainMenu.id] = nil
                end),
        plainOption:new('quit game',function() love.event.quit() end)
    }
    self.theList = optionList(options, position, dimensions)
end

function mainMenu:update()

end

function mainMenu:draw()
    self.theList:draw()
end

function mainMenu:mousepressed()

end

function mainMenu:keypressed(key)
    if key == 'w' then
        love.audio.play(self.switchSound)
        self.theList:selectPrevious()
    elseif key == 's' then
        love.audio.play(self.switchSound)
        self.theList:selectNext()
    elseif key == 'return' then
        self.theList:boopCurrent(self)
    end
end

function mainMenu:keyreleased(key)

end

return mainMenu
