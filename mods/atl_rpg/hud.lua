-- i did not write this file sober. i apologise in advance
local hud = {}

local huds = {}
local function set_hud(player, id, field, data, definition)
    local hud_data = huds[player:get_player_name()] or {}
    local hud_id = hud_data[id] or nil

    if hud_id == nil then
        definition[field] = data
        huds[player:get_player_name()][id] = player:hud_add(definition)
    else
        player:hud_change(hud_id, field, data)
    end
end

local function set_hud_text(player, id, text, definition)
    set_hud(player, id, "text", text, definition)
end

local function set_hud_scale(player, id, scale, definition)
    set_hud(player, id, "scale", scale, definition)
end

-- this may be the worst way possible to do things but it works i guess
function hud.set_main_skill(player, skill_name)
    local skill_definition = atl_rpg.get_skill(skill_name)
    set_hud_text(player, "main.image", skill_definition.icon, {
        hud_elem_type = "image",
        position = {
            x = 1,
            y = 0
        },
        offset = {
            x = -184,
            y = 16
        },
        scale = {
            x = 2,
            y = 2
        },
        alignment = {
            x = 1,
            y = 0
        },
        direction = 0,
        number = 0xFFFFFF
    })

    local experience = atl_rpg.get_experience(player, skill_name)
    local level = skill_definition.xp_to_level(experience)
    
    local progress_scale = 0
    if level == skill_definition.max_level then
        progress_scale = 1
    else
        -- todo: clamp just in case?
        progress_scale = (experience / skill_definition.level_to_xp(level + 1))
    end

    set_hud_text(player, "main.text", atl_rpg.get_experience(player, skill_name), {
        hud_elem_type = "text",
        position = {
            x = 1,
            y = 0
        },
        offset = {
            x = -144,
            y = 24
        },
        scale = {
            x = 64,
            y = 16
        },
        text = experience
    })

    -- first time: set progress background
    if huds[player:get_player_name()]["main.progress_bg"] == nil then
        set_hud_text(player, "main.progress_bg", "atl_rpg_progress_bg.png", {
            hud_elem_type = "image",
            position = {
                x = 1,
                y = 0
            },
            offset = {
                x = -144,
                y = 48
            },
            scale = {
                x = 2,
                y = 2
            },
            alignment = {
                x = 1,
                y = 0
            },
            direction = 0,
            number = 0xFFFFFF
        })
    end

    set_hud_scale(player, "main.progress", {
        x = progress_scale * 2,
        y = 2
    }, {
        hud_elem_type = "image",
        text = "atl_rpg_progress.png",
        position = {
            x = 1,
            y = 0
        },
        offset = {
            x = -141,
            y = 51
        },
        scale = {
            x = progress_scale * 2,
            y = 2
        },
        alignment = {
            x = 1,
            y = 0
        },
        direction = 0,
        number = 0xFFFFFF
    })
end

minetest.register_on_joinplayer(function(player)
    huds[player:get_player_name()] = {}
end)

minetest.register_on_leaveplayer(function(player)
    huds[player:get_player_name()] = nil
end)

return hud