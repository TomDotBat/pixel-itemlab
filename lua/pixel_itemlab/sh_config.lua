
--id, name, model, model scale (1)
PIXEL.ItemLab.Ingredient("energydrink", "Not\nMonster Energy", "models/props_junk/PopCan01a.mdl")
PIXEL.ItemLab.Ingredient("pan", "Frying Pan", "models/props_c17/metalPot002a.mdl")
PIXEL.ItemLab.Ingredient("cactus", "Cactus", "models/props_lab/cactus.mdl")
PIXEL.ItemLab.Ingredient("melon", "Melon", "models/props_junk/watermelon01.mdl")
PIXEL.ItemLab.Ingredient("clock", "A Big\nWatch", "models/props_trainstation/trainstation_clock001.mdl")
PIXEL.ItemLab.Ingredient("sign", "Road Sign", "models/props_c17/streetsign004f.mdl")
PIXEL.ItemLab.Ingredient("baby", "Your Mum", "models/props_c17/doll01.mdl")
PIXEL.ItemLab.Ingredient("boot", "Boot", "models/props_junk/Shoe001a.mdl")
PIXEL.ItemLab.Ingredient("huladoll", "Hula Doll", "models/props_lab/huladoll.mdl")
PIXEL.ItemLab.Ingredient("phone", "Phone", "models/props_trainstation/payphone_reciever001a.mdl")
PIXEL.ItemLab.Ingredient("monitor", "Gaming Monitor", "models/props_lab/monitor01a.mdl")
PIXEL.ItemLab.Ingredient("bicycle", "Bicycle", "models/props_junk/bicycle01a.mdl")
PIXEL.ItemLab.Ingredient("cone", "Traffic Cone", "models/props_junk/TrafficCone001a.mdl")
PIXEL.ItemLab.Ingredient("bin", "Wheelie Bin", "models/props_junk/TrashBin01a.mdl")
PIXEL.ItemLab.Ingredient("hook", "Hook", "models/props_junk/meathook001a.mdl")
PIXEL.ItemLab.Ingredient("bleach", "Bleach", "models/props_junk/garbage_plasticbottle001a.mdl")
PIXEL.ItemLab.Ingredient("briefcase", "Hentai", "models/props_c17/SuitCase_Passenger_Physics.mdl")
PIXEL.ItemLab.Ingredient("vibrator", "Vibrator", "models/Items/combine_rifle_cartridge01.mdl")

--id, name, model, scale (1), onCraft (optional), entOverrides (optional)
PIXEL.ItemLab.Item("crap", "Pointless Piece\nOf Crap", "models/props_junk/PopCan01a.mdl", 1, function(item, lab, owner)
    item:Ignite(6, 100)

    timer.Simple(5, function()
        if not IsValid(item) then return end

        local effectdata = EffectData()
        effectdata:SetOrigin(item:GetPos())
        util.Effect("HelicopterMegaBomb", effectdata)

        util.BlastDamage(item, item, item:GetPos(), 300, 10)
        util.ScreenShake(item:GetPos(), 5, 8, 3, 500)
        item:EmitSound("BaseExplosionEffect.Sound")

        SafeRemoveEntity(item)
    end)
end)

PIXEL.ItemLab.Item("health25", "Health Pod", "models/Items/combine_rifle_ammo01.mdl", 1, nil, {
    Use = function(self, ply)
        local curHealth, maxHealth = ply:Health(), ply:GetMaxHealth()
        if curHealth >= maxHealth then return end
        ply:SetHealth(math.min(curHealth + 25, maxHealth))

        local soundEffect = CreateSound(self, "items/smallmedkit1.wav")
        soundEffect:SetSoundLevel(70)
        soundEffect:Play()

        SafeRemoveEntity(self)
    end
})

PIXEL.ItemLab.Item("health50", "Health Booster", "models/healthvial.mdl", 1, nil, {
    Use = function(self, ply)
        local curHealth, maxHealth = ply:Health(), ply:GetMaxHealth()
        if curHealth >= maxHealth then return end
        ply:SetHealth(math.min(curHealth + 50, maxHealth))

        local soundEffect = CreateSound(self, "items/smallmedkit1.wav")
        soundEffect:SetSoundLevel(70)
        soundEffect:Play()

        SafeRemoveEntity(self)
    end
})

PIXEL.ItemLab.Item("healthmax", "Health Kit", "models/Items/HealthKit.mdl", 1, nil, {
    Use = function(self, ply)
        local maxHealth = ply:GetMaxHealth()
        if ply:Health() >= maxHealth then return end
        ply:SetHealth(ply:GetMaxHealth())

        local soundEffect = CreateSound(self, "items/smallmedkit1.wav")
        soundEffect:SetSoundLevel(70)
        soundEffect:Play()

        SafeRemoveEntity(self)
    end
})

PIXEL.ItemLab.Item("armor25", "Armour Booster", "models/Items/battery.mdl", 1, nil, {
    Use = function(self, ply)
        local curArmor, maxArmor = ply:Armor(), ply:GetMaxArmor()
        if curArmor >= maxArmor then return end
        ply:SetArmor(math.min(curArmor + 25, maxArmor))

        local soundEffect = CreateSound(self, "items/battery_pickup.wav")
        soundEffect:SetSoundLevel(70)
        soundEffect:Play()

        SafeRemoveEntity(self)
    end
})

PIXEL.ItemLab.Item("armor50", "Armour Battery", "models/Items/car_battery01.mdl", 1, nil, {
    Use = function(self, ply)
        local curArmor, maxArmor = ply:Armor(), ply:GetMaxArmor()
        if curArmor >= maxArmor then return end
        ply:SetArmor(math.min(curArmor + 50, maxArmor))

        local soundEffect = CreateSound(self, "items/battery_pickup.wav")
        soundEffect:SetSoundLevel(70)
        soundEffect:Play()

        SafeRemoveEntity(self)
    end
})

local function findFadingDoorsInSphere(pos, radius)
    if not (bKeypads and bKeypads.FadingDoors and istable(bKeypads.FadingDoors.Links)) then return end

    local results = {}
    radius = radius ^ 2

    for _, ent in ipairs(bKeypads.FadingDoors.Links) do
        if ent:GetPos():DistToSqr(pos) > radius then continue end
        if not bKeypads.FadingDoors:IsFadingDoor(ent) then continue end
        table.insert(results, ent)
    end

    return results
end

PIXEL.ItemLab.Item("fadedoorbomb", "Fading Door Bomb", "models/props_junk/PropaneCanister001a.mdl", 1, nil, {
    Use = function(self, ply)
        for k, ent in pairs(ents.FindInSphere(self:GetPos(), 100)) do
            if ent.isFadingDoor and ent.fadeActivate and not ent.fadeActive then
                ent:fadeActivate();
                if IsFirstTimePredicted() then
                    timer.Simple(5, function()
                        if IsValid(ent) and ent.fadeActive then
                            ent:fadeDeactivate();
                        end
                    end)
                end
            end
        end

        local vPoint = self:GetPos();
        local effectdata = EffectData();
        effectdata:SetStart(vPoint);
        effectdata:SetOrigin(vPoint);
        effectdata:SetScale(1);
        util.Effect("Explosion", effectdata, true, true);

        SafeRemoveEntity(self)
    end
})

local meta = FindMetaTable("Player")

function meta:CanUseItemLab(entity)
    if self:GetPos():DistToSqr(entity:GetPos()) > 25000 then return false end --Player is too far away
    return true
    --[[local owner = entity:CPPIGetOwner()
    if not IsValid(owner) then return true end --Not player owned
    if owner == self then return true end --Player is lab owner

    local friends = owner.CPPIGetFriends and owner:CPPIGetFriends() or false
    if not friends then return false end

    for _, ply in ipairs(friends) do
        if ply == self then return true end --Player is friends with lab owner
    end

    return false]]--
end

PIXEL.ItemLab.Item("fbiopenup", "FBI Open Up", "models/props_junk/PopCan01a.mdl", 1, function(item, lab, owner)
    local effectdata = EffectData()
    effectdata:SetOrigin(item:GetPos())
    util.Effect("HelicopterMegaBomb", effectdata)

    util.ScreenShake(item:GetPos(), 5, 8, 3, 500)
    item:EmitSound("BaseExplosionEffect.Sound")

    if IsValid(owner) and owner:IsPlayer() then
        owner:wanted(nil, "Experimenting with the wrong things...")
    end

    SafeRemoveEntity(item)
end)