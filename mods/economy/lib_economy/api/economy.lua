EconomyProxy = {}
EconomyProxy.__index = EconomyProxy

local function get_account_id_by_reference(player_reference)
    -- assuming it's either a player name or internal id
    if type(player_reference) == "string" then
        return player_reference
    end

    return "player:" .. player_reference:get_player_name()
end

function EconomyProxy:create(economy_object)
    local proxy = {}
    setmetatable(proxy, EconomyProxy)

    proxy.obj = economy_object
    return proxy
end
    -- economy_object should have: balance(<player or string reference>), transfer(<player or string reference sender>, <player or string reference receiver>, amount, memo), set(<player or string reference>, amount)

function EconomyProxy:balance(player_reference)
    local account_id = get_account_id_by_reference(player_reference)

    return self.obj.balance(account_id)
end

function EconomyProxy:has(player_reference, amount)
    local account_id = get_account_id_by_reference(player_reference)

    local balance = self.obj.balance(account_id)
    
    return balance >= amount
end

function EconomyProxy:remove(player_reference, amount)
    local account_id = get_account_id_by_reference(player_reference)

    local balance = self.obj.balance(account_id)
    if balance >= amount then
        return self.obj.set(account_id, balance - amount)
    end

    return false
end

function EconomyProxy:add(player_reference, amount)
    local account_id = get_account_id_by_reference(player_reference)

    local balance = self.obj.balance(account_id)

    return self.obj.set(account_id, balance + amount)
end

function EconomyProxy:transfer(sender_reference, recipient_reference, amount, memo)
    -- we shouldn't be able to transfer negative money
    if amount <= 0 then
        return false
    end

    local sender_id = get_account_id_by_reference(sender_reference)
    local recipient_id = get_account_id_by_reference(recipient_reference)

    return self.obj.transfer(sender_id, recipient_id, amount, memo)
end