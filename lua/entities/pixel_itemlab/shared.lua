
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Item Lab"
ENT.Category = "PIXEL Item Lab"
ENT.Author = "Tom.bat"
ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Ingredient1")
    self:NetworkVar("String", 1, "Ingredient2")
    self:NetworkVar("String", 2, "Ingredient3")

    self:NetworkVar("Int", 0, "CraftStart")
    self:NetworkVar("Int", 1, "CraftFinish")

    self:NetworkVarNotify("Ingredient1", self.UpdateIngredient)
    self:NetworkVarNotify("Ingredient2", self.UpdateIngredient)
    self:NetworkVarNotify("Ingredient3", self.UpdateIngredient)

    self.IngredientIds = {}
    self.Ingredients = {}

    if CLIENT then return end
    self:ResetCraftState()
end

function ENT:UpdateIngredient(name, _, newId)
    self.IsEmpty = false

    local slotId = tonumber(string.Right(name, 1))

    if slotId == 1 and newId == "" then
        table.Empty(self.IngredientIds)
        table.Empty(self.Ingredients)

        timer.Create("PIXEL.ItemLab.IngredientUpdate:" .. self:EntIndex(), .01, 1, function()
            if not IsValid(self) then return end
            hook.Run("PIXEL.ItemLab.IngredientsUpdated", self, self.Ingredients)
        end)
        return
    end

    self.IngredientIds[slotId] = newId

    for i, id in ipairs(self.IngredientIds) do
        self.Ingredients[i] = PIXEL.ItemLab.Ingredients[i]
    end

    timer.Create("PIXEL.ItemLab.IngredientUpdate:" .. self:EntIndex(), .01, 1, function()
        if not IsValid(self) then return end
        hook.Run("PIXEL.ItemLab.IngredientsUpdated", self, self.Ingredients)
    end)
end

function ENT:GetIngredientIDs(forceUpdate)
    if SERVER or forceUpdate or (not self.IsEmpty and table.IsEmpty(self.IngredientIds)) then
        self.IngredientIds = {
            self:GetIngredient1(),
            self:GetIngredient2(),
            self:GetIngredient3()
        }

        if self.IngredientIds[1] == "" then
            table.Empty(self.IngredientIds)
        end
    end

    return self.IngredientIds
end

function ENT:GetIngredients()
    if SERVER or (not self.IsEmpty and table.IsEmpty(self.Ingredients)) then
        self:GetIngredientIDs(true)

        for i, id in ipairs(self.IngredientIds) do
            self.Ingredients[i] = PIXEL.ItemLab.Ingredients[id]
        end

        if table.IsEmpty(self.Ingredients) then self.IsEmpty = true end
    end

    return self.Ingredients
end

function ENT:IsCrafting()
    return self:GetCraftFinish() ~= -1
end

function ENT:GetCraftTotalTime()
    return self:GetCraftFinish() - self:GetCraftStart()
end

function ENT:GetCraftTimeElapsed()
    return CurTime() - self:GetCraftStart()
end

function ENT:GetCraftTimeLeft()
    return self:GetCraftFinish() - CurTime()
end

function ENT:GetCraftProgress()
    return self:GetCraftTimeElapsed() / self:GetCraftTotalTime()
end