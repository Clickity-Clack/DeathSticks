local mockFixture = class('mockFixture')

function mockFixture:initialize(body, shape)
    self.body = body
    self.shape = shape
end

function mockFixture:setUserData(userData)
    self.userData = userData
end

function mockFixture:getUserData()
    return self.userData
end

return mockFixture
