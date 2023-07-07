MAX_FISHING_TIME = 10.0
FISHING_REWARD_RANGE = 2.5
FISHING_REWARD_MIN = 3.0

atl_fishing = {
    players = {}
}

minetest.register_on_joinplayer(function(player)
    atl_fishing.players[player:get_player_name()] = {
        is_fishing = false
    }
end)

minetest.register_on_leaveplayer(function(player)
    local fishing_data = atl_fishing.players[player:get_player_name()]
    if fishing_data.is_fishing == true then
        local entity = fishing_data.bobber_entity
        entity:remove()
    end

    atl_fishing.players[player:get_player_name()] = nil
end)

RippleEntity = {
    initial_properties = {
        visual = "upright_sprite", -- maybe upright_sprite with 2 textures?
        textures = {
            "atl_water_ripple_1.png",
            "atl_water_ripple_1.png"
        },
        visual_size = {
            x = 1,
            y = 1
        },

        backface_culling = false,
        static_save = false
    },
    -- set_animation_frame_speed
    -- self.object:set_rotation
    on_activate = function(self, staticdata, dtime_s)
        self.object:set_rotation(vector.dir_to_rotation({
            x = 0,
            y = 1,
            z = 0
        }))
    end,
    on_step = function(self, dtime, move_result)
        self.time_active = self.time_active + dtime
        self.frame_time = self.frame_time + dtime

        if self.time_active > 0.40 then
            self.object:remove()
        else
            if self.frame_time > 0.12 then
                self.frame = ((self.frame + 1) % 4)
                if self.frame == 0 then
                    self.frame = 1
                end

                local props = self.object:get_properties()
                props.textures[1] = "atl_water_ripple_" .. self.frame .. ".png"
                self.object:set_properties(props)
                self.frame_time = 0
            end
        end
    end,

    time_active = 0.0,
    frame_time = 0.0,
    frame = 1
}

minetest.register_entity("atl_fishing:ripple", RippleEntity)

BobberEntity = {
    initial_properties = {
        visual = "cube",
        textures = {
            "atl_bobble_top.png",
            "atl_bobble_top.png",
            "atl_bobble.png",
            "atl_bobble.png",
            "atl_bobble.png",
            "atl_bobble.png"
        },
        visual_size = {
            x = 0.20,
            y = 0.20
        },
        backface_culling = true,
        physical = true,
        static_save = false
    },

    _frozen = false,
    _floating = false,
    _intersected = false,
    _active_time = 0.0,
    _reward_time = 0.0,

    -- used to calculate when to ripple next
    _last_ripple_time = 0.0,

    on_step = function(self, dtime, move_result)
        local pos = self.object:get_pos()

        if self._frozen then
            self._active_time = self._active_time + dtime

            -- if we've passed _active_time, start rippling
            if self._active_time > self._reward_time and self._active_time < (self._reward_time + FISHING_REWARD_RANGE) then
                local active_time_secs = math.floor(self._active_time)

                if self._last_ripple_time ~= active_time_secs then 
                    minetest.add_entity(pos, "atl_fishing:ripple", nil)
                    minetest.sound_play({
                        name = "fishing_bobber_plonk",
                        gain = 1.0
                    }, {
                        pos = pos
                    })

                    self._last_ripple_time = active_time_secs
                end
            end

            -- max time has elapsed, stop fishing for the user
            if self._active_time > 10.0 then
                self.object:remove()
            end

            return
        end

        local node = minetest.get_node(pos)
        local pos_above = pos
        pos_above.y = math.floor(pos.y) + 1
        local node_above = minetest.get_node(pos_above)

        local colliding = (move_result.collides and move_result.collisions[1] and move_result.collisions[1].type == "node")


        local current_velocity = self.object:get_velocity()

        -- if we don't hit water, do nothing and start an instant decay, halving the "active time"
        if self._floating == false and node.name ~= "atl_core:water_source" and colliding then
            self.object:set_acceleration({
                x = 0,
                y = 0,
                z = 0
            })

            self.object:set_velocity({
                x = 0,
                y = 0,
                z = 0
            })

            self._frozen = true
            self._active_time = 5.0
        end

        -- if we haven't yet started floating upwards, and we're in the water, then start to increase velocity until we're at a good place
        if self._floating == false and node.name == "atl_core:water_source" and (node_above.name == "atl_core:water_source" or colliding) then
            if self._intersected == false then
                minetest.add_entity(pos, "atl_fishing:ripple", nil)
                minetest.sound_play({
                    name = "fishing_bobber_plonk",
                    gain = 1.0
                }, {
                    pos = pos
                })
                self._intersected = true
            end

            
            if current_velocity.y >= 5 then
                self._floating = true
                return
            end
            self.object:set_acceleration({
                x = 0,
                y = 0,
                z = 0
            })

            -- ease velocity
            self.object:add_velocity({
                x = 0,
                y = 1,
                z = 0
            })
            return
        end

        -- if we're floating OR we're at the top of water after entering it (fix for super high acceleration) then we freeze the entity in place - fishing has started!
        if (self._floating == true and node.name == "air") or (self._intersected == true and current_velocity.y > 0 and node.name == "air") then
            pos.y = math.floor(pos.y) - 1
            node = minetest.get_node(pos)
            if node.name == "atl_core:water_source" then
                pos.y = pos.y + 0.2
                minetest.add_entity(pos, "atl_fishing:ripple", nil)
                minetest.sound_play({
                    name = "fishing_bobber_plonk",
                    gain = 0.75
                }, {
                    pos = pos
                })
                self.object:set_pos(pos)
                self.object:set_velocity({
                    x = 0,
                    y = 0,
                    z = 0
                })
                self._frozen = true
            end
        end
    end
}

minetest.register_entity("atl_fishing:bobber", BobberEntity)

minetest.register_tool("atl_fishing:rod_wood", {
    description = "Wooden Fishing Rod",
    inventory_image = "atl_fishing_rod.png",
    range = 0,
    groups = {
        fishing_rod = 1,
        _atl_tier = 1,
        _atl_tool_type = atl_tools.types.FISHING_ROD
    },
    on_secondary_use = function(itemstack, user, pointed_thing)
        if atl_fishing.players[user:get_player_name()].is_fishing == false then
            local player_pos = user:get_pos()
            local eye_height = user:get_properties().eye_height

            player_pos = vector.add(player_pos, vector.multiply(user:get_look_dir(), 2))
            player_pos.y = player_pos.y + eye_height
            local obj = minetest.add_entity(player_pos, "atl_fishing:bobber", nil)
            if not obj then return itemstack end

            minetest.sound_play({
                name = "fishing_rod_use",
                gain = 0.6
            }, {
                to_player = user:get_player_name(),
                start_time = 0.15
            })

            local velocity = vector.multiply(user:get_look_dir(), 5)
            
            eye_height = eye_height + 3
            velocity.y = velocity.y + eye_height + 1

            obj:set_velocity(velocity)
            obj:set_acceleration({
                x = 0,
                y = -10,
                z = 0
            })

            local lua_entity = obj:get_luaentity()
            lua_entity._reward_time = math.random(FISHING_REWARD_MIN * 100, (MAX_FISHING_TIME - FISHING_REWARD_RANGE - 0.5) * 100) / 100.0

            atl_fishing.players[user:get_player_name()] = {
                is_fishing = true,
                bobber_entity = obj
            }
        else
            local entity = atl_fishing.players[user:get_player_name()].bobber_entity

            -- check for reward here
            local lua_entity = entity:get_luaentity()
            local active_time = lua_entity._active_time
            local reward_time = lua_entity._reward_time

            minetest.chat_send_player(user:get_player_name(), active_time)

            if active_time > reward_time and active_time < (reward_time + FISHING_REWARD_RANGE) then
                minetest.chat_send_player(user:get_player_name(), "You fished successfully!")
            end

            entity:remove()

            atl_fishing.players[user:get_player_name()] = {
                is_fishing = false
            }
        end
        return itemstack
    end
})

minetest.register_craft({
    output = "atl_fishing:rod_wood",
    recipe = {
        {
            "", "", "atl_core:stick"
        },
        {
            "", "atl_core:stick", ""
        },
        {
            "atl_core:stick", "", ""
        }
    }
})