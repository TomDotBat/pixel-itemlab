
--[[
    PIXEL Item Lab
    Copyright (C) 2021 Tom O'Sullivan (Tom.bat)
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

PIXEL.ItemLab.Config.FailedCraftTime = {10, 300}

--item id, craftTimeMin, craftTimeMax, successRate (0-1), customCheck, ingredient id 1, ingredient id 2, ingredient id 3

PIXEL.ItemLab.Recipe("health25", 30, 50, 1, nil, "melon", "energydrink", "baby")
PIXEL.ItemLab.Recipe("health50", 45, 55, 1, nil, "melon", "melon", "energydrink")
PIXEL.ItemLab.Recipe("healthmax", 60, 100, 1, nil, "melon", "baby", "baby")

PIXEL.ItemLab.Recipe("armor25", 30, 50, 1, nil, "pan", "pan", "cactus")
PIXEL.ItemLab.Recipe("armor50", 45, 100, 1, nil, "pan", "pan", "pan")

PIXEL.ItemLab.Recipe("fadedoorbomb", 180, 300, 1, nil, "briefcase", "briefcase", "vibrator")

PIXEL.ItemLab.Recipe("fbiopenup", 30, 50, 1, nil, "baby")
PIXEL.ItemLab.Recipe("fbiopenup", 30, 50, 1, nil, "briefcase", "vibrator", "baby")