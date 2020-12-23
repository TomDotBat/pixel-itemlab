
include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:DrawTranslucent()
    self:DrawModel()
    PIXEL.DrawEntOverhead(self, self.ItemLabName, nil, nil, 0.032)
end