local overlayScreen = class("overlayScreen")
local optionList = require 'screens/menus/optionList'
local plainOption = require  'screens/menus/plainOption'

function overlayScreen:initialize(upScreen)
    self.id = uuid()
    self.beneath = upScreen.current
    self.upScreen = upScreen

    local dimensions = { width = love.graphics.getWidth()/5, height = love.graphics.getHeight()/5 }
    local position = { x = love.graphics.getWidth()/5, y = love.graphics.getHeight()/5 }
    local options = { 
        plainOption:new('beep',function()
                local doot = love.audio.newSource( 'sounds/you.mp3', 'static' )
                love.audio.play(doot)
             end),
        plainOption:new('nothing',function() end),
        plainOption:new('quit',function(self, menu)
                local aMainMenu = mainMenu:new(menu.upScreen)
                menu.upScreen[aMainMenu.id] = aMainMenu
                menu.upScreen.current = aMainMenu
                menu.upScreen[menu.beneath.id] = nil
            end
        )        
    }
    self.theList = optionList(options, position, dimensions)
end

function overlayScreen:update(dt)
    self.beneath:update(dt)
end

function overlayScreen:mousepressed(x,y)

end

function overlayScreen:keypressed(key, scancode, isrepeat )
    if key == 'w' then
        self.theList:selectPrevious()
    elseif key == 's' then
        self.theList:selectNext()
    elseif key == 'return' then
        self.theList:boopCurrent(self)
    elseif key == 'escape' then
        self.upScreen.current = self.beneath
    end
end

function overlayScreen:keyreleased( key, scancode, isrepeat )

end

function overlayScreen:draw()
    self.beneath:draw()
    x = love.graphics.getWidth()/4
    y = love.graphics.getHeight()/4
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle('fill', x, y, love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    self.theList:draw()
end

return overlayScreen
