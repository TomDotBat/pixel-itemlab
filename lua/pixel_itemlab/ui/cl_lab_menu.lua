
net.Receive("PIXEL.ItemLab.OpenUI", function()
    local lab = net.ReadEntity()
    if not IsValid(lab) then return end

    if not LocalPlayer():CanUseItemLab(lab) then return end
    PIXEL.ItemLab.OpenUI(lab)
end)

PIXEL.RegisterFont("ItemLab.NoIngredients", "Open Sans Bold", 30)
PIXEL.RegisterFont("ItemLab.SlotName", "Open Sans Bold", 22)
PIXEL.RegisterFont("ItemLab.SlotDescription", "Open Sans SemiBold", 21)
PIXEL.RegisterFont("ItemLab.CraftButton", "Open Sans Bold", 28)
PIXEL.RegisterFont("ItemLab.CraftProgress", "Open Sans Bold", 32)

function PIXEL.ItemLab.OpenUI(lab, oldFrame)
    if IsValid(PIXEL.ItemLab.UI) and not oldFrame then return end

    local ingredients = lab:GetIngredients()

    local frame = oldFrame
    if not frame then
        frame = vgui.Create("PIXEL.Frame")
    else
        for _, child in ipairs(frame:GetChildren()) do
            if child ~= frame.CloseButton then
                child:Remove()
            end
        end

        frame.PaintOver = nil
    end

    frame:SetTitle("Item Lab")

    PIXEL.ItemLab.UI = frame
    function frame:OnClose()
        PIXEL.ItemLab.UI = nil
    end

    hook.Add("PIXEL.ItemLab.IngredientsUpdated", frame, function(self, updatedLab)
        if updatedLab ~= lab then return end
        if not IsValid(self) then return end
        PIXEL.ItemLab.OpenUI(lab, self)
    end)

    if #ingredients >= 1 then
        frame:SetSize(PIXEL.Scale(540), PIXEL.Scale(352))
        if not oldFrame then
            frame:Center()
            frame:MakePopup()
        end
    else
        frame:SetSize(PIXEL.Scale(500), PIXEL.Scale(100))
        if not oldFrame then
            frame:Center()
            frame:MakePopup()
        end

        function frame:PaintOver(w, h)
            local headerH = PIXEL.Scale(30)
            PIXEL.DrawSimpleText("No ingredients, add one to start crafting.", "ItemLab.NoIngredients", w * .5, headerH + (h - headerH) * .5, PIXEL.Colors.PrimaryText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        return
    end

    local ingredientContainer = vgui.Create("Panel", frame)
    ingredientContainer:Dock(TOP)

    local ingredientPanels = {}

    local slotCol = PIXEL.OffsetColor(PIXEL.Colors.Background, 10)
    local mdlCol = PIXEL.OffsetColor(PIXEL.Colors.Background, 4)
    for i = 1, 3 do
        local ingredient = ingredients[i] or {}

        local pnl = vgui.Create("Panel", ingredientContainer)
        pnl:Dock(LEFT)

        if not lab:IsCrafting() and ingredient.ItemLabId then
            pnl.RemoveBtn = vgui.Create("PIXEL.ImgurButton", pnl)
            pnl.RemoveBtn:SetImgurID("Mrh8Bd3")
            pnl.RemoveBtn:SetHoverColor(PIXEL.Colors.Negative)
            pnl.RemoveBtn:SetClickColor(PIXEL.OffsetColor(PIXEL.Colors.Negative, -10))

            function pnl.RemoveBtn:DoClick()
                net.Start("PIXEL.ItemLab.DropIngredient")
                 net.WriteEntity(lab)
                 net.WriteString(ingredient.ItemLabId)
                net.SendToServer()

                frame:Close()
            end
        end

        pnl.Model = vgui.Create("DModelPanel", pnl)
        pnl.Model:SetMouseInputEnabled(false)
        pnl.Model:SetModel(ingredient.ItemLabModel or "")

        local oldPaint = pnl.Model.Paint
        function pnl.Model:Paint(w, h)
            PIXEL.DrawRoundedBox(PIXEL.Scale(4), 0, 0, w, h, mdlCol)
            oldPaint(self, w, h)
        end

        function pnl:Paint(w, h)
            PIXEL.DrawRoundedBox(PIXEL.Scale(4), 0, 0, w, h, slotCol)

            local textX = w * .5
            PIXEL.DrawSimpleText("Slot #" .. i, "ItemLab.SlotName", textX, PIXEL.Scale(10), PIXEL.Colors.PrimaryText, TEXT_ALIGN_CENTER)
            PIXEL.DrawText(ingredient.ItemLabName or "Slot Empty", "ItemLab.SlotDescription", textX, w + PIXEL.Scale(10), PIXEL.Colors.SecondaryText, TEXT_ALIGN_CENTER)
        end

        function pnl:PerformLayout(w, h)
            local pad = PIXEL.Scale(20)
            local modelSize = w - pad * 2
            self.Model:SetPos(pad, pad + PIXEL.Scale(22))
            self.Model:SetSize(modelSize, modelSize)

            if not IsValid(self.RemoveBtn) then return end
            local btnSize = PIXEL.Scale(16)
            self.RemoveBtn:SetPos(w - pad - btnSize, PIXEL.Scale(13))
            self.RemoveBtn:SetSize(btnSize, btnSize)
        end

        table.insert(ingredientPanels, pnl)
    end

    function ingredientContainer:PerformLayout(w, h)
        local ingredientPanelW = math.ceil((ingredientContainer:GetWide() - PIXEL.Scale(12)) / 3)
        for i, pnl in ipairs(ingredientPanels) do
            pnl:DockMargin(0, 0, i == 3 and 0 or PIXEL.Scale(6), 0)
            pnl:SetWide(ingredientPanelW)
        end
    end

    if lab:IsCrafting() then
        frame:SetTall(PIXEL.Scale(338))

        local progBar = vgui.Create("Panel", frame)

        function progBar:Paint(w, h)
            PIXEL.DrawRoundedBox(PIXEL.Scale(6), 0, 0, w, h, slotCol)

            local craftProg = lab:GetCraftProgress()
            if not frame.ClosingItemLab and craftProg >= 1 then
                frame.ClosingItemLab = true
                frame:Close()
            end

            local pad = PIXEL.Scale(4)
            local dblPad = pad * 2
            PIXEL.DrawRoundedBox(PIXEL.Scale(4), pad, pad, (w - dblPad) * craftProg, h - dblPad, PIXEL.Colors.Primary)
            PIXEL.DrawSimpleText("Crafting - " .. math.Round(math.min(craftProg * 100, 100)) .. "% Complete", "ItemLab.CraftProgress", w * .5, h * .5, PIXEL.Colors.PrimaryText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function frame:LayoutContent(w, h)
            if not (IsValid(ingredientContainer) and IsValid(progBar)) then return end

            local containerH = PIXEL.Scale(238)
            ingredientContainer:SetTall(containerH)

            progBar:SetSize(w - PIXEL.Scale(12), PIXEL.Scale(46))
            progBar:SetPos(0, containerH + PIXEL.Scale(46))
            progBar:CenterHorizontal()
        end

        return
    end

    local craftButton = vgui.Create("PIXEL.TextButton", frame)
    craftButton:SetText("Craft")
    craftButton:SetFont("ItemLab.CraftButton")

    function craftButton:DoClick()
        net.Start("PIXEL.ItemLab.StartCrafting")
         net.WriteEntity(lab)
        net.SendToServer()

        timer.Simple(.1, function()
            PIXEL.ItemLab.OpenUI(lab, frame)
        end)
    end

    function frame:LayoutContent(w, h)
        if not (IsValid(ingredientContainer) and IsValid(craftButton)) then return end

        local containerH = PIXEL.Scale(238)
        ingredientContainer:SetTall(containerH)

        local btnH = PIXEL.Scale(46)
        craftButton:SetSize(PIXEL.Scale(120), btnH)
        craftButton:SetPos(0, containerH + PIXEL.Scale(52))
        craftButton:CenterHorizontal()
    end
end

gameevent.Listen("entity_killed")
hook.Add("entity_killed", "PIXEL.ItemLab.CloseOnDeath", function(data)
    if not data.entindex_killed or data.entindex_killed ~= LocalPlayer():EntIndex() then return end
    if IsValid(PIXEL.ItemLab.UI) then PIXEL.ItemLab.UI:Close() end
end)