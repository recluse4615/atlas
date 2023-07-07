minetest.register_tool("atl_tools:pickaxe_wood", {
    description = "Wooden Pickaxe",
    inventory_image = "tool_handle.png^(pickaxe_head.png^[multiply:" .. atl_tools.tiers[1].colour .. ")",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            cracky = atl_tools.tiers[1].times.cracky
        }
    },
    groups = {
        pickaxe = 1,
        _atl_tier = 1,
        _atl_tool_type = atl_tools.types.PICKAXE
    }
})
minetest.register_craft({
    output = "atl_tools:pickaxe_wood",
    recipe = {
        {
            "group:wood_planks", "group:wood_planks", "group:wood_planks"
        },
        {
            "", "group:stick", ""
        },
        {
            "", "group:stick", ""
        }
    }
})

minetest.register_tool("atl_tools:pickaxe_stone", {
    description = "Stone Pickaxe",
    inventory_image = "tool_handle.png^(pickaxe_head.png^[multiply:" .. atl_tools.tiers[2].colour .. ")",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            cracky = atl_tools.tiers[2].times.cracky
        }
    },
    groups = {
        pickaxe = 1,
        _atl_tier = 2,
        _atl_tool_type = atl_tools.types.PICKAXE
    }
})
minetest.register_craft({
    output = "atl_tools:pickaxe_stone",
    recipe = {
        {
            "atl_core:cobble", "atl_core:cobble", "atl_core:cobble"
        },
        {
            "", "group:stick", ""
        },
        {
            "", "group:stick", ""
        }
    }
})

-- axe
minetest.register_tool("atl_tools:axe_wood", {
    description = "Wooden Axe",
    inventory_image = "tool_handle.png^(axe_head.png^[multiply:" .. atl_tools.tiers[1].colour .. ")",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            choppy = atl_tools.tiers[1].times.choppy
        }
    },
    groups = {
        axe = 1,
        _atl_tier = 1,
        _atl_tool_type = atl_tools.types.AXE
    }
})
minetest.register_craft({
    output = "atl_tools:axe_wood",
    recipe = {
        {
            "", "group:wood_planks", "group:wood_planks"
        },
        {
            "", "group:stick", "group:wood_planks"
        },
        {
            "", "group:stick", ""
        }
    }
})

minetest.register_tool("atl_tools:axe_stone", {
    description = "Stone Axe",
    inventory_image = "tool_handle.png^(axe_head.png^[multiply:" .. atl_tools.tiers[2].colour .. ")",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            choppy = atl_tools.tiers[2].times.choppy
        }
    },
    groups = {
        axe = 1,
        _atl_tier = 2,
        _atl_tool_type = atl_tools.types.AXE
    }
})
minetest.register_craft({
    output = "atl_tools:axe_stone",
    recipe = {
        {
            "", "atl_core:cobble", "atl_core:cobble"
        },
        {
            "", "group:stick", "atl_core:cobble"
        },
        {
            "", "group:stick", ""
        }
    }
})

-- shovel
minetest.register_tool("atl_tools:shovel_wood", {
    description = "Wooden Shovel",
    inventory_image = "tool_handle.png^(shovel_head.png^[multiply:" .. atl_tools.tiers[1].colour .. ")",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            crumbly = atl_tools.tiers[1].times.crumbly
        }
    },
    groups = {
        shovel = 1,
        _atl_tier = 1,
        _atl_tool_type = atl_tools.types.SHOVEL
    }
})
minetest.register_craft({
    output = "atl_tools:shovel_wood",
    recipe = {
        {
            "", "group:wood_planks", ""
        },
        {
            "", "group:stick", ""
        },
        {
            "", "group:stick", ""
        }
    }
})

minetest.register_tool("atl_tools:shovel_stone", {
    description = "Stone Shovel",
    inventory_image = "tool_handle.png^(shovel_head.png^[multiply:" .. atl_tools.tiers[2].colour .. ")",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            crumbly = atl_tools.tiers[2].times.crumbly
        }
    },
    groups = {
        shovel = 1,
        _atl_tier = 2,
        _atl_tool_type = atl_tools.types.SHOVEL
    }
})
minetest.register_craft({
    output = "atl_tools:shovel_stone",
    recipe = {
        {
            "", "atl_core:cobble", ""
        },
        {
            "", "group:stick", ""
        },
        {
            "", "group:stick", ""
        }
    }
})