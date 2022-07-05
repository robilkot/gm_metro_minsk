-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2022 году для карты gm_metro_minsk_1984.
--	Аддон добавляет станционные пульты управления функционалом карты.
--  Данный файл отвечает за клиентскую часть ентити пульта (gmod_station_pult). 
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------

include("shared.lua")

net.Receive( "station-pults-initizlize", function()
    for _, pult in ipairs(ents.FindByClass("gmod_station_pult")) do
        pult:ButtonsInitialize()
    end
end)

-- Print format error.
-- (entity) - Button entity.
-- (message) - Error massege. 
local function logError(entity, message)
    if (Minsk and Minsk.Logger) then
        Minsk.Logger.LogError(message, "Station pults client")
    end
end

-- List of buttons.
ENT.ButtonsList = {}

-- Initizlize pult client entity.
function ENT:Initialize()
    self:ButtonsInitialize()
end

-- Initialize buttons.
function ENT:ButtonsInitialize()
    self:ClearButtons()

    buttonsConfig = self:GetConfigFromServer()

    if (buttonsConfig) then
        for _, buttonConfig in pairs(buttonsConfig) do
            if (buttonConfig.model and !IsUselessModel(buttonConfig.model)) then
                table.insert(self.ButtonsList, self:CreateButtonClientProp(buttonConfig.model, buttonConfig.pos, buttonConfig.ang))
            else
                logError(self, "Static button model is not valid. Check pult config. Model name: '"..(buttonConfig.model or "none").."'")
            end
        end
    end
end

-- Get static buttons configuration from server.
function ENT:GetConfigFromServer()
    local messageAmount = self:GetNWInt("ConfigMessageAmount", 1)
    local configMassage = ""
    
    if (messageAmount == 1) then
        configMassage = self:GetNWString("Config")
    else
        for i = 0, messageAmount do
            configMassage = configMassage..self:GetNWString("Config_"..i)
        end
    end

    return util.JSONToTable(configMassage)
end

-- Creacte button client entities.
-- (model) - Path to button model (.mdl).
-- (pos) - Local position relative to the pult.
-- (ang) - Local angle relative to the pult.
-- RETURN - new only client side entity.
function ENT:CreateButtonClientProp(model, pos, ang)
    pos = pos or Vector()
    ang = ang or Angle()

    local buttonClientProp = ClientsideModel(model)
    buttonClientProp:SetParent(self)
    buttonClientProp:SetPos(self:LocalToWorld(pos))
    buttonClientProp:SetAngles(self:LocalToWorldAngles(ang))

    table.insert(self.ButtonsList, buttonClientProp)
    
    return buttonClientProp
end

-- Happens every second.
-- Checks the unload of models.
function ENT:Think()
    self:SetNextClientThink(CurTime() + 1)
    if (self:IsUnload()) then
        for key, value in pairs(self.ButtonsList) do
            value:AddEffects(EF_NODRAW)
        end
    else 
        for key, value in pairs(self.ButtonsList) do
            value:RemoveEffects(EF_NODRAW)
        end
    end
end

-- Returns whether the entity should be unload.
-- RETURN - 'false' if entity is unload or 'true' if not. 
function ENT:IsUnload()
    if (self:IsDormant()) then
        return  true
    end
    if (self:GetPos():Distance(LocalPlayer():GetPos()) > 512) then
        return true
    end

    return false 
end

-- Remove all buttons.
function ENT:ClearButtons()
    if (self.ButtonsList) then
        for _, button in pairs(self.ButtonsList) do
            SafeRemoveEntity(button)
        end
    end

    self.ButtonsList = {}
end

-- Called when an entity is removed.
function ENT:OnRemove()
	self:ClearButtons()
end