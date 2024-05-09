local MultiShot = require 'weapons/projectiles/multishot/MultiShot'
local Twelve = class('Twelve', MultiShot)
local Pellet = require 'weapons/projectiles/Pellet'

function Twelve:initialize(iPosition, aPlayerId)
    self.shot = Pellet
    self.shotCount = 7
    self.blastRadius = 1
    MultiShot.initialize(self, iPosition, aPlayerId)
end

return Twelve
