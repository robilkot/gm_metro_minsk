include("shared.lua")

hook.Add("PostDrawOpaqueRenderables", "metrostroi_slope_debug_draw", function(isDD)
		if isDD then return end
		if GetConVarNumber("metrostroi_drawsignaldebug") == 0 then return end
		
		for _,self in pairs(ents.FindByClass("gmod_track_slope")) do
			local pos = self:LocalToWorld(Vector(0,0,0))
			local ang = self:LocalToWorldAngles(Angle(0,90,90))
			cam.Start3D2D(pos , ang, 0.25)
				surface.SetDrawColor(125, 125, 0, 255)
				surface.DrawRect(-40, -20, 80, 20)
			cam.End3D2D()
		end
end )

--- сюда заносить цифры и обозначения (модели) ---

ENT.Models[1] = {
	model = "models/mn_signs/mn_sign_slope_down_l.mdl",
	pos = Vector(0, -110, 125),
	angles = Angle(0, 0, 0),
    modelNumber = "models/mn_signs/mn_sign_slope_number.mdl",
    firstNumber = {
        ["X"] = {
            pos = Vector(0.3, 17.25, -6.275),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, -1.15),
        },
        ["XX"] = {
            pos = Vector(0.3, 16, -5.7),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, -1.15),
        },
        ["XXX"] = {
            pos = Vector(0.3, 14.75, -5.125),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, -1.15),
        },
        ["XXXX"] = {
            pos = Vector(0.3, 13.5, -4.55),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, -1.15),
        },
    },
	secondNumber = {
		["Y"] = {
            pos = Vector(0.3, 17.25, 2.7),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, -1.15),
        },
        ["YY"] = {
            pos = Vector(0.3, 16.5, 3.3),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, -1.15),
        },
    },
}
ENT.Models[2] = {
	model = "models/mn_signs/mn_sign_slope_flat_l.mdl",
	pos = Vector(0, -85, 125),
	angles = Angle(0, 0, 0),
    modelNumber = "models/mn_signs/mn_sign_slope_number.mdl",
    firstNumber = {
        ["X"] = {
            pos = Vector(0.3, -6.75, -3.4),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 0),
        },
        ["XX"] = {
            pos = Vector(0.3, -8, -3.4),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 0),
        },
        ["XXX"] = {
            pos = Vector(0.3, -9.25, -3.4),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 0),
        },
        ["XXXX"] = {
            pos = Vector(0.3, -10.5, -3.4),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 0),
        },
    },
	secondNumber = {
		["Y"] = {
            pos = Vector(0.3, -6.75, 5.5),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 0),
        },
        ["YY"] = {
            pos = Vector(0.3, -8, 5.5),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 0),
        },
    },
}
ENT.Models[3] = {
	model = "models/mn_signs/mn_sign_slope_up_l.mdl",
	pos = Vector(0, -110, 125),
	angles = Angle(0, 0, 0),
    modelNumber = "models/mn_signs/mn_sign_slope_number.mdl",
    firstNumber = {
        ["X"] = {
            pos = Vector(0.3, 17.25, -1.025),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 1.15),
        },
        ["XX"] = {
            pos = Vector(0.3, 16, -1.6),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 1.15),
        },
        ["XXX"] = {
            pos = Vector(0.3, 14.75, -2.175),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 1.15),
        },
        ["XXXX"] = {
            pos = Vector(0.3, 13.5, -2.75),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 1.15),
        },
    },
	secondNumber = {
		["Y"] = {
            pos = Vector(0.3, 17.25, 8),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 1.15),
        },
        ["YY"] = {
            pos = Vector(0.3, 16, 7.5),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 1.15),
        },
    },
}
ENT.Models[4] = {
	model = "models/mn_signs/mn_sign_slope_down_r.mdl",
	pos = Vector(0, 108, 125),
	angles = Angle(0, 0, 0),
    modelNumber = "models/mn_signs/mn_sign_slope_number.mdl",
    firstNumber = {
        ["X"] = {
            pos = Vector(0.3, -17.25, -6.025),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 1.15),
        },
        ["XX"] = {
            pos = Vector(0.3, -18.5, -6.6),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 1.15),
        },
        ["XXX"] = {
            pos = Vector(0.3, -19.75, -7.175),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 1.15),
        },
        ["XXXX"] = {
            pos = Vector(0.3, -21, -7.75),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 1.15),
        },
    },
	secondNumber = {
		["Y"] = {
            pos = Vector(0.3, -17.25, 2.825),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 1.15),
        },
        ["YY"] = {
            pos = Vector(0.3, -18.5, 2.25),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 1.15),
        },
    },
}
ENT.Models[5] = {
	model = "models/mn_signs/mn_sign_slope_flat_r.mdl",
	pos = Vector(0, 85, 125),
	angles = Angle(0, 0, 0),
    modelNumber = "models/mn_signs/mn_sign_slope_number.mdl",
    firstNumber = {
        ["X"] = {
            pos = Vector(0.3, 6.75, -3.25),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 0),
        },
        ["XX"] = {
            pos = Vector(0.3, 5.5, -3.25),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 0),
        },
        ["XXX"] = {
            pos = Vector(0.3, 4.25, -3.25),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 0),
        },
        ["XXXX"] = {
            pos = Vector(0.3, 3, -3.25),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 0),
        },
    },
	secondNumber = {
		["Y"] = {
            pos = Vector(0.3, 6.75, 5.775),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 0),
        },
        ["YY"] = {
            pos = Vector(0.3, 5.5, 5.775),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, 0),
        },
    },
}
ENT.Models[6] = {
	model = "models/mn_signs/mn_sign_slope_up_r.mdl",
	pos = Vector(0, 85, 125),
	angles = Angle(0, 0, 0),
    modelNumber = "models/mn_signs/mn_sign_slope_number.mdl",
    firstNumber = {
        ["X"] = {
            pos = Vector(0.3, 6.5, -0.725),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, -1.15),
        },
        ["XX"] = {
            pos = Vector(0.3, 5.25, -0.15),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, -1.15),
        },
        ["XXX"] = {
            pos = Vector(0.3, 4, 0.425),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, -1.15),
        },
        ["XXXX"] = {
            pos = Vector(0.3, 2.75, 1),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, -1.15),
        },
    },
	secondNumber = {
		["Y"] = {
            pos = Vector(0.3, 6.5, 8.175),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, -1.15),
        },
        ["YY"] = {
            pos = Vector(0.3, 5.25, 8.75),
            angles = Angle(0, 180, 0),
            dis = Vector(0, 2.5, -1.15),
        },
    },
}
------

function ENT:Initialize()
end

function ENT:ReceiveUpdate()
    local type = self:GetNWInt("Type", 1)
    local offset = self:GetNWVector("Offset", Vector(0, 0, 0))
    local angle = self:GetNWAngle("Angle", Angle(0, 0, 0))
    local value_u = self:GetNWString("Value_u", "")
    local length = self:GetNWString("Length", "")
    
	if (self.Type ~= type or self.Offset ~= offset or self.Angle ~= angle or self.Value_u ~= value_u or self.Length ~= length) then
		self.Type = type
		self.Offset = offset
        self.Angle = angle
		self.Value_u = value_u
		self.Length = length
        self.ModelProp = self.Models[self.Type]
        
        return true
	end

    return false
end

function ENT:SetUklonModel()
    self.UklonModel = ClientsideModel(self.ModelProp.model, RENDERGROUP_OTHER)

    local pos = self.ModelProp.pos + self.Offset 
    local angles = self.ModelProp.angles + self.Angle

    self.UklonModel:SetParent(self)
    self.UklonModel:SetPos(self:LocalToWorld(pos))
    self.UklonModel:SetAngles(self:LocalToWorldAngles(angles))
end

----- тут надо подумать ??? ---

function ENT:SetLengthModels()
    self.LengthModels = { }

    if (self.Length == "") then return end

    self.LengthModels = { }

    local format = "XXXX"

    if (#self.Length == 1) then format = "X"
    elseif (#self.Length == 2) then format = "XX"     
	elseif (#self.Length == 3) then format = "XXX" 
    end
        
    for i=1, #format do
        local pos = self.ModelProp.firstNumber[format].pos
        local angles = self.ModelProp.firstNumber[format].angles

        pos = pos + self.ModelProp.firstNumber[format].dis * (i - 1)

        local model = ClientsideModel(self.ModelProp.modelNumber, RENDERGROUP_OTHER)
        model:SetParent(self.UklonModel)
        model:SetPos(self.UklonModel:LocalToWorld(pos))
        model:SetAngles(self.UklonModel:LocalToWorldAngles(angles)) 
        model:SetSkin(self.Length[i])    

        table.insert(self.LengthModels, model)
    end
end

function ENT:SetValue_uModels()
    self.Value_uModels = { }

    if (self.Value_u == "") then return end

    self.Value_uModels = { }

    local format = "YY"

    if (#self.Value_u == 1) then format = "Y" end
        
    for i=1, #format do
        local pos = self.ModelProp.secondNumber[format].pos
        local angles = self.ModelProp.secondNumber[format].angles

        pos = pos + self.ModelProp.secondNumber[format].dis * (i - 1)

        local model = ClientsideModel(self.ModelProp.modelNumber, RENDERGROUP_OTHER)
        model:SetParent(self.UklonModel)
        model:SetPos(self.UklonModel:LocalToWorld(pos))
        model:SetAngles(self.UklonModel:LocalToWorldAngles(angles)) 
        model:SetSkin(self.Value_u[i])    

        table.insert(self.Value_uModels, model)
    end
end

function ENT:SetRand()
    local rand = math.random(-2, 2)

    self.UklonModel:SetAngles(self.UklonModel:GetAngles() + Angle(0, 0, rand))
end
---
function ENT:MissingModel()
    if (not self.UklonModel) then
        return true
    end

    if (not self.LengthModels) then
        return true
    end

    if (not self.Value_uModels) then
        return true
    end

    return false
end

function ENT:RemoveModels()
    if (self.LengthModels) then
        for _, model in ipairs(self.LengthModels) do SafeRemoveEntity(model) end
	end
    if (self.Value_uModels) then
        for _, model in ipairs(self.Value_uModels) do SafeRemoveEntity(model) end
    end

    SafeRemoveEntity(self.UklonModel)

	self.UklonModel = nil
    self.Value_uModels = nil
    self.LengthModels = nil
end

function ENT:OnRemove()
	self:RemoveModels()
end

function ENT:Think()
	local remodel
    self:NextThink(CurTime()+5)

	if self:IsDormant() or Metrostroi and Metrostroi.ReloadClientside then
		if IsValid(self.UklonModel) then
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
        self:SetUklonModel()
        self:SetLengthModels()
        self:SetValue_uModels()

        self:SetRand()
    end
    
    return true
end

function ENT:Draw()
end
