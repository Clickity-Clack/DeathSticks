local game = require 'game'
local user = require 'user'
local overlay = require 'screens/menus/overlayScreen'
local socket = require 'socket'
local binser = require 'lib/binser'
local serpent = require 'lib/serpent'

local hostScreen = class('hostScreen')
local udp = socket.udp()

function hostScreen:initialize(upScreen)
    udp:settimeout(0)
    udp:setsockname('*', 12345)

    self.id = uuid()
    self.upScreen = upScreen
    self.game = game:new()
    self.clients = {}
    self.data = nil
    self.packet = nil
    self.user = user:new(self.game.user)
end

function hostScreen:update(dt)
    self.game:update(dt, self.user:getCommands())
    self:recieve()
    --self:send()
end

function hostScreen:draw()
    self.game:draw()
end

function hostScreen:recieve()
    local packet = nil
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

function hostScreen:send()
    state = game:getState()
    packet = binser.serialize(state)
    for i in pairs(clients)do
        udp:sendto(packet, client.ip, client.socket)
    end
end

function hostScreen:addClient(anIp, aPort)
    playerId = self.game:newPlayer()
    self.clients[anIp] = { ip = anIp, port = aPort, player = playerId }
end

function hostScreen:mousepressed(x,y)
    self.user:mousepressed(x,y)
end

function hostScreen:keypressed(key, scancode, isrepeat )
    if key == 'escape' then
        self.upScreen.current = overlay:new(self.upScreen)
    end
    self.user:keypressed( key, scancode, isrepeat )
end

return hostScreen
