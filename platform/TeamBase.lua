local DestroyablePlatform = require 'platform/DestroyablePlatform'
local TeamBase = class('TeamBase', DestroyablePlatform)

function TeamBase:initialize( body, width, height, team )
    self.team = team
    DestroyablePlatform.initialize(self, body, width, height )
    self.rgba = teamColor or { 0.3,0.3,0.3 }
end 

function TeamBase:getState()
    if self.modified then
        local state = DestroyablePlatform.getState(self)
        state.team = self.team
        return state
    end
end

return TeamBase
