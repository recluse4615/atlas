local backend = {}
local use_sqlite = minetest.settings:get_bool("atl_economy.use_sqlite", false)
local starting_balance = minetest.settings:get("atl_economy.starting_balance") or 10

local modpath = minetest.get_modpath("atl_economy")

if use_sqlite then
    backend = dofile(modpath .. "/backend/sqlite.lua")
else
    backend = dofile(modpath .. "/backend/storage.lua")
end

local function add_history_record(sender_id, recipient_id, amount, memo)
    if backend.add_history(sender_id, recipient_id, amount, memo) then
        return true
    end

    return false
end

    -- economy_object should have: balance(<player or string reference>), transfer(<player or string reference sender>, <player or string reference receiver>, amount), set(<player or string reference>, amount)

lib_economy.register_economy("atl_economy", {
    balance = function(account_id)
        if not backend.has(account_id) then
            -- account needs to be created
            minetest.chat_send_all("starting account")
            backend.set(account_id, starting_balance)
        end

        return backend.get(account_id)
    end,
    transfer = function(sender_id, recipient_id, amount, memo)
        if add_history_record(sender_id, recipient_id, amount, memo) then
            backend.set(sender_id, backend.get(sender_id) - amount)
            backend.set(recipient_id, backend.get(recipient_id) + amount)
        end
    end,
    set = function(account_id, amount)
        backend.set(account_id, amount)
    end
})

minetest.register_on_joinplayer(function(player)
    minetest.chat_send_player(player:get_player_name(), "You have " .. lib_economy.current_economy:balance(player) .. " currency")

    lib_economy.current_economy:add(player, 5)
end)