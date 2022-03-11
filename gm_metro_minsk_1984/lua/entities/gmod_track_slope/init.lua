AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString "metrostroi-slope"

function ENT:Initialize()
	self:DrawShadow(false)
	self:SendUpdate()
end

function ENT:OnRemove()
end

function ENT:Think()
end

function ENT:SendUpdate()
	self:SetNWInt("Type", self.Type or 1)
	self:SetNWVector("Offset", Vector(0, self.YOffset or 0, self.ZOffset or 0))
	self:SetNWAngle("Angle", Angle(self.PAngle or 0, self.YAngle or 0, 0))
	self:SetNWString("Slope value", self.Value_u or "")
	self:SetNWString("Length", self.Length or "")
end
