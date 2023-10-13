-- this file will override almost all descriptions when items are registered
--[[
    atl_tools.types = {
    HANDLE = 10,
    BINDING = 20,
    -- continue from 100
    PICKAXE = 100,
    AXE = 110,
    SHOVEL = 120,
    HOE = 130,
    SWORD = 140,
    FISHING_ROD = 150
}
]]

local function get_tool_type(tool_type)
    for name, number in pairs(atl_tools.types) do
        if number == tool_type then
            local friendly_name = name:lower()
            friendly_name = friendly_name:gsub("%_", " ")
            return friendly_name
        end
    end
    return "item"
end

local function update_descriptions()
    for name, def in pairs(minetest.registered_tools) do
        local desc = def.description
        if def.groups._atl_tier ~= nil then
            desc = desc .. "\n" .. minetest.colorize("#333333", "tier " .. def.groups._atl_tier .. " " .. get_tool_type(def.groups._atl_tool_type))
        end
        minetest.override_item(name, { description = desc, _atl_original_description = def.description })
    end

    for name, def in pairs(minetest.registered_craftitems) do
        local desc = def.description
        if def.groups._atl_tier ~= nil then
            desc = desc .. "\n" .. minetest.colorize("#333333", "tier " .. def.groups._atl_tier .. " " .. get_tool_type(def.groups._atl_tool_type))
        end
        minetest.override_item(name, { description = desc, _atl_original_description = def.description })
    end
end

minetest.register_on_mods_loaded(update_descriptions)