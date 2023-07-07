function atl_core.register_torchlike(node_name, description, light_source, groups, floor_mesh, wall_mesh, ceiling_mesh, inventory_image, tile_image)
    
    groups.attached_node = 1
    groups.torch = 1

    -- default node
    minetest.register_node("atl_core:" .. node_name, {
        description = description,
        drawtype = "mesh",
        mesh = floor_mesh,
        inventory_image = inventory_image,
        wield_image = inventory_image,
        tiles = {
            {
                name = tile_image,
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 3.3
                }
            }
        },
        use_texture_alpha = "clip",
        paramtype = "light",
        paramtype2 = "wallmounted",
        sunlight_propagates = true,
        walkable = false,
        liquids_pointable = false,
        light_source = light_source,
        groups = groups,
        drop = "atl_core:" .. node_name,
        selection_box = {
            type = "wallmounted",
            wall_bottom = {
                -1/8, -1/2, -1/8, 1/8, 2/16, 1/8
            }
        },
        on_place = function(item_stack, placer, pointed_thing)
            local under = pointed_thing.under
            local node = minetest.get_node(under)
            local node_def = minetest.registered_nodes[node.name]
            if node_def and node_def.on_rightclick and not (placer and placer:is_player() and placer:get_player_control().sneak) then
                return node_def.on_rightclick(under, node, placer, item_stack, pointed_thing) or item_stack
            end

            local above = pointed_thing.above
            local wdir = minetest.dir_to_wallmounted(vector.subtract(under, above))
            local fake_stack = item_stack

            if wdir == 0 then
                fake_stack:set_name("atl_core:" .. node_name .. "_ceiling")
            elseif wdir == 1 then
                fake_stack:set_name("atl_core:" .. node_name)
            else
                fake_stack:set_name("atl_core:" .. node_name .. "_wall")
            end

            item_stack = minetest.item_place(fake_stack, placer, pointed_thing, wdir)
            item_stack:set_name("atl_core:" .. node_name)

            return item_stack
        end,
        floodable = true,
        -- on_flood = on_flood,
        on_rotate = false,
        _atl_placeable = true
    })

    groups.not_in_creative_inventory = 1

    -- wall node
    minetest.register_node("atl_core:" .. node_name .. "_wall", {
        drawtype = "mesh",
        mesh = wall_mesh,
        tiles = {
            {
                name = tile_image,
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 3.3
                }
            }
        },
        use_texture_alpha = "clip",
        paramtype = "light",
        paramtype2 = "wallmounted",
        sunlight_propagates = true,
        walkable = false,
        liquids_pointable = false,
        light_source = light_source,
        groups = groups,
        drop = "atl_core:" .. node_name,
        selection_box = {
            type = "wallmounted",
            wall_side = {
                -1/2, -1/2, -1/8, -1/8, 1/8, 1/8
            }
        },
        floodable = true,
        -- on_flood = on_flood,
        on_rotate = false
    })

    -- ceiling node
    minetest.register_node("atl_core:" .. node_name .. "_ceiling", {
        drawtype = "mesh",
        mesh = ceiling_mesh,
        tiles = {
            {
                name = tile_image,
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 3.3
                }
            }
        },
        use_texture_alpha = "clip",
        paramtype = "light",
        paramtype2 = "wallmounted",
        sunlight_propagates = true,
        walkable = false,
        liquids_pointable = false,
        light_source = light_source,
        groups = groups,
        drop = "atl_core:" .. node_name,
        selection_box = {
            type = "wallmounted",
            wall_top = {-1/8, -1/16, -5/16, 1/8, 1/2, 1/8},
        },
        floodable = true,
        -- on_flood = on_flood,
        on_rotate = false
    })
end
-- (node_name, description, light_source, groups, floor_mesh, wall_mesh, ceiling_mesh, inventory_image, tile_image
atl_core.register_torchlike("torch", "Torch", 12, {
    dig_immediate = 3
}, "torch_floor.obj", "torch_wall.obj", "torch_ceiling.obj", "atl_torch_on_floor.png", "atl_torch_on_floor_animated.png")

minetest.register_craft({
    output = "atl_core:torch 4",
    recipe = {
        {
            "atl_ores:coal_lump"
        },
        {
            "group:stick"
        }
    }
})