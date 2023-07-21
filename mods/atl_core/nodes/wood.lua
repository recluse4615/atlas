local function register_node(name, props)
    -- add ui prop
    props["_atl_placeable"] = true
    minetest.register_node("atl_core:" .. name, props)
end

local wood_types = {
    "oak"
}

local function friendly_name(name)
    return name:sub(1, 1):upper() .. name:sub(2)
end

for _, wood_type in ipairs(wood_types) do
    local name = friendly_name(wood_type)

    -- register log
    register_node(wood_type .. "_log", {
        description = name .. " Log",
        tiles = {
            "atl_" .. wood_type .. "_log.png",
            "atl_" .. wood_type .. "_log.png",
            "atl_" .. wood_type .. "_log_side.png",
        },
        paramtype2 = "facedir",
        is_ground_content = false,
        groups = {
            choppy = 5,
            oddly_breakable_by_hand = 1,
            flammable = 2,
            log = 1
        },
        sounds = atl_core.node_sound_wood_defaults(),
        on_place = minetest.rotate_node
    })

    register_node(wood_type .. "_planks", {
        description = name .. " Planks",
        tiles = {
            "atl_" .. wood_type .. "_planks.png"
        },
        paramtype2 = "facedir",
        place_param2 = 0,
        is_ground_content = false,
        groups = {
            choppy = 5,
            oddly_breakable_by_hand = 2,
            flammable = 2,
            wood = 1,
            wood_planks = 1
        },
        sounds = atl_core.node_sound_wood_defaults()
    })

    minetest.register_craft({
        output = "atl_core:" .. wood_type .. "_planks 4",
        recipe = {
            {
                "atl_core:" .. wood_type .. "_log"
            }
        }
    })

    register_node(wood_type .. "_leaves", {
        description = name .. " Leaves",
        tiles = {
            "atl_" .. wood_type .. "_leaves.png"
        },
        special_tiles = {
            "atl_" .. wood_type .. "_leaves_simple.png"
        },
        drawtype = "allfaces_optional",
        waving = 1,
        paramtype = "light",
        is_ground_content = false,
        groups = {
            oddly_breakable_by_hand = 3,
            leafdecay = 3,
            flammable = 2,
            leaves = 1,
        },
        sounds = atl_core.node_sound_leaves_defaults()
    })
end

minetest.register_craftitem("atl_core:stick", {
    description = "Stick",
    inventory_image = "atl_stick.png",
    groups = {
        stick = 1,
        flammable = 2
    }
})

minetest.register_craft({
    output = "atl_core:stick 4",
    recipe = {
        {
            "group:wood_planks"
        },
        {
            "group:wood_planks"
        }
    }
})

minetest.register_craft({
    type = "fuel",
    recipe = "group:wood_planks",
    burntime = 2
})

minetest.register_craft({
    type = "fuel",
    recipe = "group:log",
    burntime = 8
})

minetest.register_craft({
    type = "fuel",
    recipe = "atl_core:stick",
    burntime = 1
})