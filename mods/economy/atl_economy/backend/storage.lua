local storage = minetest.get_mod_storage()
local backend = {}

function backend.has(account_id)
    return storage:contains(account_id)
end

function backend.set(account_id, amount)
    storage:set_float(account_id, amount)
end

function backend.get(account_id)
    return storage:get_float(account_id)
end

return backend