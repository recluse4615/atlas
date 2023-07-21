function atl_core.swap_node_name(pos, name)
    local node = minetest.get_node(pos)

    if node.name == name then
        return
    end

    node.name = name
    minetest.swap_node(pos, node)
end

function atl_core.register_furnace(
    inactive_name,
    inactive_def,
    active_def,
    source_size,
    destination_size,
    furnace_type,
    cooking_speed_modifier,
    cooking_yield_multiplier)

    -- start by defining functions
    -- lowpart -> x.png^[lowpart:y:z.png -> y = 0 means full x.png, y = 100 means full z.png
    local generate_formspec = function(fuel_percent, item_percent)
        local start_x_position = 2
        local fuel_x_position = (start_x_position + (0.5 * (source_size - 1)))
        local formspec = "size[9,8.5]" ..
            "list[context;src;" .. start_x_position .. ",0.5;" .. source_size .. ",1;]" ..
            "list[context;fuel;" .. fuel_x_position .. ",2.5;1,1;]" ..
            "image[" .. fuel_x_position .. ",1.5;1,1;atl_furnace_fire_bg.png^[lowpart:" .. fuel_percent .. ":atl_furnace_fire_fg.png]" ..
            "image[" .. (fuel_x_position + 1) .. ",1.5;1,1;atl_furnace_arrow_bg.png^[lowpart:" .. item_percent .. ":atl_furnace_arrow_fg.png^[transformR270]" ..
            "list[context;dst;" .. (fuel_x_position + 2) .. ",0.96;2,2;]" .. -- todo: factor in destination_size
            "list[current_player;main;0,4.25;9,1;]" ..
            "list[current_player;main;0,5.5;9,3;9]"

        return formspec
    end

    local can_put = function(pos, list_name, index, item_stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            return 0
        end

        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()

        if list_name == "fuel" then
            local craft_result = minetest.get_craft_result({
                method = "fuel",
                width = 1,
                items = {
                    item_stack
                }
            })

            if craft_result.time ~= 0 then
                return item_stack:get_count()
            else
                return 0
            end
        elseif list_name == "src" then
            return item_stack:get_count()
        end

        return 0
    end

    local can_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local item_stack = inv:get_stack(from_list, from_index)

        return can_put(pos, to_list, to_index, item_stack, player)
    end

    local can_take = function(pos, list_name, index, item_stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            return 0
        end

        return item_stack:get_count()
    end

    -- this timer func is taken from MTG's furnace_node_timer function... i don't fully understand it
    local timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)

        local fuel_time = meta:get_float("fuel_time") or 0
        local src_time = meta:get_float("src_time") or 0
        local fuel_total_time = meta:get_float("fuel_total_time") or 0

        local inv = meta:get_inventory()

        local timer_elapsed = meta:get_int("timer_elapsed") or 0
        meta:set_int("timer_elapsed", timer_elapsed + 1) -- use "elapsed" here?

        local src_list, fuel_list
        local dst_full = false

        local cookable, cooked, fuel

        local update = true
        while elapsed > 0 and update == true do
            update = false

            src_list = inv:get_list("src")
            fuel_list = inv:get_list("fuel")
            local after_cooked
            cooked, after_cooked = atl_core.get_cookable(src_list)

            cookable = cooked.time ~= 0

            local real_elapsed = math.min(elapsed, fuel_total_time - fuel_time)
            if cookable then
                real_elapsed = math.min(real_elapsed, cooked.time - src_time)
            end

            if fuel_time < fuel_total_time then
                -- we have enough fuel
                fuel_time = fuel_time + real_elapsed

                if cookable then
                    src_time = src_time + real_elapsed
                    if src_time >= cooked.time then
                        if inv:room_for_item("dst", cooked.item) then
                            inv:add_item("dst", cooked.item)
                            for i = 1, #after_cooked.items do
                                inv:set_stack("src", i, after_cooked.items[i])
                            end
                            src_time = src_time - cooked.time
                            update = true
                        else
                            dst_full = true
                        end

                        -- todo: play sound here
                    else
                        -- item couldn't be cooked, probably missing fuel?
                        update = true
                    end
                end
            else
                -- ran out of fuel
                if cookable then
                    local after_fuel
                    fuel, after_fuel = minetest.get_craft_result({
                        method = "fuel",
                        width = 1,
                        items = fuel_list
                    })

                    if fuel.time == 0 then
                        -- no valid fuel
                        fuel_total_time = 0
                        src_time = 0
                    else
                        local is_fuel = minetest.get_craft_result({
                            method = "fuel",
                            width = 1,
                            items = {
                                after_fuel.items[1]:to_string()
                            }
                        })

                        if is_fuel.time == 0 then
                            table.insert(fuel.replacements, after_fuel.items[1])
                            inv:set_stack("fuel", 1, "")
                        else
                            inv:set_stack("fuel", 1, after_fuel.items[1])
                        end

                        local replacements = fuel.replacements
                        if replacements[1] then
                            local leftover = inv:add_item("dst", replacements[1])
                            if not leftover:is_empty() then
                                local above = vector.new(pos.x, pos.y + 1, pos.z)
                                local drop_pos = minetest.find_node_near(above, 1, { "air" }) or above

                                minetest.item_drop(replacements[1], nil, drop_pos)
                            end
                        end
                        update = true
                        fuel_total_time = fuel.time + (fuel_total_time - fuel_time)
                    end
                else
                    -- nothing to cook, no need for fuel
                    fuel_total_time = 0
                    src_time = 0
                end

                fuel_time = 0
            end

            elapsed = elapsed - real_elapsed
        end

        if fuel and fuel_total_time > fuel.time then
            fuel_total_time = fuel.time
        end

        if src_list and src_list[1]:is_empty() then
            src_time = 0
        end

        local formspec
        local item_percent = 0

        if cookable then
            item_percent = math.floor(src_time / cooked.time * 100)
        end

        local result = false

        if fuel_total_time ~= 0 then
            local fuel_percent = 100 - math.floor(fuel_time / fuel_total_time * 100)
            formspec = generate_formspec(fuel_percent, item_percent)

            atl_core.swap_node_name(pos, inactive_name .. "_active")
            result = true

            -- todo: sounds?
        else
            formspec = generate_formspec(0, 0)

            atl_core.swap_node_name(pos, inactive_name)

            minetest.get_node_timer(pos):stop()
            meta:set_int("timer_elapsed", 0)
        end

        meta:set_float("fuel_total_time", fuel_total_time)
        meta:set_float("fuel_time", fuel_time)
        meta:set_float("src_time", src_time)
        meta:set_string("formspec", formspec)

        return result
    end

    local start_timer = function(pos)
        minetest.get_node_timer(pos):start(1.0)
    end

    local on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()

        inv:set_size("src", source_size)
        inv:set_size("fuel", 1)
        inv:set_size("dst", destination_size)

        timer(pos, 0)
    end

    inactive_def.on_metadata_inventory_move = start_timer
    inactive_def.on_metadata_inventory_put = start_timer
    inactive_def.on_metadata_inventory_take = start_timer
    inactive_def.on_construct = on_construct
    inactive_def.allow_metadata_inventory_put = can_put
    inactive_def.allow_metadata_inventory_move = can_move
    inactive_def.allow_metadata_inventory_take = can_take
    inactive_def.on_timer = timer

    minetest.register_node(inactive_name, inactive_def)

    active_def.on_metadata_inventory_move = start_timer
    active_def.on_metadata_inventory_put = start_timer
    active_def.on_metadata_inventory_take = start_timer
    active_def.on_construct = on_construct
    active_def.allow_metadata_inventory_put = can_put
    active_def.allow_metadata_inventory_move = can_move
    active_def.allow_metadata_inventory_take = can_take
    active_def.drop = inactive_name
    active_def.on_timer = timer

    minetest.register_node(inactive_name .. "_active", active_def)
end

atl_core.register_furnace("atl_core:stone_furnace", {
    description = "Furnace",
    tiles = {
        "atl_furnace_top.png", "atl_furnace_bottom.png",
        "atl_furnace_side.png", "atl_furnace_side.png",
        "atl_furnace_side.png", "atl_furnace_front.png"
    },
    paramtype2 = "facedir",
    groups = {
        cracky = 5
    },
    sounds = atl_core.node_sound_stone_defaults()
}, {
    description = "Furnace",
    tiles = {
        "atl_furnace_top.png", "atl_furnace_bottom.png",
        "atl_furnace_side.png", "atl_furnace_side.png",
        "atl_furnace_side.png", {
            image = "atl_furnace_front_active.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 1.5
            }
        }
    },
    paramtype2 = "facedir",
    groups = {
        cracky = 5,
        not_in_creative_inventory = 1
    },
    sounds = atl_core.node_sound_stone_defaults(),
    light_source = 8
}, 2, 4, "cooking", 1, 1)

minetest.register_craft({
    output = "atl_core:stone_furnace",
    recipe = {
        {
            "group:stone", "group:stone", "group:stone"
        },
        {
            "group:stone", "", "group:stone"
        },
        {
            "group:stone", "group:stone", "group:stone"
        }
    }
})