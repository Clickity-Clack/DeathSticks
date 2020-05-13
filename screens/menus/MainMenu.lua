local Menu = require 'screens/menus/Menu'
local MainMenu = class('MainMenu', Menu)
local PlainOption = require 'screens/menus/PlainOption'
local TextOption = require 'screens/menus/TextOption'
local InlineOptionList = require 'screens/menus/InlineOptionList'
local LocalScreen = require 'screens/LocalScreen'
local ClientScreen = require 'screens/ClientScreen'
local HostScreen = require 'screens/HostScreen'

function MainMenu:initialize(upScreen)
    local inlineOptions = {
        PlainOption:new('Inline option 1',function() end),
        PlainOption:new('Inline option 2',function() end),
        PlainOption:new('Inline option 3',function() end)
    }

    local options = {
        PlainOption:new('local game',function(self, aMainMenu)
                newGame = LocalScreen:new(upScreen)
                aMainMenu.upScreen.s[newGame.id] = newGame
                aMainMenu.upScreen.current = newGame
                aMainMenu.upScreen.s[aMainMenu.id] = nil
            end),
        PlainOption:new('client game',function(self, aMainMenu)
                newGame = ClientScreen:new(upScreen, 'localhost')
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
        InlineOptionList:new(inlineOptions,{auto = true, bounds = {0, love.graphics.getWidth(), 0, love.graphics.getHeight()}}),
        -- TextOption:new('text test', function()
        --         end),
        PlainOption:new('quit game',function() love.event.quit() end)
    }
    Menu.initialize(self, upScreen, options)
end

return MainMenu
