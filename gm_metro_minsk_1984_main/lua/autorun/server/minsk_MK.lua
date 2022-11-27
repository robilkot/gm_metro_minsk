-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для карты gm_metro_minsk_1984.
--	Аддон позволяет блокировать кнопки закрытия металоконструкций
--  и активировать индикаторы занятости перегона.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------

-- Check map.
if (game.GetMap() != "gm_metro_minsk_1984") then return end

-- MK names list.
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

local function getFile(path, name)
    local data,found
    if file.Exists(Format(path..".txt",name),"DATA") then
        data= util.JSONToTable(file.Read(Format(path..".txt",name),"DATA"))
        found = true
    end
    if not data and file.Exists(Format(path..".lua",name),"LUA") then
        data = util.JSONToTable(file.Read(Format(path..".lua",name),"LUA"))
        found = true
    end
    if not found then
        --print(Format("%s definition file not found: %s",id,Format(path,name)))
        return
    elseif not data then
        --print(Format("Parse error in %s %s definition JSON",id,Format(path,name)))
        return
    end
    return data
end

----   API definition   ----

Minsk = Minsk or {}
Minsk.MK = Minsk.MK or {}

-- List of MK.
Minsk.MK.List = Minsk.MK.List or {}
-- Is all MK button lock.
Minsk.MK.IsAllButtonLock = Minsk.MK.IsAllButtonLock or false

-- Initialize MK system.
function Minsk.MK.Initialize()
    for _, MKName in pairs(MKNameList) do
        Minsk.MK.List[MKName] = {}
    end

    for _, ent in ipairs(ents.FindByClass("func_button")) do
        for _, MKName in ipairs(MKNameList) do        
            if (ent:GetName() == MKName.."close") then
                Minsk.MK.List[MKName].CloseButton = ent
            end
            if (ent:GetName() == MKName.."open") then
                Minsk.MK.List[MKName].OpenButton = ent
            end
        end
    end
    
    for _, ent in ipairs(ents.FindByClass("prop_dynamic")) do
        for _, MKName in ipairs(MKNameList) do
            if (ent:GetName() == MKName.."check") then
                Minsk.MK.List[MKName].Indicator = ent
            end
        end
    end

    for _, ent in ipairs(ents.FindByClass("func_door_rotating")) do
        for _, MKName in ipairs(MKNameList) do
            if (ent:GetName() == MKName.."col") then
                Minsk.MK.List[MKName].Entity = ent
            end
        end
    end

    if (not Minsk.Server and Metrostroi) then

        timer.Simple(3.0, Minsk.MK.LoadSignals)

        local m_load = Metrostroi.Load
        function Metrostroi.Load(name,keep_signs)
            m_load(name,keep_signs)
            timer.Simple(1.0, Minsk.MK.LoadSignals)
        end

        hook.Add("Think", "Minsk.MK.Think", Minsk.MK.Think)
        
    end

    if (not game.SinglePlayer()) then
        RunConsoleCommand("minsk_mk_lock")
    end
end

-- Returns mk table info.
-- RETURN - Table of MK info.
function Minsk.MK.GetTableMKInfo()
    local mkInfo = {}

    for mkName, mk in pairs(Minsk.MK.List) do
        local isClose = false 
        if (IsValid(mk.Entity)) then
            if (mk.Entity:GetInternalVariable("m_angAbsRotation")[2] != 0) then
                isClose = true
            end
        end

        mkInfo[mkName] = {
            IsClose = isClose
        }
    end

    return mkInfo
end

-- Used for single player and server not have online pults,
-- MK signals control.
if (not Minsk.Server and Metrostroi) then
    
    -- Load MK signlas for map.
    -- (name) - Map name.
    function Minsk.MK.LoadSignals(mapName)
        local data = getFile("metrostroi_data/mk_signs_%s", mapName or game.GetMap())
        
        if (not data) then return end

        for MKName, signalsName in pairs(data) do
            if (Minsk.MK.List[MKName]) then
                Minsk.MK.List[MKName].SignalList = {}
                for _, signalName in pairs(signalsName) do
                    local signal = Metrostroi.GetSignalByName(signalName)
                    if (signal) then
                        Minsk.MK.List[MKName].SignalList[signalName] = signal
                    end
                end
            end
        end 
    end

    -- Think function, calling every tick server.
    function Minsk.MK.Think()
        for MKName, MK in pairs(Minsk.MK.List) do
            if (IsValid(MK.Entity) and MK.SignalList) then
                local mkRotation = MK.Entity:GetInternalVariable("m_angAbsRotation")[2]

                if (mkRotation != 0) then
                    if (not MK.IsClose) then
                        Minsk.MK.CloseSignals(MKName)
                    end

                    MK.IsClose = true 
                else
                    if (MK.IsClose) then
                        Minsk.MK.OpenSignals(MKName)
                    end

                    MK.IsClose = false 
                end  
            end
        end
    end

    -- Close signal for MK.
    -- (MKName) - Name of MK.
    function Minsk.MK.CloseSignals(MKName)
        if (Minsk.MK.List[MKName]) then
            for _, signal in pairs(Minsk.MK.List[MKName].SignalList) do
                if (IsValid(signal)) then
                    local sig = ""
                    local lenses = ""

                    for _, lens in pairs(signal.Lenses) do
                        lenses = lenses..lens
                    end
                    
                    for i = 1, #lenses do
                        if (lenses[i] == 'R') then
                            sig = sig.."1"
                        else
                            sig = sig.."0"
                        end
                    end
                    
                    signal.ControllerLogic = true
                    signal.Sig = sig
                    signal.ARSSpeedLimit = 0
                end
            end
        end
    end

    -- Open signal for MK.
    -- (MKName) - Name of MK.
    function Minsk.MK.OpenSignals(MKName)
        if (Minsk.MK.List[MKName]) then
            for _, signal in pairs(Minsk.MK.List[MKName].SignalList) do
                if (IsValid(signal)) then
                    signal.ControllerLogic = false
                end
            end
        end
    end

end

-- Close button lock.
-- (MKName) - Name of MK.
function Minsk.MK.CloseButtonLock(MKName)
    if (Minsk.MK.List[MKName]) then
        if (IsValid(Minsk.MK.List[MKName].CloseButton)) then
            Minsk.MK.List[MKName].CloseButton:Fire("Lock")
        end 
    end
end

-- Close button unlock.
-- (MKName) - Name of MK.
function Minsk.MK.CloseButtonUnlock(MKName)
    if (IsValid(Minsk.MK.List[MKName].CloseButton)) then
        Minsk.MK.List[MKName].CloseButton:Fire("Unlock")
    end
end

-- Set indicator to lock stage.
-- (MKName) - Name of MK.
function Minsk.MK.IndicatorLock(MKName)
    if (IsValid(Minsk.MK.List[MKName].Indicator)) then
        Minsk.MK.List[MKName].Indicator:Fire("Skin", "1") 
    end
end

-- Set indicator to unlock stage.
-- (MKName) - Name of MK.
function Minsk.MK.IndicatorUnlock(MKName)
    if (IsValid(Minsk.MK.List[MKName].Indicator)) then
        Minsk.MK.List[MKName].Indicator:Fire("Skin", "0") 
    end
end

-- Open button lock.
-- (MKName) - Name of MK.
function Minsk.MK.OpenButtonLock(MKName)
    if (IsValid(Minsk.MK.List[MKName].OpenButton)) then
        Minsk.MK.List[MKName].OpenButton:Fire("Lock")
    end
end

-- Close button unlock.
-- (MKName) - Name of MK.
function Minsk.MK.OpenButtonUnlock(MKName)
    if (IsValid(Minsk.MK.List[MKName].OpenButton)) then
        Minsk.MK.List[MKName].OpenButton:Fire("Unlock")
    end
end

-- Lock all MK button.
function Minsk.MK.AllButtonLock()
    Minsk.MK.IsAllButtonLock = true

    for _, MKName in pairs(MKNameList) do
        Minsk.MK.CloseButtonLock(MKName)
        Minsk.MK.OpenButtonLock(MKName)
    end
end

-- Unlock all MK button.
function Minsk.MK.AllButtonUnlock()
    Minsk.MK.IsAllButtonLock = false

    for _, MKName in pairs(MKNameList) do
        Minsk.MK.CloseButtonUnlock(MKName)
        Minsk.MK.OpenButtonUnlock(MKName)
    end
end

-- Lock MK control.
function Minsk.MK.Lock(MKName)
    Minsk.MK.CloseButtonLock(MKName)
    Minsk.MK.IndicatorLock(MKName)
end 

-- Unlock MK control.
function Minsk.MK.Unlock(MKName)
    if (not Minsk.MK.IsAllButtonLock) then
        Minsk.MK.CloseButtonUnlock(MKName)
    end
    
    Minsk.MK.IndicatorUnlock(MKName)
end

----   Console command definition   ----

-- Lock all MK buttons for players. Used admin only.
concommand.Add("minsk_mk_lock", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    Minsk.MK.AllButtonLock()
end)

-- Unlock all MK buttons for players. Used admin only.
concommand.Add("minsk_mk_unlock", function(ply, _, args)
    if (ply and ply != NULL and not ply:IsAdmin()) then return end
    Minsk.MK.AllButtonUnlock()
end)


-- Initialization on start.
hook.Add("InitPostEntity", "Minsk.MK.Initialize", Minsk.MK.Initialize)