local VisualOptionList = class 'VisualOptionList'
local OptionList = require 'screens/menus/OptionList'

function VisualOptionList:initialize(options, position, dimensions)
    self.optionList = OptionList(options)
    self.margin = 10

    self:resize(dimensions, position)
end

function VisualOptionList:selectNext()
    self.optionList:selectNext()
end

function VisualOptionList:selectPrevious()
    self.optionList:selectPrevious()
end

function VisualOptionList:boopCurrent(MainMenu)
    self.optionList:boopCurrent(MainMenu)
end

function VisualOptionList:keypressed(k)
    self.optionList:keypressed(k)
end

function VisualOptionList:draw()
    if self.optionList == nil or self.optionList.options == nil then
        love.graphics.print('no options', self.dimensions.width/2, self.dimensions.height/2)
    else
        for i,v in ipairs(self.optionList.options) do
            v:draw()
        end
    end
end

function VisualOptionList:resize(dimensions, position)
    self.dimensions = dimensions
    if position.auto then
        self:AutoPosition(position.bounds)
    else
        self.position = position
    end
    local height = self.position.y
    for i,v in ipairs(self.optionList.options) do
        v:setPosition({x = self.position.x + self.dimensions.width/2, y = height})
        height = height + v.dimensions.height + self.margin
    end
end

function VisualOptionList:AutoPosition(bounds)
    --print('auto')
    local centerX = bounds[1] + (bounds[2] - bounds[1])/2
    local centerY = bounds[3] + (bounds[4] - bounds[3])/2
    self.position = {x = centerX - self:getWidth()/2, y = centerY - self:getHeight()/2, auto}
end

function VisualOptionList:getWidth()
    return self.dimensions.width
end

function VisualOptionList:getHeight()
    local height = 0
    for i,v in ipairs(self.optionList.options) do
        height = height + v.dimensions.height + self.margin
    end
    return height
end

return VisualOptionList
