local game = require 'game'
local overlay = require 'screens/menus/overlayScreen'
local user = require 'user'

local localScreen = class('localScreen')

function localScreen:initialize(upScreen)
    self.id = uuid()
    self.upScreen = upScreen
    self.game = game:new()
    self.user = user:new(self.game.user)
end

function localScreen:update(dt)
    self.game:update( dt , self.user:getCommands() )
end

function localScreen:mousepressed(x,y, number)
    self.user:mousepressed( x,y,number )
end

function localScreen:keypressed(key, scancode, isrepeat )
    if key == 'escape' then
        self.upScreen.current = overlay:new(self.upScreen)
    end
    self.user:keypressed( key, scancode, isrepeat )
end

function localScreen:draw()
    self.game:draw()
    self.user:draw()
end

return localScreen
