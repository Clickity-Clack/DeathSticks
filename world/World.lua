local World = class('World')

function World:initialize()
    self.cWorld = { w = 5000, h = 3000, columns = 24, rows = 22 }
    self.id = uuid()
    self.objects = {}
    love.physics.setMeter(64) --the height of a meter our worlds will be 64px
    self.physicsWorld = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
    self.physicsWorld:setCallbacks(beginContact, endContact)
    self.stems = {}
    self.removed = {}
    self.spawnPoints = {}
end

function World:update(dt, events)
    self.physicsWorld:update(dt)
    
    for i in pairs(self.stems) do
        self.stems[i]:update(dt, events)
    end
end

function World:draw(l,t,w,h)
    self.backDrop:draw(l,t,w,h)
    for v in pairs(self.stems) do
        self.stems[v]:draw(self.cam, self.user)
    end
end

function World:getState()
    local objectState = {}
    for i in pairs(self.stems) do
        objectState[self.stems[i].id] = self.stems[i]:getState()
    end
    return objectState
end

function World:unpackState(state)
    unpackObjects(self, state.stems)
end

function unpackObjects(self, stateObjects)
    for i in pairs(stateObjects) do
        self:unpackObject(stateObjects[i])
    end
end

function unpackObject(self, objectState)
    local object = self.stems[objectState.id]
    if not object and Game.stemTypes[objectState.type] then
        object = necromancer(objectState, self)
        self.stems[object.id] = object
    end
    if object then
        object:unpackState(objectState, self)
    end
    return object
end

function World:fullReport()
    for i in pairs(self.stems) do
        self.stems[i]:fullReport()
    end
end

function World:unpackRemoved(stateRemoved)
    if(stateRemoved) then
        for i in pairs(stateRemoved)do
            if self.stems[i] then
                self.stems[i]:destroy()
                self.stems[i] = nil
            end
        end
    end
end

function World:spawnControllable(playerId, controllable)
    local controllable = controllable or self.controllable
    local newControllable = controllable:new({physicsWorld = self.physicsWorld, x = self.spawnPoints[math.random(#self.spawnPoints)].x, y = self.spawnPoints[1].y}, playerId)
    self.stems[newControllable.id] = newControllable
    return newControllable
end

function World:removeControllable(id)
    self.stems[id] = nil
end

function beginContact(a, b, coll)
    local aThing, bThing = a:getUserData(), b:getUserData()
    assert(aThing.collide, aThing.class.name .. " has no collide method!")
    aThing:collide(bThing)
end

function endContact(a, b, coll)
    local aThing, bThing = a:getUserData(), b:getUserData()
    assert(aThing.separate, aThing.class.name .. " has no separate method!")
    aThing:separate(bThing)
end

return World