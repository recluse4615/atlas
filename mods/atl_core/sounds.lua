function atl_core.node_sound_defaults(table, footstep_default, dug_default, place_default)
    table = table or {}
    table.footstep = table.footstep or footstep_default or { name = "", gain = 1.0 }

    table.dug = table.dug or dug_default or { name = "default_dug_node", gain = 0.25 }

    table.place = table.place or place_default or { name = "default_place_node_hard", gain = 1.0 }
    
    return table
end

function atl_core.node_sound_dirt_defaults(table)
    table = table or {}
    table.dig = {
        name = "default_dig_crumbly",
        gain = 0.4
    }

    return atl_core.node_sound_defaults(table, {
        name = "default_dirt_footstep",
        gain = 0.25
    }, {
        name = "default_dirt_footstep",
        gain = 1.0
    }, {
        name = "default_place_node",
        gain = 1.0
    })
end

function atl_core.node_sound_stone_defaults(table)
    return atl_core.node_sound_defaults(table, {
        name = "default_hard_footstep",
        gain = 0.2
    }, {
        name = "default_hard_footstep",
        gain = 1.0
    })
end

function atl_core.node_sound_sand_defaults(table)
    return atl_core.node_sound_defaults(table, {
        name = "default_sand_footstep",
        gain = 0.05
    }, {
        name = "default_sand_footstep",
        gain = 0.15
    }, {
        name = "default_place_node",
        gain = 1.0
    })
end

function atl_core.node_sound_wood_defaults(table)
    return atl_core.node_sound_defaults(table, {
        name = "default_wood_footstep",
        gain = 0.15
    }, {
        name = "default_dig_choppy",
        gain = 0.4
    }, {
        name = "default_wood_footstep",
        gain = 1.0
    })
end

function atl_core.node_sound_leaves_defaults(table)
    return atl_core.node_sound_defaults(table, {
        name = "default_grass_footstep",
        gain = 0.45
    }, {
        name = "default_grass_footstep",
        gain = 0.7
    }, {
        name = "default_place_node",
        gain = 1.0
    })
end