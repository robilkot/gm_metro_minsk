include("shared.lua")

ENT.DigitPositions = {
    {Vector(47.5,8,-0.1)},
    {Vector(37,8,-0.1)},
    {Vector(23.6,8,-0.1)},
    {Vector(13.1,8,-0.1)},
    {Vector(1.85,8,-2.1), 0.717},
    {Vector(-5.6,8,-2.1), 0.717},
    {Vector(30.3,8,0), true},
}

function ENT:Initialize()
    self.Digits = {}
end

function ENT:ModelsInitialize()
    for k,v in pairs(self.DigitPositions) do
        local model = "models/stations/station_clock_digit.mdl"
        
        self.Digits[k] = ClientsideModel(model,RENDERGROUP_OPAQUE)
        self.Digits[k]:SetPos(self:LocalToWorld(v[1]))
        self.Digits[k]:SetAngles(self:GetAngles())
        self.Digits[k]:SetSkin(10)
        if (v[2] == true) then
            self.Digits[k]:SetSkin(11)
        else
            if (v[2] != nil) then 
                self.Digits[k]:SetModelScale(v[2]) 
            end    
            
        end
        self.Digits[k]:SetParent(self)
    end
end

function ENT:Think()
    if self:IsDormant() then self:OnRemove();return end
    
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
    local d = os.date("!*t",Metrostroi.GetSyncTime())
    self.Digits[1]:SetSkin(math.floor(d.hour / 10))
    self.Digits[2]:SetSkin(math.floor(d.hour % 10))
    self.Digits[3]:SetSkin(math.floor(d.min  / 10))
    self.Digits[4]:SetSkin(math.floor(d.min  % 10))
    self.Digits[5]:SetSkin(math.floor(d.sec  / 10))
    self.Digits[6]:SetSkin(math.floor(d.sec  % 10))
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
