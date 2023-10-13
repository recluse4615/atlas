atl_tools.types = {
    HANDLE = 10,
    BINDING = 20,
    PICKAXE_HEAD = 30,
    AXE_HEAD = 40,
    SHOVEL_HEAD = 50,
    GEMSTONE = 60,
    -- continue from 200
    PICKAXE = 200,
    AXE = 210,
    SHOVEL = 220,
    HOE = 230,
    SWORD = 240,
    FISHING_ROD = 250
}

local function friendly_name(name)
    return name:sub(1, 1):upper() .. name:sub(2)
end

for _, tier in ipairs(atl_tools.tiers) do
    if tier.constructable then
        local name = friendly_name(tier.name)
        -- create all the basic craftitems
        minetest.register_craftitem("atl_tools:" .. tier.name .. "_pickaxe_head", {
            description = name .. " Pickaxe Head",
            inventory_image = "pickaxe_head.png^[multiply:" .. tier.colour,
            groups = {
                _atl_tier = tier.tier,
                _atl_tool_type = atl_tools.types.PICKAXE
            }
        })
        minetest.register_craft({
            output = "atl_tools:" .. tier.name .. "_pickaxe_head",
            recipe = {
                {
                    tier.material, tier.material, ""
                },
                {
                    "", tier.material, tier.material
                },
                {
                    "", "", tier.material
                }
            }
        })

        minetest.register_craftitem("atl_tools:" .. tier.name .. "_axe_head", {
            description = name .. " Axe Head",
            inventory_image = "axe_head.png^[multiply:" .. tier.colour,
            groups = {
                _atl_tier = tier.tier,
                _atl_tool_type = atl_tools.types.AXE
            }
        })
        minetest.register_craft({
            output = "atl_tools:" .. tier.name .. "_axe_head",
            recipe = {
                {
                    "", tier.material, tier.material
                },
                {
                    "", "", tier.material
                },
                {
                    "", "", tier.material
                }
            }
        })

        minetest.register_craftitem("atl_tools:" .. tier.name .. "_shovel_head", {
            description = name .. " Shovel Head",
            inventory_image = "shovel_head.png^[multiply:" .. tier.colour,
            groups = {
                _atl_tier = tier.tier,
                _atl_tool_type = atl_tools.types.SHOVEL
            }
        })
        minetest.register_craft({
            output = "atl_tools:" .. tier.name .. "_shovel_head",
            recipe = {
                {
                    "", tier.material, tier.material
                },
                {
                    "", "", tier.material
                }
            }
        })

        -- temp recipes for crafting the tools themselves
        minetest.register_tool("atl_tools:pickaxe_" .. tier.name, {
            description = name .. " Pickaxe",
            inventory_image = "tool_handle.png^(pickaxe_head.png^[multiply:" .. tier.colour .. ")",
            tool_capabilities = {
                full_punch_interval = 1.0,
                max_drop_level = 1,
                groupcaps = {
                    cracky = tier.times.cracky
                }
            },
            groups = {
                pickaxe = 1,
                _atl_tier = tier.tier,
                _atl_tool_type = atl_tools.types.PICKAXE
            }
        })
        minetest.register_craft({
            output = "atl_tools:pickaxe_" .. tier.name,
            recipe = {
                {
                    "atl_tools:" .. tier.name .. "_pickaxe_head"
                },
                {
                    "atl_core:stick"
                },
                {
                    "atl_core:stick"
                }
            }
        })

        minetest.register_tool("atl_tools:axe_" .. tier.name, {
            description = name .. " Axe",
            inventory_image = "tool_handle.png^(axe_head.png^[multiply:" .. tier.colour .. ")",
            tool_capabilities = {
                full_punch_interval = 1.0,
                max_drop_level = 1,
                groupcaps = {
                    choppy = tier.times.choppy
                }
            },
            groups = {
                axe = 1,
                _atl_tier = tier.tier,
                _atl_tool_type = atl_tools.types.AXE
            }
        })
        minetest.register_craft({
            output = "atl_tools:axe_" .. tier.name,
            recipe = {
                {
                    "atl_tools:" .. tier.name .. "_axe_head"
                },
                {
                    "atl_core:stick"
                },
                {
                    "atl_core:stick"
                }
            }
        })

        minetest.register_tool("atl_tools:shovel_" .. tier.name, {
            description = name .. " Shovel",
            inventory_image = "tool_handle.png^(shovel_head.png^[multiply:" .. tier.colour .. ")",
            tool_capabilities = {
                full_punch_interval = 1.0,
                max_drop_level = 1,
                groupcaps = {
                    crumbly = tier.times.crumbly
                }
            },
            groups = {
                shovel = 1,
                _atl_tier = tier.tier,
                _atl_tool_type = atl_tools.types.SHOVEL
            }
        })
        minetest.register_craft({
            output = "atl_tools:shovel_" .. tier.name,
            recipe = {
                {
                    "atl_tools:" .. tier.name .. "_shovel_head"
                },
                {
                    "atl_core:stick"
                },
                {
                    "atl_core:stick"
                }
            }
        })
    end
end