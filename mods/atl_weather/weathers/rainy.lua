atl_weather.register_weather("rainy", {
    biomes = "all",
    min_duration = 40, --120
    max_duration = 80, --600
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
    sky = {
        day_sky = atl_weather.color(105, 110, 115),
        day_horizon = atl_weather.color(105, 110, 115),
        dawn_sky = atl_weather.color(93, 93, 95),
        dawn_horizon = atl_weather.color(110, 87, 102),
        night_sky = atl_weather.color(50, 41, 72),
        night_horizon = atl_weather.color(50, 41, 71),
        indoors = atl_weather.color(59, 59, 59),
        fog_sun_tint = atl_weather.color(38, 57, 101),
        fog_moon_tint = atl_weather.color(38, 57, 101)
    },
    soundtrack = {
        name = "atl_rain_light",
        gain = {
            adjustment = 0.1,
            min = 0.2
        },
        start_time = {
            min = 0,
            max = 1
        }
    },
    particle_spawners = function(player, is_indoors)
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
                16,
                -20
            ),
            maxpos = vector.new(
                20,
                24,
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

        particle_table[#particle_table + 1] = minetest.add_particlespawner({
            amount = 250,
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
                -25,
                16,
                -25
            ),
            maxpos = vector.new(
                25,
                24,
                25
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
            minsize = 6,
            maxsize = 6
        })

        return particle_table
    end
})