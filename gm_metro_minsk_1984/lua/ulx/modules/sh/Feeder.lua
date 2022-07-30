local CATEGORY_NAME = "Metrostroi"
local textColor = Color(152, 212, 255)

function ulx.feederInfo(calling_ply, feederNumber)
	if (feederNumber == "Feeder number" or feederNumber == "") then feederNumber = nil
	else feederNumber = tonumber(feederNumber) or 0
	end

	local feeders = Metrostroi.Feeder.GetInfoTable(feederNumber)

	if (feederNumber and !feeders[feederNumber]) then ULib.tsayError(calling_ply, "Фидер не найден.", true); return  end

	ULib.tsayColor(calling_ply, false, textColor, "Feeder info:")

	for feeder, info in pairs(feeders) do
		ULib.tsayColor(calling_ply, false, textColor, "Fedeer ", Color(0, 255, 0), ""..feeder, textColor, ":")
		for k, v in pairs(info) do
			local ParameterName = k
			local ParameterColor = Color(0, 255, 0)
			local Parameter = ""

			if (k == "On") then
				ParameterName = "Stage"
				ParameterColor = v and Color(0, 255, 0) or Color(255, 0, 0)
				Parameter = v and "On" or "Off"
			elseif (k == "Fail") then
				ParameterColor = v and Color(255, 0, 0) or Color(0, 255, 0)
				Parameter = v and "Yes" or "No"
			else
				if (type(v) != "string") then Parameter = string.format("%.1f", v)
				else Parameter = v
				end
			end

			ULib.tsayColor(calling_ply, false, textColor, "\t\t"..ParameterName..": ", ParameterColor, Parameter)
		end
	end
end

local feederInfo = ulx.command(CATEGORY_NAME, "ulx feeder info", ulx.feederInfo)
feederInfo:defaultAccess(ULib.ACCESS_ADMIN)
feederInfo:addParam{ type=ULib.cmds.StringArg, hint="Feeder number", ULib.cmds.optional}
feederInfo:help( "Получить информацию по фидерам" )

function ulx.feederConfig(calling_ply, feederNumber)
	if (feederNumber == "Feeder number" or feederNumber == "") then feederNumber = nil
	else feederNumber = tonumber(feederNumber) or 0
	end

	local feeders = Metrostroi.Feeder.GetConfigTable(feederNumber)

	if (feederNumber and !feeders[feederNumber]) then ULib.tsayError(calling_ply, "Фидер не найден.", true); return  end

	ULib.tsayColor(calling_ply, false, textColor, "Feeder config info:")

	for feeder, info in pairs(feeders) do
		ULib.tsayColor(calling_ply, false, textColor, "Fedeer ", Color(0, 255, 0), ""..feeder, textColor, ":")
		for k, v in pairs(info) do
			local ParameterName = k
			local ParameterColor = Color(0, 255, 0)
			local Parameter = ""

			if (k == "CurrentLimit") then
				ParameterName = "Current Limit"
			end
			
			if (type(v) != "string") then Parameter = string.format("%.1f", v)
			else Parameter = v
			end

			ULib.tsayColor(calling_ply, false, textColor, "\t\t"..ParameterName..": ", ParameterColor, Parameter)
		end
	end
end

local feederConfig = ulx.command(CATEGORY_NAME, "ulx feeder config", ulx.feederConfig)
feederConfig:defaultAccess(ULib.ACCESS_ADMIN)
feederConfig:addParam{ type=ULib.cmds.StringArg, hint="Feeder number"}
feederConfig:help("Получить конфигурацию фидеров")