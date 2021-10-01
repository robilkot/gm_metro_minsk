local CATEGORY_NAME = "Metrostroi"

function ulx.picketTp(calling_ply, rightNum, leftNum)
	if (#leftNum > 3 or leftNum == "") then
		leftNum = rightNum
	end
	Metrostroi.Picket.TeleportTo(calling_ply, rightNum, leftNum)
end

local picketTp = ulx.command(CATEGORY_NAME, "ulx picket tp", ulx.picketTp)
picketTp:defaultAccess(ULib.ACCESS_ADMIN)
picketTp:addParam{ type=ULib.cmds.StringArg, hint="right", ULib.cmds.optional,}
picketTp:addParam{ type=ULib.cmds.StringArg,  hint="left", ULib.cmds.optional,}
picketTp:help("Телепортация к заданному пикету")


CATEGORY_NAME = "Teleport"

picketTp = ulx.command(CATEGORY_NAME, "ulx picket tp ", ulx.picketTp)
picketTp:defaultAccess(ULib.ACCESS_ADMIN)
picketTp:addParam{ type=ULib.cmds.StringArg, hint="right", ULib.cmds.optional,}
picketTp:addParam{ type=ULib.cmds.StringArg,  hint="left", ULib.cmds.optional,}
picketTp:help("Телепортация к заданному пикету")