local DummyBPObj = class('dummy', BodiedPackable)

function DummyBPObj:initialize()
    self.shape = {}
    BodiedPackable.initialize(self, love.physics.newBody())
end

return DummyBPObj
