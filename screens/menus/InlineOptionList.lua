local InlineOptionList = class 'InlineOptionList'
local OptionList = require 'screens/menus/OptionList'

function InlineOptionList:initialize(options, position)
    --print(options)
    self.optionList = OptionList(options)
    self.optionWidth = 150
    local dimensions = { width = 500, height  = 75 }

    self:selected(false)
    self:resize(dimensions, position)
end

function InlineOptionList:selected(isSelected) --I'm so sorry you had to read this
    local selectedOption = self.optionList.options[self.optionList.selected]
    selectedOption:selected(isSelected)
end

function InlineOptionList:setPosition(position)
    self.position = position
end

function InlineOptionList:selectNext()
    self.optionList:selectNext()
    self:repositionOptions()
end

function InlineOptionList:selectPrevious()
    self.optionList:selectPrevious()
    self:repositionOptions()
end

function InlineOptionList:boop(MainMenu)
    self.optionList:boopCurrent(MainMenu)
end

function InlineOptionList:keypressed(k)
    if k == 'left' or k == 'a' then
        self:selectPrevious()
    elseif k == 'right' or k == 'd' then
        self:selectNext()
    else
        self.OptionList:keypressed(k)
    end
end

function InlineOptionList:draw()
    if self.optionList == nil or self.optionList.options == nil then
        love.graphics.print('no options', self.dimensions.width/2, self.dimensions.height/2)
    else
        for i,v in ipairs(self.optionList.options) do
            v:draw()
        end
    end
end

function InlineOptionList:resize(dimensions, position)
    self.dimensions = dimensions
    if position.auto then
        self:AutoPosition(position.bounds)
    else
        self.position = position
    end
    self:repositionOptions()
end

function InlineOptionList:repositionOptions()
    local selectedXOffset = (self.optionList.selected - 1) * self.optionWidth
    local startingXPos = self.centerX - selectedXOffset
    for i,v in ipairs(self.optionList.options) do
        v:setPosition({x = startingXPos, y = self.position.y})
        startingXPos = startingXPos + self.optionWidth
    end
end

function InlineOptionList:AutoPosition(bounds)
    --print('inline auto')
    self.centerX = bounds[1] + (bounds[2] - bounds[1])/2
    self.centerY = bounds[3] + (bounds[4] - bounds[3])/2
    self.position = {x = self.centerX, y = self.centerY, auto}
end

function InlineOptionList:getWidth()
    return self.dimensions.width
end

function InlineOptionList:getHeight()
    return self.dimensions.height
end

return InlineOptionList
