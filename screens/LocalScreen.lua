local Game = require 'Game'
local overlay = require 'screens/menus/OverlayScreen'
local User = require 'User'

local LocalScreen = class('LocalScreen')

function LocalScreen:initialize(upScreen)
    self.id = uuid()
    self.upScreen = upScreen
    self.game = Game:new()
    self.game:initBasic()
    self.user = User:new(self.game.user)
end

function LocalScreen:update(dt)
    self.game:update( dt , self.user:getCommands() )
end

function LocalScreen:mousepressed(x,y, number)
    self.user:mousepressed( x,y,number )
end

function LocalScreen:keypressed(key, scancode, isrepeat )
    if key == 'escape' then
        self.upScreen.current = overlay:new(self.upScreen)
    end
    self.user:keypressed( key, scancode, isrepeat )
end

function LocalScreen:draw()
    self.game:draw()
    self.user:draw()
end

return LocalScreen
