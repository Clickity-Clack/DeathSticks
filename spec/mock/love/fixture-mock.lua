local MockFixture = class('MockFixture')

function MockFixture:initialize(body, shape)
    self.body = body
    self.shape = shape
end

function MockFixture:setUserData(userData)
    self.userData = userData
end

function MockFixture:getUserData()
    return self.userData
end

function MockFixture:setSensor()
    
end

return MockFixture
