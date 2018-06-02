local HealthMock = class('HealthMock')

function HealthMock:initialixe()
    self.hp = 100
    self.capacity = 100
end

function HealthMock:heal(healPoints)
    if aHealth.hp < aHealth.capacity then
        aHealth.hp = aHealth.hp + healPoints
        if aHealth.hp > aHealth.capacity then
            aHealth.hp = aHealth.capacity
        end
        return true
    end
    return false
end

return HealthMock
