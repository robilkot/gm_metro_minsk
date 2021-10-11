-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для карты gm_metro_minsk_1984.
--	Аддон добавляет плакат первое поезди на составы 81-717 серии.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------


if (game.GetMap() != "gm_metro_minsk_1984") then return end

hook.Add("InitPostEntity", "SignboardInitialize1", function()       --Хук, вызываемый после инциализации игры, начало тела функции с кодом

local Trains = {						
	["gmod_subway_81-717_mvm"]	= Vector(-6, -0.1, -10),
}

for trainName, boardPos in pairs(Trains) do
	local Train = scripted_ents.GetStored(trainName).t
	
	Train.ClientProps["signboard"] = {
		model = "models/first_run.mdl",
		pos = boardPos,
		ang = Angle(0,0,0),
		hideseat=1.5
	}
	
	Train.Signboard = Train.Signboard or {}

	Train.Signboard.Think = Train.Signboard.Think or Train.Think
	function Train:Think()
		self.Signboard.Think(self)
		
		self:ShowHide("signboard", self:GetNW2Bool("Signboard") and self:GetNW2Bool("Mask22"))
	end
end
	

end) --Окончание тела функции хука



	

