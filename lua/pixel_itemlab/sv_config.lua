
PIXEL.ItemLab.Config.FailedCraftTime = {10, 300}

--item id, craftTimeMin, craftTimeMax, successRate (0-1), ingredient id 1, ingredient id 2, ingredient id 3
PIXEL.ItemLab.Recipe("health50", 30, 50, 1, nil, "melon", "melon", "melon")
PIXEL.ItemLab.Recipe("pixel_armour_charger", 5, 10, 1, PIXEL.CustomChecks.VIP, "cactus", "cactus", "cactus")