local events = { collide = {}, dead = {}, fire = {} }
function process( dt, game )
    for i, event in ipairs(game.events) do
        if events[event.type] then
            if events[event.type][event.subject.class.name] then
                events[event.type][event.subject.class.name](event, game)
            end
        end
        game.events[i] = nil
    end
end

events.fire.Character = function (event, game)
    local obj = event.subject:fire(game.world)
    if obj then
        game.objects[obj.id] = obj
    end
end

events.dead.Character = function ()
    
end

return process
