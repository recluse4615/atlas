atl_tools.tiers = {
    {
        tier = 1,
        name = "wood",
        constructable = false,
        material = "atl_core:wood_planks",
        colour = "#80493A",
        times = {
            choppy = {
                times = {
                    [5] = 2.50
                },
                uses = 10,
                maxlevel = 1
            },
            cracky = {
                times = {
                    [5] = 3.00
                },
                uses = 10,
                maxlevel = 1
            },
            crumbly = {
                times = {
                    [5] = 0.50,
                    [4] = 2.50
                },
                uses = 10,
                maxlevel = 1
            }
        }
    },
    {
        tier = 2,
        name = "stone",
        constructable = false,
        material = "atl_core:cobble",
        colour = "#868188",
        times = {
            choppy = {
                times = {
                    [5] = 2.00,
                    [4] = 2.50
                },
                uses = 12,
                maxlevel = 1
            },
            cracky = {
                times = {
                    [5] = 2.50,
                    [4] = 3.00
                },
                uses = 12,
                maxlevel = 1
            },
            crumbly = {
                times = {
                    [5] = 0.40,
                    [4] = 2.25
                },
                uses = 12,
                maxlevel = 1
            }
        }
    },
    {
        -- tin & copper cannot be used to create tools on their own
        tier = 3,
        name = "bronze",
        constructable = true,
        material = "atl_ores:bronze_ingot",
        colour = "#D3A068",
        times = {
            choppy = {
                times = {
                    [5] = 1.75,
                    [4] = 2.00,
                    [3] = 3.00
                },
                uses = 15,
                maxlevel = 2
            },
            cracky = {
                times = {
                    [5] = 2.00,
                    [4] = 2.25,
                    [3] = 3.50
                },
                uses = 15,
                maxlevel = 2
            },
            crumbly = {
                times = {
                    [5] = 0.35,
                    [4] = 2.00,
                    [3] = 2.50
                },
                uses = 15,
                maxlevel = 2
            }
        }
    },
    {
        tier = 4,
        name = "iron",
        constructable = true,
        material = "atl_ores:iron_ingot",
        colour = "#B8B5B9",
        times = {
            choppy = {
                times = {
                    [5] = 1.50,
                    [4] = 1.75,
                    [3] = 2.75
                },
                uses = 20,
                maxlevel = 3
            },
            cracky = {
                times = {
                    [5] = 1.75,
                    [4] = 2.00,
                    [3] = 3.00
                },
                uses = 20,
                maxlevel = 3
            },
            crumbly = {
                times = {
                    [5] = 0.30,
                    [4] = 1.75,
                    [3] = 2.00
                },
                uses = 20,
                maxlevel = 3
            }
        }
    },
    {
        tier = 5,
        name = "corinthite",
        constructable = true,
        material = "atl_ores:corinthite_ingot",
        colour = "#EDE19E",
        times = {
            choppy = {
                times = {
                    [5] = 1.35,
                    [4] = 1.55,
                    [3] = 2.00,
                    [2] = 4.50
                },
                uses = 25,
                maxlevel = 3
            },
            cracky = {
                times = {
                    [5] = 1.50,
                    [4] = 1.75,
                    [3] = 2.50,
                    [2] = 5.00
                },
                uses = 25,
                maxlevel = 3
            },
            crumbly = {
                times = {
                    [5] = 0.30,
                    [4] = 1.75,
                    [3] = 2.00
                },
                uses = 20,
                maxlevel = 3
            }
        }
    },
    {
        tier = 6,
        name = "steel",
        constructable = true,
        material = "atl_ores:steel_ingot",
        colour = "#45444F",
        times = {
            choppy = {
                times = {
                    [5] = 1.00,
                    [4] = 1.30,
                    [3] = 1.75,
                    [2] = 4.00,
                    [1] = 6.00
                },
                uses = 30,
                maxlevel = 3
            },
            cracky = {
                times = {
                    [5] = 1.25,
                    [4] = 1.50,
                    [3] = 2.00,
                    [2] = 3.50,
                    [1] = 5.00
                },
                uses = 30,
                maxlevel = 3
            },
            crumbly = {
                times = {
                    [5] = 0.30,
                    [4] = 1.75,
                    [3] = 2.00
                },
                uses = 20,
                maxlevel = 3
            }
        }
    }
    -- after steel, we enter the forgotten lands - nodes here don't behave the same as regular nodes in terms of groups
}