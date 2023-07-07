atl_core = {}

local modpath = minetest.get_modpath("atl_core")
dofile(modpath .. "/api.lua")
dofile(modpath .. "/descriptions.lua")

dofile(modpath .. "/sounds.lua")

dofile(modpath .. "/nodes/stone.lua")
dofile(modpath .. "/nodes/wood.lua")
dofile(modpath .. "/nodes/water.lua")
dofile(modpath .. "/nodes/torch.lua")

dofile(modpath .. "/tools.lua")

dofile(modpath .. "/mapgen.lua")

minetest.register_on_joinplayer(function(player)
    player:set_lighting({
        shadows = {
            intensity = 0.33
        }
    })
end)