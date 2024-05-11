local Game = require 'Game'
local GameScreen = require 'screens/GameScreen'
local WinScreen = require 'screens/WinScreen'
local User = require 'screens/User'
local LocalScreen = class('LocalScreen', GameScreen)

function LocalScreen:initialize(upScreen, gameSettings)
    GameScreen.initialize(self, upScreen, gameSettings)
    self.user = User:new(self.game.user)
end

function LocalScreen:update(dt)
    self.game:update( dt , self.user:getCommands() )
    if self.game.win then
        self.upScreen.current = WinScreen:new(self.upScreen, self.game.finalScore)
    end
end

return LocalScreen
