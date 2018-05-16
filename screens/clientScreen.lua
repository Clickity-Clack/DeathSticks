local unpacker = require 'handlers/unpacker'
local game = require 'game'
local user = require 'user'
local overlay = require 'screens/menus/overlayScreen'
local socket = require 'socket'
local binser = require 'lib/binser'
local serpent = require 'lib/serpent'

local address, port = "localhost", 12345

local clientScreen = class('clientScreen')
local udp = socket.udp()

function clientScreen:initialize(upState)
    udp:settimeout(0)
    udp:setpeername(address, port)
    self.id = uuid()
    self.upState = upState
    self.game = game:new()
    self.user = user:new(self.game.user)
    self.sendTime = 0
end

function clientScreen:update(dt)
    local commands = self.user:getCommands()
    self.game:update( dt, commands )
    self:send(commands)
end

function clientScreen:send(commands)
    dg = binser.serialize(commands)
    --gd = binser.deserialize(dg)
    --if love.keyboard.isDown('t') then print(serpent.block(commands)) print(serpent.block(gd)) end
    udp:send(dg)
end

function clientScreen:mousepressed(x,y,number)
    self.user:mousepressed(x,y,number)
end

function clientScreen:keypressed(key, scancode, isrepeat )
    if key == 'escape' then
        self.upState.current = overlay:new(self.upState)
    end
    self.user:keypressed( key, scancode, isrepeat )
end

function clientScreen:draw()
    self.user:draw()
    self.game:draw()
end

return clientScreen
