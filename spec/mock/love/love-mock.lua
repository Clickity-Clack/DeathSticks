local love = {}

local BodyMock = require 'spec/mock/love/body-mock'
local FixtureMock = require 'spec/mock/love/fixture-mock'
local ImageMock = require 'spec/mock/love/image-mock'
local ShapeMock = require 'spec/mock/love/shape-mock'
local BlankMock = function() return {} end
love.physics = { newBody = BodyMock, newFixture = FixtureMock, newRectangleShape = ShapeMock }
love.graphics = { newImage = ImageMock }

return love
