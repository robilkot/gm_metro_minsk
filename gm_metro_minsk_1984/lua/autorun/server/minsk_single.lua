-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для Garry's Mod Metrostroi.
--	Аддон адаптирует карту gm_metro_minsk_1984 для одиночной игры
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------

if (game.GetMap() ~= "gm_metro_minsk_1984") or not game.SinglePlayer () then return end

local ENTClearList = {
    ["lua_run"] = {},
    ["trigger_multiple"] = {"RC*"}
}

local DepotTrackswitchName = "trackswitch_d*"

local function ClearEntities()
    for class, names in pairs(ENTClearList) do
        for _, ent in pairs(ents.FindByClass(class)) do
            if (ent:IsValid()) then
                if (#names ~= 0) then
                    for _, name in ipairs(names) do
                        if (name[#name]) == "*" then
                            if (string.sub(ent:GetName(), 1, #name - 1)  == string.sub(name, 1, #name - 1)) then
                                ent:Remove()
                            end 
                        else
                            if (ent:GetName() == name) then
                                ent:Remove()
                            end 
                        end
                        
                    end
                else
                    ent:Remove()
                end
            end
        end
    end
end

local function UnlockDepotTrackswitch()
    for _, ent in pairs(ents.FindByClass("prop_door_rotating")) do
        if (ent:IsValid()) then
            if (string.sub(ent:GetName(), 1, #DepotTrackswitchName - 1)  == string.sub(DepotTrackswitchName, 1, #DepotTrackswitchName - 1)) then
                ent:Fire("Unlock")
            end    
        end
    end
end

local function SinglePreparation()
    ClearEntities()
    UnlockDepotTrackswitch()
end

timer.Simple(1, SinglePreparation)

