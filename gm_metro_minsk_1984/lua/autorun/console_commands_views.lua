-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2022 году для карты gm_metro_minsk_1984.
--	Описание видимости серверных консольных команд на клиенте.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------

if (game.GetMap() != "gm_metro_minsk_1984") then return end

local tunnelRegions = {
    "ssv",
    "ik-pl",
    "pl-okt",
    "okt-pp",
    "pp-jk",
    "jk-an",
    "an-pch",
    "pch-ms",
}

local function tunnelLightAutoComplete(command, argStr, argNum)
    local result = {}
    local args = string.Split(argStr:Trim():lower(), ' ')
    local fillCommand = command.." "

    if (argNum == 1) then
        for _, region in pairs(tunnelRegions) do
            table.insert(result, fillCommand..region)
        end
        table.insert(result, fillCommand..  "all")
    elseif (args[1] != "all") then
        fillCommand = fillCommand..args[1].." "

        result = {
            fillCommand.."1",
            fillCommand.."2"
        }
    end

    return result
end

local feedersRegions = {
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
}

local function feederRegionsAutoComplete(command)
    local result = {}
    local fillCommand = command.." "

    for _, feeder in pairs(feedersRegions) do
        table.insert(result, fillCommand..feeder)
    end
    table.insert(result, fillCommand..  "all")

    return result
end

local function voltageAutoComplete(command, argStr, argNum)
    local result = {}
    local args = string.Split(argStr:Trim():lower(), ' ')
    local fillCommand = command.." "
    if (argNum == 1) then
        return feederRegionsAutoComplete(command)
    else
        fillCommand = fillCommand..args[1].." "

        result = {
            fillCommand.."750",
            fillCommand.."825",
        }
    end

    return result
end

local function currentLimitAutoComplete(command, argStr, argNum)
    local result = {}
    local args = string.Split(argStr:Trim():lower(), ' ')
    local fillCommand = command.." "

    if (argNum == 1) then
        return feederRegionsAutoComplete(command)
    else
        fillCommand = fillCommand..args[1].." "

        result = {
            fillCommand.."4000",
        }
    end

    return result
end

timer.Simple(3, function()
    concommand.AddClientView("minsk_tunnel_light_on", tunnelLightAutoComplete)
    concommand.AddClientView("minsk_tunnel_light_off", tunnelLightAutoComplete)
    concommand.AddClientView("minsk_tunnel_light_lock", tunnelLightAutoComplete)
    concommand.AddClientView("minsk_tunnel_light_unlock", tunnelLightAutoComplete)

    concommand.AddClientView("metrostroi_voltage_feeder", voltageAutoComplete)
    concommand.AddClientView("metrostroi_current_limit_feeder", currentLimitAutoComplete)
    concommand.AddClientView("metrostroi_feeder_off", currentLimitAutoComplete)
    concommand.AddClientView("metrostroi_feeder_on", currentLimitAutoComplete)
    concommand.AddClientView("metrostroi_feeder_info")
    concommand.AddClientView("metrostroi_feeder_config")
    concommand.AddClientView("metrostroi_feeder_train_info")

    concommand.AddClientView("minsk_mk_lock")
    concommand.AddClientView("minsk_mk_unlock")

    concommand.AddClientView("picket_tp")    
end)