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

function Metrostroi.FeederInitialize()
    local name = game.GetMap()
    local data = getFile("metrostroi_data/feeder_%s", name)

    if (not data) then return end

    Metrostroi.CurrentLimits = {}
    Metrostroi.VoltagesLimits = {}
    Metrostroi.FeedersOn = {}
    Metrostroi.Currents = {}
    Metrostroi.Voltages = {}
    Metrostroi.VoltageRestoreTimers = {}

    local currentLimit = GetConVarNumber("metrostroi_current_limit")
    local voltage = math.max(0,GetConVarNumber("metrostroi_voltage"))
    local Rfeed = 0.03

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

    concommand.Add("metrostroi_current_limit_feeder", function(ply, _, args)
        local feeder = tonumber(args[1])
        local current = tonumber(args[2])
        if (feeder and args[2] and Metrostroi.CurrentLimits[feeder] ~= nil) then
            Metrostroi.CurrentLimits[feeder] = current
        end
    end)
    
    concommand.Add("metrostroi_voltage_feeder", function(ply, _, args)
        local feeder = tonumber(args[1])
        local voltage = tonumber(args[2])
        if (feeder and args[2] and Metrostroi.VoltagesLimits[feeder] ~= nil) then
            Metrostroi.VoltagesLimits[feeder] = voltage
        end
    end)
    
    concommand.Add("metrostroi_feeder_on", function(ply, _, args)
        local feeder = tonumber(args[1])
        if (feeder and Metrostroi.FeedersOn[feeder] ~= nil) then
            Metrostroi.FeedersOn[feeder] = true 
        end
    end)
    
    concommand.Add("metrostroi_feeder_off", function(ply, _, args)
        local feeder = tonumber(args[1])
        if (feeder and Metrostroi.FeedersOn[feeder] ~= nil) then
            Metrostroi.FeedersOn[feeder] = false
        end
    end)

    timer.Simple(1, function ()
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

    print("Metrostroi: Feeder loaded")
end

Metrostroi.FeederInitialize()