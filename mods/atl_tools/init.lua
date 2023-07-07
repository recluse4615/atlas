atl_tools = {}

local modpath = minetest.get_modpath("atl_tools")
dofile(modpath .. "/tiers.lua")
dofile(modpath .. "/tools.lua")
dofile(modpath .. "/early_tools.lua")

minetest.register_node("atl_tools:workbench", {
    description = "Workbench",
    tiles = {
        "atl_workbench.png",
        "atl_cobble.png",
        "atl_cobble.png",
        "atl_cobble.png",
        "atl_cobble.png",
    },
    groups = {
        cracky = 5
    },
    drawtype = "nodebox",
    paramtype = "light",
    node_box = {
        type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, -0.375, 0.5, -0.375}, -- NodeBox1
			{-0.5, -0.5, 0.375, -0.375, 0.5, 0.5}, -- NodeBox2
			{0.375, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox3
			{0.375, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox4
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- top
		}
    },
    drop = "atl_tools:workbench"
})

minetest.register_craft({
    output = "atl_tools:workbench",
    recipe = {
        {
            "atl_core:cobble",
            "atl_core:cobble",
            "atl_core:cobble"
        },
        {
            "atl_core:cobble",
            "atl_core:cobble",
            "atl_core:cobble"
        },
        {
            "atl_core:cobble",
            "atl_core:cobble",
            "atl_core:cobble"
        }
    }
})