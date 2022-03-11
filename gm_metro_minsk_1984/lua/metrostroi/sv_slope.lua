local function getFile(path,name,id)
    local data,found
    if file.Exists(Format(path..".txt",name),"DATA") then
        data= util.JSONToTable(file.Read(Format(path..".txt",name),"DATA"))
        found = true
    end
    if not data and file.Exists(Format(path..".lua",name),"LUA") then
        data= util.JSONToTable(file.Read(Format(path..".lua",name),"LUA"))
        found = true
    end
    if not found then
        return
    elseif not data then
        return
    end
    return data
end

local function loadSlopes(name, keep)
    name = name or game.GetMap()

    local slopes_ents = ents.FindByClass("gmod_track_slope")
    for k,v in pairs(slopes_ents) do SafeRemoveEntity(v) end

    if keep then return end
    local slopes = getFile("metrostroi_data/slope_%s",name,"Slope")
    if not slopes then return end

    for k,v in pairs(slopes) do
        local ent = ents.Create("gmod_track_slope")
        if IsValid(ent) then
            ent:SetPos(v.Pos)
            ent:SetAngles(v.Angles)
            
            ent.Type = v.Type or 1
            ent.YOffset = v.YOffset or 0
            ent.ZOffset = v.ZOffset or 0
            ent.PAngle = v.PAngle or 0
            ent.YAngle = v.YAngle or 0
            ent.Value_u = v.Value_u or ""
            ent.Length = v.Length or ""
            ent:SendUpdate()
            ent:Spawn()
        end
    end
    
end

hook.Add("Initialize", "Metrostroi_MapSlopeInitialize", function()
    timer.Simple(2.0, loadSlopes)
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
    local slopes = {}
    local slopes_ents = ents.FindByClass("gmod_track_slope")
    
    for k,v in pairs(slopes_ents) do
        table.insert(slopes, {
            Pos = v:GetPos(),
            Angles = v:GetAngles(),
            Type = (v.Type ~= 1) and v.Type or nil,
            YOffset = (v.YOffset ~= 0) and v.YOffset or nil,
            ZOffset = (v.ZOffset ~= 0) and v.ZOffset or nil,
            PAngle = (v.PAngle ~= 0) and v.PAngle or nil,
            YAngle = (v.YAngle ~= 0) and v.YAngle or nil,
            Value_u = v.Value_u,
            Length = v.Length,w
        })
    end
    local data = util.TableToJSON(slopes, true)
    file.Write(string.format("metrostroi_data/slope_%s.txt", name), data)
end

local m_load = Metrostroi.Load
function Metrostroi.Load(name,keep_signs)
    m_load(name,keep_signs)
    loadSlopes(name,keep_signs)
end

end)                                        --Окончание тела функции с задержкой

Metrostroi.Slope = {}