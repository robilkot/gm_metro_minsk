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


local function getFile(path)
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

local function setFile(path, data)
    path = path..".txt"
    if not file.Exists(path, "DATA") then
        file.Append(path)
    end

    file.Write(path, data)
end

local data = getFile("metrostroi_data/feeder_"..game.GetMap())
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

    if (feeder == nil or current == nil or current < 0) then return end
    
    if (Metrostroi.CurrentLimits[feeder] ~= nil) then
        Metrostroi.CurrentLimits[feeder] = current
    end
end

-- Set voltage limit on feeder
-- (feeder) - feeder number 
-- (voltage) - voltage limit > 0 
function Metrostroi.Feeder.SetVoltage(feeder, voltage)
    feeder = tonumber(feeder)
    voltage = tonumber(voltage)

    if (feeder == nil or voltage == nil or voltage < 0) then return end
    
    if (Metrostroi.VoltagesLimits[feeder] ~= nil) then
        Metrostroi.VoltagesLimits[feeder] = voltage
    end
end

-- Set current limit on all feeder
-- (voltage) - current limit > 0 
function Metrostroi.Feeder.SetAllCurrent(current)
    current = tonumber(current)

    if (current == nil or current < 0) then return end
    
    for feeder, _ in pairs(Metrostroi.CurrentLimits) do
        Metrostroi.CurrentLimits[feeder] = current
    end
end

-- Set voltage limit on all feeder
-- (feeder) - feeder number 
-- (voltage) - voltage limit > 0 
function Metrostroi.Feeder.SetAllVoltage(voltage)
    voltage = tonumber(voltage)

    if (voltage == nil or voltage < 0) then return end
    
    for feeder, _ in pairs(Metrostroi.VoltagesLimits) do
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
        info = info.." "..Metrostroi.VoltagesLimits[feeder].."; "
        info = info..Metrostroi.CurrentLimits[feeder].."; "
        info = info..((Metrostroi.FeedersOn[feeder]) and "On" or "Off")..";\n"
    end

    return info
end

function Metrostroi.Feeder.Save()
    local data = {} 

    for feeder, voltageValue in pairs(Metrostroi.VoltagesLimits) do
        data[feeder] = {
            ["VoltageLimit"] = voltageValue,
            ["CurrentLimit"] = Metrostroi.CurrentLimits[feeder]
        }
    end

    setFile("metrostroi_data/feeder_"..game.GetMap(), util.TableToJSON(data, true))
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

        hook.Remove("Think", "Metrostroi_ElectricConsumptionThink")
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

concommand.Add("metrostroi_feeder_info", function(ply, _, _)
    ply:ChatPrint(Metrostroi.Feeder.GetInfoString())
end)

concommand.Add("metrostroi_feeder_save", function(ply, _, _)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    Metrostroi.Feeder.Save()
end)

-- Initialization
Metrostroi.Feeder.Initialize()