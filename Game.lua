Serializeable = require('handlers/unpacking/Serializeable')
Collideable = require('handlers/unpacking/Collideable')
DynamicCollideable = require('handlers/unpacking/DynamicCollideable')
local NullControllable = require 'character/NullControllable'
local Player = require 'player/Player'
local NullPlayer = require 'player/NullPlayer'
local eventHandler = require 'handlers/eventHandler'
local Victory = require 'handlers/victory/Victory'
local FFAVictory = require 'handlers/victory/FFAVictory'
local TeamVictory = require 'handlers/victory/TeamVictory'
local TeamDeathmatchVictory = require 'handlers/victory/TeamDeathmatchVictory'
local TitanVictory = require 'handlers/victory/TitanVictory'
local Bot = require 'player/Bot'
local World = require 'world/World'
local WorldFactory = require 'world/WorldFactory'
local FreeLookControllable = require 'character/FreeLookControllable'
local HasCamera = require 'screens/HasCamera'

local Game = class('Game')

function Game:initialize(gameSettings) -- TODO: Big idea - what if we extracted all the 'user' stuff out to the GameScreen? Why? Idk seemed like a good idea when I came up with it
    self.id = uuid()

    HasCamera.initializeMixin(self)
    initializePhysics(self)
    
    love.graphics.setBackgroundColor( 1, 1, 1 )

    self.players = {}
    self.ai = {}
    self.removed = {}
    self.events = {}
    self.world = World:new()

    self.victory = Victory:new({'red','blue'})
    self.win = false
    self.userPlayer = NullPlayer:new()
    self.once = false
    
    WorldFactory:PopulateWorld(self.world, gameSettings.mapName)
    spawnPlayers(self, gameSettings.botNum)
    if self.once then
        self:writeState()
    end
end

function initializePhysics(self)
    love.physics.setMeter(64) --the height of a meter our worlds will be 64px
    self.physicsWorld = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
    self.physicsWorld:setCallbacks(beginContact, endContact)
end

function Game:writeState()
    local filename = 'output/state_' .. os.date('%Y-%m-%d %H.%M.%S') .. '.txt'
    local file = io.open(filename, 'w')
    file:write(json.encode(self:getState()))
    file:close()

end

function spawnPlayers(self, botNum)
    for i=0,botNum do
        local x = Bot:new(self:newPlayer())
        x.player:switchControllable(self.world:spawnControllable(x.player.id))
        self.ai[x.id] = x
    end
    self.userPlayer = self:newPlayer()
    if diag.ViewPort.FreeLook then
        self.userPlayer:switchControllable(self.world:spawnControllable(self.userPlayer.id, FreeLookControllable))
        return
    end
    self.userPlayer:switchControllable(self.world:spawnControllable(self.userPlayer.id))
end

function Game:update(dt, input)
    self.userPlayer.commands = input
    
    eventHandler( dt, self )

    self.world:update(dt, self.events)

    for i in pairs(self.players) do
        self.players[i]:update()
    end
    for i in pairs(self.ai) do
        self.ai[i]:update()
    end

    self:updateCamera()
    if self.victory.win then 
        self.win = true
        self.finalScore = self.victory:getScore()
    end
end

function Game:getScore()
    return self.victory:getScore()
end

function Game:updateCamera()
    if not self.userPlayer.controllable.isNull then self.cam:setPosition( self.userPlayer:getCenter() ) end
end

function Game:getState()
    local playerState = {}
    for v in pairs(self.players) do
        playerState[v] = self.players[v]:getState()
    end

    local worldState = self.world:getState()
    
    return { players = playerState, world = worldState, victory = self.victory:getState()}
end

function Game:unpackState(state)
    self.world:unpackState(state.world)
    self:unpackPlayers(state.players)
    self:unpackRemoved(state.removed)
    self:unpackVictory(state.victory)
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

    self.world:fullReport()

    self.removedChanged = true
end

function Game:unpackRemoved(stateRemoved)
    if(stateRemoved) then
        self.world:unpackRemoved(stateRemoved)
        for i in pairs(stateRemoved)do
            if self.players[i] then
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

function Game:draw()
    self.cam:draw(
        function(l,t,w,h)
            self.world:draw(l,t,w,h)
        end
    )
    if self.userPlayer.controllable then
        self.userPlayer.controllable:drawHud()
    end
    self.victory:draw()

    self:drawDiag()
end

function Game:drawDiag()
    self.world:drawDiag()
end

function Game:newPlayer(aControllable)
    local aTeam = self.victory:teamLeast()
    local newPlayer = Player:new(aControllable or NullControllable:new(), aTeam)
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

    self.victory:assess({type='leave', subject = thePlayer})
    self:remove(aPlayerId)
    self.players[aPlayerId] = nil
end

function beginContact(a, b, coll)
    local aThing, bThing = a:getUserData(), b:getUserData()
    assert(aThing.collide, aThing.class.name .. " has no collide method!")
    aThing:collide(bThing)
end

function endContact(a, b, coll)
    local aThing, bThing = a:getUserData(), b:getUserData()
    assert(aThing.separate, aThing.class.name .. " has no separate method!")
    aThing:separate(bThing)
end

return Game
