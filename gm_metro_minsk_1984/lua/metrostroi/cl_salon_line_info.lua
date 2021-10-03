-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для карты gm_metro_minsk_1984.
--	Аддон заменяет стандартные наддверные схемы на минские.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------

if (game.GetMap() != "gm_metro_minsk_1984") then return end

local Trains = {
    ["gmod_subway_81-717_mvm"]  = "models/lin_minsk84.mdl",
    ["gmod_subway_81-714_mvm"]  = "models/lin_minsk84.mdl",
	["gmod_subway_81-717_lvz"]  = "models/lin_minsk84.mdl",
	["gmod_subway_81-714_lvz"]  = "models/lin_minsk84.mdl"
}


hook.Add("InitPostEntity", "BogeySoundInitialize", function()       --Хук, вызываемый после инциализации игры, начало тела функции с кодом

for train, model in pairs(Trains) do
    ENT = scripted_ents.GetStored(train).t

    ENT.ClientProps["schemes"].model = model
    ENT.ClientProps["schemes"].pos = Vector(-47, 0, 13)
end

end) --Окончание тела функции хука
