uuid = require 'lib/uuid'
uuid.seed()
class = require("lib/middleclass")
serpent = require 'lib/serpent'
love.graphics.setDefaultFilter("nearest","nearest")
helper = require 'helper'
MainMenu = require 'screens/menus/MainMenu'
json = require 'lib/json'

function love.load()
    love.window.setTitle("DEATHSTICKS!!!")
    --love.graphics.getCanvas():setFilter("nearest")
    local bigV = love.getVersion()
    if bigV < 11 then
        love.window.showMessageBox("unsupported version", "Looks like you're using a version before 11.0, which this game can't support :( sorry", "error")
        love.event.quit()
    end
    font = love.graphics.newFont(14)
    screen = {}
    screen.s = {}
    diag = json.decode(helper.readAll('settings/diag.json'))
    
    firstScreen = MainMenu:new(screen)
    screen.s[firstScreen.id] = firstScreen
    screen.current = screen.s[firstScreen.id]
    math.randomseed(os.time())
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
    if diag.Screen.DrawQuads then
        local w, h = love.graphics.getWidth(), love.graphics.getHeight()
        love.graphics.setColor(1,1,1)
        love.graphics.line(w/2,0,w/2,h)
        love.graphics.line(0,h/2,w,h/2)
    end
    screen.current:draw()
end
