local Platform = require 'platform/Platform'
local DestroyablePlatform = class('DestroyablePlatform', Platform)
local Health = require 'character/Health'

function DestroyablePlatform:initialize( body, width, height )
    Platform.initialize(self, body, width, height)
    self.health = Health:new(self.id, 300) --parentId,hp,capacity,armor
end

function DestroyablePlatform:ouch(hurtyThing)
    self.health:ouch(hurtyThing)
end

function DestroyablePlatform:update(dt, events)
    if self.health.dead then
        table.insert(events, { type = 'dead', subject = self })
        self.health.dead = false
    end
    self.modified = self.modified or self.health.modified
end

function DestroyablePlatform:draw()
    self.health:draw(self.body:getX(),self.body:getY())
    Platform.draw(self)
end

function DestroyablePlatform:destroy()
    self.body:destroy()
end

function DestroyablePlatform:getState()
    if self.modified then
        local state = Platform.getState(self)
        state.health = self.health:getState()
        return state
    end
end

function DestroyablePlatform:unpackState(state, game)
    if state then
        self.health:unpackState(state.health, game)
        Platform.unpackState(self, state)
    end
end

return DestroyablePlatform
