local optionList = class 'optionList'

function optionList:initialize(options, position, dimensions)
    self.options = options
    self.margin = 10
    self.position = position
    self.dimensions = dimensions

    if self.options == nil then 
        return
    end
    self.selected = initOptions(self.options, self.position, self.dimensions, self.margin)
end

function initOptions(options, position, dimensions, margin)
    local prevOption = { dimensions = { height = 0 } }
    local firstIndex = nil
    local height = position.y
    for i in pairs(options) do
        if not firstIndex then
            firstIndex = i
        end
        height = height + prevOption.dimensions.height + margin
        options[i]:setPosition({x = position.x + dimensions.width/2, y = height})
        prevOption = options[i]
    end
    options[firstIndex]:selected(true)
    return firstIndex
end

function optionList:selectNext()
    if self.options == nil then 
        return
    end

    self.options[self.selected]:selected(false)
    self.selected = next(self.options, self.selected)
    if not self.selected then self.selected = next(self.options, 0) end
    self.options[self.selected]:selected(true)
end

function optionList:selectPrevious()
    if self.options == nil then 
        return
    end

    self.options[self.selected]:selected(false)
    if self.selected == 1 then
        self.selected = #self.options
    else
        self.selected = self.selected - 1
    end
    self.options[self.selected]:selected(true)

end

function optionList:boopCurrent(mainMenu)
    self.options[self.selected]:boop(mainMenu)
end

function optionList:draw()
    if self.options == nil then
        love.graphics.print('no options', self.dimensions.width/2, self.dimensions.height/2)
        return
    end

    for i,v in ipairs(self.options) do
        v:draw()
    end
end

return optionList
