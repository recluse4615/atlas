atl_ui = {}

atl_ui = {}
atl_ui.last_held = {}
atl_ui.last_pointed = {}
atl_ui.huds = {}

atl_ui.crosshair_hud_offsets = {
    usable = {
        x = 32,
        y = 32
    },
    interactable = {
        x = -32,
        y = 32
    }
}

local function set_hud_image(player, type, image_path)
    local crosshair_offset = {
        x = 0,
        y = 0
    }

    -- if the hud currently doesn't exist (set to 0), then create it - otherwise just update the text
    local hud_id = atl_ui.huds[player:get_player_name()][type]
    if hud_id == 0 then
        hud_id = player:hud_add({
            hud_elem_type = "image",
            position = {
                x = 0.5,
                y = 0.5
            },
            offset = atl_ui.crosshair_hud_offsets[type],
            text = image_path,
            scale = {
                x = 2,
                y = 2
            },
            alignment = {
                x = 0,
                y = 0
            },
            direction = 0,
            number = 0xFFFFFF
        })

        atl_ui.huds[player:get_player_name()][type] = hud_id
    else
        player:hud_change(hud_id, "text", image_path)
    end
end

-- set the hud text to nothing, which for images hides it
local function hide_hud_image(player, type)
    local hud_id = atl_ui.huds[player:get_player_name()][type]
    if hud_id ~= 0 then
        player:hud_change(hud_id, "text", "")
    end
end


local function check_pointed(player)
    local pointed_thing = atl_core.get_pointed_at(player)
    if pointed_thing then
        local pointed_node = minetest.get_node(pointed_thing.under)

        local item_capabilities = player:get_wielded_item():get_tool_capabilities()
        if pointed_node and minetest.get_dig_params(minetest.registered_nodes[pointed_node.name].groups, item_capabilities).diggable then
            set_hud_image(player, "interactable", "hud_interactable.png")
        else
            hide_hud_image(player, "interactable")
        end

        -- todo: actually handle _atl_placeable check here
    else
        hide_hud_image(player, "interactable")
    end
end

local steps = 0
local max_steps = 2

minetest.register_globalstep(function(dtime)

    -- quick hack to reduce time spent on this silly task, only run every few globalsteps
    steps = steps + 1
    if steps < max_steps then
        return
    end

    steps = 0

    for _, player in ipairs(minetest.get_connected_players()) do

        local item_stack = player:get_wielded_item()

        -- todo: cache atl_ui.last_pointed
        check_pointed(player)

        -- todo: move to check_pointed as raycasts will be useful to determine if we ACTUALLY can place a node
        if atl_ui.last_held[player:get_player_name()] ~= item_stack:get_name() then
            atl_ui.last_held[player:get_player_name()] = item_stack:get_name()
            if item_stack:get_name() ~= "" then
                local item_def = minetest.registered_items[item_stack:get_name()]

                if item_def and item_def._atl_placeable then

                    if item_def._atl_placeable then
                        set_hud_image(player, "usable", "hud_usable.png")
                    end
                else
                    hide_hud_image(player, "usable")
                end
            else
                -- todo: handle hands
                hide_hud_image(player, "usable")
            end
        end
    end
end)


-- set default state
minetest.register_on_joinplayer(function(player)
    local player_name = player:get_player_name()

    atl_ui.last_held[player_name] = ""
    atl_ui.last_pointed[player_name] = ""
    atl_ui.huds[player:get_player_name()] = {
        usable = 0,
        interactable = 0
    }
    set_hud_image(player, "usable", "")
    set_hud_image(player, "interactable", "")
end)

minetest.register_on_leaveplayer(function(player)
    atl_ui.huds[player:get_player_name()] = nil
end)