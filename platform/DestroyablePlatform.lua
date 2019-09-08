local Platform = require 'platform/Platform'
local DestroyablePlatform = class('DestroyablePlatform', Platform)
local HasHealth = require 'character/HasHealth'
DestroyablePlatform:include(HasHealth)

function DestroyablePlatform:initialize( body, width, height )
    Platform.initialize(self, body, width, height)
    HasHealth.initializeMixin(self, 1000)--self.health = Health:new(self.id, 1000) --parentId,hp,capacity,armor
end

function DestroyablePlatform:update(dt, events)
    HasHealth.update(self, dt, events)
    if self.dead then
        table.insert(events, { type = 'dead', subject = self })
        self.dead = false
    end
end

function DestroyablePlatform:draw()
    Platform.draw(self)
    HasHealth.draw(self,self.body:getX(),self.body:getY()) --part of implementation
end

function DestroyablePlatform:destroy()
    self.body:destroy()
end

function DestroyablePlatform:getState()
    if self.modified then --move to hashealth
        local state = Platform.getState(self)
        HasHealth.getState(self, state)
        return state
    end
end

function DestroyablePlatform:unpackState(state, game)
    if state then
        HasHealth.unpackState(self, state, game) --Include method in HasHealth
        Platform.unpackState(self, state)
    end
end

return DestroyablePlatform
