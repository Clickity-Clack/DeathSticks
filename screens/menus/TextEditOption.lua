local TextEditOption = class 'TextEditOption'

function TextEditOption:initialize(title, boop)
    self.boop = self.toggleIsEditing
    self.title = title
    self.text = ''
    self.isSelected = false
    self.isEditing = false
    self.dimensions = { width = 500, height  = 75 }
    self.isBlinking = 0
    self.blinkLength = 0.5
    self.blinkTimer = 0
    self.once = true
end

function TextEditOption:update(dt)
    self.blinkTimer = self.blinkTimer + dt
    if self.blinkTimer >= self.blinkLength then
        if self.once then
            print('time up')
            self.once = false
        end
        self.blink = not self.blink
        self.blinkTimer = 0
    end
end

function TextEditOption:toggleIsEditing()
    self.isEditing = not (self.isEditing)
end

function TextEditOption:selected(isSelected)
    self.isSelected = isSelected
end

function TextEditOption:setPosition(position)
    self.position = position
end

function TextEditOption:keypressed(key)
    if key == 'backspace' then
        self.text = string.sub(self.text, 1, -2)
    end
end

function TextEditOption:textinput(t)
    self.text = self.text .. t
end

function TextEditOption:draw()
    love.graphics.setColor(1,1,1)
    if self.isSelected then
        if not self.isEditing then
            love.graphics.rectangle('line', self.position.x - self.dimensions.width/2, self.position.y - self.dimensions.height/2, self.dimensions.width, self.dimensions.height)
        else
            local recx = (font:getWidth(self.text)/2) + 1
            local recHeight = font:getHeight()
            local recWidth = font:getWidth(' ') + 4
            local drawType = 'line'
            if self.blink then 
                drawType = 'fill'
            end
            love.graphics.rectangle(drawType, self.position.x + recx, self.position.y - recHeight/2, recWidth, recHeight)
        end
    end

    if self.text == '' and not self.isEditing then
        love.graphics.print(self.title, self.position.x - font:getWidth(self.title)/2, self.position.y - font:getHeight()/2)
    else
        love.graphics.print(self.text, self.position.x - font:getWidth(self.text)/2, self.position.y - font:getHeight()/2)
    end
end

return TextEditOption
