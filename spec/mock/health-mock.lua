local HealthMock = class('HealthMock')

function HealthMock:initialize()
    self.hp = 100
    self.capacity = 100
end

function HealthMock:heal(healPoints)
    if self.hp < self.capacity then
        self.hp = self.hp + healPoints
        if self.hp > self.capacity then
            self.hp = self.capacity
        end
        return true
    end
    return false
end

return HealthMock
