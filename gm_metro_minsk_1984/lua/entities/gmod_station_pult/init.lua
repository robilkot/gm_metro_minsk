AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

-- List of verified sounds.
local validSoundFiles = {}

-- Check sound file valid.
-- (soundFile) - Sound file path.
-- RETURN - 'false' if sound file is not valid or true if valid.
local function сheckSoundFile(soundFile)
    if (table.KeyFromValue(validSoundFiles, soundFile)) then
        return true
    end
    
    if (string.EndsWith(soundFile, ".mp3") or string.EndsWith(soundFile, ".wav")) then
        if (file.Exists("sound/"..soundFile, "GAME")) then
            table.insert(validSoundFiles, soundFile)
            return true
        end 
    end

    return false
end

-- Check presence button actions.
-- (buttonConfig) - Config of button.
-- RETURN - 'true' if button contains actions or 'false' if not.
local function checkButtonConfingActions(buttonConfig)
    if ((buttonConfig.actions and table.Count(buttonConfig.actions) ~= 0) or buttonConfig.action) then
        return true
    end

    return false 
end

local function parsingStringFuncion(funcString)
    local extractFunc = "Minsk.StationPults.extractFunc = function(pult, button) "..funcString.." end"
    local errorMsg = RunString(extractFunc, "Button func", false)
    if (errorMsg == nil) then
        table.insert(funcs, Minsk.StationPults.extractFunc)
        Minsk.StationPults.extractFunc = nil
    else 
        errorLog(self, "Button function is faled! "..errorMsg..". Check pult button configuration. ".."Button name: '"..(buttonConfig.name or "none").."'")
    end
end

-- Print format error.
-- (entity) - Pult entity.
-- (message) - Error massege. 
local function errorLog(entity, message)
    Minsk.ErrorLog.SetError(message.."; Pult name: '"..entity:GetName().."'", "Station pults")
end

local buttonFunctions = {
    animation = function(pult, button)
        button.entity:ResetSequence(button.stage.animation)
    end,
    sound = function(pult, button)
        button.entity:EmitSound(soundFile)
    end,
    stageIncriment = function(pult, button)
        button.stage = button.stage + 1
        if (button.stage > actionsCount) then 
            button.stage = 1
        end
    end
}

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
            local button = { }
            local actionsFuncs = { }
            local actionsCount = (buttonConfig.actions) and table.Count(buttonConfig.actions) or 0
            local buttonEntity = self:CreateButtonEntity(buttonConfig.model, buttonConfig.pos, buttonConfig.ang)

            if (actionsCount == 0 && buttonConfig.action) then
                actionsCount = 1
                buttonConfig.actions = {}
                table.insert(buttonConfig.actions, buttonConfig.action)
            end

            if (actionsCount > 1) then
                button.stage = 1
                actionsFuncs["stageIncriment"] = function()
                    button.stage = button.stage + 1
                    if (button.stage > actionsCount) then 
                        button.stage = 1
                    end
                end
            end
            
            for actionNumber, action in ipairs(buttonConfig.actions) do
                local funcs = { }
                local soundFile = action.sound or buttonConfig.sound
                local animation = action.animation
                local func = action.func
                local output = action.output
                local outputs = action.outputs and table.Copy(action.outputs) or { }

                if (soundFile) then
                    if (сheckSoundFile(soundFile)) then
                        table.insert(funcs, buttonFunctions.sound)
                    else 
                        errorLog(self, "Sound loading error. Sound file name: '"..soundFile.."'; ".."Button name: '"..(buttonConfig.name or "none").."'")
                    end
                end

                if (animation) then
                    table.insert(funcs, buttonFunctions.animation)
                end

                if (func) then
                    if (type(func) == "function") then
                        table.insert(funcs, func)
                    elseif (type(func) == "string") then
                        parsingStringFuncion(funcString)
                    end
                end

                if (output and table.Count(outputs) == 0) then
                    table.insert(outputs, output)
                end

                if (table.Count(outputs) > 0) then
                    for _, output in ipairs(outputs) do
                        table.insert(funcs, function()
                            if (button.blocked) then return end
    
                            local findEnts = ents.FindByName(output.targetEntName)
    
                            if (table.Count(findEnts) > 0) then
                                findEnts[1]:Fire(output.input, output.param, output.delay)
                            end
                        end)
                    end
                end
                

                if (actionsCount > 1) then
                    table.insert(actionsFuncs, function(pult, button)
                        for _, func in ipairs(funcs) do
                            func(pult, button)
                        end
                    end)
                else
                    table.Add(actionsFuncs, funcs)
                end
            end

            if (actionsCount > 1) then
                buttonEntity.Use = function()
                    actionsFuncs[button.stage](self, button)
                    actionsFuncs["stageIncriment"]()
                end
            else
                buttonEntity.Use = function()
                    for _, func in ipairs(actionsFuncs) do
                        func(self, button)
                    end
                end
            end

            if (buttonConfig.description and buttonConfig.description ~= "") then
                buttonEntity:SetOverlayText(buttonConfig.description)
            end

            if (table.KeyFromValue(usingNames, buttonConfig.name) != nil) then
                errorLog(self, "Button name is not unique! Check pult button configuration. ".."Button name: '"..(buttonConfig.name or "none").."'")
            end

            table.insert(usingNames, buttonConfig.name)

            button.name = buttonConfig.name
            button.entity = buttonEntity
            button.actionsFuncs = actionsFuncs
            button.soundFile = soundFile
            button.blocked = buttonConfig.blocked

            table.insert(self.ButtonsList, button)
        else
            table.insert(staticButtonsConfig, buttonConfig)
        end
    end

    self:SendConfigToClient(staticButtonsConfig)
end

-- Clear all buttons.
function ENT:ClearButtons()
    for _, button in ipairs(self.ButtonsList) do
        if (IsValid(button.entity)) then
            button.entity:Remove()
        end
    end

    self.ButtonsList = {}
end

-- Create indicator entity
-- (model) - Path to button model (.mdl).
-- (pos) - Local position relative to the pult.
-- (ang) - Local angle relative to the pult.
-- RETURN - New button entity.
function  ENT:CreateButtonEntity(model, pos, ang)
    pos = pos or Vector()
    ang = ang or Angle()

    local entity = ents.Create("base_gmodentity")
    entity:SetModel(model)
    entity:SetParent(self)
    entity:SetPos(self:LocalToWorld(pos))
    entity:SetAngles(self:LocalToWorldAngles(ang))
    entity:PhysicsInit(SOLID_BSP)
    entity:SetUseType(SIMPLE_USE)
    entity:PhysWake()
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
            errorLog(self, "Indicator not created. Name is faled! Check pult indicators configuration. Indicator name: '"..indicatorConfig.name.."'")
            continue
        end
        if (self.IndicatorsList[name]) then
            errorLog(self, "Indicator not created. Name is not unique! Check pult indicators configuration. Indicator name: '"..indicatorConfig.name.."'")
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

-- Clear all indicators.
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
        if (button.name == name) then
            return button
        end
    end
end

-- Toggle button to next stage.
-- (name) - Button name.
function ENT:ToggleButton(name)
    local button = self:GetButton(name)

    if (button and button.entity and IsValid(button.entity)) then
        button.entity:Use(self, self)
    end
end

-- Set button to stage. If the stage is not found, does nothing.
-- (name) - Button name.
function ENT:SetButtonStage(name, stage)
    local button = self:GetButton(name)

    if (button and IsValid(button.entity) and button.actionsFuncs) then
        if (button.actionsFuncs["stageIncriment"]) then
            local toStageAct = stage - 1

            if (toStageAct < 1) then
                toStageAct = table.Count(button.actionsFuncs) - 1
            end

            local funcs = button.actionsFuncs[toStageAct]
            if (funcs) then
                button.stage = stage
                funcs(self, button)
            end
        end
    end
end

function ENT:BlockButton(name)
    local button = self:GetButton(name)

    if (button) then
        button.blocked = true
    end
end

function ENT:BlockButton(name)
    local button = self:GetButton(name)
    
    if (button) then
        button.blocked = false
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