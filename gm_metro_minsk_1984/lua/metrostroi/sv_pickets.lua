-----------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для Garry's Mod Metrostroi.
--	Аддон добавляет в игру пикеты.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------

local function getFile(path,name,id)
    local data,found
    if file.Exists(Format(path..".txt",name),"DATA") then
        --print(Format("Metrostroi: Loading %s definition...",id))
        data= util.JSONToTable(file.Read(Format(path..".txt",name),"DATA"))
        found = true
    end
    if not data and file.Exists(Format(path..".lua",name),"LUA") then
        --print(Format("Metrostroi: Loading default %s definition...",id))
        data= util.JSONToTable(file.Read(Format(path..".lua",name),"LUA"))
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

local function loadPickets(name, keep)
    name = name or game.GetMap()

    local pickets_ents = ents.FindByClass("gmod_track_picket")
    for k,v in pairs(pickets_ents) do SafeRemoveEntity(v) end

    if keep then return end
    local pickets = getFile("metrostroi_data/picket_%s",name,"Picket")
    if not pickets then return end

    for k,v in pairs(pickets) do
        local ent = ents.Create("gmod_track_picket")
        if IsValid(ent) then
            ent:SetPos(v.Pos)
            ent:SetAngles(v.Angles)
            
            ent.Type = v.Type or 1
            ent.YOffset = v.YOffset or 0
            ent.ZOffset = v.ZOffset or 0
            ent.PAngle = v.PAngle or 0
            ent.YAngle = v.YAngle or 0
            ent.Left = v.Left or false 
            ent.RightNumber = v.RightNumber or ""
            ent.LeftNumber = v.LeftNumber or ""
            ent:SendUpdate()
            ent:Spawn()
        end
    end
    
end

hook.Add("Initialize", "Metrostroi_MapPicketInitialize", function()
    timer.Simple(2.0, loadPickets)
end)


timer.Simple(1, function()                  --Задержка после загрузки игры

local m_save = Metrostroi.Save
function Metrostroi.Save(name)
    m_save(name)

    if not file.Exists("metrostroi_data","DATA") then
        file.CreateDir("metrostroi_data")
    end
    name = name or game.GetMap()

    -- Format signs, signal, switch data
    local pickets = {}
    local pickets_ents = ents.FindByClass("gmod_track_picket")
    
    for k,v in pairs(pickets_ents) do
        table.insert(pickets, {
            Pos = v:GetPos(),
            Angles = v:GetAngles(),
            Type = (v.Type ~= 1) and v.Type or nil,
            YOffset = (v.YOffset ~= 0) and v.YOffset or nil,
            ZOffset = (v.ZOffset ~= 0) and v.ZOffset or nil,
            PAngle = (v.PAngle ~= 0) and v.PAngle or nil,
            YAngle = (v.YAngle ~= 0) and v.YAngle or nil,
            Left = (v.Left ~= false) and v.Left or nil,
            RightNumber = v.RightNumber,
            LeftNumber = v.LeftNumber,w
        })
    end
    local data = util.TableToJSON(pickets, true)
    file.Write(string.format("metrostroi_data/picket_%s.txt", name), data)
end

local m_load = Metrostroi.Load
function Metrostroi.Load(name,keep_signs)
    m_load(name,keep_signs)
    loadPickets(name,keep_signs)
end

end)                                        --Окончание тела функции с задержкой

