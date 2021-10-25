-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для карты gm_metro_minsk_1984.
--	Аддон реализует команды для управления туннельным освещением.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------


if (game.GetMap() ~= "gm_metro_minsk_1984") then return end

local HaulList = {
  "ik-pl",
  "pl-okt",
  "okt-pp",
  "pp-jk",
  "jk-an",
  "an-pch",
  "pch-ms"  
} -- Пергоны 


----   API definition   ----

Metrostroi.TunnelLight = Metrostroi.TunnelLight or {}


-- Initialize tunnel light
function Metrostroi.TunnelLight.Initialize()
    Metrostroi.TunnelLight.Buttons = {}
    Metrostroi.TunnelLight.ButtonsLocked = false 

    local buttonList = ents.FindByClass("func_button")
    
    for _, ent in ipairs(buttonList) do
        for _, haulName in ipairs(HaulList) do
            for i = 1, 2 do
                for j = 1, 2 do
                    if (ent:GetName() == "lt_"..haulName..i..j) then
                        Metrostroi.TunnelLight.Buttons[haulName..i..j] = ent
                    end
                end
                
            end
        end
    end

    if (not game.SinglePlayer()) then
        RunConsoleCommand("metrostroi_tunnel_light_lock", "all")
    end
end

-- On light on haul 
-- (haulName) - haul name
-- (wayNumber) - way number
function Metrostroi.TunnelLight.On(haulName, wayNumber)
    if (haulName == nil or wayNumber == nil) then return end

    local haulButton1 = Metrostroi.TunnelLight.Buttons[haulName..wayNumber.."1"]
    local haulButton2 = Metrostroi.TunnelLight.Buttons[haulName..wayNumber.."2"]
    local buttonsLocked = Metrostroi.TunnelLight.ButtonsLocked

    if (haulButton1 != nil and haulButton1:IsValid()) then
        if (buttonsLocked) then haulButton1:Fire("Unlock") end
        haulButton1:Fire("PressIn")
        if (buttonsLocked) then haulButton1:Fire("Lock") end
    end
    if (haulButton2 != nil and haulButton2:IsValid()) then
        if (buttonsLocked) then haulButton2:Fire("Unlock") end
        haulButton2:Fire("PressIn")
        if (buttonsLocked) then haulButton2:Fire("Lock") end  
    end
end

-- Off light on haul 
-- (haulName) - haul name
-- (wayNumber) - way number
function Metrostroi.TunnelLight.Off(haulName, wayNumber)
    if (haulName == nil or wayNumber == nil) then return end

    local haulButton1 = Metrostroi.TunnelLight.Buttons[haulName..wayNumber.."1"]
    local haulButton2 = Metrostroi.TunnelLight.Buttons[haulName..wayNumber.."2"]
    local buttonsLocked = Metrostroi.TunnelLight.ButtonsLocked
    
    if (haulButton1 != nil and haulButton1:IsValid()) then
        if (buttonsLocked) then haulButton1:Fire("Unlock") end
        haulButton1:Fire("PressOut")
        print(Metrostroi.TunnelLight.ButtonsLocked)
        if (buttonsLocked) then haulButton1:Fire("Lock") end
    end
    if (haulButton2 != nil and haulButton2:IsValid()) then
        if (buttonsLocked) then haulButton2:Fire("Unlock") end
        haulButton2:Fire("PressOut")
        if (buttonsLocked) then haulButton2:Fire("Lock") end
    end
end

-- On all tunnel light on map
function Metrostroi.TunnelLight.AllOn()
    local buttonsLocked = Metrostroi.TunnelLight.ButtonsLocked
    if (buttonsLocked) then Metrostroi.TunnelLight.ButtonsUnlock() end
    for _, button in pairs(Metrostroi.TunnelLight.Buttons) do
        if (button != nil and button:IsValid()) then
            button:Fire("PressIn")
        end
    end
    print(buttonsLocked)
    if (buttonsLocked) then Metrostroi.TunnelLight.ButtonsLock() end
end

-- Off all tunnel light on map
function Metrostroi.TunnelLight.OffAll()
    local buttonsLocked = Metrostroi.TunnelLight.ButtonsLocked
    if (buttonsLocked) then Metrostroi.TunnelLight.ButtonsUnlock() end
    for _, button in pairs(Metrostroi.TunnelLight.Buttons) do
        if (button != nil and button:IsValid()) then
            button:Fire("PressOut")
        end
    end
    if (buttonsLocked) then Metrostroi.TunnelLight.ButtonsLock() end
end

-- Lock all tunnel light buttons on map
function Metrostroi.TunnelLight.ButtonsLock()
    for _, button in pairs(Metrostroi.TunnelLight.Buttons) do
        if (button != nil and button:IsValid()) then
            button:Fire("Lock")
        end
    end
    Metrostroi.TunnelLight.ButtonsLocked = true
end

-- Unlock all tunnel light buttons on map
function Metrostroi.TunnelLight.ButtonsUnlock()
    for _, button in pairs(Metrostroi.TunnelLight.Buttons) do
        if (button != nil and button:IsValid()) then
            button:Fire("Unlock")
        end
    end
    Metrostroi.TunnelLight.ButtonsLocked = false
end


----   Console command definition   ----

concommand.Add("metrostroi_tunnel_light_on", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    if (args[1] == "all") then
        Metrostroi.TunnelLight.AllOn()
    else
        Metrostroi.TunnelLight.On(args[1], args[2])
    end
end)

concommand.Add("metrostroi_tunnel_light_off", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    if (args[1] == "all") then
        Metrostroi.TunnelLight.OffAll()
    else
        Metrostroi.TunnelLight.Off(args[1], args[2])
    end
end)

concommand.Add("metrostroi_tunnel_light_lock", function(ply, _, args)
    Metrostroi.TunnelLight.ButtonsLock()
end)

concommand.Add("metrostroi_tunnel_light_unlock", function(ply, _, args)
    Metrostroi.TunnelLight.ButtonsUnlock()
end)


-- Initialization
hook.Add("InitPostEntity", "TunnelLightInitialize", Metrostroi.TunnelLight.Initialize)
--Metrostroi.TunnelLight.Initialize()