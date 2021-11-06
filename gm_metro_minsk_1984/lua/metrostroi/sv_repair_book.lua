-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для карты gm_metro_minsk_1984.
--	Аддон добавляет книгу ремонта в составы(серверная часть).
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------


if (game.GetMap() != "gm_metro_minsk_1984") then return end

hook.Add("InitPostEntity", "RepairBookInitialize", function()       --Хук, вызываемый после инциализации игры, начало тела функции с кодом

local Trains = {						
	"gmod_subway_81-717_mvm",
}

for _, trainName in pairs(Trains) do
	local ENT = scripted_ents.GetStored(trainName).t
	
	ENT.RepairBook = ENT.RepairBook or {}

	ENT.RepairBook.Think = ENT.RepairBook.Think or ENT.Think
	function ENT:Think()
		local wagonNumbers = {}

		for _, train in pairs(self.WagonList) do
			table.insert(wagonNumbers, train.WagonNumber)
		end

		self:SetNW2String("RepairBookWagonNumbers", util.TableToJSON(wagonNumbers))
		return self.RepairBook.Think(self)
	end
end
	

end) --Окончание тела функции хука



	

