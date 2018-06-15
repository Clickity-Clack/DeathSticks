local OverlayScreen = class("OverlayScreen")
local OptionList = require 'screens/menus/OptionList'
local PlainOption = require  'screens/menus/PlainOption'

function OverlayScreen:initialize(upScreen)
    self.id = uuid()
    self.beneath = upScreen.current
    self.upScreen = upScreen

    local dimensions = { width = love.graphics.getWidth()/5, height = love.graphics.getHeight()/5 }
    local position = { x = love.graphics.getWidth()/5, y = love.graphics.getHeight()/5 }
    local options = { 
        PlainOption:new('beep',function()
                local doot = love.audio.newSource( 'sounds/you.mp3', 'static' )
                love.audio.play(doot)
             end),
        PlainOption:new('nothing',function() end),
        PlainOption:new('quit',function(self, menu)
                local aMainMenu = MainMenu:new(menu.upScreen)
                menu.upScreen[aMainMenu.id] = aMainMenu
                menu.upScreen.current = aMainMenu
                menu.upScreen[menu.beneath.id] = nil
            end
        )        
    }
    self.theList = OptionList(options, position, dimensions)
end

function OverlayScreen:update(dt)
    self.beneath:update(dt)
end

function OverlayScreen:mousepressed(x,y)

end

function OverlayScreen:keypressed(key, scancode, isrepeat )
    if key == 'w' or key == 'up' then
        self.theList:selectPrevious()
    elseif key == 's' or key == 'down' then
        self.theList:selectNext()
    elseif key == 'return' then
        self.theList:boopCurrent(self)
    elseif key == 'escape' then
        self.upScreen.current = self.beneath
    end
end

function OverlayScreen:keyreleased( key, scancode, isrepeat )

end

function OverlayScreen:draw()
    self.beneath:draw()
    x = love.graphics.getWidth()/4
    y = love.graphics.getHeight()/4
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle('fill', x, y, love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    self.theList:draw()
end

return OverlayScreen
