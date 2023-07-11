atl_weather = {}

local modpath = minetest.get_modpath("atl_weather")

dofile(modpath .. "/api.lua")
dofile(modpath .. "/weathers/clear.lua")
dofile(modpath .. "/weathers/rainy.lua")