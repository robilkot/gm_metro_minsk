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


local function getFile(path,name)
    local data,found
    if file.Exists(Format(path..".txt",name),"DATA") then
        data = util.JSONToTable(file.Read(Format(path..".txt",name),"DATA"))
        found = true
    end
    if not found then
        return
    elseif not data then
        return
    end
    return data
end

local data = getFile("metrostroi_data/feeder_%s", game.GetMap())
if (not data) then return end       -- Return, if config file dont found


----   API definition   ----

Metrostroi.Feeder = {}

-- Initialize feeders
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

-- Set current limit on feeder
-- (feeder) - feeder number
-- (voltage) - current limit > 0 
function Metrostroi.Feeder.SetCurrent(feeder, current)
    feeder = tonumber(feeder)
    current = tonumber(current)

    if (feeder == nil or current == nil) then return end
    
    if (Metrostroi.CurrentLimits[feeder] ~= nil) then
        Metrostroi.CurrentLimits[feeder] = current
    end
end

-- Set voltage limit on feeder
-- (feeder) - feeder number 
-- (voltage) - voltage limit > 0 
function Metrostroi.Feeder.SetVoltage(feeder, voltage)
    feeder = tonumber(feeder)
    current = tonumber(voltage)

    if (feeder == nil or voltage == nil) then return end
    
    if (Metrostroi.VoltagesLimits[feeder] ~= nil) then
        Metrostroi.VoltagesLimits[feeder] = voltage
    end
end

-- Turn on feeder, supply current start
-- (feeder) - feeder number
function Metrostroi.Feeder.On(feeder)
    feeder = tonumber(feeder)
    if (feeder ~= nil and Metrostroi.FeedersOn[feeder] ~= nil) then
        Metrostroi.FeedersOn[feeder] = true 
    end
end

-- Turns off feeder, supply current stops.
-- (feeder) - feeder number 
function Metrostroi.Feeder.Off(feeder)
    feeder = tonumber(feeder)
    if (feeder ~= nil and Metrostroi.FeedersOn[feeder] ~= nil) then
        Metrostroi.FeedersOn[feeder] = false 
    end
end

-- Turn on all feeder, supply current start
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

-- Return a table of info about feeders
function Metrostroi.Feeder.GetInfoTable()
    local info = {}
    
    for feeder, _ in pairs(Metrostroi.FeedersOn) do
        info[feeder] = {}
        info[feeder]["Current Limit"] = Metrostroi.CurrentLimits[feeder]
        info[feeder]["Voltages"] = Metrostroi.VoltagesLimits[feeder]
        info[feeder]["State"] = ((Metrostroi.FeedersOn[feeder]) and "On" or "Off")
    end

    return info
end

-- Return a string of info about feeders
function Metrostroi.Feeder.GetInfoString()
    local info = "Feeder info: \n"
    
    for feeder, _ in pairs(Metrostroi.FeedersOn) do
        info = info..feeder..": "
        info = info.."\tCurrent limit: "..Metrostroi.CurrentLimits[feeder].."; "
        info = info.."Voltages: "..Metrostroi.VoltagesLimits[feeder].."; "
        info = info.."State: "..((Metrostroi.FeedersOn[feeder]) and "On" or "Off")..";\n"
    end

    return info
end


----   Hook inject   ----

timer.Simple(1, function ()
    local Rfeed = 0.03
    local hookName = "Metrostroi_ElectricConsumptionThink"
    local m_hookFunc = hook.GetTable()["Think"][hookName]
    hook.Remove(hookName)

    local function ElectricConsumptionFeederThink()
        m_hookFunc()
    
        for feeder in pairs(Metrostroi.Voltages) do
            if (Metrostroi.FeedersOn[feeder] ~= nil) then 
                if Metrostroi.Currents[feeder] > Metrostroi.CurrentLimits[feeder] then
                    Metrostroi.VoltageRestoreTimers[feeder] = CurTime() + 7.0
                end
                if Metrostroi.VoltageRestoreTimers[feeder] and CurTime() < Metrostroi.VoltageRestoreTimers[feeder] then 
                    Metrostroi.Voltage = 0 
                    Metrostroi.VoltageRestoreTimers[feeder] = nil
                end
                
                Metrostroi.Voltages[feeder] = (Metrostroi.FeedersOn[feeder]) and math.max(0, Metrostroi.VoltagesLimits[feeder] - Metrostroi.Currents[feeder] * Rfeed) or 0
            end
        end
    end

    hook.Add("Think", hookName, ElectricConsumptionFeederThink)
end)


----   Console command definition   ----

concommand.Add("metrostroi_current_limit_feeder", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    Metrostroi.Feeder.SetCurrent(args[1], args[2])
end)

concommand.Add("metrostroi_voltage_feeder", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    Metrostroi.Feeder.SetVoltage(args[1], args[2])
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

concommand.Add("metrostroi_feeder_info", function (ply, _, _)
    ply:ChatPrint(Metrostroi.Feeder.GetInfoString())
end)

-- Initialization
Metrostroi.Feeder.Initialize()