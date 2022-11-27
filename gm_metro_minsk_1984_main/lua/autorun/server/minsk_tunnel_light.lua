-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для карты gm_metro_minsk_1984.
--	Аддон реализует команды для управления туннельным освещением.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------


if (game.GetMap() != "gm_metro_minsk_1984") then return end

local HaulList = {
    "ssv",
    "ik-pl",
    "pl-okt",
    "okt-pp",
    "pp-jk",
    "jk-an",
    "an-pch",
    "pch-ms"
} -- hauls 


----   API definition   ----

Minsk = Minsk or {}
Minsk.TunnelLight = Minsk.TunnelLight or {}


-- Initialize tunnel light
function Minsk.TunnelLight.Initialize()
    Minsk.TunnelLight.Buttons = {}
    Minsk.TunnelLight.ButtonsLocked = false 

    local buttonList = ents.FindByClass("func_button")
    
    for _, ent in ipairs(buttonList) do
        for _, haulName in ipairs(HaulList) do
            for i = 1, 2 do
                for j = 1, 2 do
                    if (ent:GetName() == "lt_"..haulName..i..j) then
                        Minsk.TunnelLight.Buttons[haulName..i..j] = ent
                    end
                end
                
            end
        end
    end

    if (not game.SinglePlayer()) then
        RunConsoleCommand("minsk_tunnel_light_lock")
    end
end

-- On light on haul 
-- (haulName) - haul name
-- (wayNumber) - way number
function Minsk.TunnelLight.On(haulName, wayNumber)
    if (haulName == nil or wayNumber == nil) then return end

    local haulButton1 = Minsk.TunnelLight.Buttons[haulName..wayNumber.."1"]
    local haulButton2 = Minsk.TunnelLight.Buttons[haulName..wayNumber.."2"]
    local buttonsLocked = Minsk.TunnelLight.ButtonsLocked

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
function Minsk.TunnelLight.Off(haulName, wayNumber)
    if (haulName == nil or wayNumber == nil) then return end

    local haulButton1 = Minsk.TunnelLight.Buttons[haulName..wayNumber.."1"]
    local haulButton2 = Minsk.TunnelLight.Buttons[haulName..wayNumber.."2"]
    local buttonsLocked = Minsk.TunnelLight.ButtonsLocked
    
    if (haulButton1 != nil and haulButton1:IsValid()) then
        if (buttonsLocked) then haulButton1:Fire("Unlock") end
        haulButton1:Fire("PressOut")
        if (buttonsLocked) then haulButton1:Fire("Lock") end
    end
    if (haulButton2 != nil and haulButton2:IsValid()) then
        if (buttonsLocked) then haulButton2:Fire("Unlock") end
        haulButton2:Fire("PressOut")
        if (buttonsLocked) then haulButton2:Fire("Lock") end
    end
end

-- On all tunnel light on map
function Minsk.TunnelLight.AllOn()
    local buttonsLocked = Minsk.TunnelLight.ButtonsLocked
    if (buttonsLocked) then Minsk.TunnelLight.ButtonsUnlock() end
    for _, button in pairs(Minsk.TunnelLight.Buttons) do
        if (button != nil and button:IsValid()) then
            button:Fire("PressIn")
        end
    end
    if (buttonsLocked) then Minsk.TunnelLight.ButtonsLock() end
end

-- Off all tunnel light on map
function Minsk.TunnelLight.OffAll()
    local buttonsLocked = Minsk.TunnelLight.ButtonsLocked
    if (buttonsLocked) then Minsk.TunnelLight.ButtonsUnlock() end
    for _, button in pairs(Minsk.TunnelLight.Buttons) do
        if (button != nil and button:IsValid()) then
            button:Fire("PressOut")
        end
    end
    if (buttonsLocked) then Minsk.TunnelLight.ButtonsLock() end
end

-- Lock all tunnel light buttons on map
function Minsk.TunnelLight.ButtonsLock()
    for _, button in pairs(Minsk.TunnelLight.Buttons) do
        if (button != nil and button:IsValid()) then
            button:Fire("Lock")
        end
    end
    Minsk.TunnelLight.ButtonsLocked = true
end

-- Unlock all tunnel light buttons on map
function Minsk.TunnelLight.ButtonsUnlock()
    for _, button in pairs(Minsk.TunnelLight.Buttons) do
        if (button != nil and button:IsValid()) then
            button:Fire("Unlock")
        end
    end
    Minsk.TunnelLight.ButtonsLocked = false
end


----   Console command definition   ----

concommand.Add("minsk_tunnel_light_on", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    if (args[1] == "all") then
        Minsk.TunnelLight.AllOn()
    else
        Minsk.TunnelLight.On(args[1], args[2])
    end
end)

concommand.Add("minsk_tunnel_light_off", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    if (args[1] == "all") then
        Minsk.TunnelLight.OffAll()
    else
        Minsk.TunnelLight.Off(args[1], args[2])
    end
end)

concommand.Add("minsk_tunnel_light_lock", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    Minsk.TunnelLight.ButtonsLock()
end)

concommand.Add("minsk_tunnel_light_unlock", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    Minsk.TunnelLight.ButtonsUnlock()
end)


-- Initialization
hook.Add("InitPostEntity", "MinskTunnelLightInitialize", Minsk.TunnelLight.Initialize)
