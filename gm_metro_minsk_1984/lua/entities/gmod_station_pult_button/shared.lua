-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2022 году для карты gm_metro_minsk_1984.
--	Аддон добавляет станционные пульты управления функционалом карты.
--  Данный файл отвечает за описание ентити пульта (gmod_station_pult). 
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------

DEFINE_BASECLASS("base_gmodentity")
ENT.Base = "base_gmodentity"
ENT.Type            = "anim"

ENT.PrintName       = "Station pult" 
ENT.Author          = "klusandr"

ENT.Spawnable       = false 
ENT.AdminSpawnable  = true