uuid = require 'lib/uuid'
uuid.seed()
class = require("lib/middleclass")
serpent = require 'lib/serpent'
helper = require 'helper'
MainMenu = require 'screens/menus/MainMenu'

function love.load()
    love.window.setTitle("DEATHSTICKS!!!")
    local bigV = love.getVersion()
    if bigV < 11 then
        love.window.showMessageBox("unsupported version", "Looks like you're using a version before 11.0, which this game can't support :( sorry", "error")
        love.event.quit()
    end
    font = love.graphics.newFont(14)
    screen = {}
    screen.s = {}
    firstScreen = MainMenu:new(screen)
    screen.s[firstScreen.id] = firstScreen
    screen.current = screen.s[firstScreen.id]
    --screen.current = overlay:new(screen)
end

function love.resize(x, y)
    screen.current:resize()
end

function love.update(dt)
    screen.current:update(dt)
end

function love.mousepressed(x,y,number)
    screen.current:mousepressed(x,y,number)
end

function love.keypressed(key, scancode, isrepeat )
    screen.current:keypressed(key, scancode, isrepeat )    
end

function love.textinput(t)
    screen.current:textinput(t)
end

function love.draw()
    screen.current:draw()
end
