local Weapon = require 'weapons/Weapon'
local InterpretedWeapon = class('InterpretedWeapon', Weapon)

function InterpretedWeapon:initialize()
    self.ammo = self.initialammo
    self.initialammo = nil
    Weapon.initialize(self)
end

return InterpretedWeapon
