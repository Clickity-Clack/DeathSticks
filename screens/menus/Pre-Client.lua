local Menu = require 'screens/menus/Menu'
local PreClient = class('PreClient', Menu)
local OptionList = require 'screens/menus/OptionList'
local PlainOption = require 'screens/menus/PlainOption'
local LocalScreen = require 'screens/LocalScreen'
local ClientScreen = require 'screens/ClientScreen'
local HostScreen = require 'screens/HostScreen'

function PreClient:initialize(upScreen)
    local options = {
        PlainOption:new('ip address',function(self, aPreClient)
                newGame = LocalScreen:new(upScreen)
                aPreClient.upScreen.s[newGame.id] = newGame
                aPreClient.upScreen.current = newGame
                aPreClient.upScreen.s[aPreClient.id] = nil
            end),
        PlainOption:new('quit game',function() love.event.quit() end)
    }
    Menu.initialize(self, upScreen, options)
end

return PreClient
