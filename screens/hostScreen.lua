local game = require 'game'
local overlay = require 'screens/menus/overlayScreen'
local socket = require 'socket'
local binser = require 'lib/binser'

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
end

function hostScreen:update(dt)
    self.game:update(dt)
    self:recieve()
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
        print(data)
        if pcall(function () self.packet = binser.deserialize(self.data) end) then
            theClient = self.clients[msg_or_ip]
            if not theClient then
                self:addClient(msg_or_ip, port_or_nil)
                theClient = self.clients[msg_or_ip]
            end
            self.game.players[theClient.playerId].actions = self.packet
        elseif msg_or_ip == 'timeout' then
            
        end
        data, msg_or_ip, port_or_nil = udp:receivefrom()
    end
end

function hostScreen:retrieveData()
end

function hostScreen:processPacket(packet)

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
    self.clients[anIp] = { ip = anIp, port = aPort, playerId = playerId }
end

function hostScreen:mousepressed(x,y)
    self.game:mousepressed(x,y)
end

function hostScreen:keypressed(key, scancode, isrepeat )
    if key == 'escape' then
        self.upScreen.current = overlay:new(self.upScreen)
    end
    self.game:keypressed( key, scancode, isrepeat )
end

function hostScreen:keyreleased( key, scancode, isrepeat )
    self.game:keyreleased( key, scancode, isrepeat )
end

return hostScreen
