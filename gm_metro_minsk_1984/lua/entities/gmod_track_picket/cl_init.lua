-----------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для Garry's Mod Metrostroi.
--	Аддон добавляет в игру пикеты.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------

include("shared.lua")

hook.Add("PostDrawOpaqueRenderables", "metrostroi_picket_debug_draw", function(isDD)
		if isDD then return end
		if GetConVarNumber("metrostroi_drawsignaldebug") == 0 then return end
		
		for _,self in pairs(ents.FindByClass("gmod_track_picket")) do
			local pos = self:LocalToWorld(Vector(0,0,0))
			local ang = self:LocalToWorldAngles(Angle(0,90,90))
			cam.Start3D2D(pos , ang, 0.25)
				surface.SetDrawColor(125, 125, 0, 255)
				surface.DrawRect(-40, -20, 80, 20)
			cam.End3D2D()
		end
end )

ENT.Models[1] = {
	model = "models/mn_signs/mn_picket_t.mdl",
	pos = Vector(0, 132.2, 125),
	angles = Angle(0, 180, 0),
    modelNumber = "models/mn_signs/mn_picket_number.mdl",
    firstNumber = {
        ["X"] = {
            pos = Vector(-1.75, -0.75, 0),
            angles = Angle(0, 0, 0),
            dis = Vector(-1.75, -1.75, 0),
        },
        ["XX"] = {
            pos = Vector(-0.75, 0.25, 0),
            angles = Angle(0, 0, 0),
            dis = Vector(-1.75, -1.75, 0),
        },
        ["XXX"] = {
            pos = Vector(0.1, 1, 0),
            angles = Angle(0, 0, 0),
            dis = Vector(-1.75, -1.75, 0),
        },
    },
}
ENT.Models[2] = {
	model = "models/mn_signs/mn_picket_t.mdl",
	pos = Vector(0, 97.2, 110),
	angles = Angle(0, 180, 0),
    modelNumber = "models/mn_signs/mn_picket_number.mdl",
    firstNumber = {
        ["X"] = {
            pos = Vector(-1.75, -0.75, 0),
            angles = Angle(0, 0, 0),
            dis = Vector(-1.75, -1.75, 0),
        },
        ["XX"] = {
            pos = Vector(-0.75, 0.25, 0),
            angles = Angle(0, 0, 0),
            dis = Vector(-1.75, -1.75, 0),
        },
        ["XXX"] = {
            pos = Vector(0.1, 1, 0),
            angles = Angle(0, 0, 0),
            dis = Vector(-1.75, -1.75, 0),
        },
    },
}
ENT.Models[3] = {
	model = "models/mn_signs/mn_picket.mdl",
	pos = Vector(0, 90, 125),
	angles = Angle(0, 180, 0),
    modelNumber = "models/mn_signs/mn_picket_number.mdl",
    firstNumber = {
        ["X"] = {
            pos = Vector(-1.75, -0.75, 0),
            angles = Angle(0, 0, 0),
            dis = Vector(-1.75, -1.75, 0),
        },
        ["XX"] = {
            pos = Vector(-0.75, 0.25, 0),
            angles = Angle(0, 0, 0),
            dis = Vector(-1.75, -1.75, 0),
        },
        ["XXX"] = {
            pos = Vector(0.1, 1, 0),
            angles = Angle(0, 0, 0),
            dis = Vector(-1.75, -1.75, 0),
        },
    },
}

function ENT:Initialize()
end

function ENT:ReceiveUpdate()
    local type = self:GetNWInt("Type", 1)
    local left = self:GetNWBool("Left", false)
    local offset = self:GetNWVector("Offset", Vector(0, 0, 0))
    local angle = self:GetNWAngle("Angle", Angle(0, 0, 0))
    local rightNumber = self:GetNWString("RightNumber", "")
    local leftNumber = self:GetNWString("LeftNumber", "")
    
	if (self.Type ~= type or self.Left ~= left or self.Offset ~= offset or self.Angle ~= angle or self.RightNumber ~= rightNumber or self.LeftNumber ~= leftNumber) then
		self.Type = type
		self.Left = left
		self.Offset = offset
        self.Angle = angle
		self.RightNumber = rightNumber
		self.LeftNumber = leftNumber
        self.ModelProp = self.Models[self.Type]
        
        return true
	end

    return false
end

function ENT:SetPicketModel()
    self.PicketModel = ClientsideModel(self.ModelProp.model, RENDERGROUP_OTHER)

    local pos = self.ModelProp.pos + self.Offset 
    local angles = self.ModelProp.angles + self.Angle

    self.PicketModel:SetParent(self)
    self.PicketModel:SetPos(self:LocalToWorld(pos))
    self.PicketModel:SetAngles(self:LocalToWorldAngles(angles))
end

function ENT:SetRightNumberModels()
    self.RightNumberModels = { }

    if (self.RightNumber == "") then return end

    self.RightNumberModels = { }

    local format = "XXX"

    if (#self.RightNumber == 1) then format = "X"
    elseif (#self.RightNumber == 2) then format = "XX"    
    end
        
    for i=1, #format do
        local pos = self.ModelProp.firstNumber[format].pos
        local angles = self.ModelProp.firstNumber[format].angles

        pos = pos + self.ModelProp.firstNumber[format].dis * (i - 1)

        local model = ClientsideModel(self.ModelProp.modelNumber, RENDERGROUP_OTHER)
        model:SetParent(self.PicketModel)
        model:SetPos(self.PicketModel:LocalToWorld(pos))
        model:SetAngles(self.PicketModel:LocalToWorldAngles(angles)) 
        model:SetSkin(self.RightNumber[i])    

        table.insert(self.RightNumberModels, model)
    end
end

function ENT:SetLeftNumberModels()
    self.LeftNumberModels = { }

    if (self.LeftNumber == "") then return end

    local format = "XXX"

    if (#self.LeftNumber == 1) then format = "X"
    elseif (#self.LeftNumber == 2) then format = "XX"    
    end
        
    for i=1, #format do
        local pos = self.ModelProp.firstNumber[format].pos 
        local angles = self.ModelProp.firstNumber[format].angles + Angle(0, -90, 0) 

        if (format == "XX") then pos = pos + Vector(0.25, 1.25, 0)
        elseif (format == "X") then pos = pos + Vector(0, 3.5, 0)
        end

        pos = pos + self.ModelProp.firstNumber[format].dis * Vector(1, -1, 1) * (i - 1)

        local model = ClientsideModel(self.ModelProp.modelNumber, RENDERGROUP_OTHER)
        model:SetParent(self.PicketModel)
        model:SetPos(self.PicketModel:LocalToWorld(pos))
        model:SetAngles(self.PicketModel:LocalToWorldAngles(angles)) 
        model:SetSkin(self.LeftNumber[i])    

        table.insert(self.LeftNumberModels, model)
    end
end

function ENT:SetLeft()
    local oldPos = self:WorldToLocal(self.PicketModel:GetPos())
    local oldAngles = self.PicketModel:GetAngles()

    oldPos = (oldPos - self.Offset * 2) * Vector(1, -1, 1)

    self.PicketModel:SetPos(self:LocalToWorld(oldPos))
    self.PicketModel:SetAngles( self.PicketModel:GetAngles() + Angle(0, 180, 0))
end

function ENT:SetRand()
    local rand = math.random(-2, 2)

    self.PicketModel:SetAngles(self.PicketModel:GetAngles() + Angle(0, 0, rand))
end

function ENT:MissingModel()
    if (not self.PicketModel) then
        return true
    end

    if (not self.RightNumberModels) then
        return true
    end

    if (not self.LeftNumberModels) then
        return true
    end

    return false
end

function ENT:RemoveModels()
    if (self.RightNumberModels) then
        for _, model in ipairs(self.RightNumberModels) do SafeRemoveEntity(model) end
	end
    if (self.LeftNumberModels) then
        for _, model in ipairs(self.LeftNumberModels) do SafeRemoveEntity(model) end
    end

    SafeRemoveEntity(self.PicketModel)

	self.PicketModel = nil
    self.LeftNumberModels = nil
    self.RightNumberModels = nil
end

function ENT:OnRemove()
	self:RemoveModels()
end

function ENT:Think()
	local remodel
    
    self:NextThink(CurTime()+5)

	if self:IsDormant() or Metrostroi and Metrostroi.ReloadClientside then
		if IsValid(self.PicketModel) then
			self:RemoveModels()
		end
		self.MustDraw = false
        
		return true
	else
		self.MustDraw = true
	end

    remodel = remodel or self:ReceiveUpdate() or self:MissingModel()
    
    if not self.ModelProp then return true end

    if (remodel) then
        

        self:RemoveModels()
        self:SetPicketModel()
        self:SetRightNumberModels()
        self:SetLeftNumberModels()
        
        if (self.Left) then
           self:SetLeft()
        end

        self:SetRand()
    end
    
    return true
end

function ENT:Draw()
end
