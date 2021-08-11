-----------------------------------------------------------------------
--	Скрипт написан в 2021 году, для дополнения Metrostroi.
--	Аддон добавляет пикеты.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
-----------------------------------------------------------------------

TOOL.Category   = "Metro"
TOOL.Name       = "Picket Tool"
TOOL.Command    = nil
TOOL.ConfigName = ""
TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" }
}

if CLIENT then
	language.Add("Tool.picket.name", "Picket Tool")
	language.Add("Tool.picket.desc", "Sets pickets")
	language.Add("Tool.picket.left", "Set/Update")
	language.Add("Tool.picket.right", "Remove")
	language.Add("Tool.picket.reload", "Scan")
end

local Types = {"Round tunnel", "Rectangle tunnel", "Common type"}

if SERVER then util.AddNetworkString "metrostroi-stool-picket" end

function TOOL:SpawnPicket(ply,trace,param)
    local pos = trace.HitPos

    -- Use some code from rerailer
    local tr = Metrostroi.RerailGetTrackData(pos,ply:GetAimVector())
    if not tr then return end

    -- Create self.Picket entity
    local ent
    local found = false
    local entlist = ents.FindInSphere(pos,64)
    for k,v in pairs(entlist) do
        if v:GetClass() == "gmod_track_picket" then
            ent = v
            found = true
        end
    end

    if not ent then ent = ents.Create("gmod_track_picket") end
    if IsValid(ent) then

        ent:SetPos(tr.centerpos - tr.up * 9.5)
        ent:SetAngles((-tr.right):Angle() + Angle(0,90,0))
        
        ent.Type = self.Picket.Type
        ent.Left = self.Picket.Left
        ent.YOffset = self.Picket.YOffset
        ent.ZOffset = self.Picket.ZOffset
        ent.PAngle = self.Picket.PAngle
        ent.YAngle = self.Picket.YAngle
        ent.RightNumber = self.Picket.RightNumber
        ent.LeftNumber = (self.Picket.LeftNumberCheck) and self.Picket.LeftNumber or self.Picket.RightNumber
        ent:SendUpdate()

        if not found then
            ent:Spawn()
            -- Add to undo
            undo.Create("picket")
                undo.AddEntity(ent)
                undo.SetPlayer(ply)
            undo.Finish()
        end
    end
    return ent
end

function TOOL:GetPicket(ply,trace)
    local ent
    local pos = trace.HitPos

    local entlist = ents.FindInSphere(pos,64)
    for k,v in pairs(entlist) do
        if v:GetClass() == "gmod_track_picket" then
            ent = v
        end
    end

    return ent
end

function TOOL:LeftClick(trace)
    if CLIENT then
        return true
    end

    local ply = self:GetOwner()
    if (ply:IsValid()) and (not ply:IsAdmin()) then return false end
    if not trace then return false end
    if trace.Entity and trace.Entity:IsPlayer() then return false end
  
     ent = self:SpawnPicket(ply,trace)

    return true
end


function TOOL:RightClick(trace)
    if CLIENT then
        return true
    end

    local ply = self:GetOwner()
    if (ply:IsValid()) and (not ply:IsAdmin()) then return false end
    if not trace then return false end
    if trace.Entity and trace.Entity:IsPlayer() then return false end

    local entlist = ents.FindInSphere(trace.HitPos,(self.Type == 3 and self.Auto.Type == 5) and 192 or 64)
    for k,v in pairs(entlist) do
        if v:GetClass() == "gmod_track_picket" then
            if IsValid(v) then SafeRemoveEntity(v) end
        end
    end
    return true
end

function TOOL:Reload(trace)
    if CLIENT then return true end
    
    local ply = self:GetOwner()
    
    if not trace then return false end
    if trace.Entity and trace.Entity:IsPlayer() then return false end
    
    local ent = self:GetPicket(ply, trace)

    if (not ent ) then return true end

    self.Picket.Type = ent.Type
    self.Picket.Left = ent.Left
    self.Picket.YOffset = ent.YOffset
    self.Picket.ZOffset = ent.ZOffset
    self.Picket.PAngle = ent.PAngle
    self.Picket.YOffset = ent.YOffset 
    self.Picket.RightNumber = ent.RightNumber
    self.Picket.LeftNumber = ent.LeftNumber

    net.Start("metrostroi-stool-picket")
        net.WriteTable(self.Picket)
    net.Send(self:GetOwner())

    return true
end

function TOOL:SendSettings()
    if not self.Picket then return end

    net.Start "metrostroi-stool-picket"
        net.WriteTable(self.Picket)
    net.SendToServer()
end

net.Receive("metrostroi-stool-picket", function(_, ply)
    local TOOL = LocalPlayer and LocalPlayer():GetTool("picket") or ply:GetTool("picket")
    TOOL.Picket = net.ReadTable()
    if CLIENT then
        NeedUpdate = true
    end
end)

function TOOL:BuildCPanelCustom()
    local tool = self
    local CPanel = controlpanel.Get("picket")
    if not CPanel then return end

    CPanel:ClearControls()
    CPanel:SetPadding(0)
    CPanel:SetSpacing(0)
    CPanel:Dock( FILL )

    local VType = vgui.Create("DComboBox")
    VType:ChooseOption(Types[self.Picket.Type or 1], self.Picket.Type or 1)
    VType:SetColor(color_black)
    for i = 1, 3 do
        VType:AddChoice(Types[i])
    end
    VType.OnSelect = function(_, index, name)
        VType:SetValue(name)
        tool.Picket.Type = index
        tool:SendSettings()
    end
    CPanel:AddItem(VType)

    local VRightNum = CPanel:TextEntry("Right number:")
    VRightNum:SetValue(tool.Picket.RightNumber or "")
    function VRightNum:OnChange()
        local value = self:GetValue()
        local newValue = ""
        for i = 1, #value do
            if ( ('0' <= value[i] and value[i] <= '9') and #newValue <= 2 ) then
                newValue = newValue..value[i] 
            end
        end
        self:SetText(newValue)
        self:SetCaretPos(#newValue)
        tool.Picket.RightNumber = self:GetValue()
        tool:SendSettings()
    end
    
    if (tool.Picket.LeftNumberCheck) then
        local VLeftNum = CPanel:TextEntry("Left number:")
        VLeftNum:SetValue(tool.Picket.LeftNumber or "")
        function VLeftNum:OnChange()
            local value = self:GetValue()
            local newValue = ""
            for i = 1, #value do
                if ( ('0' <= value[i] and value[i] <= '9') and #newValue <= 2 ) then
                    newValue = newValue..value[i] 
                end
            end
            self:SetText(newValue)
            self:SetCaretPos(#newValue)
            tool.Picket.LeftNumber = VLeftNum:GetValue()
            tool:SendSettings()
        end
    end

    local VLeftNumberCheck = CPanel:CheckBox("Left number")
    VLeftNumberCheck:SetValue(tool.Picket.LeftNumberCheck or false)
    function VLeftNumberCheck:OnChange()
        tool.Picket.LeftNumberCheck = self:GetChecked()
        tool:SendSettings()
        tool:BuildCPanelCustom()
    end

    local VYOffT = CPanel:NumSlider("Y Offset:",nil,-100,100,0)
    VYOffT:SetValue(tool.Picket.YOffset or 0)
    VYOffT.OnValueChanged = function(num)
        tool.Picket.YOffset = VYOffT:GetValue()
        tool:SendSettings()
    end

    local VZOffT = CPanel:NumSlider("Z Offset:",nil,-50,50,0)
    VZOffT:SetValue(tool.Picket.ZOffset or 0)
    VZOffT.OnValueChanged = function(num)
        tool.Picket.ZOffset = VZOffT:GetValue()
        tool:SendSettings()
    end

    local VPAngle = CPanel:NumSlider("Pitch angle:",nil,-90,90,0)
    VPAngle:SetValue(tool.Picket.PAngle or 0)
    VPAngle.OnValueChanged = function(num)
        tool.Picket.PAngle = VPAngle:GetValue()
        tool:SendSettings()
    end

    local VYAngle = CPanel:NumSlider("Yaw angle:",nil,-90,90,0)
    VYAngle:SetValue(tool.Picket.YAngle or 0)
    VYAngle.OnValueChanged = function(num)
        tool.Picket.YAngle = VYAngle:GetValue()
        tool:SendSettings()
    end

    local VLeftOC = CPanel:CheckBox("Left side(if can be left-side)")
    VLeftOC:SetTooltip("Left side")
    VLeftOC:SetValue(tool.Picket.Left or false)
    function VLeftOC:OnChange()
        tool.Picket.Left = self:GetChecked()
        tool:SendSettings()
    end
end

TOOL.NotBuilt = true
function TOOL:Think()
    if CLIENT and (self.NotBuilt or NeedUpdate) then
        self.Picket = self.Picket or util.JSONToTable(string.Replace(GetConVarString("piсket"),"'","\"")) or {}
        self:SendSettings()
        self:BuildCPanelCustom()
        self.NotBuilt = false
        NeedUpdate = false
    end
end
function TOOL.BuildCPanel(panel)
    panel:AddControl("Header", { Text = "#Tool.picket.name", Description = "#Tool.picket.desc" })
    if not self then return end
    self:BuildCPanelCustom()
end