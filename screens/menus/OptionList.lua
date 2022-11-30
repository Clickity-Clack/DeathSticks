local OptionList = class 'OptionList'

function OptionList:initialize(options)
    self.options = options
    self:initOptions(options)
end

function OptionList:initOptions()
    if self.options[1] ~= nil then
        self.options[1]:selected(true)
        self.selected = 1
    end
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

function OptionList:currentIsEditing()
    return self.options[self.selected].isEditing
end

function OptionList:boopCurrent(MainMenu)
    self.options[self.selected]:boop(MainMenu)
end

function OptionList:keypressed(k)
    self.options[self.selected]:keypressed(k)
end

function OptionList:textinput(k)
    if self.options[self.selected].textinput then
        self.options[self.selected]:textinput(k)
    end
end

return OptionList
