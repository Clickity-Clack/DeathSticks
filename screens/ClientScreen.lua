local unpacker = require 'handlers/unpacker'
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
end

function ClientScreen:update(dt)
    local commands = self.user:getCommands()
    self.game:update( dt, commands )
    self:send(commands)
end

function ClientScreen:send(commands)
    dg = binser.serialize(commands)
    --gd = binser.deserialize(dg)
    --if love.keyboard.isDown('t') then print(serpent.block(commands)) print(serpent.block(gd)) end
    udp:send(dg)
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
