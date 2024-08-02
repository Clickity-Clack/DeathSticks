local Bot = class('Bot')

function Bot:initialize(aPlayer, skittishness)
    self.id = uuid()
    self.player = aPlayer
    self.direction = 'left'
    self.walking = true
    self.skittishness = skittishness or 1
end

function Bot:update(dt, objects)
    if math.random() > 0.99 then
        self:switchDirection()
    end
    if math.random() > 0.99 then
        self:setWalking( not self.walking )
    end
    if math.random() > 0.99 then
        self.jump = true
    end

    self:setCommands()
end

function Bot:switchDirection()
    if self.direction == 'left' then
        self.direction = 'right'
    else
        self.direction = 'left'
    end
end

function Bot:setWalking(walking)
    self.walking = walking
end

function Bot:setCommands()
    local commands = { direction = 'stopped', jump = false, r = 0, a = false, b = false, c = false, weaponSwitch = 'no' }
    if self.walking then
        commands.horizontalDirection = self.direction
    end
    if self.target then
        commands.a = true
    end
    self.player.commands = commands
end

function Bot:getLineOfSight()
    
end

function Bot:draw()
end

return Bot
