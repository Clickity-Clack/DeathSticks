local ObjectDisplay = class('ObjectDisplay')

local superClassData = {
    Projectile = {color = {0.7,0.7,0.1}, draw = true},
    PowerUp = {color = {0.5,0.0,0.5}, draw = false},
    Platform = {color = {0.3,0.7,0.3}, draw = false},
    other = {color = {0,0,0}, draw = true}
}

local classData = {
    other = {name = "other", static = false, color = {0, 0, 0}, superClass = superClassData.other},
    CharacterControllable = {name = "CharacterControllable", static = false, color = {0.5, 0.5, 1}, superClass = superClassData.other},
    NullControllable = {name = "NullControllable", static = false, color = {1, 1, 1}, superClass = superClassData.other},
    WeaponPower = {name = "WeaponPower", static = true, color = {0.7, 0.3, 0.3}, superClass = superClassData.PowerUp},
    HealthPower = {name = "HealthPower", static = true, color = {0.7, 0.3, 0.3}, superClass = superClassData.PowerUp},
    ArmorPower = {name = "ArmorPower", static = true, color = {0.3, 0.3, 0.3}, superClass = superClassData.PowerUp},
    JetpackPower = {name = "JetpackPower", static = true, color = {0.3, 0.3, 0.7}, superClass = superClassData.PowerUp},
    Platform = {name = "Platform", static = true, color = {0.5, 1, 0.3}, superClass = superClassData.Platform},
    DestroyablePlatform = {name = "DestroyablePlatform", static = true, color = {1, 0.5, 0.3}, superClass = superClassData.Platform},
    Bottom = {name = "Bottom", static = true, color = {1, 0.5, 0.3}, superClass = superClassData.Platform},
    DeadlyPlatform = {name = "DeadlyPlatform", static = true, color = {1, 0, 0}, superClass = superClassData.Platform},
    TeamBase = {name = "TeamBase", static = true, color = {0.3, 0.7, 0.3}, superClass = superClassData.Platform},
    Water = {name = "Water", static = true, color = {0.3, 0.3, 1}, superClass = superClassData.Platform},
    Rocket = {name = "Rocket", static = false, color = {1, 0.1, 0.1}, superClass = superClassData.Projectile},
    NineMil = {name = "NineMil", static = false, color = {0.3, 0.5, 0.5}, superClass = superClassData.Projectile}
}
function ObjectDisplay:initialize(position, boxDimensions, gridDimensions, height)
    self.position = position or {x = 7, y = 100}
    self.boxDimensions = boxDimensions or {height = 7, width = 20}
    self.gridDimensions = gridDimensions or {rowHeight = 8, columnWidth = 21}
    self.rowCount = 50
    self.drawStatic = true
end

function ObjectDisplay:drawObjects(stems)
    local staticObjects, dynamicObjects = sortObjects(stems)
    local drawIndex = 0
    if self.drawStatic then
        drawIndex = drawCollection(self, staticObjects, drawIndex)
    end
    drawCollection(self, dynamicObjects, drawIndex)
end

function sortObjects(stems)
    local staticObjects = {}
    local dynamicObjects = {}
    for i in pairs(stems) do
        local obj = stems[i]
        local objData = classData[obj.class.name] or classData.other
        if objData.static then
            table.insert(staticObjects, objData)
        else
            table.insert(dynamicObjects, objData)
        end
    end
    return staticObjects, dynamicObjects
end

function drawCollection(self, objectList, drawIndex)
    local classColor = {}
    local superClassColor = {}
    local relativePosition = {}
    for i in pairs(objectList) do
        classColor = objectList[i].color
        superClassColor = objectList[i].superClass.color
        relativePosition = calculateRelativePosition(self, drawIndex)
        superClassVisible = objectList[i].superClass.draw

        if superClassVisible then
            drawObject(superClassColor, classColor, relativePosition, self.boxDimensions)
            drawIndex = drawIndex + 1
        end
    end
    return drawIndex
end

function calculateRelativePosition(self, drawIndex)
    local xColumnIndex = math.floor(drawIndex/self.rowCount)
    local xOffset = xColumnIndex * self.gridDimensions.columnWidth
    local yOffset = math.fmod(drawIndex, self.rowCount) * self.gridDimensions.rowHeight
    return {x = self.position.x + xOffset, y = self.position.y + yOffset}
end

function drawObject(color1, color2, position, size)
    love.graphics.setColor(color1)
    love.graphics.rectangle('fill', position.x, position.y, 2*size.width/3, size.height)
    love.graphics.setColor(color2)
    love.graphics.rectangle('fill', position.x + 2*size.width/3, position.y, size.width/3, size.height)
end

function ObjectDisplay:setDrawStatic(drawStatic)
    self.drawStatic = drawStatic
end

return ObjectDisplay
