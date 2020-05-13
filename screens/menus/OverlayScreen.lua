local OverlayScreen = class("OverlayScreen")
local VisualOptionList = require 'screens/menus/VisualOptionList'
local PlainOption = require  'screens/menus/PlainOption'

function OverlayScreen:initialize(upScreen)
    self.id = uuid()
    self.beneath = upScreen.current
    self.upScreen = upScreen

    local dimensions = { width = love.graphics.getWidth()/5, height = love.graphics.getHeight()/5 }
    local position = { x = love.graphics.getWidth()/2.5, y = love.graphics.getHeight()/3 }
    local options = { 
        -- PlainOption:new('beep',function()
        --         local doot = love.audio.newSource( 'sounds/you.mp3', 'static' )
        --         love.audio.play(doot)
        --      end),
        -- PlainOption:new('nothing',function() end),
        PlainOption:new('quit',function(self, menu)
                local aMainMenu = MainMenu:new(menu.upScreen)
                menu.upScreen.s[aMainMenu.id] = aMainMenu
                menu.upScreen.current = aMainMenu
                menu.upScreen.s[menu.beneath.id] = nil
            end
        )        
    }
    self.optionList = VisualOptionList(options, position, dimensions)
end

function OverlayScreen:update(dt)
    self.beneath:update(dt)
end

function OverlayScreen:resize(x,y)
    local dimensions = { width = love.graphics.getWidth()/5, height = love.graphics.getHeight()/5 }
    local position = { x = love.graphics.getWidth()/2.5, y = love.graphics.getHeight()/3 }
    self.optionList:resize(dimensions, position)
    self.beneath:resize(x,y)
end

function OverlayScreen:mousepressed(x,y)

end

function OverlayScreen:keypressed(key, scancode, isrepeat )
    if key == 'w' or key == 'up' then
        self.optionList:selectPrevious()
    elseif key == 's' or key == 'down' then
        self.optionList:selectNext()
    elseif key == 'return' then
        self.optionList:boopCurrent(self)
    elseif key == 'escape' then
        self.upScreen.current = self.beneath
    end
end

function OverlayScreen:textinput(t)
    
end

function OverlayScreen:keyreleased( key, scancode, isrepeat )

end

function OverlayScreen:draw()
    self.beneath:draw()
    x = love.graphics.getWidth()/4
    y = love.graphics.getHeight()/4
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle('fill', x, y, love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    self.optionList:draw()
end

return OverlayScreen
