
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

include("shared.lua")

local ingredientCols = {
    Color(200, 140, 140, 200),
    Color(140, 200, 140, 200),
    Color(140, 140, 200, 200)
}

local ingredientOffsets = {
    [1] = {
        Vector(-5, 0, 0)
    },
    [2] = {
        Vector(0, -8, 0),
        Vector(0, 8, 0)
    },
    [3] = {
        Vector(0, -10, 0),
        Vector(0, 0, 0),
        Vector(0, 10, 0)
    }
}

function ENT:Initialize()
    self.IngredientModels = {}
end

local sin, curTime = math.sin, CurTime
function ENT:Think()
    local ingredients = self:GetIngredients()
    local ingredientCount = #ingredients
    local time = curTime()
    local offsets = ingredientOffsets[ingredientCount]
    local isCrafting = self:IsCrafting()
    local craftProg = self:GetCraftProgress()

    for i, ingredient in ipairs(ingredients) do
        local mdl = ingredient.ItemLabModel
        if not mdl then continue end

        local csModel = self.IngredientModels[i]
        if not IsValid(csModel) then
            self.IngredientModels[i] = ClientsideModel(mdl)
            csModel = self.IngredientModels[i]
            csModel:SetParent(self)
            csModel:SetRenderFX(16)
            csModel:SetRenderMode(RENDERMODE_TRANSCOLOR)
            csModel:SetColor(ingredientCols[i])
        end
        if csModel:GetModel() ~= mdl then csModel:SetModel(mdl) end

        csModel:SetModelScale((ingredientCount == 1) and .6 or .4)
        csModel:SetAngles(self:LocalToWorldAngles(Angle(-sin(time * 1.4) * 14, time * 25, sin(time * 1.4) * 14)))
        csModel:SetPos(self:LocalToWorld(
            (isCrafting and offsets[i] * (1 - craftProg) or offsets[i])
            + Vector(.9, -.6, 36 + sin(time * 1.4) * 2)
        ))
    end

    for i = ingredientCount + 1, 3 do
        if not IsValid(self.IngredientModels[i]) then continue end
        self.IngredientModels[i]:Remove()
    end
end

function ENT:OnRemove()
    for i = 1, 3 do
        if not IsValid(self.IngredientModels[i]) then continue end
        self.IngredientModels[i]:Remove()
    end
end

local pos, ang = Vector(12, -1, 3), Angle(0, 90, 90)
function ENT:Draw()
    self:DrawModel()
    PIXEL.DrawEntOverhead(self, "Item Lab", ang, pos)
end