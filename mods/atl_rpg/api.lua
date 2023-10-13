
atl_rpg.skills = {}

local backend = dofile(minetest.get_modpath("atl_rpg") .. "/backend/storage.lua")

local batch_time = minetest.settings:get("atl_rpg.batch_time") or 1

local function get_default_xp_curve(max_level)
    local level_to_xp = function(level) return (1.5 * math.ceil(level / 50)) * ((level * level) + (100 * level) + 40) end

    -- xp needed = (1.5 * ceil(level / 50)) * ((level)^2 + 100*(level) + 40)
    return {
        -- returns the amount of experience needed for a level
        level_to_xp = level_to_xp,
        -- returns the level for a given amount of exp
        xp_to_level = function(experience)
            -- avoid a max_level sized for loop by checking specifically for max level
            if level_to_xp(max_level) < experience then
                return max_level
            end

            for i = 1, max_level do
                local experience_needed = level_to_xp(i)
                if experience_needed > experience then
                    return (i - 1)
                end
            end

            return max_level
        end
    } 
end

local function on_player_level_up(player, skill_name, new_level, old_level)
    -- do any default stuff here
end

-- ui stuff
local skills_ui_tracking = {}
local hud_backend = dofile(minetest.get_modpath("atl_rpg") .. "/hud.lua")

local function get_player_name(player_reference)
    -- assuming it's either a player name or internal id
    if type(player_reference) == "string" then
        return player_reference
    end

    return player_reference:get_player_name()
end

local function gains_ui_tick(player, skill_name, experience)
    local all_skills_data = skills_ui_tracking[get_player_name(player)] or {}
    local current_skill_data = all_skills_data[skill_name] or nil
    if current_skill_data == nil then
        current_skill_data = {
            experience = 0,
            time_spent = 0
        }
    end

    current_skill_data.experience = current_skill_data.experience + experience
    current_skill_data.time_spent = 0

    skills_ui_tracking[get_player_name(player)][skill_name] = current_skill_data

    skills_ui_tracking[get_player_name(player)].last_skill = skill_name
end

local function tick_all_ui()
    for player_name, ui_data in pairs(skills_ui_tracking) do
        local skill_to_display = ui_data.last_skill or nil

        if skill_to_display ~= nil then
            hud_backend.set_main_skill(minetest.get_player_by_name(player_name), ui_data.last_skill)
        end
    end
    minetest.after(batch_time, tick_all_ui)
end

minetest.after(batch_time, tick_all_ui)

minetest.register_on_joinplayer(function(player)
    skills_ui_tracking[player:get_player_name()] = {}
end)

minetest.register_on_leaveplayer(function(player)
    skills_ui_tracking[player:get_player_name()] = {}
end)

function atl_rpg.register_skill(skill_name, skill_definition)
    local default_xp_curve = get_default_xp_curve(skill_definition.max_level)

    skill_definition.xp_to_level = skill_definition.xp_to_level or default_xp_curve.xp_to_level
    skill_definition.level_to_xp = skill_definition.level_to_xp or default_xp_curve.level_to_xp
    skill_definition.on_level_up = skill_definition.on_level_up or function(player, new_level, old_level) end

    atl_rpg.skills[skill_name] = skill_definition
end

function atl_rpg.get_skill(skill_name)
    return atl_rpg.skills[skill_name]
end

function atl_rpg.get_experience(player, skill_name)
    return backend.get_exp(player, skill_name)
end

function atl_rpg.get_level(player, skill_name)
    local skill_definition = atl_rpg.get_skill(skill_name)
    return skill_definition.xp_to_level(atl_rpg.get_experience(player, skill_name))
end

function atl_rpg.get_player_experience_multiplier(player, skill_name)
    local skill_definition = atl_rpg.get_skill(skill_name)
    return skill_definition.get_experience_multiplier(player)
end

function atl_rpg.add_experience(player, skill_name, experience)
    local current_level = atl_rpg.get_level(player, skill_name)
    local current_experience = atl_rpg.get_experience(player, skill_name)
    local skill_definition = atl_rpg.get_skill(skill_name)

    local new_experience = current_experience + experience
    local new_level = skill_definition.xp_to_level(new_experience)
    if current_level < skill_definition.max_level and new_level > current_level then
        on_player_level_up(player, skill_name, new_level, current_level)
        skill_definition.on_level_up(player, new_level, current_level)
    end

    gains_ui_tick(player, skill_name, experience)

    backend.set_exp(player, skill_name, new_experience)
end