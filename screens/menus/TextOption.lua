local PlainOption = class 'PlainOption'

function PlainOption:initialize(title, boop)
    self.boop = boop
    self.title = title
    self.text = ''
    self.isSelected = false
    self.dimensions = { width = 500, height  = 75 }
end

function PlainOption:selected(isSelected)
    self.isSelected = isSelected
end

function PlainOption:setPosition(position)
    self.position = position
end

function PlainOption:keypressed(key)
    if key == 'backspace' then
        self.text = string.sub(self.text, 1, -1)
    end
end

function PlainOption:textinput(t)
    self.text = self.text .. t
end

function PlainOption:draw()
    love.graphics.setColor(1,1,1)
    if self.isSelected then
        love.graphics.rectangle('line', self.position.x - self.dimensions.width/2, self.position.y - self.dimensions.height/2, self.dimensions.width, self.dimensions.height)
    end
    love.graphics.print(self.title, self.position.x - font:getWidth(self.title)/2, self.position.y - font:getHeight())
    love.graphics.print(self.text, self.position.x - font:getWidth(self.text)/2, self.position.y - font:getHeight()*1.5)
end

return PlainOption
