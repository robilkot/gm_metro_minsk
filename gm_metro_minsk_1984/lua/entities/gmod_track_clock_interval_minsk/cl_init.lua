include("shared.lua")

ENT.DigitPositions = {
    {Vector(-25.2,8,-1.1)},
    {Vector(-38.8,8,-1.1)},
    {Vector(-49.25,8,-1.1)},
    {Vector(-31.9,8,-1),true},
}

function ENT:Initialize()
    self.Digits = {}
end

function ENT:ModelsInitialize()
    for k, v in pairs(self.DigitPositions) do
        if not IsValid(self.Digits[k]) then
            local model = "models/stations/station_clock_digit.mdl"

            self.Digits[k] = ClientsideModel(model, RENDERGROUP_OPAQUE)
            self.Digits[k]:SetPos(self:LocalToWorld(v[1]))
            self.Digits[k]:SetAngles(self:GetAngles())
            self.Digits[k]:SetSkin(10)
            if (v[2] == true) then
                self.Digits[k]:SetSkin(11)
            end
            self.Digits[k]:SetParent(self)
        end
    end
end

function ENT:Think()
    if self:IsDormant() then
        self:OnRemove()
        return
    end

    if (not self:ModelsIsValid()) then
        self:ModelsInitialize()
    else
        self:TimeUpdate()
    end
end

function ENT:ModelsIsValid()
    for k, _ in pairs(self.DigitPositions) do
        if not IsValid(self.Digits[k]) then return false end
    end
    
    return true 
end

function ENT:TimeUpdate()
    local dT = Metrostroi.GetTimedT()
    local interval = Metrostroi.GetSyncTime() - (self:GetIntervalResetTime() + GetGlobalFloat("MetrostroiTY"))

    if (interval <= (9 * 60 + 59)) and (interval >= 0) then
        self.Digits[1]:SetSkin(math.floor(interval / 60))
        self.Digits[2]:SetSkin(math.floor((interval % 60) / 10))
        local seconds = math.floor((interval % 60) % 10)
        if (seconds % 5 == 0) then
            self.Digits[3]:SetSkin(seconds)
        end
    else
        for i=1,3 do
            self.Digits[i]:SetSkin(10)
        end
    end
end

function ENT:ModelsOnRemove()
    for _,v in pairs(self.Digits) do
        SafeRemoveEntity(v)
    end
end

function ENT:OnRemove()
    self:ModelsOnRemove()
end

function ENT:Draw()
    self:DrawModel()
end
