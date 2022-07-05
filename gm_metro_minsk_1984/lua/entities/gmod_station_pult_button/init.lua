-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2022 году для карты gm_metro_minsk_1984.
--	Аддон добавляет станционные пульты управления функционалом карты.
--  Данный файл отвечает за сервеную часть ентити кнопки пульта. 
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

-- List of verified sounds files.
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

-- Parsing function on code sting.
-- (funcString) - Function body code from string.
-- RETURN - New function if parsing is success, or nil if faled.
local function parsingStringFuncion(funcString)
    local extractFunc = "Minsk.StationPults.extractFunc = function(pult, button, activator, value) "..funcString.." end"
    local errorMsg = RunString(extractFunc, "Button func", false)
    if (errorMsg == nil) then
        local res = Minsk.StationPults.extractFunc
        Minsk.StationPults.extractFunc = nil

        return res
    else 
        logError(self, "Button function is faled! "..errorMsg..". Check pult button configuration. ".."Button name: '"..(buttonConfig.name or "none").."'")
    end
end

-- Print format error.
-- (entity) - Button entity.
-- (message) - Error massege. 
local function logError(entity, message)
    if (Minsk and Minsk.Logger) then
        Minsk.Logger.LogError(message.."; Pult name: '"..(entity.PultOwner:GetName() or "none").."'", "Station pults")
    end
end

ENT.Name = nil
-- Button stage number.
ENT.StageNum = 1
-- Max button stage count.
ENT.StageCount = 0
-- StageList list.
ENT.StageList = { }
-- Button owner pult.
ENT.PultOwner = nil
ENT.IsBlocked = false
ENT.BlockConfig = nil

-- Base initialize entity.
-- REMARK - Called :Spawn() after :InitializeConfig().
function ENT:Initialize()
    self:PhysicsInit(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:SetOwner(self.PultOwner)
    self:SetParent(self.PultOwner)
    self:PhysWake()
end

-- Initizlize entity by config.
-- REMARK - Called before :Spawn().
function ENT:InitializeConfig(buttonConfig, pult)
    buttonConfig = Minsk.StationPults.ApplyButtonPrototype(buttonConfig)

    self.PultOwner = pult
    self.Name = buttonConfig.name

    local model = buttonConfig.model
    local pos = buttonConfig.pos or Vector()
    local ang = buttonConfig.ang or Angle()
    local actionsCount = (buttonConfig.actions) and table.Count(buttonConfig.actions) or 0
    local block = buttonConfig.block

    if (model and !IsUselessModel(buttonConfig.model)) then
        self:SetModel(model)
    else
        logError(self, "Button is not created. Model is not valid. Check pult button config. Model name: '"..(buttonConfig.model or "none").."'; ".."Button name: '"..(buttonConfig.name or "none").."'")
        return
    end

    self:SetPos(pult:LocalToWorld(pos))
    self:SetAngles(pult:LocalToWorldAngles(ang))
    self:ResetSequence(self:GetSequenceName(1))

    if (actionsCount == 0 && buttonConfig.action) then
        actionsCount = 1
        buttonConfig.actions = {}
        table.insert(buttonConfig.actions, buttonConfig.action)
    end

    for _, action in ipairs(buttonConfig.actions) do
        local animation = action.animation
        local soundFile = action.sound or buttonConfig.sound
        local func = action.func
        local output = action.output
        local outputs = action.outputs
        
        if (soundFile) then
            if (!сheckSoundFile(soundFile)) then
                logError(self, "Button sound loading error. Sound file name: '"..soundFile.."'; ".."Button name: '"..(buttonConfig.name or "none").."'")
                soundFile = nil
            end
        end

        if (func) then
            if (type(func) == "string") then
                func = parsingStringFuncion(func)
            end
        end

        if (output and (!outputs or table.Count(outputs) == 0)) then
            outputs = { }
            table.insert(outputs, output)
        end

        self:AddStage(animation, soundFile, func, outputs)
    end

    if (buttonConfig.block) then
        self.BlockConfig = { }
        if (block.animation) then
            self.BlockConfig.animation = block.animation
        end
        if (block.sound) then
            if (сheckSoundFile(block.sound)) then
                self.BlockConfig.sound = block.sound
            else
                logError(self, "Button block sound loading error. Sound file name: '"..soundFile.."'; ".."Button name: '"..(buttonConfig.name or "none").."'")
            end
        end
    end

    if (buttonConfig.description) then
        self:SetOverlayText(buttonConfig.description)
    end
end

-- Add a new stage on the button.
-- (animation) - Animation name, playing during the current state.
-- (soundFile) - Sound file name, playing during the current state.
-- (func) - Function, called during the current state.
-- (outputs) - Outputs config, fire during the current state.
function ENT:AddStage(animation, soundFile, func, outputs)
    local stage = {}

    if (animation) then
        stage.animation = animation
    end
    if (soundFile) then
        stage.sound = soundFile
    end
    if (func) then
        stage.func = func
    end
    if (outputs) then
        stage.outputs = outputs
    end

    self.StageCount = self.StageCount + 1

    table.insert(self.StageList, stage)
end

-- Toggle button stage, execution stage action and incriment StageNum.
-- (activator) - Entity activator.
-- (caller) - Entity caller. This will typically be the same as activator unless some other entity is acting as a proxy.
-- (type) - Use type. See Enums/USE.
-- (value) - Use value.
function ENT:ToggleStage(activator, caller, useType, value)
    local stage = self.StageList[self.StageNum]

    if (stage.animation) then
        self:ResetSequence(stage.animation)
    end

    if (stage.sound) then
        self:EmitSound(stage.sound)
    end

    if (stage.func) then
        stage.func(self.PultOwner, self, activator, value)
    end

    if (stage.outputs) then
        for _, output in ipairs(stage.outputs) do
            if (!IsValid(output.TargetEnt)) then
                output.TargetEnt = ents.FindByName(output.targetEntName)[1]
            end

            if (!IsValid(output.TargetEnt)) then return end
            output.TargetEnt:Fire(output.input, output.param, output.delay)
        end
    end

    if (self.StageCount > 1) then
        self.StageNum = self.StageNum + 1
        if (self.StageNum > self.StageCount) then
            self.StageNum = 1
        end
    end
end

-- Toggle button block, playing block animation and sound.
-- (activator) - Entity activator.
-- (caller) - Entity caller. This will typically be the same as activator unless some other entity is acting as a proxy.
-- (type) - Use type. See Enums/USE.
-- (value) - Use value.
function ENT:ToggleBlock()
    local block = self.BlockConfig

    if (!block) then return end

    if (block.animation) then
        self:ResetSequence(block.animation)
    end

    if (block.sound) then
        self:EmitSound(block.sound)
    end
end

-- Use handler.
-- (activator) - Entity activator.
-- (caller) - Entity caller. This will typically be the same as activator unless some other entity is acting as a proxy.
-- (type) - Use type. See Enums/USE.
-- (value) - Use value.
function ENT:Use(activator, caller, useType, value)
    if (!self.IsBlocked) then
        self:ToggleStage(activator, caller, useType, value)
    else
        self:ToggleBlock(activator, caller, useType, value)
    end
end