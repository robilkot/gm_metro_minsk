local CATEGORY_NAME = "Metrostroi"

function ulx.feederInfo(calling_ply)
	ULib.tsayColor(calling_ply, false, Color(152, 212, 255), "Fedeer info:")
	for feeder, info in pairs(Metrostroi.Feeder.GetInfoTable()) do
		ULib.tsayColor(calling_ply, false, Color(152, 212, 255), "Fedeer ", Color(0, 255, 0), ""..feeder, Color(152, 212, 255), ":")
		for k, v in pairs(info) do
			ULib.tsayColor(calling_ply, false, Color(152, 212, 255), "\t\t"..k..": ", (v == "Off") and Color(255, 0, 0) or Color(0, 255, 0), ""..v)
		end
	end
end

local feederInfo = ulx.command(CATEGORY_NAME, "ulx feeder info", ulx.feederInfo)
feederInfo:defaultAccess(ULib.ACCESS_ADMIN)
feederInfo:help( "Получить информацию по фидерам" )