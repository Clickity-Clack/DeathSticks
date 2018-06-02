local love = {}

local bodyMock = require 'spec/mock/body-mock'
local fixtureMock = require 'spec/mock/fixture-mock'
love.physics = { newBody = bodyMock, newFixture = fixtureMock }

return love
