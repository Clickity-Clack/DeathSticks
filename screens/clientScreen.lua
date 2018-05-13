local unpacker = require 'handlers/unpacker'
local game = require 'game'
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
    self.sendTime = 0
end

function clientScreen:update(dt)
    self.game:update(dt)
    self:send(dt)
end

function clientScreen:send(dt)
    l = self.game.players[self.game.user].actions
    dg = binser.serialize(l)
    gd = binser.deserialize(dg)
    if love.keyboard.isDown('t') then print(serpent.block(l)) print(serpent.block(dg)) end
    udp:send(dg)
end

function clientScreen:mousepressed(x,y)
    self.game:mousepressed(x,y)
end

function clientScreen:keypressed(key, scancode, isrepeat )
    if key == 'escape' then
        self.upState.current = overlay:new(self.upState)
    end
    self.game:keypressed( key, scancode, isrepeat )
end

function clientScreen:keyreleased( key, scancode, isrepeat )
    self.game:keyreleased( key, scancode, isrepeat )
end

function clientScreen:draw()
    self.game:draw()
end

return clientScreen
