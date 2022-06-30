-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2022 году для карты gm_metro_minsk_1984.
--	Аддон добавляет логгирование для скриптовых компонентов карты.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------

Minsk = Minsk or {}
Minsk.Logger = {}

function Minsk.Logger.LogError(message, tag)
    tag = (tag) and "["..tag.."]" or ""

    ErrorNoHalt("[Minsk]", tag, " "..message..".", "\n")
end