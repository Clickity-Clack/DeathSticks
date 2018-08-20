local socket = require 'socket'
local binser = require 'lib/binser'
local GameScreen = require 'screens/GameScreen'
local User = require 'screens/User'
local HostScreen = class('HostScreen', GameScreen)
local WinScreen = require 'screens/WinScreen'
local udp = socket.udp()

function HostScreen:initialize(upScreen)
    GameScreen.initialize(self, upScreen)
    udp:settimeout(0)
    udp:setsockname('*', 12345)
    
    self.game:initBasic()
    self.clients = {}
    self.data = nil
    self.packet = nil
    self.user = User:new(self.game.user)
    self.once = true
end

function HostScreen:update(dt)
    self.game:update(dt, self.user:getCommands())
    self:recieve()
    self:send()
    if self.game.win then
        self.upScreen.current = WinScreen:new(self.upScreen, self.game.finalScore)
    end
end

function HostScreen:recieve()
    -- if msg_or_ip ~= 'timeout' then
    --     error("Unknown network error: "..tostring(msg))
    -- end
    local data, msg_or_ip, port_or_nil = udp:receivefrom()
    while data do
        self.data = data
        if pcall(function () self.packet = binser.deserialize(self.data) end) then
            theClient = self.clients[msg_or_ip]
            if not theClient then
                self:addClient(msg_or_ip, port_or_nil)
                theClient = self.clients[msg_or_ip]
            end
            theClient.player.commands = self.packet[1]
            theClient.timeout = 0
        elseif msg_or_ip == 'timeout' then
            
        end
        data, msg_or_ip, port_or_nil = udp:receivefrom()
    end
end

function HostScreen:send()
    local packet, state
    state = self.game:getState()
    if love.keyboard.isDown('y') then 
        self.once = false
    end
    if love.keyboard.isDown('u') then
        self.game:fullReport()
    end
    packet = binser.serialize(state)
    for i in pairs(self.clients)do
        if self.clients[i].timeout < 12 then
            udp:sendto(packet, self.clients[i].ip, self.clients[i].port)
            self.clients[i].timeout = self.clients[i].timeout + 1
        else
            self:removeClient(i)
        end
    end
end

function HostScreen:firstPacket(clientId)
    assert(self.clients[clientId], "firstPacket: No client with that Id")
    local packet, state
    self.game:fullReport()
    state = self.game:getState()
    state.yourId = self.clients[clientId].player.id
    packet = binser.serialize(state)
    udp:sendto(packet, self.clients[clientId].ip, self.clients[clientId].port)
end

function HostScreen:addClient(anIp, aPort)
    local playerObj = self.game:newPlayer()
    playerObj:switchControllable(self.game:newCharacterControllable(playerObj.id))
    self.clients[anIp] = { ip = anIp, port = aPort, player = playerObj, timeout = 0 }
    self:firstPacket(anIp)
end

function HostScreen:removeClient(anIp)
    self.game:removePlayer(self.clients[anIp].player.id)
    self.clients[anIp] = nil
end

return HostScreen
