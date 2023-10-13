atl_rpg.register_skill("core:mining", {
    name = "Mining",
    description = "Your strength at using a pickaxe",
    max_level = 100,
    icon = "atl_rpg_icon_mining.png"
})

local function silly_loop()
    for _, player in ipairs(minetest.get_connected_players()) do
        minetest.chat_send_all("adding exp for " .. player:get_player_name())
        atl_rpg.add_experience(player, "core:mining", 1)
    end

    minetest.after(0.2, silly_loop)
end

minetest.after(0.2, silly_loop)