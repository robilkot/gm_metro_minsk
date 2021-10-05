AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:EntIndex()
	self:SetModel("models/stations/station_clock.mdl")
end
