local GameScreen = class('GameScreen')
local Game = require 'Game'
local overlay = require 'screens/menus/OverlayScreen'

function GameScreen:initialize(upScreen)
    self.id = uuid()
    self.upScreen = upScreen
    self.game = Game:new()
end

function GameScreen:mousepressed(x,y, number)
    self.user:mousepressed( x,y,number )
end

function GameScreen:keypressed(key, scancode, isrepeat )
    if key == 'escape' then
        self.upScreen.current = overlay:new(self.upScreen)
    end
    self.user:keypressed( key, scancode, isrepeat )
end

function GameScreen:draw()
    self.game:draw()
end

return GameScreen
