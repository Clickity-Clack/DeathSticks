local DummyDBPObj = class('dummy', DynamicBodiedPackable)

function DummyDBPObj:initialize()
    self.shape = {}
    DynamicBodiedPackable.initialize(self, love.physics.newBody())
end

return DummyDBPObj
