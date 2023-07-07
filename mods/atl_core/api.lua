
function atl_core.get_pointed_at(player)
    local tool_range = player:get_wielded_item():get_definition().range or nil

    local wield_range = tool_range or 4

    return atl_core.get_pointed_at_by_distance(player, wield_range)
end

function atl_core.get_pointed_at_by_distance(player, distance)
    -- code borrowed from https://github.com/Rotfuchs-von-Vulpes/what_is_this_uwu-minetest/blob/master/help.lua#L210

    local player_pos = player:get_pos()
    local eye_height = player:get_properties().eye_height
    local eye_offset = player:get_eye_offset()

    player_pos.y = player_pos.y + eye_height
    player_pos = vector.add(player_pos, eye_offset)

    local see_liquid = minetest.registered_nodes[minetest.get_node(player_pos).name].drawtype ~= "liquid"


    local look_dir = player:get_look_dir()
    look_dir = vector.multiply(look_dir, distance)

    local end_pos = vector.add(look_dir, player_pos)

    local ray = minetest.raycast(player_pos, end_pos, false, see_liquid)

    return ray:next()
end