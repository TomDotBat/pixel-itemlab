
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

PIXEL.ItemLab.Recipes = PIXEL.ItemLab.Recipes or {}

function PIXEL.ItemLab.Recipe(item, craftTimeMin, craftTimeMax, successRate, customCheck, ...)
    if not PIXEL.ItemLab.Items[item] then return end

    local ingredientIds = {...}
    if not ingredientIds then return end

    local ingredientCount = #ingredientIds
    if ingredientCount < 1 or ingredientCount > 3 then return end

    for _, ingredientId in ipairs(ingredientIds) do
        if not PIXEL.ItemLab.Ingredients[ingredientId] then return end
    end

    local sortedIds = table.Copy(ingredientIds)
    table.sort(sortedIds)
    local id = table.concat(sortedIds, ".")

    local recipe = {
        id = id,
        item = item,
        craftTime = {craftTimeMin, craftTimeMax},
        successRate = successRate or 1,
        customCheck = customCheck
    }

    PIXEL.ItemLab.Recipes[id] = recipe

    return recipe
end
