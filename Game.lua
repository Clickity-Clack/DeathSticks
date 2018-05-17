local Platform = require 'Platform'
local Health = require 'powerups/Health'
local PointerPower = require 'powerups/PointerPower'
local CharacterControllable = require 'character/CharacterControllable'
local gamera = require 'lib/gamera'
local winWidth = love.graphics.getWidth
local winHeight = love.graphics.getHeight
local Player = require 'Player'
local serpent = require 'lib/serpent'
local unpack = require 'handlers/unpacker'
local eventHandler = require 'handlers/eventHandler'

local Game = class('Game')

function Game:initialize()
    self.id = uuid()
    self.cWorld = { w = 5000, h = 3000, columns = 24, rows = 22 }
    self.offCenter = { x = self.cWorld.w/2 - winWidth(), y = self.cWorld.h/2 - winHeight() }
    self.cam = gamera.new( 0, 0, self.cWorld.w, self.cWorld.h )
    self.cam:setWindow( 10, 10, 780, 580 )
    self.cam:setPosition( self.offCenter.x + winWidth(), self.offCenter.y + winHeight() )

    love.physics.setMeter(64) --the height of a meter our worlds will be 64px
    self.world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
    self.world:setCallbacks(beginContact, endContact)
    love.graphics.setBackgroundColor( 1, 1, 1 )

    self.objects = {}
    self.players = {}
    self.removed = {}
    self.events = {}
    local x = Platform:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winWidth()-55/2 + self.offCenter.y), winWidth(), 50)
    self.objects[x.id] = x
    x = Health:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winWidth()-55/2 + self.offCenter.y - 40))
    self.objects[x.id] = x
    x = PointerPower:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x + 20, winWidth()-55/2 + self.offCenter.y - 40))
    self.objects[x.id] = x
    x = Platform:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winHeight()/2 + self.offCenter.y))
    self.objects[x.id] = x
    self.spawnPoint = { x = winWidth()/2 + self.offCenter.x, y = winHeight()/2 + self.offCenter.y + 25}
    self:newPlayer()
    self.user = self:newPlayer()
    self.once = true
    -- print(serpent.block(self:getState()))
end

function Game:update(dt, input)
    --print(input.a)
    self.user.commands = input

    self.world:update(dt)

    eventHandler( dt, self )
    for i in pairs(self.players) do
        self.players[i]:update()
    end

    self.cam:setPosition( self.user:getCenter() )
    for v in pairs(self.objects) do
        self.objects[v]:update(dt, self.events)
    end
end

function Game:getState()
    local playerState = {}
    for v in pairs(self.players) do
        playerState[self.players[v].id] = self.players[v]:getState()
    end

    local objectState = {}
    --print('Gamestate')
    for i in pairs(self.objects) do
        --print(serpent.block(self.objects[i]))
        objectState[self.objects[i].id] = self.objects[i]:getState()
    end
    if self.once then
        print(serpent.block(objectState))
        self.once = false
    end
    return { players = playerState, objects = objectState }
end

function Game:unpackState(state)
    unpack(state, self.objects, self.players, self.removed, self.world)
end

function Game:drawWorld(cl,ct,cw,ch)
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

function Game:draw()
    self.cam:draw(
        function(l,t,w,h)
            self:drawWorld(l,t,w,h)
            for v in pairs(self.objects) do
                self.objects[v]:draw(self.cam, self.user)
            end
        end
    )
    if self.user.controllable then
        self.user.controllable:drawHud()
    end
end

function Game:newPlayer()
    newCharacterControllable = CharacterControllable:new(love.physics.newBody(self.world, self.spawnPoint.x, self.spawnPoint.y, 'dynamic'))
    self.objects[newCharacterControllable.id] = newCharacterControllable
    newPlayer = Player:new(newCharacterControllable)
    self.players[newPlayer.id] = newPlayer
    return newPlayer
end

function beginContact(a, b, coll)
    a:getUserData():collide(b:getUserData())
end

function endContact(a, b, coll)

end

return Game
