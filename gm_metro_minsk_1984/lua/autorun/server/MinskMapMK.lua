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

if (game.GetMap() ~= "gm_metro_minsk_1984") then return end

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
}

MinskMapMK = {}
MinskMapMK.ButtonList = {}
MinskMapMK.IndicatorList = {}

local function ButtonLock(MKName)
    if (MinskMapMK.ButtonList[MKName]) then
        MinskMapMK.ButtonList[MKName]:Fire("Lock")
    end
end

local function ButtonUnlock(MKName)
    if (MinskMapMK.ButtonList[MKName]) then
        MinskMapMK.ButtonList[MKName]:Fire("Unlock")
    end
end

local function IndicatorLock(MKName)
    if (MinskMapMK.IndicatorList[MKName]) then
        MinskMapMK.IndicatorList[MKName]:Fire("Skin", "1") 
    end
end

local function IndicatorUnlock(MKName)
    if (MinskMapMK.IndicatorList[MKName]) then
        MinskMapMK.IndicatorList[MKName]:Fire("Skin", "0") 
    end
end

function MinskMapMK.MKInitialize()
    local buttonList = ents.FindByClass("func_button")
    local indicatorList = ents.FindByClass("prop_dynamic")
    
    for _, ent in ipairs(buttonList) do
        for _, MKName in ipairs(MKNameList) do
            
            if (ent:GetName() == MKName.."close") then
                MinskMapMK.ButtonList[MKName] = ent
            end
        end
    end
    
    for _, ent in ipairs(indicatorList) do
        for _, MKName in ipairs(MKNameList) do
            if (ent:GetName() == MKName.."check") then
                MinskMapMK.IndicatorList[MKName] = ent
            end
        end
    end
end

function MinskMapMK.Lock(MKName)
    ButtonLock(MKName)
    IndicatorLock(MKName)
end 

function MinskMapMK.Unlock(MKName)
    ButtonUnlock(MKName)
    IndicatorUnlock(MKName)
end


MinskMapMK.MKInitialize()