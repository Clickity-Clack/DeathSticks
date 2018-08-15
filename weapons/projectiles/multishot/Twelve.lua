local MultiShot = require 'weapons/projectiles/multishot/MultiShot'
local Twelve = class('Twelve', MultiShot)
local Pellet = require 'weapons/projectiles/Pellet'

function Twelve:initialize(barrelDeets, aPlayerId, world)
    self.shot = Pellet
    self.shotCount = 7
    self.blastRadius = 1
    MultiShot.initialize(self, barrelDeets, aPlayerId, world)
end

return Twelve
