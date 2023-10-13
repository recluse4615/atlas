local storage = minetest.get_mod_storage()
local backend = {}

local function get_id_by_reference(player_reference)
    -- assuming it's either a player name or internal id
    if type(player_reference) == "string" then
        return player_reference
    end

    return player_reference:get_player_name()
end

function backend.get_exp(player, skill_name)
    return storage:get_int(get_id_by_reference(player) .. ":" .. skill_name)
end

function backend.set_exp(player, skill_name, experience)
    storage:set_int(get_id_by_reference(player) .. ":" .. skill_name, experience)
end

return backend