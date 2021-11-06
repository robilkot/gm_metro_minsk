-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для Garry's Mod Metrostroi.
--	Аддон позволяет блокировать кнопки закрытия металоконструкций
--  и активировать индикаторы занятости перегона.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------


if (game.GetMap() != "gm_metro_minsk_1984") then return end

local MKNameList = {
    "MK1",
	"MK3",
	"MK5",
    "MK6",
    "MK9",
    "MK10",
    "MK13",
    "MK14",
	"MK17",
} -- MK names


----   API definition   ----

Minsk = Minsk or {}
Minsk.MK = Minsk.MK or {}

function Minsk.MK.Initialize()    
    Minsk.MK.CloseButtonList = {}
    Minsk.MK.OpenButtonList = {}
    Minsk.MK.IndicatorList = {}
    
    local buttonList = ents.FindByClass("func_button")
    local indicatorList = ents.FindByClass("prop_dynamic")

    for _, ent in ipairs(buttonList) do
        for _, MKName in ipairs(MKNameList) do
            
            if (ent:GetName() == MKName.."close") then
                Minsk.MK.CloseButtonList[MKName] = ent
            end
            if (ent:GetName() == MKName.."open") then
                Minsk.MK.OpenButtonList[MKName] = ent
            end
        end
    end
    
    for _, ent in ipairs(indicatorList) do
        for _, MKName in ipairs(MKNameList) do
            if (ent:GetName() == MKName.."check") then
                Minsk.MK.IndicatorList[MKName] = ent
            end
        end
    end

    if (not game.SinglePlayer()) then
        RunConsoleCommand("minsk_mk_lock")
    end
end

function Minsk.MK.CloseButtonLock(MKName)
    if (Minsk.MK.CloseButtonList[MKName]) then
        Minsk.MK.CloseButtonList[MKName]:Fire("Lock")
    end
end

function Minsk.MK.CloseButtonUnlock(MKName)
    if (Minsk.MK.CloseButtonList[MKName]) then
        Minsk.MK.CloseButtonList[MKName]:Fire("Unlock")
    end
end

function Minsk.MK.OpenButtonLock(MKName)
    if (Minsk.MK.OpenButtonList[MKName]) then
        Minsk.MK.OpenButtonList[MKName]:Fire("Lock")
    end
end

function Minsk.MK.OpenButtonUnlock(MKName)
    if (Minsk.MK.OpenButtonList[MKName]) then
        Minsk.MK.OpenButtonList[MKName]:Fire("Unlock")
    end
end

function Minsk.MK.AllButtonLock()
    for _, MKName in pairs(MKNameList) do
        Minsk.MK.CloseButtonLock(MKName)
        Minsk.MK.OpenButtonLock(MKName)
    end
end

function Minsk.MK.AllButtonUnlock()
    for _, MKName in pairs(MKNameList) do
        Minsk.MK.CloseButtonUnlock(MKName)
        Minsk.MK.OpenButtonUnlock(MKName)
    end
end

function Minsk.MK.IndicatorLock(MKName)
    if (Minsk.MK.IndicatorList[MKName]) then
        Minsk.MK.IndicatorList[MKName]:Fire("Skin", "1") 
    end
end

function Minsk.MK.IndicatorUnlock(MKName)
    if (Minsk.MK.IndicatorList[MKName]) then
        Minsk.MK.IndicatorList[MKName]:Fire("Skin", "0") 
    end
end

function Minsk.MK.Lock(MKName)
    Minsk.MK.CloseButtonLock(MKName)
    Minsk.MK.IndicatorLock(MKName)
end 

function Minsk.MK.Unlock(MKName)
    Minsk.MK.CloseButtonUnlock(MKName)
    Minsk.MK.IndicatorUnlock(MKName)
end


----   Console command definition   ----

concommand.Add("minsk_mk_lock", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    Minsk.MK.AllButtonLock()
end)

concommand.Add("minsk_mk_unlock", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    Minsk.MK.AllButtonUnlock()
end)


-- Initialization
hook.Add("InitPostEntity", "MinskMKInitialize", Minsk.MK.Initialize)