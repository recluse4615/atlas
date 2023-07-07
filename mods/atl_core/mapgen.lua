

minetest.register_alias("mapgen_stone", "atl_core:stone")
minetest.register_alias("mapgen_water_source", "atl_core:water_source")
minetest.register_alias("mapgen_river_water_source", "atl_core:water_source")

minetest.clear_registered_biomes()
--minetest.clear_registered_ores()
minetest.clear_registered_decorations()

minetest.register_biome({
    name = "grassland",
    node_top = "atl_core:dirt_with_grass",
    depth_top = 1,
    node_filler = "atl_core:dirt",
    depth_filler = 3,

    node_riverbed = "atl_core:sand",
    depth_riverbed = 2,

    y_max = 31000,
    y_min = 6,
    heat_point = 50,
    humidity_point = 35
})

minetest.register_biome({
    name = "grassland_ocean",
    node_top = "atl_core:sand",
    depth_top = 1,
    node_filler = "atl_core:sand",
    depth_filler = 3,
    node_riverbed = "atl_core:gravel",
    depth_riverbed = 2,
    node_cave_liquid = "atl_core:water_source",
    y_max = 6,
    y_min = -255,
    heat_point = 50,
    humidity_point = 35
})


minetest.register_decoration({
    name = "atl_core:oak_tree_1",
    deco_type = "schematic",
    place_on = {
        "atl_core:dirt_with_grass"
    },
    sidelen = 16,
    noise_params = {
        offset = 0.002,
        scale = 0.0004,
        spread = {
            x = 250,
            y = 250,
            z = 250
        },
        seed = 2,
        octaves = 3,
        persist = 0.66
    },
    biomes = {
        "grassland"
    },
    y_max = 31000,
    y_min = 12,
    schematic = minetest.get_modpath("atl_core") .. "/schematics/oak_tree_1.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random"
})

minetest.register_decoration({
    name = "atl_core:oak_tree_2",
    deco_type = "schematic",
    place_on = {
        "atl_core:dirt_with_grass"
    },
    sidelen = 16,
    noise_params = {
        offset = 0.0035,
        scale = 0.0004,
        spread = {
            x = 250,
            y = 250,
            z = 250
        },
        seed = 4,
        octaves = 3,
        persist = 0.66
    },
    biomes = {
        "grassland"
    },
    y_max = 31000,
    y_min = 12,
    schematic = minetest.get_modpath("atl_core") .. "/schematics/oak_tree_2.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random"
})

minetest.register_decoration({
    name = "atl_core:oak_tree_3",
    deco_type = "schematic",
    place_on = {
        "atl_core:dirt_with_grass"
    },
    sidelen = 16,
    noise_params = {
        offset = 0.0005,
        scale = 0.0004,
        spread = {
            x = 250,
            y = 250,
            z = 250
        },
        seed = 4,
        octaves = 3,
        persist = 0.66
    },
    biomes = {
        "grassland"
    },
    y_max = 1024,
    y_min = 12,
    schematic = minetest.get_modpath("atl_core") .. "/schematics/oak_tree_3.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random"
})

local dbuf
local path_noise = {
	offset = 0,
	scale = 1,
	spread = {x = 1024, y = 1024, z = 1024},
	seed = 11711,
	octaves = 3,
	persist = 0.4
}
--[[{
	offset = 100.0,
    scale = -30000.0,
    spread = {
        x = 256,
        y = 256,
        z = 256
    },
    seed = 513337,
    octaves = 1,
    persist = 0.5,
    flags = "defaults, absvalue"
}]]--

local c_air = minetest.CONTENT_AIR
local c_stone = minetest.get_content_id("atl_core:stone")

local chunk_size_in_nodes = minetest.setting_get("chunksize") * 16

--[[minetest.register_on_generated(function(minp, maxp, blockseed)
    if minp.y > 0 or maxp.y < 0 then
        return
    end

    local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
    local area = VoxelArea:new({
        MinEdge = emin,
        MaxEdge = emax
    })
    local data = vm:get_data(dbuf)

    -- why do we need to add 1 here? maxp - minp is always 79?
    local noise_map = minetest.get_perlin_map(path_noise, {
        x = math.abs(maxp.x - minp.x) + 1,
        y = math.abs(maxp.z - minp.z) + 1 -- use a 2d map, with z as y
    }):get_2d_map({
        x = minp.x,
        y = minp.z
    })

    local heightmap = minetest.get_mapgen_object("heightmap")

    -- minetest.chat_send_all(#heightmap)

    for z = minp.z, maxp.z do
        for x = minp.x, maxp.x do
            local local_z = (z - minp.z) + 1
            local local_x = (x - minp.x) + 1

            local idx = local_x + ((local_z - 1) * chunk_size_in_nodes)
            local height_value = heightmap[idx]

            -- skip if the chunk we're generating right now doesn't contain the height value + 1
            local height_test = height_value + 1
            if height_test >= minp.y and height_test <= maxp.y then

                local vm_index = area:index(x, height_value + 1, z)
                -- data[vm_index] = c_stone

                -- minetest.chat_send_all("x: " .. local_x .. " z: " .. local_z)

                local noise_val = noise_map[local_x][local_z]
                -- minetest.chat_send_all(#noise_map[local_x])
                if noise_val >= 0.07 then
                    minetest.chat_send_all("x: " .. x .. " y: " .. height_test .. " z: " .. z)
                    -- local height_value = heightmap[local_x + (local_z * chunk_size_in_nodes)]
                    -- minetest.chat_send_all("x: " .. x .. ", z: " .. z .. ", height: " .. height_value)
                    data[vm_index] = c_stone
                end
            end
        end
    end

    vm:set_data(data)
    vm:calc_lighting()
    vm:write_to_map(data)
end)]]--