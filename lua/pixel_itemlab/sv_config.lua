
PIXEL.ItemLab.Config.FailedCraftTime = {10, 300}

--item id, craftTimeMin, craftTimeMax, successRate (0-1), customCheck, ingredient id 1, ingredient id 2, ingredient id 3

PIXEL.ItemLab.Recipe("health25", 30, 50, 1, nil, "melon", "energydrink", "baby")
PIXEL.ItemLab.Recipe("health50", 45, 55, 1, nil, "melon", "melon", "energydrink")
PIXEL.ItemLab.Recipe("healthmax", 60, 100, 1, nil, "melon", "baby", "baby")

PIXEL.ItemLab.Recipe("armor25", 30, 50, 1, nil, "pan", "pan", "cactus")
PIXEL.ItemLab.Recipe("armor50", 45, 100, 1, nil, "pan", "pan", "pan")

PIXEL.ItemLab.Recipe("pixel_armour_charger", 45, 100, 1, nil, "hook", "hook", "pan")
PIXEL.ItemLab.Recipe("pixel_health_charger", 45, 100, 1, nil, "hook", "hook", "melon")

PIXEL.ItemLab.Recipe("fadedoorbomb", 180, 300, 1, nil, "briefcase", "briefcase", "vibrator")

PIXEL.ItemLab.Recipe("pixel_armour_vip_charger", 45, 100, 1, PIXEL.CustomChecks.VIP, "hook", "pan", "pan")
PIXEL.ItemLab.Recipe("pixel_health_vip_charger", 45, 100, 1, PIXEL.CustomChecks.VIP, "hook", "melon", "melon")
PIXEL.ItemLab.Recipe("pixel_money_charger", 45, 100, 1, PIXEL.CustomChecks.VIP, "hook", "hook", "huladoll")

PIXEL.ItemLab.Recipe("pixel_reverse_money_charger", 45, 100, 1, PIXEL.CustomChecks.VIPPlus, "hook", "huladoll", "huladoll")

PIXEL.ItemLab.Recipe("fbiopenup", 30, 50, 1, nil, "baby")
PIXEL.ItemLab.Recipe("fbiopenup", 30, 50, 1, nil, "briefcase", "vibrator", "baby")