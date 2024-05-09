local Platform = require 'platform/Platform'
local DestroyablePlatform = require 'platform/DestroyablePlatform'
local TeamBase = require 'platform/TeamBase'
local DeadlyPlatform = require 'platform/DeadlyPlatform'
local Water = require 'platform/Water'
local Bottom = require 'platform/Bottom'
local CharacterControllable = require 'character/CharacterControllable'
local NullControllable = require 'character/NullControllable'
local FingerBullet = require 'weapons/projectiles/FingerBullet'
local ThirtyOdd = require 'weapons/projectiles/ThirtyOdd'
local Pointer = require 'weapons/Pointer'
local Sniper = require 'weapons/Sniper'
local Shotgun = require 'weapons/Shotgun'
local RocketLauncher = require 'weapons/RocketLauncher'
local GrenadeLauncher = require 'weapons/GrenadeLauncher'
local Character = require 'character/Character'
local HealthPower = require 'powerups/HealthPower'
local WeaponPower = require 'powerups/WeaponPower'
local ArmorPower = require 'powerups/ArmorPower'
local JetpackPower = require 'powerups/JetpackPower'
local gamera = require 'lib/gamera'
local winWidth = love.graphics.getWidth
local winHeight = love.graphics.getHeight
local Player = require 'player/Player'
local NullPlayer = require 'player/NullPlayer'
local necromancer = require 'handlers/necromancer'
local eventHandler = require 'handlers/eventHandler'
local Victory = require 'handlers/victory/Victory'
local FFAVictory = require 'handlers/victory/FFAVictory'
local TeamVictory = require 'handlers/victory/TeamVictory'
local TeamDeathmatchVictory = require 'handlers/victory/TeamDeathmatchVictory'
local TitanVictory = require 'handlers/victory/TitanVictory'
local Bot = require 'player/Bot'

local WorldFactory = class('WorldFactory')

local WorldFactory:PopulateWorld(world, map)

end

local TeamBaseFactory(details)
    return TeamBase:new()
end

return WorldFactory