# atl_core api

## atl_core.register_cookable

`atl_core.register_cookable` allows you to define any cookable recipe, including ones with multiple inputs.

```
atl_core.register_cookable({
    "me:node_a",
    "me:node_b"
}, "me:node_c")
```

cookable durations are normalised at a 5 second duration

## atl_core.get_cookable

`atl_core.get_cookable` is an extension of `minetest.get_craft_result` for composite cooking recipes.

```
cooked, after_cooked = atl_core.get_cookable({
    -- list of ItemStack
})

if cooked.item:is_empty() == false then
    -- we have a recipe!
end
```

## atl_core.register_furnace

`atl_core.register_furnace` is a function that allows you to create arbitrary furnaces, keeping the functionality consistent

```
atl_core.register_furnace("me:inactive_node_name", {
        -- inactive nodedef
    }, {
        -- active nodedef
    },
    2, -- amount of input slots
    4, -- amount of output slots
    "cooking", -- type of craft (currently unused)
    1, -- speed modifier (currently unused)
    1 -- yield modifier (currently unused)
)
```