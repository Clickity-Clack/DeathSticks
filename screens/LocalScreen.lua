local Game = require 'Game'
local GameScreen = require 'screens/GameScreen'
local User = require 'screens/User'
local LocalScreen = class('LocalScreen', GameScreen)

function LocalScreen:initialize(upScreen)
    GameScreen.initialize(self, upScreen)
    self.game:initBasic()
    self.user = User:new(self.game.user)
end

function LocalScreen:update(dt)
    self.game:update( dt , self.user:getCommands() )
end

return LocalScreen
