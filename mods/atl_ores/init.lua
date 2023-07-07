atl_ores = {}

atl_ores.ores = {
    {
        name = "tin",
        colour = "#F2F0E5",
        group_level = 4,
        type = "ore",
        layers = {
            {
                clust_scarcity = 24 * 24 * 24,
                clust_num_ores = 2,
                clust_size = 3,
                y_min = -32,
                y_max = -256
            },
            {
                clust_scarcity = 16 * 16 * 16,
                clust_num_ores = 4,
                clust_size = 3,
                y_min = -64,
                y_max = -256
            },
            {
                clust_scarcity = 32 * 32 * 32,
                clust_num_ores = 2,
                clust_size = 3,
                y_min = -256,
                y_max = -2048
            }
        }
    },
    {
        name = "copper",
        colour = "#A77B5B",
        group_level = 4,
        type = "ore",
        layers = {
            {
                clust_scarcity = 24 * 24 * 24,
                clust_num_ores = 2,
                clust_size = 3,
                y_min = -32,
                y_max = -256
            },
            {
                clust_scarcity = 16 * 16 * 16,
                clust_num_ores = 4,
                clust_size = 3,
                y_min = -64,
                y_max = -256
            },
            {
                clust_scarcity = 32 * 32 * 32,
                clust_num_ores = 2,
                clust_size = 3,
                y_min = -256,
                y_max = -2048
            }
        }
    },
    {
        name = "bronze",
        colour = "#D3A068",
        group_level = 3,
        type = "composite"
    },
    {
        name = "iron",
        colour = "#B8B5B9",
        group_level = 3,
        type = "ore",
        layers = {
            {
                clust_scarcity = 24 * 24 * 24,
                clust_num_ores = 2,
                clust_size = 3,
                y_min = -64,
                y_max = -512
            },
            {
                clust_scarcity = 16 * 16 * 16,
                clust_num_ores = 4,
                clust_size = 3,
                y_min = -128,
                y_max = -512
            },
            {
                clust_scarcity = 32 * 32 * 32,
                clust_num_ores = 2,
                clust_size = 3,
                y_min = -512,
                y_max = -2048
            }
        }
    },
    {
        name = "gold",
        colour = "#FBD949", -- todo: replace
        group_level = 3,
        type = "ore",
        layers = {
            {
                clust_scarcity = 24 * 24 * 24,
                clust_num_ores = 2,
                clust_size = 3,
                y_min = -64,
                y_max = -512
            },
            {
                clust_scarcity = 16 * 16 * 16,
                clust_num_ores = 4,
                clust_size = 3,
                y_min = -128,
                y_max = -512
            },
            {
                clust_scarcity = 32 * 32 * 32,
                clust_num_ores = 2,
                clust_size = 3,
                y_min = -512,
                y_max = -2048
            }
        }
    },
    {
        name = "corinthite",
        colour = "#EDE193",
        group_level = 2,
        type = "composite"
    },
    {
        name = "steel",
        colour = "#45444F",
        group_level = 1,
        type = "composite"
    }
}

atl_ores.minerals = {
    {
        name = "coal",
        colour = "#212123",
        group_level = 5,
        type = "mineral",
        layers = {
            {
                clust_scarcity = 12 * 12 * 12,
                clust_num_ores = 4,
                clust_size = 3,
                y_min = 1024,
                y_max = -64
            },
            {
                clust_scarcity = 8 * 8 * 8,
                clust_num_ores = 16,
                clust_size = 5,
                y_min = -64,
                y_max = -512
            },
            {
                clust_scarcity = 8 * 8 * 8,
                clust_num_ores = 8,
                clust_size = 5,
                y_min = -512,
                y_max = -2048
            }
        }
    },
    {
        name = "tigers_eye",
        colour = "#F49430",
        group_level = 4,
        type = "crystal",
        layers = {
            {
                clust_scarcity = 16 * 16 * 16,
                clust_num_ores = 1,
                clust_size = 2,
                y_min = 1024,
                y_max = -64
            },
            {
                clust_scarcity = 12 * 12 * 12,
                clust_num_ores = 2,
                clust_size = 5,
                y_min = -64,
                y_max = -512
            },
            {
                clust_scarcity = 16 * 16 * 16,
                clust_num_ores = 2,
                clust_size = 5,
                y_min = -512,
                y_max = -2048
            }
        }
    },
    {
        name = "jade",
        colour = "#3CA554",
        group_level = 4,
        type = "crystal",
        layers = {
            {
                clust_scarcity = 16 * 16 * 16,
                clust_num_ores = 1,
                clust_size = 2,
                y_min = 1024,
                y_max = -64
            },
            {
                clust_scarcity = 12 * 12 * 12,
                clust_num_ores = 2,
                clust_size = 5,
                y_min = -64,
                y_max = -512
            },
            {
                clust_scarcity = 16 * 16 * 16,
                clust_num_ores = 2,
                clust_size = 5,
                y_min = -512,
                y_max = -2048
            }
        }
    }
}

local function friendly_name(name)
    return name:sub(1, 1):upper() .. name:sub(2)
end

local function register_node(name, props)
    -- add ui prop
    props["_atl_placeable"] = true
    minetest.register_node("atl_ores:" .. name, props)
end

for _, ore in ipairs(atl_ores.ores) do
    local name = friendly_name(ore.name)

    -- create ingot
    minetest.register_craftitem("atl_ores:" .. ore.name .. "_ingot", {
        description = name .. " Ingot",
        inventory_image = "atl_ingot.png^[multiply:" .. ore.colour
    })

    -- register regular stone variant
    if ore.type == "ore" then
        register_node(ore.name .. "_stone_ore", {
            description = name .. " Ore",
            tiles = {
                "atl_stone.png^(atl_ore.png^[multiply:" .. ore.colour .. ")"
            },
            groups = {
                cracky = ore.group_level
            },
            drop = "atl_ores:" .. ore.name .. "_lump"
        })

        -- create lump
        minetest.register_craftitem("atl_ores:" .. ore.name .. "_lump", {
            description = "Raw " .. name,
            inventory_image = "atl_lump.png^[multiply:" .. ore.colour,
            groups = {
                smeltable = 1
            }
        })

        -- temp: craft lumps -> ingot
        minetest.register_craft({
            output = "atl_ores:" .. ore.name .. "_ingot",
            recipe = {
                {
                    "atl_ores:" .. ore.name .. "_lump"
                }
            }
        })
        for _, layer in ipairs(ore.layers) do
            
            minetest.register_ore({
                ore_type = "scatter",
                ore = "atl_ores:" .. ore.name .. "_stone_ore",
                wherein = "atl_core:stone",
                clust_scarcity = layer.clust_scarcity,
                clust_num_ores = layer.clust_num_ores,
                clust_size = layer.clust_size,
                y_max = layer.y_min,
                y_min = layer.y_max
            })
        end
    end
end

for _, mineral in ipairs(atl_ores.minerals) do
    local name = friendly_name(mineral.name)

    local layered_texture = "atl_mineral.png"
    if mineral.type == "crystal" then
        layered_texture = "atl_crystal.png"
    end

    register_node(mineral.name .. "_stone_ore", {
        description = name .. " Ore",
        tiles = {
            "atl_stone.png^(" .. layered_texture .. "^[multiply:" .. mineral.colour .. ")"
        },
        groups = {
            cracky = mineral.group_level
        },
        drop = "atl_ores:" .. mineral.name .. "_lump"
    })

    -- create lump
    minetest.register_craftitem("atl_ores:" .. mineral.name .. "_lump", {
        description = name,
        inventory_image = "atl_lump.png^[multiply:" .. mineral.colour
    })

    for _, layer in ipairs(mineral.layers) do
        minetest.register_ore({
            ore_type = "scatter",
            ore = "atl_ores:" .. mineral.name .. "_stone_ore",
            wherein = "atl_core:stone",
            clust_scarcity = layer.clust_scarcity,
            clust_num_ores = layer.clust_num_ores,
            clust_size = layer.clust_size,
            y_max = layer.y_min,
            y_min = layer.y_max
        })
    end
end