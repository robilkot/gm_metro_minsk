-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2022 году для карты gm_metro_minsk_1984.
--	Аддон добавляет станционные пульты управления функционалом карты.
--  Данный файл отвечает за функции управлния аддоном. 
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------

if (SERVER) then
    Minsk = Minsk or {}
    Minsk.StationPults = Minsk.StationPults or {}

    util.AddNetworkString("station-pults-initizlize")

    -- Print format error.
    -- (entity) - Pult entity.
    -- (message) - Error massege. 
    local function logError(message)
        if (Minsk and Minsk.Logger) then
            Minsk.Logger.LogError(message, "Station pults")
        end
    end

    -- Converts button config action to actions table.
    -- (buttonConfig) - Button config table.
    local function convertButtonActionToActions(buttonConfig)
        if (buttonConfig.action and !buttonConfig.actions) then
            buttonConfig.actions = {
                buttonConfig.action
            }
        end
    end

    -- Load pults config from file.
    -- RETURN - Pults config table.
    local function loadConfigFromFile()
        local data,found
        local path = "minsk_data/station_pults.json"

        if file.Exists(path, "DATA") then
            data = util.JSONToTable(file.Read(path, "DATA"))
            found = true
        end
        if not data and file.Exists(path, "LUA") then
            data = util.JSONToTable(file.Read(path, "LUA"))
            found = true
        end
        if not found then
            logError("Configuration file not found. Path: '"..path.."'")
            return
        elseif not data then
            logError("Configuration parse JSON error")
            return
        end

        return data
    end

    -- List of pults.
    Minsk.StationPults.PultsList = { }

    -- Returns pult from the list by name.
    -- (name) Pult name.
    -- RETURN - Pult entity or nil if not found.
    function Minsk.StationPults.GetPult(name)
        if (name and name ~= "") then
            for _, pult in ipairs(Minsk.StationPults.PultsList) do
                if (pult:GetName() == name) then
                    return pult
                end
            end
        end
    end

    -- Returns pult from the global space by name.
    -- (name) Pult name.
    -- RETURN - Pult entity or 'nil' if not found.
    function Minsk.StationPults.GetGlobalPult(name)
        local findsPults = ents.FindByClass("gmod_station_pult")

        if (findsPults) then
            for _, pult in ipairs(findsPults) do
                if (pult:GetName() == name) then
                    return pult
                end
            end
        end
    end

    -- Returns pult config by name.
    -- (pultsConfog) - Pults config table.
    -- (name) - Pult name.
    -- RETURN - Pult config table or 'nil' if not found.
    function Minsk.StationPults.GetPultConfig(pultsConfog, name)
        for _, pultConfig in pairs(pultsConfog) do
            if (pultConfig.name and pultConfig.name == name) then
                return pultConfig
            end
        end
    end

    -- Initialize pults on configu based.
    -- (pultsConfog) - Pults config table.
    function Minsk.StationPults.InitializePults(pultsConfog)
        local usingNames = {}

        for _, pultConfig in ipairs(pultsConfog) do
            if (table.KeyFromValue(usingNames, pultConfig.name)) then
                Minsk.LogError.LogError("Pult not created. Name is not unique! Check pult configuration. Pult name: '"..pultConfig.name.."'", "StationPults")
                continue 
            end

            local pult = Minsk.StationPults.GetGlobalPult(pultConfig.name)

            if (!pult) then
                pult = ents.Create("gmod_station_pult")
                pult:Spawn()
            else 
                pult.HammerEntity = true
            end

            Minsk.StationPults.InitializePult(pult, pultConfig)
            table.insert(Minsk.StationPults.PultsList, pult)
            table.insert(usingNames, pultConfig.name)
        end
    end

    function Minsk.StationPults.ClientInitializePults()
        timer.Simple(1, function()
            net.Start("station-pults-initizlize")
            net.Broadcast()
        end)
    end

    -- Initialize pult entity on config based.
    -- (pult) Pult entity.
    -- (pultConfig) Pult config table.
    function Minsk.StationPults.InitializePult(pult, pultConfig)
        if (pult:GetName() == "") then pult:SetName(pultConfig.name) end
        if (pultConfig.model) then pult:SetModel(pultConfig.model) end
        if (pultConfig.pos) then pult:SetPos(pultConfig.pos) end
        if (pultConfig.ang) then pult:SetAngles(pultConfig.ang) end
        if (pultConfig.buttons) then pult:InitializeButtons(pultConfig.buttons) end
        if (pultConfig.indicators) then pult:InitializeIndicators(pultConfig.indicators) end
    end
    
    -- Create pult entity.
    -- RETURN - New pult entity.
    function Minsk.StationPults.CreatePult()
        pult = ents.Create("gmod_station_pult")
        pult:Spawn()
        return pult
    end

    -- Reinitialize initialized pults on configu based.
    -- (pultsConfog) - Pults config table.
    function Minsk.StationPults.ReinitializePults(pultsConfog)
        local usingNames = {}

        for index, pult in pairs(Minsk.StationPults.PultsList) do
            if (IsValid(pult)) then
                local pultConfig = Minsk.StationPults.GetPultConfig(pultsConfog, pult:GetName())
                if (pultConfig and !pultConfig.pultInit) then
                    Minsk.StationPults.ReinitializePult(pult, pultConfig)
                    pultConfig.pultInit = true
                    table.insert(usingNames, pultConfig.name)
                else 
                    pult:Remove()
                    Minsk.StationPults.PultsList[index] = nil
                end
            else 
                Minsk.StationPults.PultsList[index] = nil
            end
        end

        for _, pultConfig in ipairs(pultsConfog) do
            if (!pultConfig.pultInit) then
                if (table.KeyFromValue(usingNames, pultConfig.name)) then
                    Minsk.LogError.LogError("Pult not created. Name is not unique! Check pult configuration. Pult name: '"..pultConfig.name.."'", "StationPults")
                    continue 
                end

                pult = Minsk.StationPults.CreatePult()
                Minsk.StationPults.InitializePult(pult, pultConfig)
                table.insert(Minsk.StationPults.PultsList, pult)
                table.insert(usingNames, pultConfig.name)
            else 
                pultConfig.pultInit = nil 
            end
        end
        
        Minsk.StationPults.PultsList = table.ClearKeys(Minsk.StationPults.PultsList)
        Minsk.StationPults.ClientInitializePults()
    end

    -- Reinitialize initialized pult entity on config based.
    -- (pult) Pult entity.
    -- (pultConfig) Pult config table.
    function Minsk.StationPults.ReinitializePult(pult, pultConfig)
        pult:ClearButtons()
        pult:ClearIndicators()
        Minsk.StationPults.InitializePult(pult, pultConfig)
    end

    -- Apply button prototype.
    -- (buttonConfig) - Button config table.
    -- RETURN - New button config table whith prototype values.
    function Minsk.StationPults.ApplyButtonPrototype(buttonConfig)
        local buttonPrototype = (buttonConfig.prototype) and Minsk.StationPults.ButtonPrototypes[buttonConfig.prototype] or nil

        if (!buttonPrototype) then return buttonConfig end
        
        local newButtonConfig = table.Copy(buttonConfig)
        
        convertButtonActionToActions(newButtonConfig)

        for key, value in pairs(buttonPrototype) do
            if (key == "actions") then
                newButtonConfig.actions = newButtonConfig.actions or {}
                for actNum, actTable in ipairs(buttonPrototype.actions) do
                    newButtonConfig.actions[actNum] = newButtonConfig.actions[actNum] or {}
                    for actKey, actValue in pairs(actTable) do
                        if (!newButtonConfig.actions[actNum][actKey]) then
                            newButtonConfig.actions[actNum][actKey] = actValue
                        end
                    end
                end
            else
                if (!newButtonConfig[key]) then
                    newButtonConfig[key] = value
                end
            end
        end

        return newButtonConfig
    end

    -- Apply indicator prototype.
    -- (indicatorConfig) - Indicator config table.
    -- RETURN - New indicator config table whith prototype values.
    function Minsk.StationPults.ApplyIndicatorPrototype(indicatorConfig)
        local indicatorPrototype = (indicatorConfig.prototype) and Minsk.StationPults.IndicatorPrototypes[indicatorConfig.prototype] or nil
        if (!indicatorPrototype) then return indicatorConfig end
        
        local newIndicatorConfig = table.Copy(indicatorConfig)
        
        for key, value in pairs(indicatorPrototype) do
            if (!newIndicatorConfig[key]) then
                newIndicatorConfig[key] = value
            end
        end

        return newIndicatorConfig
    end

    local loadFile = CreateConVar("minsk_station_pults_load_file", 1, nil, nil, 0, 1)

    -- Load pults config table from file and initiileze or reinitialize pults.
    function Minsk.StationPults.Load()
        local pultsConfog = (loadFile:GetBool()) and loadConfigFromFile() or Minsk.StationPults.PultsConfig

        if (Minsk.StationPults.PultsList and table.Count(Minsk.StationPults.PultsList) ~= 0) then
            Minsk.StationPults.ReinitializePults(pultsConfog)
        else 
            Minsk.StationPults.InitializePults(pultsConfog)
        end
    end

    -- Print json pult config on console.
    -- (pultsConfog) - Pults config table.
    -- (pultNumber) - Print pult number. If nil, print all pults.
    function Minsk.StationPults.PrintJSONConfig(pultsConfog, pultNumber)
        local maxPrintLen = 4096
        local configString = (!pultNumber) and util.TableToJSON(pultsConfog, true) or util.TableToJSON(pultsConfog[pultNumber], true)
        
        if (!configString) then return end

        local len = string.len(configString)
        local amount = 1
        
        if (len > maxPrintLen) then
            amount = math.ceil(len / maxPrintLen)
        end
        
        for i = 1, amount do
            local printString = string.sub(configString, (i - 1) * maxPrintLen + 1, (i * maxPrintLen))
            print(printString)
        end
    end

    -- Load pults config table from file and initiileze or reinitialize pults.
    concommand.Add("minsk_station_pults_load", function(ply, _, args)
        //if (ply and ply != NULL and not ply:IsAdmin()) then return end
        Minsk.StationPults.Load()
    end)

    -- Print json pult config on console.
    -- (args[1]) - Print pult number. If nil, print all pults.
    concommand.Add("minsk_station_pults_print_json_config", function(ply, _, args)
        pultNumber = (args[1]) and tonumber(args[1]) or nil
        Minsk.StationPults.PrintJSONConfig(Minsk.StationPults.PultsConfig, pultNumber)
    end)

    

    hook.Add("InitPostEntity", "Minsk_StationPults_Load", function()
        Minsk.StationPults.Load()
    end)
end