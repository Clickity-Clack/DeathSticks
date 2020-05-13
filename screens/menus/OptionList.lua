local OptionList = class 'OptionList'

function OptionList:initialize(options)
    self.options = options
    self:initOptions(options)
end

function OptionList:initOptions()
    local firstIndex = nil
    for i in pairs(self.options) do
        firstIndex = i
        break
    end
    self.options[firstIndex]:selected(true)
    self.selected = firstIndex
end

function OptionList:selectNext()
    if self.options ~= nil then 
        self.options[self.selected]:selected(false)
        self.selected = next(self.options, self.selected)
        if not self.selected then self.selected = next(self.options, 0) end
        self.options[self.selected]:selected(true)
    end
end

function OptionList:selectPrevious()
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

function OptionList:boopCurrent(MainMenu)
    self.options[self.selected]:boop(MainMenu)
end

-- function OptionList:textinput(t)
--     print(self.options[self.selection])
--     self.options[self.selection]:textinput(t)
-- end

return OptionList
