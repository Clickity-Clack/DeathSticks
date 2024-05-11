function shouldTextBeDark(cap,level,backColor,fillColor)
    local backColorRGBValue = backColor[1] + backColor[2] + backColor[3]
    local fillColorRGBValue = fillColor[1] + fillColor[2] + fillColor[3]
    local percentage = level/cap
    local totalBack = (1 - percentage) * backColorRGBValue
    local totalFill = percentage * fillColorRGBValue
    local averageRGBValue = totalBack + totalFill
    return averageRGBValue > 0.8
end

return {
    draw = function(x,y,cap,level,backColor,fillColor,width,height)
        love.graphics.setColor(backColor)
        love.graphics.rectangle('fill', x, y, width, height)
        love.graphics.setColor(fillColor)
        love.graphics.rectangle('fill', x, y, level/cap * width, height)
        if shouldTextBeDark(cap,level,backColor,fillColor) then
            love.graphics.setColor(0,0,0)
        else
            love.graphics.setColor(1,1,1)
        end
        local printx = x + width/2 - font:getWidth(level)/2
        local printy = y + height/2 - font:getHeight()/2
        love.graphics.print(level, printx, printy)
    end
}