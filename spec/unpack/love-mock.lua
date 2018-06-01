local love = {}

local bodyMock = require 'spec/unpack/body-mock'
local fixtureMock = require 'spec/unpack/fixture-mock'
love.physics = { newBody = bodyMock, newFixture = fixtureMock }

return love
