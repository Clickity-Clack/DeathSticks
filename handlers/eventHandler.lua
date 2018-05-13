
function process( dt, game )
    for i, event in ipairs(game.events) do
        event:handle(dt, game)
        game.events[i] = nil
    end
end

return process
