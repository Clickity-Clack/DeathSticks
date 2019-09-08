local NullControllable = require 'character/NullControllable'
local NullPlayer = class('NullPlayer')
NullPlayer:include(Serializeable)

function NullPlayer:initialize( controllable )
    Serializeable.initializeMixin(self)
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
