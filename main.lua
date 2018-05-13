uuid = require 'lib/uuid'
uuid.seed()
class = require("lib/middleclass")
mainMenu = require 'screens/menus/mainMenu'

function love.load()
    font = love.graphics.newFont(14)
    screen = {}
    screen.s = {}
    firstScreen = mainMenu:new(screen)
    screen.s[firstScreen.id] = firstScreen
    screen.current = screen.s[firstScreen.id]
    --screen.current = overlay:new(screen)
end

function love.update(dt)
    screen.current:update(dt)
end

function love.mousepressed(x,y)
    screen.current:mousepressed(x,y)
end

function love.keypressed(key, scancode, isrepeat )
    screen.current:keypressed(key, scancode, isrepeat )    
end

function love.keyreleased(key, scancode, isrepeat )
    screen.current:keyreleased(key, scancode, isrepeat )
end

function love.draw()
    screen.current:draw()
end
