
PIXEL.ItemLab.Recipes = PIXEL.ItemLab.Recipes or {}

function PIXEL.ItemLab.Recipe(item, craftTimeMin, craftTimeMax, successRate, ...)
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
        successRate = successRate or 1
    }

    PIXEL.ItemLab.Recipes[id] = recipe

    return recipe
end
