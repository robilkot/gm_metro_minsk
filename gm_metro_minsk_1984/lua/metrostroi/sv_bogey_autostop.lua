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
        if inputName == "BogeyAutostopInertial" then 
            if (data == "setRight") then
                self.AutostopSide = "right"
            elseif(data == "setLeft") then
                self.AutostopSide = "left"
            else
                if ((self.AutostopSide == "right" and self.SpeedSign == 1) or (self.AutostopSide == "left" and self.SpeedSign == -1)) then
                    local train = self:GetNW2Entity("TrainEntity")
                    
                    activator:Fire("OnAutostopToggle")
                    if (self.Speed > 10) then
                        train.Pneumatic:TriggerInput("Autostop",0)
                    end
                end
            end
        end

        if inputName == "BogeyAutostopStatic" then
            local train = self:GetNW2Entity("TrainEntity")

            train.Pneumatic:TriggerInput("Autostop",0)
        end   
    end

    return m_AcceptInput(self, inputName, activator, called, data)
end

end)    --Окончание тела функции хука