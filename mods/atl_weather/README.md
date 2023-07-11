# atl_weather

A mod designed originally for Atlas, but flexible and extensible with no dependencies.

## Usage

You first will need to register the weathers you want, which are based on biomes.

```lua
atl_weather.register_weather("weather name", {
    -- you can set biomes = "all" to apply for every biome
    biomes = {
        "biome_one",
        "biome_two"
    },

    -- minimum time, in seconds
    min_duration = 120,

    -- maximum time, in seconds
    max_duration = 600,

    -- weight, loosely defined as "how frequently will this weather apply?"
    weight = 100,

    -- optional, if set when this weather ends it'll pick one randomly from this list
    next = {
        "next_weather"
    },

    -- called whenever a player enters the weather area, use this to set lighting, clouds, etc
    on_enter = function(player)

    end,

    -- called whenever a player leaves the weather area
    on_leave = function(player)

    end,

    -- optional, if this is true then the particle_spawners will get called dynamically based off of whether or not you're indoors
    toggle_particles = true,

    -- optional, used to define particle spawners for things like rain. when toggle_particles is false, this will only run at the same time on_enter is called
    particle_spawners = function(player, y_offset)
        local particle_table = {}

        particle_table[#particle_table + 1] = minetest.add_particlespawner({ ... })

        return particle_table
    end,


    -- on_step is currently NYI
    on_step = function(player, dtime)

    end,

    -- on_tick is currently NYI
    on_tick = function(player, tick_time)

    end
})
```

## How weather works / caveats

Weather is calculated globally based off of an 80x80x80 grid (that extra x80 is important!). In multiplayer scenarios, 2 players in the same grid will see the same weather effects at the same time (+- some "init" time).

The weather in one grid is never guaranteed to be the same as the weather in another grid. This can lead to funky situations where, for instance, one grid is raining and the other is clear. Please keep this in mind - use `weight` numbers to your advantage to try and control this.

The weather in a given grid is based off of the position the grid is initialised - if a grid contains multiple biomes, it will only apply based off of the biome at the players' position. This can lead to situations where you start travelling in to a grid but the weather changes dramatically, and then dramatically again when leaving the grid.

Since weather works with biomes and an 80x80x80 grid, you can define underground biomes with weather! This can be incredibly useful for things like atmospheric dust clouds, or adding an extra layer of depth to regular exploration.

## Optimisations for multiplayer (also applied in SP)

Outside of the 80x80x80 grid, weather works in a slightly delayed fashion. Instead of running on globalstep, it runs on a tick system. At the moment, one tick is set to 2 seconds - this means that weather will only update its state (both per player and globally) every 2 seconds.

The grid is routinely pruned as part of this tick process to ensure that inactive grids aren't stored in memory. This could lead to situations where the weather system "forgets" what's next because the grid is unoccupied.