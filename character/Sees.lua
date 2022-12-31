local Sees = {}

function Sees:initializeMixin()
end

function Sees:CanISee(myPos, target, obstacles)     --TODO: Eventually this should return a length - 0 if it's completely blocked, then the length that's visible. Could probably do that by calculating the intersection point on the line from the viewpoint to the edge of the ObstacleSightProfile
    local targetSightProfile = calculateSightProfile(myPos, target:getVisibleBox())
    local targetSightLine = {}
    targetSightLine[1] = [myPos, targetSightProfile[1]]
    targetSightLine[2] = [myPos, targetSightProfile[2]]
    targetSightLine[1].blocked = false
    targetSightLine[2].blocked = false
    for k,obstacle in pairs(obstacles)
        local obstacleSightProfile = calculateSightProfile(myPos, obstacle:getVisibleBox())
        for sightLineIter = 1, 2 do
            targetSightLine[sightLineIter].blocked = targetSightLine[sightLineIter].blocked or checkIntersection(targetSightLine[sightLineIter], obstacleSightProfile)
        end
    end
    return !(targetSightLine[1].blocked and targetSightLine[2].blocked)
end

function calculateSightProfile(myPos, box)
    local boxCenter = findCenter(box)
    local boxYGreater = boxCenter.y > myPos.y
    local boxXGreater = boxCenter.x > myPos.x
    if boxYGreater then
        if boxXGreater then
            return {box[2], box[4]}
        else
            return {box[1], box[3]}
        end
    else
        if boxXGreater then
            return {box[1], box[3]}
        else
            return {box[2], box[4]}
        end
    end
end

function findCenter(box)
    local centerX = (box[1][1] + box[2][1] + box[3][1] + box[4][1])/4
    local centerY = (box[1][2] + box[2][2] + box[3][2] + box[4][2])/4
    return {centerX, centerY}
end

function checkIntersection(lineA, lineB)

end

function isInsideBox(point, box)

end

return Sees
