atl_core = {}

local modpath = minetest.get_modpath("atl_core")
dofile(modpath .. "/api.lua")
dofile(modpath .. "/descriptions.lua")

dofile(modpath .. "/sounds.lua")

dofile(modpath .. "/nodes/stone.lua")
dofile(modpath .. "/nodes/wood.lua")
dofile(modpath .. "/nodes/water.lua")
dofile(modpath .. "/nodes/torch.lua")

dofile(modpath .. "/nodes/furnace.lua")

dofile(modpath .. "/tools.lua")

dofile(modpath .. "/mapgen.lua")

minetest.register_on_joinplayer(function(player)
    player:set_lighting({
        shadows = {
            intensity = 0.33
        }
    })
end)

--[[minetest.register_node("atl_core:table",  {
    drawtype = "mesh",
    mesh = "table.obj",
    tiles = {
        "atl_oak_planks.png"
    },
    walkable = false,
    groups = {
        choppy = 5
    }
})

minetest.register_craft({
    output = "atl_core:table",
    recipe = {
        {
            "group:wood_planks", "group:wood_planks", "group:wood_planks"
        },
        {
            "group:wood_planks", "", "group:wood_planks"
        },
        {
            "group:wood_planks", "", "group:wood_planks"
        }
    }
})]]--