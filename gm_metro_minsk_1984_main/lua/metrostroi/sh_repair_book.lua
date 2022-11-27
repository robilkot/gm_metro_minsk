-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для карты gm_metro_minsk_1984.
--	Аддон добавляет книгу ремонта в составы (общая часть).
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------


if (game.GetMap() != "gm_metro_minsk_1984") then return end

local Trains = {						
	"gmod_subway_81-717_mvm_custom",
}


hook.Add("InitPostEntity", "RepairBookInitializeShared", function()       --Хук, вызываемый после инциализации игры, начало тела функции с кодом

for _, trainName in pairs(Trains) do
	local Train = scripted_ents.GetStored(trainName).t
	local spawnTablePos

	for key, spawnTable in pairs(Train.Spawner) do
		if (tonumber(key) != nil) then
			if (spawnTable[1] == "SpawnMode") then
				spawnTablePos = key
			end
		end
	end

	table.insert(Train.Spawner, (spawnTablePos or #Train.Spawner) - 1, {"RepairBook", "Книга ремонта", "Boolean"})
end

end) --Окончание тела функции хука
