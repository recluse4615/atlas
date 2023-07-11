atl_weather.register_weather("clear", {
    biomes = "all",
    min_duration = 4, --120
    max_duration = 8, --600
    weight = 50,
    --next = {
    --    "sunny2"
    --},
    on_enter = function(player)
        minetest.chat_send_player(player:get_player_name(), "it's clear")
    end,
    on_leave = function(player)
        minetest.chat_send_player(player:get_player_name(), "goodbye clear")
    end
})