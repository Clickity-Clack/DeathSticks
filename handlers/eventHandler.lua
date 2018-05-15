local events = { collide = {}, dead = {}, fire = {} }
function process( dt, game )
    for i, event in ipairs(game.events) do
        if events[event.type] then
            if events[event.type][event.subject.class.name] then
                events[event.type][event.subject.class.name](event, game)
            end
        end
    end
end

events.fire.character = function (event, game)
    local obj = event.subject.weapons.current:fire(game.world)
    if obj then
        game.objects[obj.id] = obj
    end
end

events.dead.character = function ()
    
end

return process
