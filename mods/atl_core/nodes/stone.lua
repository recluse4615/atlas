

local function register_node(name, props)
    -- add ui prop
    props["_atl_placeable"] = true
    minetest.register_node("atl_core:" .. name, props)
end

register_node("stone", {
    description = "Stone",
    tiles = {
        "atl_stone.png"
    },
    groups = {
        cracky = 5,
        stone = 1
    },
    drop = "atl_core:cobble",
    sounds = atl_core.node_sound_stone_defaults()
})

register_node("cobble", {
    description = "Cobblestone",
    tiles = {
        "atl_cobble.png"
    },
    is_ground_content = false,
    groups = {
        cracky = 5,
        stone = 1
    },
    sounds = atl_core.node_sound_stone_defaults()
})

-- todo move out of stone.lua lol

register_node("dirt", {
    description = "Dirt",
    tiles = {
        "atl_dirt.png"
    },
    groups = {
        crumbly = 5,
        soil = 1
    },
    sounds = atl_core.node_sound_dirt_defaults()
})

register_node("dirt_with_grass", {
    description = "Grass Block",
    tiles = {
        "atl_grass.png",
        "atl_dirt.png",
        {
            name = "atl_dirt.png^atl_grass_side.png",
            tileable_vertical = false
        }
    },
    groups = {
        crumbly = 5,
        soil = 1,
        spreading_dirt_type = 1
    },
    drop = "atl_core:dirt",
    sounds = atl_core.node_sound_dirt_defaults({}, {
        name = "default_grass_footstep",
        gain = 0.2
    })
})

register_node("sand", {
    description = "Sand",
    tiles = {
        "atl_sand.png"
    },
    groups = {
        crumbly = 5,
        falling_node = 1,
        sand = 1
    },
    sounds = atl_core.node_sound_sand_defaults()
})

register_node("gravel", {
    description = "Gravel",
    tiles = {
        "atl_gravel.png"
    },
    groups = {
        crumbly = 5,
        falling_node = 1
    },
})