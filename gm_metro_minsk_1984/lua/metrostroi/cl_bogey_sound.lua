-----------------------------------------------------------------------------------------
--                          Творческое объеденение "MetroPack"
--	Скрипт написан в 2021 году, для дополнения Metrostroi, карты gm_metro_minsk_1984.
--	Аддон заставляет тележку воспроизводить звуки, проезжая через определённые триггеры.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
-----------------------------------------------------------------------------------------


local soundNames = {
    ["okt-pl1"]     = "bogey/okt-pl1.mp3",
	["gate1"]     = "bogey/gate1.mp3",
}


hook.Add("Initialize", "BogeySoundInitialize", function()       --Хук, вызываемый после инциализации игры, начало тела функции с кодом


ENT = scripted_ents.GetStored("gmod_train_bogey").t

function ENT:SoundReload(sound)
    if (self.Sounds[sound]) then
        local snd = self.Sounds[sound]
        if (snd:IsPlaying()) then
            snd:ChangeVolume(0, 0)
            snd:Stop()
        end
    end
end

local m_ReinitializeSounds = ENT.ReinitializeSounds
function ENT:ReinitializeSounds()
    m_ReinitializeSounds(self)

    for k,v in pairs(soundNames) do
        util.PrecacheSound(v)

        self.Sounds[k] = CreateSound(self, Sound(v))
    end
end

local m_Think = ENT.Think
function ENT:Think()
    m_Think(self)

    local speed = self:GetSpeed()
    local soundName = self:GetNW2String("BogeySound:SoundName", "")
    local tunnel_pitch, tunnel_volume
    
    tunnel_pitch = (0.01*speed)+0.5
	if speed<30 then tunnel_volume = speed/30 elseif speed>=30 then tunnel_volume=(speed+20)/50 end

    if (soundName ~= "") then
        self:SoundReload(soundName)
        self:SetSoundState(soundName, tunnel_volume, tunnel_pitch)
    end
end


end) --Окончание тела функции хука



