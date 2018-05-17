local Platform = require 'Platform'
local Character = require 'Character'
local CharacterControllable = require 'CharacterControllable'
local gamera = require 'lib/gamera'
local isDown = love.keyboard.isDown
local winWidth = love.graphics.getWidth
local winHeight = love.graphics.getHeight
local overlay = require './menus/OverlayScreen'
local Player = require 'Player'
local eventHandler = require 'eventHandler'

local GameScreen = class('GameScreen')

function GameScreen:initialize(upScreen)
    self.id = uuid()
    self.events = {}
    self.eventHandler = eventHandler:new()
    self.cWorld = { w = 5000, h = 3000, columns = 24, rows = 22 }
    self.offCenter = { x = self.cWorld.w/2 - winWidth(), y = self.cWorld.h/2 - winHeight() }
    self.cam = gamera.new( 0, 0, self.cWorld.w, self.cWorld.h )
    self.cam:setWindow( 10, 10, 780, 580 )
    self.cam:setPosition( self.offCenter.x + winWidth(), self.offCenter.y + winHeight() )

    love.physics.setMeter(64) --the height of a meter our worlds will be 64px
    self.world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
    love.graphics.setBackgroundColor( 1, 1, 1 )

    self.objects = {}
    local x = Platform:new('ground', love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winWidth()-55/2 + self.offCenter.y), winWidth(), 50)
    self.objects[x.id] = x
    x = Platform:new('Platform1', love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winHeight()/2 + self.offCenter.y))
    self.objects[x.id] = x
    x = CharacterControllable:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winHeight()/2 + self.offCenter.y, 'dynamic'))
    self.objects[x.id] = x
    self.Player = Player:new(x)
    self.upScreen = upScreen
end

function GameScreen:update(dt)
    self.world:update(dt)

    self.cam:setPosition( self.Player:getX(), self.Player:getY() )

    self.eventHandler:process(self.events, self.objects)

    for v in pairs(self.objects) do
        self.objects[v]:update(dt, self.events, self.cam)
    end
end

function GameScreen:mousepressed(x,y)
    self.Player:mousepressed(x,y,self.events)
    --xOffset, yOffset = cam:toWorld(love.mouse.getPosition())
    -- table.insert( objects, ball:new('', love.physics.newBody(world, xOffset, yOffset, "dynamic")) )
end

function GameScreen:drawWorld(cl,ct,cw,ch)
    local w = self.cWorld.w / self.cWorld.columns
    local h = self.cWorld.h / self.cWorld.rows

    local minX = math.max(math.floor(cl/w), 0)
    local maxX = math.min(math.floor((cl+cw)/w), self.cWorld.columns-1)
    local minY = math.max(math.floor(ct/h), 0)
    local maxY = math.min(math.floor((ct+ch)/h), self.cWorld.rows-1)

    for y=minY, maxY do
        for x=minX, maxX do
        if (x + y) % 2 == 0 then
            love.graphics.setColor(0.3,0.3,0.3)
        else
            love.graphics.setColor(0.8,0.8,0.8)
        end
        love.graphics.rectangle("fill", x*w, y*h, w, h)
        end
    end
end

function GameScreen:keypressed(key)
    if key == 'escape' then
        self.upScreen.current = overlay:new(self.upScreen, self.cam)
    end
    self.Player:keypressed( key, scancode, isrepeat )
end

function GameScreen:keyreleased( key, scancode, isrepeat )
    self.Player:keyreleased( key, scancode, isrepeat )
end

function GameScreen:draw()
    self.cam:draw(
        function(l,t,w,h)
            self:drawWorld(l,t,w,h)
            for v in pairs(self.objects) do
                self.objects[v]:draw()
            end
        end
    )
end

return GameScreen
