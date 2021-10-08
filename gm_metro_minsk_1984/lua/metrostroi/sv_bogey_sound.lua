-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для карты gm_metro_minsk_1984.
--	Аддон заставляет тележку воспроизводить звуки, проезжая через определённые триггеры.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------


hook.Add("InitPostEntity", "BogeySoundInitialize", function()   --Хук, вызываемый после инциализации игры, начало тела функции с кодом


ENT = scripted_ents.GetStored("gmod_train_bogey").t

local m_Think = ENT.Think
function ENT:Think()
    local retVal = m_Think(self)

    if (self:GetNW2String("BogeySound:SoundName", "") ~= "") then
        self:SetNW2String("BogeySound:SoundName", "")
    end
    
    return retVal
end

local m_AcceptInput = ENT.AcceptInput
function ENT:AcceptInput(inputName, activator, called, data)
    if inputName == "BogeySound" then 
		
        self:SetNW2String("BogeySound:SoundName", data)
    end
	
    return m_AcceptInput(self, inputName, activator, called, data)
end

end)    --Окончание тела функции хука    
    

