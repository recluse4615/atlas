# lib_economy

lib_economy is a core library, primarily for third party integration. it's designed to give mod developers the flexibility in economies. oftentimes, you don't need to know _where_ the money is coming from, just that the money is coming from _somewhere_.

## usage api

to use the api as a developer, you simply need to use `lib_economy.current_economy`:

```lua
local econ = lib_economy.current_economy

local player = minetest.get_player_by_name("recluse4615")

-- display currency
local player_balance = econ:balance(player)
minetest.chat_send_player(player, "You have " .. player_balance .. " currency")

-- check if the player has more than 10 currency
if econ:has(player, 10) then
    minetest.chat_send_player(player, "You have at least 10 currency")
end

-- add 5 currency to the player
if econ:add(player, 5) then
    minetest.chat_send_player(player, "You have been gifted 5 currency. New amount: " .. econ:balance(player))
end

-- transfer 10 currency from "recluse4615" to "admin" with the memo "living tax"
if econ:transfer(player, minetest.get_player_by_name("admin"), 10, "living tax") then
    minetest.chat_send_player(player, "You have sent 10 currency to the admin as a living tax.")
end

-- remove 5 currency from the player (will fail if the player has less than 5 currency)
if econ:remove(player, 5) then
    minetest.chat_send_player(player, "You have been deducted 5 currency. Damn")
end
```

you can use the exact same api, whilst targeting a specific economy (useful if you have multiple currency mods):
```lua
-- get the atl_economy economy
local econ = lib_economy.get_economy("atl_economy")

-- ... other stuff
```

## register an economy

if you're making an economy mod, all you need to do is call `lib_economy.register_economy(economy_name, economy_object)`:

```lua

lib_economy.register_economy("epic_points", {
    balance = function(account_id)
        -- implement method (protip: you can create the account here, if you choose)
    end,

    transfer = function(sender_id, recipient_id, amount, memo)
        -- implement method
    end,

    set = function(account_id, amount)
        -- implement method
    end
})

```

## concept of "accounts"

lib_economy does not discriminate. an account is simply an ID with a balance attached - this means you can create accounts for any purpose (eg: a "town" account to collect local taxes)!

if an account id starts with `player:`, then it's a players' own account. this is to avoid any collision issues with account names.

**account creation (currently) needs to be handled by the economy provider!**

as an example, you could create a lottery system like so:
```lua

-- for example purposes only, this creates an empty lottery account
function_to_create_an_account("my_mod:lottery", 0)

-- players can then deposit...
lib_economy.current_economy:transfer(player_one, "my_mod:lottery", 100, "contributing 100 currency to the lottery")

-- at some point, we may implement a querying api, although for now this will need to be handled locally
local players_contributed = [ player_one ]
local random_player = players_contributed[1]
if lib_economy.current_economy:transfer("my_mod:lottery", random_player, lib_economy.current_economy:balance("my_mod:lottery"), "congratulations on winning the lottery!") then
    minetest.chat_send_message(random_player, "congratulations! you have won the lottery!!")
end
```