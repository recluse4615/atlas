atl_weather.register_weather("rainy", {
    biomes = "all",
    min_duration = 4, --120
    max_duration = 8, --600
    weight = 100,
    --next = {
    --    "sunny2"
    --},
    on_enter = function(player)
        minetest.chat_send_player(player:get_player_name(), "it's rainy")
    end,
    on_leave = function(player)
        minetest.chat_send_player(player:get_player_name(), "goodbye rainy")
    end,
    toggle_particles = true,
    particle_spawners = function(player, y_offset)
        minetest.chat_send_player(player:get_player_name(), "applying particles")
        local particle_table = {}

        particle_table[#particle_table + 1] = minetest.add_particlespawner({
            amount = 200,
            time = 0,
            collisiondetection = true,
            collision_removal = true,
            object_collision = false,
            attached = player,
            vertical = true,
            texture = "atl_weather_rain.png",
            playername = player:get_player_name(),
            glow = 0,
            minpos = vector.new(
                -20,
                16 + y_offset,
                -20
            ),
            maxpos = vector.new(
                20,
                24 + y_offset,
                20
            ),
            minvel = vector.new(-1, -20, -1),
            maxvel = vector.new(1, -10, 1),
            minacc = {
                x = 0,
                y = 0,
                z = 0
            },
            maxacc = {
                x = 0,
                y = 0,
                z = 0
            },
            minexptime = 3,
            maxexptime = 6,
            minsize = 4,
            maxsize = 4
        })

        return particle_table
    end
})