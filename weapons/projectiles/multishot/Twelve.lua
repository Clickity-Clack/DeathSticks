local MultiShot = require 'weapons/projectiles/multishot/MultiShot'
local Twelve = class('Twelve', MultiShot)
local Pellet = require 'weapons/projectiles/Pellet'

function Twelve:initialize(iPosition, aPlayerId)
    self.shot = Pellet
    self.shotCount = 12
    MultiShot.initialize(self, iPosition, aPlayerId)
    self.blastRadius = 2
end

return Twelve
