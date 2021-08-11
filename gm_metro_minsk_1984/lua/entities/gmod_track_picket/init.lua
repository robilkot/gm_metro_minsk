-----------------------------------------------------------------------
--	Скрипт написан в 2021 году, для дополнения Metrostroi.
--	Аддон добавляет пикеты.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
-----------------------------------------------------------------------

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString "metrostroi-picket"

local models = {
	"models/mn_signs/mn_picket.mdl",
	"models/mn_signs/mn_picket_t.mdl",
}

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
	self:SetNWBool("Left", self.Left or false)
	self:SetNWString("RightNumber", self.RightNumber or "")
	self:SetNWString("LeftNumber", self.LeftNumber or "")
end
