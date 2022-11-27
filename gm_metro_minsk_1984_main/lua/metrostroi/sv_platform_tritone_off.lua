-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для карты gm_metro_minsk_1984.
--	Аддон отключет звук тритон на станциях.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------


if (game.GetMap() != "gm_metro_minsk_1984") then return end

hook.Add("PostGamemodeLoaded", "PlatformTritoneOffInitialize", function()   --Хук, вызываемый после инциализации игры, начало тела функции с кодом

ENT = scripted_ents.GetStored("gmod_track_platform").t

ENT.TriTone = Sound("")

end)    --Окончание тела функции хука    
    

