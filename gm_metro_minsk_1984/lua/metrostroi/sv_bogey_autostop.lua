-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для карты gm_metro_minsk_1984.
--	Аддон заставляет тележку срывать автостоп, проезжая через определённые триггеры.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------


hook.Add("InitPostEntity", "BogeyAutostopInitialize", function()   --Хук, вызываемый после инциализации игры, начало тела функции с кодом

ENT = scripted_ents.GetStored("gmod_train_bogey").t

local m_AcceptInput = ENT.AcceptInput
function ENT:AcceptInput(inputName, activator, called, data)
    if (self:GetNW2Bool("IsForwardBogey")) then
        local train = self:GetNW2Entity("TrainEntity")

        if inputName == "BogeyAutostopInertial" then 
            if (self.Speed > 10) then
                train.Pneumatic:TriggerInput("Autostop",0)
            end
        end
        if inputName == "BogeyAutostopStatic" then 
            train.Pneumatic:TriggerInput("Autostop",0)
        end
    end
    
    return m_AcceptInput(self, inputName, activator, called, data)
end

end)    --Окончание тела функции хука    
    

