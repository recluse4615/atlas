local default_economy = false
local current_name = ""

lib_economy.economies = {}
lib_economy.current_economy = {}

function lib_economy.register_economy(economy_name, economy_object)
    local proxy = EconomyProxy:create(economy_object)
    lib_economy.economies[economy_name] = proxy

    -- set default economy to whatever loads first (as well as current economy)
    if not default_economy then
        default_economy = proxy
        lib_economy.current_economy = default_economy
    end

    local selected_economy = minetest.settings:get("lib_economy.selected_economy") or ""
    if economy_name == selected_economy then
        lib_economy.current_economy = proxy
    end
end

function lib_economy.get_economy(economy_name)
    return lib_economy.economies[economy_name]
end