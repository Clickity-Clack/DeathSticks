local Packable = require'handlers/unpacking/Packable'
local NullControllable = require 'character/NullControllable'
local NullPlayer = class('NullPlayer', Packable)

function NullPlayer:initialize( controllable )
    Packable.initialize(self)
    self.controllable = NullControllable:new()
end

function NullPlayer:update()
end

function NullPlayer:getCenter()
    return self.controllable:getCenter()
end

function NullPlayer:switchControllable( controllable )
    return NullControllable:new()
end

return NullPlayer
