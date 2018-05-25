local Game = require 'Game'
local User = require 'User'
local overlay = require 'screens/menus/OverlayScreen'
local socket = require 'socket'
local binser = require 'lib/binser'
local serpent = require 'lib/serpent'

local HostScreen = class('HostScreen')
local udp = socket.udp()

function HostScreen:initialize(upScreen)
    udp:settimeout(0)
    udp:setsockname('*', 12345)

    self.id = uuid()
    self.upScreen = upScreen
    self.game = Game:new()
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
end

function HostScreen:draw()
    self.game:draw()
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
        elseif msg_or_ip == 'timeout' then
            
        end
        data, msg_or_ip, port_or_nil = udp:receivefrom()
    end
end

function HostScreen:send()
    local packet, state
    state = self.game:getState()
    if love.keyboard.isDown('y') then 
        print(serpent.block(state))
        self.once = false
    end
    if love.keyboard.isDown('u') then
        self.game:fullReport()
    end
    packet = binser.serialize(state)
    for i in pairs(self.clients)do
        udp:sendto(packet, self.clients[i].ip, self.clients[i].port)
    end
end

function HostScreen:addClient(anIp, aPort)
    playerId = self.game:newPlayer()
    self.clients[anIp] = { ip = anIp, port = aPort, player = playerId }
    self.game:fullReport()
end

function HostScreen:mousepressed(x,y)
    self.user:mousepressed(x,y)
end

function HostScreen:keypressed(key, scancode, isrepeat )
    if key == 'escape' then
        self.upScreen.current = overlay:new(self.upScreen)
    end
    self.user:keypressed( key, scancode, isrepeat )
end

return HostScreen
