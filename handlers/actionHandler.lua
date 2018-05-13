local walkAction = require 'actions/walkAction'
local jumpAction = require 'actions/jumpAction'
local fireAction = require 'actions/fireAction'
actionType = { walkAction = walkAction, jumpAction = jumpAction, fireAction = fireAction }

function process( dt, game )
    rval = {}
    for i in pairs( game.players ) do
        player = game.players[i]
        for i in pairs(player.actions) do
            actionObj = player.actions[i]
            action = actionType[actionObj.type]:new(actionObj.code)
            action:handle( player, dt, game)
            rval[i] = action
            player.actions[i] = nil
        end
    end
end

return process
