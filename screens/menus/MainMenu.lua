local Menu = require 'screens/menus/Menu'
local MainMenu = class('MainMenu', Menu)
local OptionList = require 'screens/menus/OptionList'
local PlainOption = require 'screens/menus/PlainOption'
local LocalScreen = require 'screens/LocalScreen'
local ClientScreen = require 'screens/ClientScreen'
local HostScreen = require 'screens/HostScreen'

function MainMenu:initialize(upScreen)
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
    Menu.initialize(self, upScreen, options)
end

return MainMenu
