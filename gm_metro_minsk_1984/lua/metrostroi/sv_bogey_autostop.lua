-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для аддона Metrostroi.
--	Аддон реализует взаимодействие тележки с инерционным и статичсеким автостопом.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------


hook.Add("InitPostEntity", "BogeyAutostopInitialize", function()   --Хук, вызываемый после инциализации игры, начало тела функции с кодом

ENT = scripted_ents.GetStored("gmod_train_bogey").t

ENT.BogeyAutostop = ENT.BogeyAutostop or {}

ENT.BogeyAutostop.AcceptInput = ENT.BogeyAutostop.AcceptInput or ENT.AcceptInput
function ENT:AcceptInput(inputName, activator, called, data)
    local train = self:GetNW2Entity("TrainEntity")
    if (self:GetNW2Bool("IsForwardBogey") and train.SubwayTrain and train.SubwayTrain.WagType == 1) then
        if inputName == "BogeyAutostopInertial" then
            if (self.AutostopEnable) then
                if ((data == "right" and self.SpeedSign == 1) or (data == "left" and self.SpeedSign == -1)) then
                    
                    if (self.Speed > 10) then
                        train.Pneumatic:TriggerInput("Autostop",0)
                        called:Fire("FireUser2")
                    else
                        called:Fire("FireUser1")
                    end
                end
            end
            
            self.AutostopEnable = not self.AutostopEnable
        end

        if inputName == "BogeyAutostopStatic" then
            local train = self:GetNW2Entity("TrainEntity")

            train.Pneumatic:TriggerInput("Autostop",0)
        end   
    end

    return self.BogeyAutostop.AcceptInput(self, inputName, activator, called, data)
end

end)    --Окончание тела функции хука