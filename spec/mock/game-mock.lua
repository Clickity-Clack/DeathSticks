local GameMock = class('GameMock')
local WeaponMock = require 'spec/mock/weapon-mock'
local mock1 = class('mock1', WeaponMock)
local mock2 = class('mock2', WeaponMock)

function GameMock:initialize(udp)
end
local unpackable = {}
function GameMock:unpackObject(state)
    return unpackable[state.type]
end
unpackable.WeaponMock = function(game, state)
    return WeaponMock:new(state.udp)
end
unpackable.mock1 = function(game, state)
    return mock1:new(state.udp)
end
unpackable.mock2 = function(game, state)
    return mock2:new(state.udp)
end

return GameMock
