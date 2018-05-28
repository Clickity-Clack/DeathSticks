Packable = require 'handlers/unpacking/Packable'
BodiedPackable = require 'handlers/unpacking/BodiedPackable'
DynamicBodiedPackable = require 'handlers/unpacking/DynamicBodiedPackable'
local Platform = require 'Platform'
local CharacterControllable = require 'character/CharacterControllable'
local NullControllable = require 'character/NullControllable'
local FingerBullet = require 'weapons/projectiles/FingerBullet'
local ThirtyOdd = require 'weapons/projectiles/ThirtyOdd'
local Pointer = require 'weapons/Pointer'
local Sniper = require 'weapons/Sniper'
local Character = require 'character/Character'
local HealthPower = require 'powerups/HealthPower'
local WeaponPower = require 'powerups/WeaponPower'
local gamera = require 'lib/gamera'
local winWidth = love.graphics.getWidth
local winHeight = love.graphics.getHeight
local Player = require 'Player'
local necromancer = require 'handlers/necromancer'
local eventHandler = require 'handlers/eventHandler'

local Game = class('Game')

function Game:initialize()
    self.id = uuid()
    self.cWorld = { w = 5000, h = 3000, columns = 24, rows = 22 }
    self.offCenter = { x = self.cWorld.w/2 - winWidth()/2, y = self.cWorld.h/2 - winHeight()/2 }
    self.cam = gamera.new( 0, 0, self.cWorld.w, self.cWorld.h )
    self.cam:setWindow( 10, 10, 780, 580 )
    self.cam:setPosition( self.offCenter.x + winWidth()/2, self.offCenter.y + winHeight()/2 )

    love.physics.setMeter(64) --the height of a meter our worlds will be 64px
    self.world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
    self.world:setCallbacks(beginContact, endContact)
    love.graphics.setBackgroundColor( 1, 1, 1 )

    self.objects = {}
    self.players = {}
    self.removed = {}
    self.events = {}

    self.user = self:newPlayer(NullControllable:new())
    self.once = true
end

function Game:initBasic()
    local x = Platform:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winWidth()-55/2 + self.offCenter.y, 'kinematic'), winWidth(), 50)
    self.objects[x.id] = x
    x = HealthPower:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winWidth()-55/2 + self.offCenter.y - 40, 'kinematic'))
    self.objects[x.id] = x
    x = WeaponPower:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x + 20, winWidth()-55/2 + self.offCenter.y - 40, 'kinematic'), Pointer)
    self.objects[x.id] = x
    x = WeaponPower:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x + 60, winWidth()-55/2 + self.offCenter.y - 40, 'kinematic'), Sniper)
    self.objects[x.id] = x
    x = Platform:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winHeight()/2 + self.offCenter.y, 'kinematic'))
    self.objects[x.id] = x
    self.spawnPoint = { x = winWidth()/2 + self.offCenter.x, y = winHeight()/2 + self.offCenter.y + 25}
    self:newPlayer()
    self.user:switchControllable(self:newCharacterControllable())
end

function Game:update(dt, input)
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
        playerState[v] = self.players[v]:getState()
    end

    local objectState = {}
    for i in pairs(self.objects) do
        objectState[self.objects[i].id] = self.objects[i]:getState()
    end
    
    return { players = playerState, objects = objectState }
end

function Game:unpackState(state)
    self:unpackObjects(state.objects)
    self:unpackPlayers(state.players)
    self:unpackRemoved(state.removed)
end

function Game:unpackObjects(stateObjects)
    for i in pairs(stateObjects) do
        self:unpackObject(stateObjects[i])
    end
end

function Game:unpackObject(objectState)
    local object = self.objects[objectState.id]
    if not object then
        object = necromancer(objectState, self)
        object:reId(objectState)
        if not object.id then print(objectState.id)end
        self.objects[object.id] = object
    end
    object:unpackState(objectState, self)
end

function Game:unpackPlayers(statePlayers)
    for i, state in ipairs(statePlayers) do
        unpackPlayer(state)
    end
end

function Game:unpackPlayer(playerState)
    local player = self.players[playerState.id]
    if not player then
        player = Player:new()
        player:reId(playerState)
        self.players[player.id] = player
    end
    object:unpackState(objectState, self.unpackObject)
end

function Game:fullReport()
    for i in pairs(self.players) do
        self.players[i]:fullReport()
    end

    for i in pairs(self.objects) do
        self.objects[i]:fullReport()
    end
end

function Game:unpackRemoved(stateRemoved)
    
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

function Game:newPlayer(aControllable)
    newPlayer = Player:new(aControllable or self:newCharacterControllable())
    self.players[newPlayer.id] = newPlayer
    return newPlayer
end

function Game:newCharacterControllable()
    local newCharacterControllable = CharacterControllable:new(love.physics.newBody(self.world, self.spawnPoint.x, self.spawnPoint.y, 'dynamic'))
    self.objects[newCharacterControllable.id] = newCharacterControllable
    return newCharacterControllable
end

function beginContact(a, b, coll)
    local aThing, bThing = a:getUserData(), b:getUserData()
    assert(aThing.collide, aThing.class.name .. " has no collide method!")
    aThing:collide(bThing)
end

function endContact(a, b, coll)

end

return Game
