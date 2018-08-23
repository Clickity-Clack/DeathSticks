local Game = require 'Game'
local User = require 'screens/User'
local socket = require 'socket'
local binser = require 'lib/binser'
local GameScreen = require 'screens/GameScreen'
local WinScreen = require 'screens/WinScreen'

local port = 12345

local ClientScreen = class('ClientScreen', GameScreen)
local udp = socket.udp()

function ClientScreen:initialize(upState, address)
    GameScreen.initialize(self, upState)
    udp:settimeout(0)
    udp:setpeername(address, port)
    
    self.user = User:new()
    self.sendTime = 0
    self.once = true
end

function ClientScreen:update(dt)
    local commands = self.user:getCommands()
    self:sendCommands(commands)
    self:recieveState()
    if self.game.win then
        self.upScreen.current = WinScreen:new(self.upScreen, self.game.finalScore)
    end
end

function ClientScreen:sendCommands(commands)
    dg = binser.serialize(commands)
    udp:send(dg)
end

function ClientScreen:recieveState()
    local data, msg = udp:receive()
    local recieved = false
    while data do
        self.data = data
        if pcall(function () self.packet = binser.deserialize(self.data) end) then
            self.game:unpackState(self.packet[1])
            if self.once then 
                local id = self.packet[1]['yourId']
                self.game.user = self.game.players[id]
                self.user.playerId = self.game.user
                self.once = false
            end
            self.game:updateCamera()
        elseif msg == 'timeout' then
        end

        data, msg = udp:receive()
        recieved = true
    end
    return recieved
end

return ClientScreen
