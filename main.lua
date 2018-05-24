uuid = require 'lib/uuid'
uuid.seed()
class = require("lib/middleclass")
local MainMenu = require 'screens/menus/MainMenu'
serpent = require 'lib/serpent'
helper = require 'helper'

function love.load()
    font = love.graphics.newFont(14)
    screen = {}
    screen.s = {}
    firstScreen = MainMenu:new(screen)
    screen.s[firstScreen.id] = firstScreen
    screen.current = screen.s[firstScreen.id]
    --screen.current = overlay:new(screen)
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

function love.draw()
    screen.current:draw()
end
