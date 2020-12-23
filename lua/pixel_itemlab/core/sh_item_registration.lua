
PIXEL.ItemLab.Ingredients = PIXEL.ItemLab.Ingredients or {}

function PIXEL.ItemLab.Ingredient(id, name, model, scale)
    local tbl = {}

    tbl.ItemLabId = id
    tbl.ItemLabIngredient = true
    tbl.ItemLabName = name
    tbl.Category = "PIXEL Item Lab - Ingredients"
    tbl.ItemLabModel = model
    tbl.ItemLabScale = scale or 1

    tbl.Base = "pixel_itemlab_ingredient_base"
    tbl.PrintName = string.Replace(name, "\n", " ")
    tbl.Spawnable = true

    PIXEL.ItemLab.Ingredients[id] = tbl
    return tbl
end

PIXEL.ItemLab.Items = PIXEL.ItemLab.Items or {}

function PIXEL.ItemLab.Item(id, name, model, scale, onCraft, entOverrides)
    local tbl = entOverrides or {}

    tbl.ItemLabId = id
    tbl.ItemLabName = name
    tbl.Category = "PIXEL Item Lab - Items"
    tbl.ItemLabModel = model
    tbl.ItemLabScale = scale or 1
    tbl.ItemLabRecipes = {}
    tbl.ItemLabOnCraft = onCraft

    tbl.Base = tbl.Base or "pixel_itemlab_item_base"
    tbl.PrintName = string.Replace(name, "\n", " ")
    tbl.Spawnable = true

    PIXEL.ItemLab.Items[id] = tbl
    return tbl
end

timer.Simple(1, function()
    for _, ingredient in pairs(PIXEL.ItemLab.Ingredients) do
        scripted_ents.Register(ingredient, "pixel_itemlab_ingredient_" .. ingredient.ItemLabId)
    end

    for _, item in pairs(PIXEL.ItemLab.Items) do
        scripted_ents.Register(item, "pixel_itemlab_item_" .. item.ItemLabId)
    end
end)