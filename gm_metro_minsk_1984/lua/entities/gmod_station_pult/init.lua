-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2022 году для карты gm_metro_minsk_1984.
--	Аддон добавляет станционные пульты управления функционалом карты.
--  Данный файл отвечает за сервеную часть ентити пульта (gmod_station_pult). 
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

-- Check presence button actions.
-- (buttonConfig) - Config of button.
-- RETURN - 'true' if button contains actions or 'false' if not.
local function checkButtonConfingActions(buttonConfig)
    if ((buttonConfig.actions and table.Count(buttonConfig.actions) ~= 0) or buttonConfig.action) then
        return true
    end

    return false 
end

-- Print format error.
-- (entity) - Pult entity.
-- (message) - Error massege. 
local function logError(entity, message)
    if (Minsk and Minsk.Logger) then
        Minsk.Logger.LogError(message.."; Pult name: '"..entity:GetName().."'", "Station pults")
    end
end

-- List of buttons.
ENT.ButtonsList = {}
-- List of indicators.
ENT.IndicatorsList = {}

-- Initizlize pult entity. Without buttons and indicator.
function ENT:Initialize()
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType(SIMPLE_USE)

    self:SetModel("models/station_pult_01a.mdl")
    self:PhysWake()
end

-- Send static(no actions) button config to client.
function ENT:SendConfigToClient(buttonsConfig)
    local configMassage = util.TableToJSON(buttonsConfig)

    local messageLen = string.len(configMassage)
    local messageAmount = 1

    if (messageLen > 199) then
        messageAmount = math.ceil(messageLen / 199)
    end
    
    if (messageAmount == 1) then
        self:SetNWString("Config", configMassage)
    else 
        self:SetNWInt("ConfigMessageAmount", messageAmount)
        for i = 1, messageAmount do
            local message = string.sub(configMassage, (i - 1) * 199 + 1, (i * 199))
            self:SetNWString("Config_"..i, message)
        end
    end
end

-- Initialize buttons from the passed configuration.
-- (buttonsConfig) - Table corresponding to button configuration format. 
function ENT:InitializeButtons(buttonsConfig)
    local staticButtonsConfig = {}
    local usingNames = {}

    for _, buttonConfig in pairs(buttonsConfig) do
        buttonConfig = Minsk.StationPults.ApplyButtonPrototype(buttonConfig)

        if (checkButtonConfingActions(buttonConfig)) then
            if (buttonConfig.name) then
                if (table.KeyFromValue(usingNames, buttonConfig.name) != nil) then
                    logError(self, "Button is not created. Name is not unique! Check pult button configuration. Button name: '"..(buttonConfig.name or "none").."'")
                    continue
                end
            end

            local button = self:CreateButtonEntity(buttonConfig)

            table.insert(usingNames, buttonConfig.name)
            table.insert(self.ButtonsList, button)
        else
            table.insert(staticButtonsConfig, buttonConfig)
        end
    end

    self:SendConfigToClient(staticButtonsConfig)
end

-- Clear and remove all buttons.
function ENT:ClearButtons()
    for _, button in ipairs(self.ButtonsList) do
        if (IsValid(button)) then
            button:Remove()
        end
    end

    self.ButtonsList = {}
end

-- Create button entity
-- (buttonsConfig) - Table corresponding to button configuration format. 
-- RETURN - New button entity(gmod_station_pult_button).
function  ENT:CreateButtonEntity(buttonConfig)
    local entity = ents.Create("gmod_station_pult_button")

    entity:InitializeConfig(buttonConfig, self)
    entity:Spawn()    

    return entity
end

-- Initialize indicators from the passed configuration.
-- (buttonsConfig) - Table corresponding to indicators configuration format.
function ENT:InitializeIndicators(indicatorsConfig)
    for _, indicatorConfig in ipairs(indicatorsConfig) do
        indicatorConfig = Minsk.StationPults.ApplyIndicatorPrototype(indicatorConfig)
        local name = indicatorConfig.name
        if (!name or name == "") then
            logError(self, "Indicator not created. Name is faled! Check pult indicators configuration. Indicator name: '"..indicatorConfig.name.."'")
            continue
        end
        if (self.IndicatorsList[name]) then
            logError(self, "Indicator not created. Name is not unique! Check pult indicators configuration. Indicator name: '"..indicatorConfig.name.."'")
            continue
        end
        
        local indicator = {
            name = name,
            stage = 1,
            entity = self:CreateIndicatorEntity(indicatorConfig.model, indicatorConfig.stagesSkins[1], indicatorConfig.pos, indicatorConfig.ang),
            stagesSkins = {}
        }

        for _, stageSkin in ipairs(indicatorConfig.stagesSkins) do
            table.insert(indicator.stagesSkins, stageSkin)
        end
        self.IndicatorsList[name] = indicator
    end
end

-- Clear and remove all indicators.
function ENT:ClearIndicators()
    for _, indicator in pairs(self.IndicatorsList) do
        if (IsValid(indicator.entity)) then
            indicator.entity:Remove()
        end
    end
    
    self.IndicatorsList = {}
end

-- Create indicator entity.
-- (model) - Path to model (.mdl).
-- (skin) - Default skin number.
-- (pos) - Local position relative to the pult.
-- (ang) - Local angle relative to the pult.
-- RETURN - New indicator entity.
function ENT:CreateIndicatorEntity(model, skin, pos, ang)
    skin = skin or 0
    pos = pos or Vector()
    ang = ang or Angle()

    local entity = ents.Create("base_gmodentity")
    entity:SetModel(model)
    entity:SetParent(self)
    entity:SetPos(self:LocalToWorld(pos))
    entity:SetAngles(self:LocalToWorldAngles(ang))
    entity:SetSkin(skin)
    entity:PhysicsInit(SOLID_NONE)
    entity:Spawn()

    return entity
end

-- Return button by name or nil if not found.
-- (name) - Button name.
-- RETRUN - Button or nil.
function ENT:GetButton(name)
    for _, button in ipairs(self.ButtonsList) do
        print(button.Name)
        if (button.Name == name) then
            return button
        end
    end
end

-- Toggle button to next stage.
-- (name) - Button name.
function ENT:ToggleButton(name)
    local button = self:GetButton(name)

    if (IsValid(button)) then
        button:Use(self, self)
    end
end

-- Set button to stage. If the stage is not found, does nothing.
-- (name) - Button name.
function ENT:SetButtonStage(name, stage)
    -- local button = self:GetButton(name)

    -- if (button and IsValid(button.entity) and button.actionsFuncs) then
    --     if (button.actionsFuncs["stageIncriment"]) then
    --         local toStageAct = stage - 1

    --         if (toStageAct < 1) then
    --             toStageAct = table.Count(button.actionsFuncs) - 1
    --         end

    --         local funcs = button.actionsFuncs[toStageAct]
    --         if (funcs) then
    --             button.stage = stage
    --             funcs(self, button)
    --         end
    --     end
    -- end
end

-- Block button.
-- (name) - Button name.
function ENT:BlockButton(name)
    local button = self:GetButton(name)
    print(button.IsBlocked)
    if (button) then
        button.IsBlocked = true
    end
end

-- Unblock button.
-- (name) - Button name.
function ENT:UnblockButton(name)
    local button = self:GetButton(name)
    
    if (button) then
        button.IsBlocked = false
    end
end

-- Return indicator by name or nil if not found.
-- (name) - Indicator name.
-- RETRUN - Indicator or nil.
function ENT:GetIndicator(name)
    if (name and name != "") then
        return self.IndicatorsList[name]
    end
end

-- Toggle indicator to next stage.
-- (name) - Indicator name.
function ENT:ToggleIndicator(name)
    local indicator = self:GetIndicator(name)

    if (indicator and IsValid(indicator.entity)) then
        indicator.stage = indicator.stage + 1
        
        if (indicator.stage > #indicator.stagesSkins) then
            indicator.stage = 1
        end

        local skin = indicator.stagesSkins[indicator.stage] or 1

        indicator.entity:SetSkin(skin)
    end
end

-- Set indicator to stage. If the stage is not found, does nothing.
-- (name) - Indicator name.
function ENT:SetIndicatorStage(name, stage)
    local indicator = self:GetIndicator(name)

    if (indicator and IsValid(indicator.entity)) then
        local skin = indicator.stagesSkins[stage]
        if (skin) then
            indicator.stage = stage
            indicator.entity:SetSkin(skin)
        end
    end
end

-- Processes incoming inputs.
-- (inputName) - Input name.
-- (activator) - Entity activator.
-- (caller) - Entity caller.
-- (data) - String parameter or parameters separate ';'.
function ENT:AcceptInput(inputName, activator, caller, data)
    if (inputName == "ToggleIndicator") then
        self:ToggleIndicator(data)
    elseif (inputName == "ToggleButton") then
        self:ToggleButton(data)
    elseif (inputName == "SetIndicatorStage") then
        local separator = string.find(data, ";");
        
        if (separator) then
            local indicatorName = string.Trim(string.sub(data, 1, separator - 1), " ")
            local indicatorStage = tonumber(string.Trim(string.sub(data, separator + 1), " "))

            if (indicatorName and indicatorStage) then
                self:SetIndicatorStage(indicatorName, indicatorStage)
            end
        end
    end
end