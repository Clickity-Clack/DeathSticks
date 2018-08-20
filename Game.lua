Packable = require 'handlers/unpacking/Packable'
BodiedPackable = require 'handlers/unpacking/BodiedPackable'
DynamicBodiedPackable = require 'handlers/unpacking/DynamicBodiedPackable'
local Platform = require 'platform/Platform'
local DestroyablePlatform = require 'platform/DestroyablePlatform'
local DeadlyPlatform = require 'platform/DeadlyPlatform'
local Bottom = require 'platform/Bottom'
local CharacterControllable = require 'character/CharacterControllable'
local NullControllable = require 'character/NullControllable'
local FingerBullet = require 'weapons/projectiles/FingerBullet'
local ThirtyOdd = require 'weapons/projectiles/ThirtyOdd'
local Pointer = require 'weapons/Pointer'
local Sniper = require 'weapons/Sniper'
local Shotgun = require 'weapons/Shotgun'
local RocketLauncher = require 'weapons/RocketLauncher'
local GrenadeLauncher = require 'weapons/GrenadeLauncher'
local Character = require 'character/Character'
local HealthPower = require 'powerups/HealthPower'
local WeaponPower = require 'powerups/WeaponPower'
local ArmorPower = require 'powerups/ArmorPower'
local JetpackPower = require 'powerups/JetpackPower'
local gamera = require 'lib/gamera'
local winWidth = love.graphics.getWidth
local winHeight = love.graphics.getHeight
local Player = require 'player/Player'
local NullPlayer = require 'player/NullPlayer'
local necromancer = require 'handlers/necromancer'
local eventHandler = require 'handlers/eventHandler'
local Victory = require 'handlers/victory/Victory'
local FFAVictory = require 'handlers/victory/FFAVictory'
local TeamVictory = require 'handlers/victory/TeamVictory'
local Bot = require 'player/Bot'

local Game = class('Game')

Game.static.stemTypes = {CharacterControllable = true, ThirtyOdd = true, NineMil = true, Twelve = true, Rocket = true, Grenade = true, Explosion = true, HealthPower = true, WeaponPower = true, ArmorPower = true, JetpackPower = true, FingerBullet = true, NullControllable = true, Platform = true, DestroyablePlatform = true, DeadlyPlatform = true, Bottom = true}

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

    self.stems = {}
    self.players = {}
    self.ai = {}
    self.removed = {}
    self.events = {}

    self.victory = TeamVictory:new({'red', 'blue'})
    self.win = false
    self.user = NullPlayer:new()
    self.once = false

    self.cam:setPosition( self.offCenter.x + winWidth()/2, self.offCenter.y + winHeight()/2 + 175 )
end

function Game:initBasic()
    local x = DestroyablePlatform:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winWidth()-55/2 + self.offCenter.y, 'kinematic'), winWidth(), 50)
    self.stems[x.id] = x
    x = HealthPower:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winWidth()-55/2 + self.offCenter.y - 40, 'kinematic'))
    self.stems[x.id] = x
    x = WeaponPower:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winWidth()/2 + self.offCenter.y - 140, 'kinematic'), Sniper)
    self.stems[x.id] = x
    x = ArmorPower:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x - 500, winWidth()/2 + self.offCenter.y + 600, 'kinematic'))
    self.stems[x.id] = x
    x = JetpackPower:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x + 500, winWidth()/2 + self.offCenter.y + 600, 'kinematic'))
    self.stems[x.id] = x
    x = WeaponPower:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x + 180, winWidth()/2 + self.offCenter.y + 600, 'kinematic'), RocketLauncher)
    self.stems[x.id] = x
    x = WeaponPower:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x + 220, winWidth()-55/2 + self.offCenter.y - 40, 'kinematic'), Shotgun)
    self.stems[x.id] = x
    x = WeaponPower:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x + 260, winWidth()-55/2 + self.offCenter.y - 40, 'kinematic'), GrenadeLauncher)
    self.stems[x.id] = x
    x = Platform:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winHeight()/2 + self.offCenter.y, 'kinematic'))
    self.stems[x.id] = x
    x = Platform:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x - 500, winHeight()/2 + self.offCenter.y + 750, 'kinematic'), winWidth(), 50)
    self.stems[x.id] = x
    x = Platform:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x + 500, winHeight()/2 + self.offCenter.y + 750, 'kinematic'), winWidth(), 50)
    self.stems[x.id] = x
    x = Platform:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winHeight()/2 + self.offCenter.y + 700, 'kinematic'), 50, 500)
    self.stems[x.id] = x
    x = DeadlyPlatform:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winHeight()/2 + self.offCenter.y + 1055, 'kinematic'), winWidth(), 50)
    self.stems[x.id] = x
    x = Platform:new(love.physics.newBody(self.world, winWidth()/2 + self.offCenter.x, winHeight()/2 + self.offCenter.y + 1024, 'kinematic'), 500, 30)
    self.stems[x.id] = x
    x = Bottom:new(love.physics.newBody(self.world, self.cWorld.w/2, winHeight()/2 + self.offCenter.y + 2500, 'kinematic'), self.cWorld.w)
    self.stems[x.id] = x
    self.spawnPoint = { x = winWidth()/2 + self.offCenter.x, y = winHeight()/2 + self.offCenter.y + 25}
    x = Bot:new(self:newPlayer())
    x.player:switchControllable(self:newCharacterControllable(x.player.id))
    self.ai[x.id] = x
    self.user = self:newPlayer()
    self.user:switchControllable(self:newCharacterControllable(self.user.id))
end

function Game:update(dt, input)
    self.user.commands = input

    self.world:update(dt)

    eventHandler( dt, self )

    for i in pairs(self.players) do
        self.players[i]:update()
    end
    for i in pairs(self.ai) do
        self.ai[i]:update()
    end

    self:updateCamera()

    for v in pairs(self.stems) do
        self.stems[v]:update(dt, self.events)
    end
    if self.victory.win then 
        self.win = true
        self.finalScore = self.victory:getScore()
    end
end

function Game:getScore()
    return self.victory:getScore()
end

function Game:updateCamera()
    if not self.user.controllable.isNull then self.cam:setPosition( self.user:getCenter() ) end
end

function Game:getState()
    local playerState = {}
    for v in pairs(self.players) do
        playerState[v] = self.players[v]:getState()
    end

    local objectState = {}
    for i in pairs(self.stems) do
        objectState[self.stems[i].id] = self.stems[i]:getState()
    end
    
    return { players = playerState, stems = objectState, removed = self.removed, victory = self.victory:getState()}
end

function Game:unpackState(state)
    self:unpackObjects(state.stems)
    self:unpackPlayers(state.players)
    self:unpackRemoved(state.removed)
    self:unpackVictory(state.victory)
end

function Game:unpackObjects(stateObjects)
    for i in pairs(stateObjects) do
        self:unpackObject(stateObjects[i])
    end
end

function Game:unpackObject(objectState)
    local object = self.stems[objectState.id]
    if not object then
        -- print(serpent.block(objectState))
        -- print()
        object = necromancer(objectState, self)
        if Game.stemTypes[objectState.type] then self.stems[object.id] = object end
    end
    object:unpackState(objectState, self)
    return object
end

function Game:unpackPlayers(statePlayers)
    for i in pairs(statePlayers) do
        self:unpackPlayer(statePlayers[i])
    end
end

function Game:unpackPlayer(playerState)
    local player = self.players[playerState.id]
    if not player then
        controllable = self.stems[playerState.controllableId]
        player = self:newPlayer(controllable)
        player:reId(playerState)
        self.players[player.id] = player
    end
    player:unpackState(playerState, self)
    return player
end

function Game:fullReport()
    for i in pairs(self.players) do
        self.players[i]:fullReport()
    end

    for i in pairs(self.stems) do
        self.stems[i]:fullReport()
    end
    self.removedChanged = true
end

function Game:unpackRemoved(stateRemoved)
    if(stateRemoved) then
        for i in pairs(stateRemoved)do
            if self.stems[i] then
                self.stems[i]:destroy()
                self.stems[i] = nil
            elseif self.players[i] then
                --self.players[i]:destroy()
            end
        end
    end
end

function Game:remove(anId)
    self.removed[anId] = true
    self.removedChanged = true
end

function Game:unpackVictory(victoryState)
    self.victory:unpackState(victoryState)
    if self.victory.win then
        self.win = true
        self.finalScore = self.victory.score
    end
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
            for v in pairs(self.stems) do
                self.stems[v]:draw(self.cam, self.user)
            end
        end
    )
    if self.user.controllable then
        self.user.controllable:drawHud()
    end
    self.victory:draw()
end

function Game:newPlayer(aControllable)
    local aTeam = self.victory:teamLeast()
    local newPlayer = Player:new(aControllable, aTeam)
    self.players[newPlayer.id] = newPlayer
    self.victory:assess({type='join', subject = newPlayer})
    return newPlayer
end

function Game:removePlayer(aPlayerId)
    local thePlayer = self.players[aPlayerId]
    thePlayer.controllable:destroy()
    self:remove(self.players[aPlayerId].controllable.id)
    self.stems[thePlayer.controllable.id] = nil
    local event
    for i in pairs(self.events) do
        event = self.events[i]
        if(event.subject) then
            if (event.subject.id == aPlayerId) then
                self.events[i] = nil
            end
        end
    end

    self.victory:assess({type='leave', subject = newPlayer})
    self:remove(aPlayerId)
    self.players[aPlayerId] = nil
end

function Game:newCharacterControllable(aPlayerId)
    local newCharacterControllable = CharacterControllable:new(love.physics.newBody(self.world, self.spawnPoint.x, self.spawnPoint.y, 'dynamic'), aPlayerId)
    self.stems[newCharacterControllable.id] = newCharacterControllable
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
