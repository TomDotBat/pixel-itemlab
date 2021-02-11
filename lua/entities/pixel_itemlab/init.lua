
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_lab/crematorcase.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local physObj = self:GetPhysicsObject()
    if not physObj:IsValid() then return end
    physObj:Wake()
end

function ENT:AddIngredient(ingredientId)
    local ingredientCount = #self:GetIngredients()
    if ingredientCount > 2 then return end

    self["SetIngredient" .. tostring(ingredientCount + 1)](self, ingredientId)
    return true
end

function ENT:RemoveIngredient(targetId)
    if self.RemoveCooldown then return end
    self.RemoveCooldown = true

    timer.Create("PIXEL.ItemLab.IngredientRemoveCooldown" .. self:EntIndex(), 1, 1, function()
        if not IsValid(self) then return end
        self.RemoveCooldown = nil
    end)

    local ingredients = self:GetIngredientIDs()
    table.RemoveByValue(ingredients, targetId)

    self:SetIngredient1(ingredients[1] or "")
    self:SetIngredient2(ingredients[2] or "")
    self:SetIngredient3(ingredients[3] or "")
end

function ENT:DropItem(entClass)
    local ent = ents.Create(entClass)
    ent:SetPos(self:LocalToWorld(Vector(34, 0, 30)))
    ent:Spawn()

    return ent
end

function ENT:ResetIngredients()
    self:SetIngredient1("")
    self:SetIngredient2("")
    self:SetIngredient3("")

    table.Empty(self.IngredientIds)
    table.Empty(self.Ingredients)
end

function ENT:ResetCraftState()
    self:ResetIngredients()
    self:SetCraftStart(-1)
    self:SetCraftFinish(-1)
end

function ENT:Touch(entity)
    if self.AddingIngredient or self:IsCrafting() then return end
    if not (IsValid(entity) and entity.GetClass and entity.ItemLabIngredient) then return end
    if not self:AddIngredient(entity.ItemLabId) then return end

    self.AddingIngredient = true

    local effectdata = EffectData()
    effectdata:SetOrigin(entity:GetPos())
    util.Effect("StunstickImpact", effectdata, true, true)

    timer.Simple(0, function()
        if IsValid(entity) then entity:Remove() end
        if not IsValid(self) then return end
        self.AddingIngredient = false
    end)
end

util.AddNetworkString("PIXEL.ItemLab.OpenUI")

local cooldowns = {}
function ENT:Use(ply)
    if not ply:CanUseItemLab(self) then return end

    if cooldowns[ply] then return end
    cooldowns[ply] = true
    timer.Simple(1, function()
        cooldowns[ply] = nil
    end)

    net.Start("PIXEL.ItemLab.OpenUI")
     net.WriteEntity(self)
    net.Send(ply)
end

function ENT:OnRemove()
    if not self.SoundEffect then return end
    self.SoundEffect:Stop()
end

function ENT:FinishCrafting()
    self:ResetCraftState()

    if not self.SoundEffect then return end
    self.SoundEffect:FadeOut(1)

    timer.Simple(1, function()
        if not IsValid(self) then return end
        self.SoundEffect:Stop()
        self.SoundEffect = nil
    end)
end

util.AddNetworkString("PIXEL.ItemLab.StartCrafting")

net.Receive("PIXEL.ItemLab.StartCrafting", function(len, ply)
    local lab = net.ReadEntity()
    if not IsValid(lab) then return end
    if not ply:CanUseItemLab(lab) then return end
    if lab:IsCrafting() then return end

    local ingredientIds = table.Copy(lab:GetIngredientIDs())
    table.sort(ingredientIds)

    local selectedRecipe = PIXEL.ItemLab.Recipes[table.concat(ingredientIds, ".")]

    local craftTime
    if selectedRecipe then
        craftTime = math.random(selectedRecipe.craftTime[1], selectedRecipe.craftTime[2])

        if math.Rand(0, 1) > selectedRecipe.successRate then
            selectedRecipe = nil
        end
    else
        craftTime = math.random(PIXEL.ItemLab.Config.FailedCraftTime[1], PIXEL.ItemLab.Config.FailedCraftTime[2])
    end

    local curTime = CurTime()
    lab:SetCraftStart(curTime)
    lab:SetCraftFinish(curTime + craftTime)

    lab.SoundEffect = CreateSound(lab, "pixel_itemlab/itemlab_processing.wav")
    lab.SoundEffect:SetSoundLevel(60)
    lab.SoundEffect:Play()

    timer.Create("PIXEL.ItemLab.CraftTimer:" .. lab:EntIndex(), craftTime, 1, function()
        if not IsValid(lab) then return end
        lab:FinishCrafting()

        local finishSound = CreateSound(lab, "pixel_itemlab/itemlab_finished.mp3")
        finishSound:SetSoundLevel(70)
        finishSound:Play()

        local ent
        if selectedRecipe.customCheck and not selectedRecipe.customCheck(ply) then
            ent = lab:DropItem("pixel_itemlab_item_crap")
        elseif not PIXEL.ItemLab.Items[selectedRecipe.item] then
            ent = lab:DropItem(selectedRecipe.item or "pixel_itemlab_item_crap")
        else
            ent = lab:DropItem("pixel_itemlab_item_" .. (selectedRecipe and selectedRecipe.item or "crap"))
        end

        if ent.Setowning_ent then ent:Setowning_ent(ply) end

        if not isfunction(ent.ItemLabOnCraft) then return end
        ent.ItemLabOnCraft(ent, lab, lab:CPPIGetOwner())
    end)
end)

util.AddNetworkString("PIXEL.ItemLab.DropIngredient")

net.Receive("PIXEL.ItemLab.DropIngredient", function(len, ply)
    local lab = net.ReadEntity()
    local ingredientId = net.ReadString()
    if not IsValid(lab) then return end
    if not ply:CanUseItemLab(lab) then return end
    if lab:IsCrafting() then return end
    if not PIXEL.ItemLab.Ingredients[ingredientId] then return end

    lab:RemoveIngredient(ingredientId)
    lab:DropItem("pixel_itemlab_ingredient_" .. ingredientId)
end)