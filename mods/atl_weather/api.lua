WEATHER_CHUNK_SIZE = 80
PARTICLES_HIGH_OFFSET = 64

atl_weather.registered_weathers = {}

function atl_weather.register_weather(weather_name, weather_definition)
    weather_definition.name = weather_name

    weather_definition.particle_spawners = weather_definition.particle_spawners or function(player, y_offset) return {} end
    weather_definition.toggle_particles = weather_definition.toggle_particles or false

    -- todo: default sky
    atl_weather.registered_weathers[weather_name] = weather_definition
end

-- internal funcs
-- map_cache is in the format of { weather_name = "xyz", duration = <time weather lasts for, in seconds>, time_spent = <time weather has been going, in seconds> }
local map_cache = {}

-- player_cache is in the format of { weather = "xyz", pos_hash = 123, last = { weather = "xyz", pos_hash = 123 }}
local player_cache = {}

local function _calculate_map_key(pos)
    local x = math.floor(pos.x / WEATHER_CHUNK_SIZE)
    local y = math.floor(pos.y / WEATHER_CHUNK_SIZE)
    local z = math.floor(pos.z / WEATHER_CHUNK_SIZE)

    return minetest.hash_node_position({x = x, y = y, z = z})
end

--[[local function _unpack_map_key(map_key)
    local y = (map_key >> 20) & 0x3FF
    local z = (map_key >> 10) & 0x3FF
    local x = (map_key) & 0x3FF

    return {
        x = x,
        y = y,
        z = z
    }
end
]]--

local function get_next_weather_by_biome(biome_name)
    local max_weight = 0
    local possible_weathers = {}

    for name, def in pairs(atl_weather.registered_weathers) do
        minetest.chat_send_all(name)
        if def.biomes == "all" then
            possible_weathers[name] = def
            max_weight = max_weight + def.weight
        else
            -- otherwise, we need to loop through all biomes
            for _, biome in ipairs(def.biomes) do
                if biome == biome_name then -- matched
                    possible_weathers[name] = def
                    max_weight = max_weight + def.weight
                    break
                end
            end
        end
    end

    if max_weight > 0 then
        local weight_number = math.random(2, max_weight) - 1

        for _, def in pairs(possible_weathers) do
            weight_number = weight_number - def.weight

            if weight_number <= 0 then
                return def
            end
        end
    end

    return atl_weather.registered_weathers.clear
end

local function get_map_weather_data(pos)
    local key = _calculate_map_key(pos)
    local cached_data = map_cache[key] or nil
    if cached_data == nil then
        -- generate the weather data, first we want to check the biome at the first generated position (not ideal, but it'll do for now)
        -- we then want to iterate through all 
        local biome_data = minetest.get_biome_data(pos)
        if biome_data ~= nil then
            local biome_name = minetest.get_biome_name(biome_data.biome)

            local next_weather = get_next_weather_by_biome(biome_name)

            cached_data = {
                weather_name = next_weather.name,
                duration = math.random(next_weather.min_duration, next_weather.max_duration),
                time_spent = 0,
                next_weather = ""
            }

            map_cache[key] = cached_data

            minetest.chat_send_all("playing weather " .. map_cache[key].weather_name .. " for " .. map_cache[key].duration)
        else
            -- huh, do we default here??
        end
    else
        -- get the next weather if it's applicable
        if cached_data.time_spent >= cached_data.duration and cached_data.next_weather ~= "" then
            local next_weather = atl_weather.registered_weathers[cached_data.next_weather]

            cached_data = {
                weather_name = next_weather.name,
                duration = math.random(next_weather.min_duration, next_weather.max_duration),
                time_spent = 0,
                next_weather = ""
            }

            map_cache[key] = cached_data
        end
    end
    return cached_data
end

local function set_map_weather_data(pos, weather_data)
    map_cache[_calculate_map_key(pos)] = weather_data
end

-- apply weather effects to the player, if needed
local function apply_weather_effects(player, weather_data)
    local weather = atl_weather.registered_weathers[weather_data.weather_name]
    weather.on_enter(player)
end

local function clear_particle_spawners(player_cache_data)
    for _, id in ipairs(player_cache_data.meta.particles) do
        minetest.delete_particlespawner(id)
    end

    player_cache_data.meta.particles = {}
    player_cache_data.meta.particles_applied = false
    return player_cache_data
end

local function tick_weather()
    -- first, tick duration for all active weathers
    for key, data in pairs(map_cache) do
        map_cache[key].time_spent = map_cache[key].time_spent + 2
        if map_cache[key].time_spent >= map_cache[key].duration then

            local weather_data = atl_weather.registered_weathers[map_cache[key].weather_name]

            -- if we have a next weather, then use that - otherwise, regenerate it completely
            if weather_data.next ~= nil and #weather_data.next >= 1 then
                map_cache[key].next_weather = weather_data.next[1]
                map_cache[key]._dirty = true
            else
                map_cache[key] = nil
            end
        end
    end

    -- loop through every player
    for _, player in ipairs(minetest.get_connected_players()) do

        local player_cache_data = player_cache[player:get_player_name()]
        local player_current_position = _calculate_map_key(player:get_pos())

        -- we've moved in to a different area
        -- if player_cache_data.pos_hash ~= player_current_position then
        local weather_data = get_map_weather_data(player:get_pos())

        -- the weather is different here!
        if weather_data.weather_name ~= player_cache_data.weather then

            if player_cache_data.weather ~= "" then
                local last_weather = atl_weather.registered_weathers[player_cache_data.weather]

                if last_weather.toggle_particles == true then
                    player_cache_data = clear_particle_spawners(player_cache_data)
                end

                last_weather.on_leave(player)
            end

            apply_weather_effects(player, weather_data)

            player_cache_data.last.weather = player_cache_data.weather
            player_cache_data.weather = weather_data.weather_name
        end

        -- todo: do we even need this lol
        if player_cache_data.pos_hash ~= player_current_position then
            player_cache_data.last.pos_hash = player_cache_data.pos_hash
            player_cache_data.pos_hash = player_current_position
        end

        -- toggle particle spawners
        local current_weather_definition = atl_weather.registered_weathers[player_cache_data.weather]
        local natural_light_level = minetest.get_natural_light(player:get_pos(), 0.5) or 0
        local is_indoors = (natural_light_level <= 8)

        if current_weather_definition.toggle_particles == true and (player_cache_data.meta.particles_applied == false or player_cache_data.meta.is_indoors ~= is_indoors) then

            minetest.chat_send_player(player:get_player_name(), "changing particle spawners, yipee")

            local y_offset = 0
            if is_indoors then
                y_offset = PARTICLES_HIGH_OFFSET
            end

            if player_cache_data.meta.is_indoors ~= is_indoors then
                player_cache_data = clear_particle_spawners(player_cache_data)
            end

            player_cache_data.meta.particles_applied = true
            player_cache_data.meta.particles = current_weather_definition.particle_spawners(player, y_offset)
        end


        player_cache[player:get_player_name()] = player_cache_data
    end

    minetest.after(2, tick_weather)
end

minetest.after(2, tick_weather)

minetest.register_on_joinplayer(function(player)
    local pos_hash = _calculate_map_key(player:get_pos())

    player_cache[player:get_player_name()] = {
        weather = "",
        pos_hash = pos_hash,
        last = {
            weather = "",
            pos_hash = pos_hash
        },
        meta = {
            particles = {
            },
            particles_applied = false,
            is_indoors = false
        }
    }

    apply_weather_effects(player, get_map_weather_data(player:get_pos()))
end)

minetest.register_on_leaveplayer(function(player)
    player_cache[player:get_player_name()] = nil
end)