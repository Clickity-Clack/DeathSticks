local love = {}

local bodyMock = require 'spec/mock/love/body-mock'
local fixtureMock = require 'spec/mock/love/fixture-mock'
love.physics = { newBody = bodyMock, newFixture = fixtureMock }

return love
