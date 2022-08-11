-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для аддона Metrostroi.
--	Аддон реализует токоразделы, разделяя контактный рельс на учатки(фидеры), 
--  с независимым напряжением.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------


local function loadFile(path)
    local data,found
    if file.Exists(path..".txt", "DATA") then
        data = util.JSONToTable(file.Read(path..".txt", "DATA"))
        found = true
    end
    if not data and file.Exists(path..".lua", "LUA") then
        data = util.JSONToTable(file.Read(path..".lua", "LUA"))
        found = true
    end
    
    return data
end

local data = loadFile("metrostroi_data/feeder_"..game.GetMap())
if (not data) then return end       -- Return, if config file dont found

----   Local functions   ----

-- Save data in file.
-- (path) - Full path to file, no extension.
-- (data) - Data written to file.
local function saveFile(path, data)
    path = path..".txt"
    if not file.Exists(path, "DATA") then
        file.Append(path)
    end

    file.Write(path, data)
end

-- Separate text by characters to strings with a specific length.
-- (sourceString) - Source string.
-- (maxLen) - Max out strings length.
-- (noPatterns) - Disable patterns lua string patterns.
-- (...) - Many string-separator, separating the string.
-- RETURN - Separated strings table.
local function textSeparator(sourceString, maxLen, noPatterns, ...)
    local separators = { ... }
    local len = string.len(sourceString)
    local currentPos = 1
    local protector = 1
    local separeteStrings = {}
	
    while (currentPos <= len) do
        local separeteString = string.sub(sourceString, currentPos, currentPos + (maxLen - 1))
        local separeteLen = string.len(separeteString)

        if (separeteLen == maxLen) then
            for _, separator in ipairs(separators) do
                local separatorFind
				local tempFind = 0
				
				while(protector < 100) do
					tempFind = string.find(separeteString, separator, tempFind + 1, 0, noPatterns)
					
					if (tempFind) then separatorFind = tempFind
					else break end
					
					protector = protector + 1
				end
				
				if (separatorFind != nil) then
					separeteLen = separatorFind - 1
					separeteString = string.sub(sourceString, currentPos, currentPos + separeteLen)
					break
				end
            end
        end

        table.insert(separeteStrings, separeteString)
        currentPos = currentPos + separeteLen + 1
		
		protector = 1
        if (protector > 100) then break end
        protector = protector + 1
    end

    return separeteStrings
end

-- Print text to player chat taking into account the maximum allowable transmission length.
-- (ply) - The player who received the message.
-- (sourceString) - String to be sent. 
-- (noPatterns) - Disable patterns lua string patterns.
-- (...) - Many string-separator, separating the string.
local function ExtendedChatPrintConfig(ply, sourceString, noPatterns, ...)
    local printStings = textSeparator(sourceString, 200, noPatterns, ...)
    for i, printString in ipairs(printStings) do
        if (i > 1) then printString = " \n"..printString end

        ply:ChatPrint(printString)
    end
end

----   API definition   ----

Metrostroi.Feeder = {}

-- Initialize feeders.
function Metrostroi.Feeder.Initialize()
    Metrostroi.CurrentLimits = {}
    Metrostroi.VoltagesLimits = {}
    Metrostroi.FeedersOn = {}
    Metrostroi.Currents = {}
    Metrostroi.Voltages = {}
    Metrostroi.VoltageRestoreTimers = {}

    local currentLimit = GetConVarNumber("metrostroi_current_limit")
    local voltage = math.max(0,GetConVarNumber("metrostroi_voltage"))
    
    for feeder, params in pairs(data) do
        Metrostroi.CurrentLimits[feeder] = currentLimit
        Metrostroi.VoltagesLimits[feeder] = voltage
        Metrostroi.Currents[feeder] = 0
        Metrostroi.Voltages[feeder] = 0
        Metrostroi.FeedersOn[feeder] = true
        
        for k, v in pairs(params) do
            if (k == "CurrentLimit") then
                Metrostroi.CurrentLimits[feeder] = v or currentLimit
            elseif (k == "VoltageLimit") then
                Metrostroi.VoltagesLimits[feeder] = math.max(0, v or voltage)
            end
        end
    end

    print("Metrostroi: Feeder loaded")
end

-- Set current limit on feeder.
-- (feeder) - Feeder number.
-- (voltage) - Current limit > 0. 
function Metrostroi.Feeder.SetCurrent(feeder, current)
    feeder = tonumber(feeder)
    current = tonumber(current)

    if (feeder == nil or current == nil or current < 0) then return end
    
    if (Metrostroi.CurrentLimits[feeder] ~= nil) then
        Metrostroi.CurrentLimits[feeder] = current
    end
end

-- Set voltage limit on feeder.
-- (feeder) - Feeder number 
-- (voltage) - voltage limit > 0. 
function Metrostroi.Feeder.SetVoltage(feeder, voltage)
    feeder = tonumber(feeder)
    voltage = tonumber(voltage)

    if (feeder == nil or voltage == nil or voltage < 0) then return end
    
    if (Metrostroi.VoltagesLimits[feeder] ~= nil) then
        Metrostroi.VoltagesLimits[feeder] = voltage
    end
end

-- Set current limit on all feeder.
-- (voltage) - Current limit > 0.
function Metrostroi.Feeder.SetAllCurrent(current)
    current = tonumber(current)

    if (current == nil or current < 0) then return end
    
    for feeder, _ in pairs(Metrostroi.CurrentLimits) do
        Metrostroi.CurrentLimits[feeder] = current
    end
end

-- Set voltage limit on all feeder.
-- (feeder) - Feeder number.
-- (voltage) - Voltage limit > 0.
function Metrostroi.Feeder.SetAllVoltage(voltage)
    voltage = tonumber(voltage)

    if (voltage == nil or voltage < 0) then return end
    
    for feeder, _ in pairs(Metrostroi.VoltagesLimits) do
        Metrostroi.VoltagesLimits[feeder] = voltage
    end
end

-- Turn on feeder, supply current start.
-- (feeder) - Feeder number.
function Metrostroi.Feeder.On(feeder)
    feeder = tonumber(feeder)
    if (feeder ~= nil and Metrostroi.FeedersOn[feeder] ~= nil) then
        Metrostroi.FeedersOn[feeder] = true 
    end
end

-- Turns off feeder, supply current stops.
-- (feeder) - Feeder number. 
function Metrostroi.Feeder.Off(feeder)
    feeder = tonumber(feeder)
    if (feeder ~= nil and Metrostroi.FeedersOn[feeder] ~= nil) then
        Metrostroi.FeedersOn[feeder] = false 
    end
end

-- Turn on all feeder, supply current start.
function Metrostroi.Feeder.AllOn()
    for k, _ in pairs(Metrostroi.FeedersOn) do
        Metrostroi.FeedersOn[k] = true
    end
end

-- Turns off all feeder, supply current stops.
function Metrostroi.Feeder.AllOff()
    for k, _ in pairs(Metrostroi.FeedersOn) do
        Metrostroi.FeedersOn[k] = false
    end
end

-- Return a table with current feeders info.
-- (selectFeeder) - Select feeder number. If nil select all.
-- RETRUN - Table of current feeders or feeder info.
function Metrostroi.Feeder.GetInfoTable(selectFeeder)
    local info = {}
    
    local function getFeeder(feeder)
        if (!Metrostroi.Voltages[feeder]) then return end
        
        return {
            ["Voltage"] = Metrostroi.Voltages[feeder],
            ["Current"] = Metrostroi.Currents[feeder],
            ["On"] = Metrostroi.FeedersOn[feeder],
            ["Fail"] = (Metrostroi.VoltageRestoreTimers[feeder] != nil),
        }
    end

    if (selectFeeder) then
        info[selectFeeder] = getFeeder(selectFeeder)
    else
        for feeder, _ in pairs(Metrostroi.FeedersOn) do
            info[feeder] = getFeeder(feeder)
        end
    end

    return info
end

-- Retrun a table with config of feeders.
-- (selectFeeder) - Select feeder number. If nil select all.
-- RETRUN - Table of feeders or feeder config.
function Metrostroi.Feeder.GetConfigTable(selectFeeder)
    local info = {}
    
    local function getFeeder(feeder)
        if (!Metrostroi.Voltages[feeder]) then return end
        
        return {
            ["CurrentLimit"] = Metrostroi.VoltagesLimits[feeder],
            ["Voltages"] = Metrostroi.CurrentLimits[feeder],
        }
    end

    if (selectFeeder) then
        info[selectFeeder] = getFeeder(selectFeeder)
    else
        for feeder, _ in pairs(Metrostroi.FeedersOn) do
            info[feeder] = getFeeder(feeder)
        end
    end

    return info
end

-- Return string of current feeders info.
-- RETRUN - Format string with feeders current info.
function Metrostroi.Feeder.GetInfoString(selectFeeder)
    local info = "Feeder info:\n"

    local function getFeeder(feeder)
        if (!Metrostroi.Voltages[feeder]) then return end
        
        return string.format("%s: Voltage: %-5.1f Current: %-7.1f Stage: %-5s Fall: %-5s\n", 
            feeder, 
            Metrostroi.Voltages[feeder],
            Metrostroi.Currents[feeder],
            ((Metrostroi.FeedersOn[feeder]) and "On" or "Off"),
            (Metrostroi.VoltageRestoreTimers[feeder] != nil)
        )
    end

    if (selectFeeder) then
        local feeder = getFeeder(selectFeeder)
        if (feeder) then info = info..feeder
        else return
        end
    else
        for feeder, _ in pairs(Metrostroi.FeedersOn) do
            info = info..getFeeder(feeder)
        end
    end
    
    return info
end

function Metrostroi.Feeder.GetTrainInfoString(train)
	local info = "Feeder train info : \n"
	if (!IsValid(train) or !train.WagonList) then return end
	
	for _, wagon in pairs(train.WagonList) do
		print(wagon)
		info = info..Format("Вагон № %04d (%s)\n", wagon.WagonNumber, wagon.ClassName)
		info = info.."\t\t 1-я тележка на фидере № "..(wagon.FrontBogey.Feeder or "nil").."\n"
		info = info.."\t\t 2-я тележка на фидере № "..(wagon.RearBogey.Feeder or "nil").."\n"
	end
	
	return info
end

-- Return string of feeders config.
-- RETRUN - Format string with feeders config.
function Metrostroi.Feeder.GetConfigString(selectFeeder)
    local function getFeeder(feeder)
        if (!Metrostroi.Voltages[feeder]) then return end
        
        return string.format("%s: Voltages: %-7.1f Current limit: %-7.1f\n", 
            feeder, 
            Metrostroi.VoltagesLimits[feeder],
            Metrostroi.CurrentLimits[feeder]
        )
    end

    local info = "Feeder config info:\n"
    
    if (selectFeeder) then
        local feeder = getFeeder(selectFeeder)
        if (feeder) then info = info..feeder
        else return
        end
    else
        for feeder, _ in pairs(Metrostroi.FeedersOn) do
            info = info..getFeeder(feeder)
        end
    end

    return info
end

-- Load feeders config on file. 
function Metrostroi.Feeder.Load()
    data = loadFile("metrostroi_data/feeder_"..game.GetMap())
    if (not data) then return end

    Metrostroi.Feeder.Initialize()
end

-- Save feeders config to file.
function Metrostroi.Feeder.Save()
    local data = {} 

    for feeder, voltageValue in pairs(Metrostroi.VoltagesLimits) do
        data[feeder] = {
            ["VoltageLimit"] = voltageValue,
            ["CurrentLimit"] = Metrostroi.CurrentLimits[feeder]
        }
    end

    saveFile("metrostroi_data/feeder_"..game.GetMap(), util.TableToJSON(data, true))
end

----   Hook inject   ----
-- Calcul voltage.
timer.Simple(1, function ()
    local Rfeed = 0.03
    local hookName = "Metrostroi_ElectricConsumptionThink"
    local m_hookFunc = hook.GetTable()["Think"][hookName]

    local function ElectricConsumptionFeederThink()
        m_hookFunc()
    
        for feeder in pairs(Metrostroi.Voltages) do
            if (Metrostroi.FeedersOn[feeder] ~= nil) then 
                if Metrostroi.Currents[feeder] > Metrostroi.CurrentLimits[feeder] then
                    Metrostroi.VoltageRestoreTimers[feeder] = CurTime() + 7.0
                end
                
                if (Metrostroi.VoltageRestoreTimers[feeder]) then
                    Metrostroi.Voltages[feeder] = 0 
                    if (CurTime() > Metrostroi.VoltageRestoreTimers[feeder]) then
                        Metrostroi.VoltageRestoreTimers[feeder] = nil
                    end
                else
                    Metrostroi.Voltages[feeder] = (Metrostroi.FeedersOn[feeder]) and math.max(0, Metrostroi.VoltagesLimits[feeder] - Metrostroi.Currents[feeder] * Rfeed) or 0
                end
            end
        end
    end

    hook.Add("Think", hookName, ElectricConsumptionFeederThink)
end)


----   New Metrostroi electric consumptionThink hook   ----
-- Turns off when a new version of the Metrostroi addon is released.
if (Metrostroi.Version == 1537278077) then
    timer.Simple(0.5, function()
        local function consumeFromFeeder(inCurrent, inFeeder)
            if inFeeder then
                Metrostroi.Currents[inFeeder] = Metrostroi.Currents[inFeeder] + inCurrent*0.4
            else
                Metrostroi.Current = Metrostroi.Current + inCurrent*0.4
            end
        end
        
        local prevTime

        hook.Add("Think", "Metrostroi_ElectricConsumptionThink", function()
            -- Change in time
            prevTime = prevTime or CurTime()
            local deltaTime = (CurTime() - prevTime)
            prevTime = CurTime()
        
            -- Calculate total rate
            Metrostroi.TotalRateWatts = 0
            Metrostroi.Current = 0
            for k,v in pairs(Metrostroi.Currents) do Metrostroi.Currents[k] = 0 end
            local bogeys = ents.FindByClass("gmod_train_bogey")
            for _,bogey in pairs(bogeys) do
                if bogey.Feeder then
                    Metrostroi.Currents[bogey.Feeder] = Metrostroi.Currents[bogey.Feeder] + bogey.DropByPeople
                else
                    Metrostroi.Current = Metrostroi.Current + bogey.DropByPeople
                end
            end
            for _,class in pairs(Metrostroi.TrainClasses) do
                local trains = ents.FindByClass(class)
                for _,train in pairs(trains) do
                    if train.Electric then
                        if train.Electric.EnergyChange then Metrostroi.TotalRateWatts = Metrostroi.TotalRateWatts + math.max(0, train.Electric.EnergyChange) end
                        local current = math.max(0, train.Electric.Itotal or 0) -  math.max(0, train.Electric.Iexit or 0)
        
                        local fB = IsValid(train.FrontBogey) and train.FrontBogey
                        local rB = IsValid(train.RearBogey) and train.RearBogey
                        if fB and (not fB.ContactStates or (not fB.ContactStates[1] and not fB.ContactStates[2])) then fB = nil end -- Don't have contact with TR
                        if rB and (not rB.ContactStates or (not rB.ContactStates[1] and not rB.ContactStates[2])) then rB = nil end -- Don't have contact with TR
        
                        local fBfeeder = fB and fB.Feeder
                        local rBfeeder = rB and rB.Feeder
        
                        if fBfeeder then
                            if not rBfeeder or fBfeeder == rBfeeder then
                                consumeFromFeeder(current, fBfeeder) -- Feeders are same
                            else
                                consumeFromFeeder(current * 0.5, fBfeeder) -- Feeders are different
                            end
                        end
        
                        if rBfeeder then
                            if not fBfeeder then
                                consumeFromFeeder(current, rBfeeder) -- Feeders are same
                            elseif fBfeeder ~= rBfeeder  then
                                consumeFromFeeder(current * 0.5, rBfeeder) -- Feeders are different
                            end
                        end
                        if not rBfeeder and not fBfeeder then consumeFromFeeder(current) end
                    end
                end
            end
            -- Ignore invalid values
            if Metrostroi.TotalRateWatts > 1e8 then Metrostroi.TotalRateWatts = 0 end
            if Metrostroi.TotalRateWatts > 0 then
                -- Calculate total kWh
                Metrostroi.TotalkWh = Metrostroi.TotalkWh + (Metrostroi.TotalRateWatts/(3.6e6))*deltaTime
            end
            -- Calculate total resistance of people on rails and current flowing through
            --local Rperson = 0.613
            --local Iperson = Metrostroi.Voltage / (Rperson/(Metrostroi.PeopleOnRails + 1e-9))
            --Metrostroi.Current = Metrostroi.Current + Iperson
        
            -- Check if exceeded global maximum current
            if Metrostroi.Current > GetConVar("metrostroi_current_limit"):GetInt() then
                Metrostroi.VoltageRestoreTimer = CurTime() + 7.0
                print(Format("[!] Power feed protection tripped: current peaked at %.1f A",Metrostroi.Current))
            end
        
            local voltage = math.max(0,GetConVar("metrostroi_voltage"):GetInt())
        
            -- Calculate new voltage
            local Rfeed = 0.03 --25
            Metrostroi.Voltage = voltage - Metrostroi.Current*Rfeed
            if CurTime() < Metrostroi.VoltageRestoreTimer then Metrostroi.Voltage = 0 end
            for i in pairs(Metrostroi.Voltages) do
                Metrostroi.Voltages[i] = math.max(0,voltage - Metrostroi.Currents[i]*Rfeed)
            end
            --print(Format("%5.1f v %.0f A",Metrostroi.Voltage,Metrostroi.Current))
        end) 
    end)
end  


----   Console command definition   ----

concommand.Add("metrostroi_current_limit_feeder", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    
    if (args[1] == "all") then
        Metrostroi.Feeder.SetAllCurrent(args[2])
    else
        Metrostroi.Feeder.SetCurrent(args[1], args[2])
    end
end)

concommand.Add("metrostroi_voltage_feeder", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    if (args[1] == "all") then
        Metrostroi.Feeder.SetAllVoltage(args[2])
    else
        Metrostroi.Feeder.SetVoltage(args[1], args[2])
    end
    
end)

concommand.Add("metrostroi_feeder_on", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    if (args[1] == "all") then
        Metrostroi.Feeder.AllOn()
    else
        Metrostroi.Feeder.On(args[1])
    end
end)

concommand.Add("metrostroi_feeder_off", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    if (args[1] == "all") then
        Metrostroi.Feeder.AllOff()
    else
        Metrostroi.Feeder.Off(args[1])
    end
end)

concommand.Add("metrostroi_feeder_info", function(ply, _, args)
    local printString = Metrostroi.Feeder.GetInfoString(tonumber(args[1]))
	if (ply == NULL) then print(printString); return end
    if (printString) then ExtendedChatPrintConfig(ply, printString, true, "\n") end
end)

concommand.Add("metrostroi_feeder_config", function(ply, _, args)
    local printString = Metrostroi.Feeder.GetConfigString(tonumber(args[1]))
	if (ply == NULL) then print(printString); return end
    if (printString) then ExtendedChatPrintConfig(ply, printString, true, "\n") end
end)

concommand.Add("metrostroi_feeder_load", function(ply, _, _)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    Metrostroi.Feeder.Load()
end)

concommand.Add("metrostroi_feeder_save", function(ply, _, _)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    Metrostroi.Feeder.Save()
end)

concommand.Add("metrostroi_feeder_train_info", function(ply, _, _)
	if (ply == NULL) then return end
	
	local traceEnt = ply:GetEyeTrace().Entity
	
	if (IsValid(traceEnt)) then 
		local printString = Metrostroi.Feeder.GetTrainInfoString(traceEnt)
		if (printString) then ExtendedChatPrintConfig(ply, printString, true, ".\n") end
	end	
end)


-- Initialization
Metrostroi.Feeder.Initialize()