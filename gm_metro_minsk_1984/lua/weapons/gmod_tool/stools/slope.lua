TOOL.Category   = "Metro"
TOOL.Name       = "Slope Tool"
TOOL.Command    = nil
TOOL.ConfigName = ""
TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" }
}

if CLIENT then
	language.Add("Tool.Slope.name", "Slope Tool")
	language.Add("Tool.Slope.desc", "Sets Slope")
	language.Add("Tool.Slope.left", "Set/Update")
	language.Add("Tool.Slope.right", "Remove")
	language.Add("Tool.Slope.reload", "Scan")
end

local Types = {"Down left", "Flat left", "Up left", "Down right", "Flat right", "Up right"}

if SERVER then util.AddNetworkString "metrostroi-stool-slope" end

function TOOL:SpawnUnkon(ply,trace,param)
    local pos = trace.HitPos

    -- Use some code from rerailer
    local tr = Metrostroi.RerailGetTrackData(pos,ply:GetAimVector())
    if not tr then return end

    -- Create self.Slope entity
    local ent
    local found = false
    local entlist = ents.FindInSphere(pos,64)
    for k,v in pairs(entlist) do
        if v:GetClass() == "gmod_track_slope" then
            ent = v
            found = true
        end
    end

    if not ent then ent = ents.Create("gmod_track_slope") end
    if IsValid(ent) then

        ent:SetPos(tr.centerpos - tr.up * 9.5)
        ent:SetAngles((-tr.right):Angle() + Angle(0,90,0))
        
        ent.Type = self.Slope.Type
        ent.YOffset = self.Slope.YOffset
        ent.ZOffset = self.Slope.ZOffset
        ent.PAngle = self.Slope.PAngle
        ent.YAngle = self.Slope.YAngle
        ent.Value_u = self.Slope.Value_u
        ent.Length = self.Slope.Length
        ent:SendUpdate()

        if not found then
            ent:Spawn()
            -- Add to undo
            undo.Create("slope")
                undo.AddEntity(ent)
                undo.SetPlayer(ply)
            undo.Finish()
        end
    end
    return ent
end

function TOOL:GetSlope(ply,trace)
    local ent
    local pos = trace.HitPos

    local entlist = ents.FindInSphere(pos,64)
    for k,v in pairs(entlist) do
        if v:GetClass() == "gmod_track_slope" then
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
  
     ent = self:SpawnUnkon(ply,trace)

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
        if v:GetClass() == "gmod_track_slope" then
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

    self.Slope.Type = ent.Type
    self.Slope.YOffset = ent.YOffset
    self.Slope.ZOffset = ent.ZOffset
    self.Slope.PAngle = ent.PAngle
    self.Slope.YOffset = ent.YOffset 
    self.Slope.Value_u = ent.Value_u
    self.Slope.Length = ent.Length

    net.Start("metrostroi-stool-slope")
        net.WriteTable(self.Slope)
    net.Send(self:GetOwner())

    return true
end

function TOOL:SendSettings()
    if not self.Slope then return end

    net.Start "metrostroi-stool-slope"
        net.WriteTable(self.Slope)
    net.SendToServer()
end

net.Receive("metrostroi-stool-slope", function(_, ply)
    local TOOL = LocalPlayer and LocalPlayer():GetTool("slope") or ply:GetTool("slope")
    TOOL.Slope = net.ReadTable()
    if CLIENT then
        NeedUpdate = true
    end
end)

function TOOL:BuildCPanelCustom()
    local tool = self
    local CPanel = controlpanel.Get("slope")
    if not CPanel then return end

    CPanel:ClearControls()
    CPanel:SetPadding(0)
    CPanel:SetSpacing(0)
    CPanel:Dock( FILL )

    local VType = vgui.Create("DComboBox")
    VType:ChooseOption(Types[self.Slope.Type or 1], self.Slope.Type or 1)
    VType:SetColor(color_black)
    for i = 1, 6 do
        VType:AddChoice(Types[i])
    end
    VType.OnSelect = function(_, index, name)
        VType:SetValue(name)
        tool.Slope.Type = index
        tool:SendSettings()
    end
    CPanel:AddItem(VType)

    local VValue_u = CPanel:TextEntry("Value slope")
    VValue_u:SetValue(tool.Slope.Value_u or "")
    function VValue_u:OnChange()
        local value = self:GetValue()
        local newValue = ""
        for i = 1, #value do
            if ( ('0' <= value[i] and value[i] <= '9') and #newValue <= 2 ) then
                newValue = newValue..value[i] 
            end
        end
        self:SetText(newValue)
        self:SetCaretPos(#newValue)
        tool.Slope.Value_u = self:GetValue()
        tool:SendSettings()
    end
    
    local VLength = CPanel:TextEntry("Length")
    VLength:SetValue(tool.Slope.Length or "")
    function VLength:OnChange()
        local value = self:GetValue()
        local newValue = ""
        for i = 1, #value do
            if ( ('0' <= value[i] and value[i] <= '9') and #newValue <= 3 ) then
                newValue = newValue..value[i] 
            end
        end
        self:SetText(newValue)
        self:SetCaretPos(#newValue)
        tool.Slope.Length = self:GetValue()
        tool:SendSettings()
    end

    local VYOffT = CPanel:NumSlider("Y Offset:",nil,-50,50,0)
    VYOffT:SetValue(tool.Slope.YOffset or 0)
    VYOffT.OnValueChanged = function(num)
        tool.Slope.YOffset = VYOffT:GetValue()
        tool:SendSettings()
    end

    local VZOffT = CPanel:NumSlider("Z Offset:",nil,-100,100,0)
    VZOffT:SetValue(tool.Slope.ZOffset or 0)
    VZOffT.OnValueChanged = function(num)
        tool.Slope.ZOffset = VZOffT:GetValue()
        tool:SendSettings()
    end

    local VPAngle = CPanel:NumSlider("Pitch angle:",nil,-10,10,0)
    VPAngle:SetValue(tool.Slope.PAngle or 0)
    VPAngle.OnValueChanged = function(num)
        tool.Slope.PAngle = VPAngle:GetValue()
        tool:SendSettings()
    end

    local VYAngle = CPanel:NumSlider("Yaw angle:",nil,-15,15,0)
    VYAngle:SetValue(tool.Slope.YAngle or 0)
    VYAngle.OnValueChanged = function(num)
        tool.Slope.YAngle = VYAngle:GetValue()
        tool:SendSettings()
    end

end

TOOL.NotBuilt = true
function TOOL:Think()
    if CLIENT and (self.NotBuilt or NeedUpdate) then
        self.Slope = self.Slope or util.JSONToTable(string.Replace(GetConVarString("slope"),"'","\"")) or {}
        self:SendSettings()
        self:BuildCPanelCustom()
        self.NotBuilt = false
        NeedUpdate = false
    end
end
function TOOL.BuildCPanel(panel)
    panel:AddControl("Header", { Text = "#Tool.slope.name", Description = "#Tool.slope.desc" })
    if not self then return end
    self:BuildCPanelCustom()
end