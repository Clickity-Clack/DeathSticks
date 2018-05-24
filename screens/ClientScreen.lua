--local unpacker = require 'handlers/unpacker'
local testState = require 'clutter/testState'
local Game = require 'Game'
local User = require 'User'
local overlay = require 'screens/menus/OverlayScreen'
local socket = require 'socket'
local binser = require 'lib/binser'
local serpent = require 'lib/serpent'

local address, port = "localhost", 12345

local ClientScreen = class('ClientScreen')
local udp = socket.udp()

function ClientScreen:initialize(upState)
    udp:settimeout(0)
    udp:setpeername(address, port)
    self.id = uuid()
    self.upState = upState
    self.game = Game:new()
    self.user = User:new(self.game.user)
    self.sendTime = 0
    self.once = false
end

function ClientScreen:update(dt)
    local commands = self.user:getCommands()
    self:sendCommands(commands)
    if once then
        self.game:update( dt, commands )
    else
        self.game:unpackState(testState)
    end
end

function ClientScreen:sendCommands(commands)
    dg = binser.serialize(commands)
    udp:send(dg)
end

function ClientScreen:recieveState()
    local data, msg = udp:receive()
    local recieved = false
    if love.keyboard.isDown('t') then print(data) end
    while data do
        self.data = data
        if pcall(function () self.packet = binser.deserialize(self.data) end) then
            --print(serpent.block(self.packet))
            self.game:unpackState(self.packet[1])
        elseif msg == 'timeout' then
        end

        data, msg = udp:receive()
        recieved = true
    end
    return recieved
    -- self.game:unpackState(testState)
    -- return true
end

function ClientScreen:mousepressed(x,y,number)
    self.user:mousepressed(x,y,number)
end

function ClientScreen:keypressed(key, scancode, isrepeat )
    if key == 'escape' then
        self.upState.current = overlay:new(self.upState)
    end
    self.user:keypressed( key, scancode, isrepeat )
end

function ClientScreen:draw()
    self.user:draw()
    self.game:draw()
end

return ClientScreen
