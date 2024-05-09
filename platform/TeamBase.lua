local DestroyablePlatform = require 'platform/DestroyablePlatform'
local TeamBase = class('TeamBase', DestroyablePlatform)

function TeamBase:initialize( iPosition, team )
    self.team = team
    local dimensions = {height = 100, width = 100}
    DestroyablePlatform.initialize(self, iPosition, dimensions )
    self.rgba = teamColor or { 0.7,0.3,0.3 }
end 

function TeamBase:getState()
    if self.modified then
        local state = DestroyablePlatform.getState(self)
        state.team = self.team
        return state
    end
end

return TeamBase
