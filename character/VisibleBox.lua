local HasVisibleBox = {}

function HasVisibleBox:initializeMixin(boxDimensions)
    self.VisibleBox = {}
    self.VisibleBox[1] = {boxDimensions.x, boxDimensions.y}
    self.VisibleBox[2] = {boxDimensions.x + boxDimensions.w, boxDimensions.y}
    self.VisibleBox[3] = {boxDimensions.x + boxDimensions.w, boxDimensions.y + boxDimensions.h}
    self.VisibleBox[4] = {boxDimensions.x, boxDimensions.y + boxDimensions.h}
    self.VisibleBox = boxDimensions
end

function HasVisibleBox:getVisibleBox()
    return self.VisibleBox
end

return HasVisibleBox
