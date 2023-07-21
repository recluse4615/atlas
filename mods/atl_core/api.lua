
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

atl_core.composite_cookables = {}

-- shorthand for creating cooking recipes, to keep a consistent cooking time
function atl_core.register_cookable(source, destination)
    if type(source) == "table" then
        table.insert(atl_core.composite_cookables, {
            recipe = source,
            output = destination,
            cooktime = 5.0
        })
    else
        minetest.register_craft({
            type = "cooking",
            output = destination,
            recipe = source,
            cooktime = 5.0
        })
    end
end

function atl_core.get_cookable(item_list)
    local cooked, after_cooked = minetest.get_craft_result({
        method = "cooking",
        width = #item_list,
        items = item_list
    })

    if cooked.item:is_empty() == true and #item_list > 1 then
        table.sort(item_list, function(a, b)
            return a:get_name() < b:get_name()
        end)

        local possible_cookables = {}

        -- loop through all composite cookables
        for _, cookable in ipairs(atl_core.composite_cookables) do
            local matches = true

            -- check every item matches
            for _, item_name in ipairs(cookable.recipe) do
                local item_matches = false
                for _, item_stack in ipairs(item_list) do
                    if item_stack:get_name() == item_name then
                        item_matches = true
                        break
                    end
                end

                if item_matches == false then
                    matches = false
                    break
                end
            end

            if matches == true then
                table.insert(possible_cookables, cookable)
            end
        end

        if #possible_cookables > 1 then
            -- sort by amount of items in the recipe, descending, so the first recipe is always the most complex
            table.sort(possible_cookables, function(a, b)
                return #a.recipe > #b.recipe
            end)
        end

        if #possible_cookables > 0 then
            local final_cookable = possible_cookables[1]

            -- todo: we can probably do this better, but just decrement _every_ item by one
            local decrement_items = {}
            for _, item_stack in ipairs(item_list) do
                local new_item = ItemStack(item_stack)
                new_item:set_count(new_item:get_count() - 1)

                table.insert(decrement_items, new_item)
            end

            return { item = ItemStack(final_cookable.output), time = final_cookable.cooktime }, { items = decrement_items }
        end

        -- return empty item, because we can't do anything
        return { item = ItemStack(""), time = 0 }, item_list
    end

    return cooked, after_cooked
end