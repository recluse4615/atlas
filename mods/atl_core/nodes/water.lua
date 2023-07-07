local function register_node(name, props)
    -- add ui prop
    props["_atl_placeable"] = false
    minetest.register_node("atl_core:" .. name, props)
end

register_node("water_source", {
    description = "Water Source",
    drawtype = "liquid",
    waving = 3,
    tiles = {
        {
            name = "atl_water_source_animated.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0
            }
        },
        {
            name = "atl_water_source_animated.png",
            backface_culling = true,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0
            }
        }
    },
    use_texture_alpha = "blend",
    paramtype = "light",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "source",
    liquid_alternative_flowing = "atl_core:water_flowing",
    liquid_alternative_source = "atl_core:water_source",
    liquid_viscosity = 1,
    post_effect_color = {
        a = 103,
        r = 30,
        g = 60,
        b = 90
    },
    groups = {
        water = 3,
        liquid = 3,
        cools_lava = 1
    }
})

register_node("water_flowing", {
    description = "Flowing Water",
    drawtype = "flowingliquid",
    waving = 3,
    tiles = {
        "atl_water.png"
    },
    special_tiles = {
        {
            name = "atl_water_flowing_animated.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0
            }
        },
        {
            name = "atl_water_flowing_animated.png",
            backface_culling = true,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0
            }
        },
    },
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "flowingliquid",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "flowing",
    liquid_alternative_flowing = "atl_core:water_flowing",
    liquid_alternative_source = "atl_core:water_source",
    liquid_viscosity = 1,
    post_effect_color = {
        a = 103,
        r = 30,
        g = 60,
        b = 90
    },
    groups = {
        water = 3,
        liquid = 3,
        not_in_creative_inventory = 1,
        cools_lava = 1
    }
})