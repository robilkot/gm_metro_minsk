if (SERVER) then
    Minsk.StationPults.GetPult("Pult_1"):BlockButton("button_1")

    Minsk.StationPults.PultsConfig = {
        {   
            name = "Pult_1",
            model = "models/station_pult_01a.mdl",
            pos = Vector(810, 450, -80),
            
            buttons = {
                { 
                    prototype = "BlackButton",
                    pos = Vector(14.05, 8.22, 17.9),
                    action = {
                        func = function ()
                            print(1)
                        end
                    }
                },
                { 
                    prototype = "RedButton",
                    pos = Vector(12.4, 8.22, 17.9),
                },
                { 
                    prototype = "BlackButton",
                    pos = Vector(14.05 - 1.65 * 2, 8.22, 17.9),
                },
                { 
                    prototype = "RedButton",
                    pos = Vector(12.4 - 1.65 * 2, 8.22, 17.9),
                    
                },
                { 
                    prototype = "BlackButton",
                    pos = Vector(14.05 - 1.65 * 4, 8.22, 17.9),
                    
                },
                { 
                    prototype = "RedButton",
                    pos = Vector(12.4 - 1.65 * 4, 8.22, 17.9),
                    
                },
                
                { 
                    prototype = "BlackButton",
                    pos = Vector(2.5, 8.22, 17.9),
                    
                },
                { 
                    prototype = "RedButton",
                    pos = Vector(0.85, 8.22, 17.9),
                    
                },
                { 
                    prototype = "BlackButton",
                    pos = Vector(2.5 - 1.65 * 2, 8.22, 17.9),
                    
                },
                { 
                    prototype = "RedButton",
                    pos = Vector(0.85 - 1.65 * 2, 8.22, 17.9),
                    
                },
                { 
                    prototype = "BlackButton",
                    pos = Vector(2.5 - 1.65 * 4, 8.22, 17.9),
                    
                },
                { 
                    prototype = "RedButton",
                    pos = Vector(0.85 - 1.65 * 4, 8.22, 17.9),
                    
                },
    
                { 
                    prototype = "BlackButton",
                    pos = Vector(-9, 8.22, 17.9),
                    
                },
                { 
                    prototype = "RedButton",
                    pos = Vector(-10.65, 8.22, 17.9),
                    
                },
                { 
                    prototype = "BlackButton",
                    pos = Vector(-9 - 1.65 * 2, 8.22, 17.9),
                    
                },
                { 
                    prototype = "RedButton",
                    pos = Vector(-10.65 - 1.65 * 2, 8.22, 17.9),
                    
                },
                { 
                    prototype = "BlackButton",
                    pos = Vector(-9 - 1.65 * 4, 8.22, 17.9),
                    
                },
                { 
                    prototype = "RedButton",
                    pos = Vector(-10.65 - 1.65 * 4, 8.22, 17.9),
                    
                },
    
                { 
                    prototype = "RotationSwitch2",
                    pos = Vector(12.4, 8.22, 13.5),
                    
                },
                { 
                    prototype = "RotationSwitch2",
                    pos = Vector(12.4 - 5, 8.22, 13.5),
                    
                },
    
                { 
                    prototype = "RotationSwitch2",
                    pos = Vector(0.85, 8.22, 13.5),
                    
                },
                { 
                    prototype = "RotationSwitch2",
                    pos = Vector(0.85 - 5, 8.22, 13.5),
                    
                },
    
                { 
                    prototype = "RotationSwitch2",
                    pos = Vector(-10.7, 8.22, 13.5),
                    
                },
                { 
                    prototype = "RotationSwitch2",
                    pos = Vector(-10.7 - 5, 8.22, 13.5),
                    
                },
    
                { 
                    prototype = "RotationSwitch2",
                    pos = Vector(16.52, 8.22, 4.7),
                    
                },
                
                { 
                    prototype = "Toggle",
                    pos = Vector(0.1, 8.22, 2.7),
                    
                },
    
                { 
                    prototype = "Toggle",
                    pos = Vector(7.4, 8.22, -3.85),
                    
                },
                { 
                    prototype = "Toggle",
                    pos = Vector(7.4, 8.22, -3.85 -4.5),
                    
                },
                { 
                    prototype = "Toggle",
                    pos = Vector(7.4, 8.22, -3.85 -8.95),
                    
                },
    
                { 
                    prototype = "Toggle",
                    pos = Vector(4.15, 8.22, -6.05),
                    
                },
                { 
                    prototype = "Toggle",
                    pos = Vector(4.15, 8.22, -6.05 - 4.5),
                    
                },
                { 
                    prototype = "Toggle",
                    pos = Vector(4.15, 8.22, -6.05 - 8.95),
                    
                },
    
                { 
                    prototype = "Toggle",
                    pos = Vector(-7.4, 8.22, -3.85),
                    
                },
                { 
                    prototype = "Toggle",
                    pos = Vector(-7.4, 8.22, -3.85 -4.5),
                    
                },
                { 
                    prototype = "Toggle",
                    pos = Vector(-7.4, 8.22, -3.85 -8.95),
                    
                },
    
                { 
                    prototype = "Toggle",
                    pos = Vector(-4.15, 8.22, -6.05),
                    
                },
                { 
                    prototype = "Toggle",
                    pos = Vector(-4.15, 8.22, -6.05 - 4.5),
                    
                },
                { 
                    prototype = "Toggle",
                    pos = Vector(-4.15, 8.22, -6.05 - 8.95),
                    
                },
            },
        
            indicators = {
                {   
                    prototype = "GreenRed",
                    name = "ind_1",
                    pos = Vector(10.12 + 1.65 * 2, 8.5, 20.4),
                    ang = Angle(180, 0, 0)
                }
            }
        },
        {
            name = "Pult_2",
            pos = Vector(880, 450, -80),
            indicators = {
                {   
                    prototype = "GreenRed",
                    name = "ind_2",
                    pos = Vector(10.12 + 1.65 * 2, 8.5, 20.4),
                    ang = Angle(180, 0, 0)
                }
            }
        },
        {
            name = "Pult_3",
            pos = Vector(960, 450, -80),
            buttons = {
                {
                    prototype = "BlackButton",
                    pos = Vector(10.12 + 1.65 * 2, 8.5, 20.4),
                }
            },
            indicators = {
                {   
                    prototype = "GreenRed",
                    name = "ind_1",
                    pos = Vector(10.12 + 1.65 * 2, 8.5, 20.4),
                    ang = Angle(180, 0, 0)
                }
            }
        },
    }
    
    
    -- всякое тестовое дерьмо
    
    
    local bb = { 
        prototype = "BlackButton",
        pos = Vector(17.3, 8.22, 9.2),
        
    }
    local rb = { 
        prototype = "RedButton",
        pos = Vector(15.6, 8.22, 9.2),
        
    }
    
    for i = 0, 4 do
        local b1 = table.Copy(bb)
        local b2 = table.Copy(rb)
    
        b1.pos = b1.pos + Vector(-1.65 * 2 * i, 0, 0)
        b2.pos = b2.pos + Vector(-1.65 * 2 * i, 0, 0)
        
        table.insert(Minsk.StationPults.PultsConfig[1].buttons, b1)
        table.insert(Minsk.StationPults.PultsConfig[1].buttons, b2)
    end
    
    bb.pos = bb.pos + Vector(-19.75, 0, 0)
    rb.pos = rb.pos + Vector(-19.75, 0, 0)
    
    for i = 0, 4 do
        local b1 = table.Copy(bb)
        local b2 = table.Copy(rb)
    
        b1.pos = b1.pos + Vector(-1.65 * 2 * i, 0, 0)
        b2.pos = b2.pos + Vector(-1.65 * 2 * i, 0, 0)
        
        table.insert(Minsk.StationPults.PultsConfig[1].buttons, b1)
        table.insert(Minsk.StationPults.PultsConfig[1].buttons, b2)
    end
    
    local sw = { 
        prototype = "RotationSwitch2",
        pos = Vector(16.52, 8.22, 4.7),
        
    }
    
    for i = 0, 4 do
        local sw = table.Copy(sw)
        sw.pos = sw.pos + Vector(-1.64 * 2 * i, 0, 0)
        table.insert(Minsk.StationPults.PultsConfig[1].buttons, sw)
    end
    
    sw.pos = sw.pos + Vector(-19.95, 0, 0)
    
    for i = 0, 4 do
        local sw = table.Copy(sw)
        sw.pos = sw.pos + Vector(-1.64 * 2 * i, 0, 0)
        table.insert(Minsk.StationPults.PultsConfig[1].buttons, sw)
    end
    
    Minsk.StationPults.ButtonPrototypes = {
        ["BlackButton"] = {
            model = "models/minsk/station_pult_button_01a.mdl",
            sound = "ambient/pult_button1.mp3",
            actions = {
                {
                    animation = "press",
                }
            },
        },
        ["RedButton"] = {
            model = "models/minsk/station_pult_button_01b.mdl",
            sound = "ambient/pult_button1.mp3",
            actions = {
                {
                    animation = "press",
                }
            },
        },
        ["Toggle"] = {
            model = "models/minsk/station_pult_toggle_01a.mdl",
            sound = "ambient/pult_button1.mp3",
            actions = {
                {
                    animation = "toggle_down",
                },
                {
                    animation = "toggle_up",
                }
            }
        },
        ["RotationSwitch"] = {
            model = "models/minsk/station_pult_rotation_toggle_01a.mdl",
            sound = "ambient/pult_button1.mp3",
            actions = {
                {
                    animation = "toggle_left",
                },
                {
                    animation = "toggle_right",
                }
            }
        },
        ["RotationSwitch2"] = {
            model = "models/minsk/station_pult_rotation_toggle_02a.mdl",
            sound = "ambient/pult_button1.mp3",
            actions = {
                {
                    animation = "toggle_left",
                },
                {
                    animation = "toggle_right",
                }
            }
        },
        ["KeySwitch"] = {
            model = "models/minsk/station_pult_key_toggle_01a.mdl",
            sound = "ambient/pult_button1.mp3",
            actions = {
                {
                    animation = "toggle_on",
                },
                {
                    animation = "toggle_off",
                }
            }
        },
    
        ["StaticBlackButton"] = {
            model = "models/minsk/station_pult_button_01a.mdl"
        },
        ["StaticRedButton"] = {
            model = "models/minsk/station_pult_button_01b.mdl"
        },
        ["StaticRotationSwitch"] = {
            model = "models/minsk/station_pult_rotation_toggle_01a.mdl"
        },
        ["StaticRotationSwitch2"] = {
            model = "models/minsk/station_pult_rotation_toggle_02a.mdl"
        },
        ["StaticKeySwitch"] = {
            model = "models/minsk/station_pult_key_toggle_01a.mdl"
        },
    }
    
    Minsk.StationPults.IndicatorPrototypes = {
        ["GreenRed"] = {
            model = "models/stations/station_pult_twolamps.mdl",
            stagesSkins = { 1, 0 }
        },
    }
end



---{ 
--     prototype = "RotationSwitch",
--     name = "button_3",
--     pos = Vector(15, 8.22, 0),
--     
--     actions = {
--         {   
--             func = function(pult, button)
--                 print("sw1")
--                 pult:SetIndicatorStage("ind_1", 2)
--             end,
            
--         },
--         {   
--             func = function(pult) 
--                 print("sw2")
--                 pult:SetIndicatorStage("ind_1", 1)
--             end,
--         }
--     },
--     description = "Кнопка 2"
-- },
-- { 
--     prototype = "RotationSwitch2",
--     name = "button_4",
--     pos = Vector(10, 8.22, 0),
--     
--     actions = {
--         {
--             func = function() print("sw21") end,
--         },
--         {
--             func = function() print("sw22") end,
--         }
--     },
--     description = "Кнопка 2"
-- },
-- { 
--     prototype = "Toggle",
--     name = "button_5",
--     pos = Vector(20, 8.22, 0),
--     
--     actions = {
--         {   
--             func = function() 
--                 print("tg2")
--             end,
--         },
--         {   
--             func = function()
--                 print("tg2")

--             end,
--         }
--     },
--     description = "Кнопка 5"
-- },
-- {
--     prototype = "StaticKeySwitch",
--     pos = Vector(25, 8.22, 0),
-- },
-- {
--     prototype = "StaticKeySwitch",
--     pos = Vector(30, 8.22, 0),
-- },
-- {
--     prototype = "StaticKeySwitch",
--     pos = Vector(35, 8.22, 0),
-- },
-- {
--     prototype = "StaticKeySwitch",
--     pos = Vector(40, 8.22, 0),
-- },
-- {
--     prototype = "StaticKeySwitch",
--     pos = Vector(45, 8.22, 0),
-- }

-- Minsk.StationPults.ButtonsConfig = {
--     { 
--         prototype = "BlackButton",
--         name = "button_1",
--         pos = Vector(17.5, 8.22, 0),
--         
--         description = "Кнопка 1"
--     },
--     { 
--         prototype = "RedButton",
--         name = "button_2",
--         pos = Vector(18.5, 8.22, 0),
--         
--         actions = {
--             {
--                func = function() print("Press2") end,
--             }
--         },
--         description = "Кнопка 1"
--     },
--     { 
--         prototype = "RotationSwitch",
--         name = "button_3",
--         pos = Vector(15, 8.22, 0),
--         
--         actions = {
--             {   
--                 func = function() print("sw1") end,
--             },
--             {   
--                 func = function() print("sw2") end,
--             }
--         },
--         description = "Кнопка 2"
--     },
--     { 
--         prototype = "RotationSwitch2",
--         name = "button_4",
--         pos = Vector(10, 8.22, 0),
--         
--         actions = {
--             {
--                 func = function() print("sw21") end,
--             },
--             {
--                 func = function() print("sw22") end,
--             }
--         },
--         description = "Кнопка 2"
--     },
--     { 
--         prototype = "Toggle",
--         name = "button_5",
--         pos = Vector(20, 8.22, 0),
--         
--         actions = {
--             {   
--                 func = function() print("tg1") end,
--             },
--             {   
--                 func = function() print("tg2") end,
--             }
--         },
--         description = "Кнопка 5"
--     },
--     {
--         prototype = "StaticKeySwitch",
--         pos = Vector(25, 8.22, 0),
--     }

-- { 
--     name = "button_1",
--     model = "models/minsk/station_pult_button_01a.mdl",
--     pos = Vector(17.5, 8.22, 0),
--     
--     sound = "ambient/pult_button1.mp3",
--     actions = {
--         {
--             animation = "press",
--             sound = nil,
--             func = function() end,
--             output = {
--                 targetEntName = "button",
--                 input = "SetAnimation",
--                 param  = "press",
--                 delay = 0,
--             }
--         }
--     },
--     description = "Кнопка 1"
-- },
-- { 
--     name = "button_2",
--     model = "models/minsk/station_pult_rotation_toggle_01a.mdl",
--     pos = Vector(15, 8.22, 0),
--     
--     sound = "ambient/pult_button1.mp3",
--     actions = {
--         {
--             animation = "toggle_left",
--         },
--         {
--             animation = "toggle_right",
--         }
--     },
--     description = "Переключатель 1"
-- },
-- { 
--     name = "button_3",
--     model = "models/minsk/station_pult_rotation_toggle_02a.mdl",
--     pos = Vector(10, 8.22, 0),
--     
--     sound = "ambient/pult_button1.mp3",
--     actions = {
--         {
--             animation = "toggle_left",
--         },
--         {
--             animation = "toggle_right",
--         }
--     },
--     description = "Перключатель 2"
-- },
-- { 
--     name = "button_4",
--     model = "models/minsk/station_pult_toggle_01a.mdl",
--     pos = Vector(18, 8.22, 3),
--     
--     sound = "ambient/pult_button1.mp3",
--     actions = {
--         {
--             animation = "toggle_up",
--         },
--         {
--             animation = "toggle_down",
--         }
--     },
--     description = "Тумблер 1"
-- },
-- { 
--     name = "button_5",
--     model = "models/minsk/station_pult_button_01b.mdl",
--     pos = Vector(18.5, 8.22, 0),
--     
--     sound = "ambient/pult_button1.mp3",
--     actions = {
--         {
--             animation = "press",
--         }
--     },
--     description = "Кнопка 5"
-- },
-- { 
--     name = "Ключ",
--     model = "models/minsk/station_pult_key_toggle_01a.mdl",
--     pos = Vector(12, 8.22, 0),
--     
--     sound = "ambient/pult_button1.mp3",
--     actions = {
--         {
--             animation = "toggle_on",
--         },
--         {
--             animation = "toggle_off",
--         }
--     },
--     description = "Кнопка 5"
-- },
-- {
--     model = "models/minsk/station_pult_button_01a.mdl",
--     pos = Vector(18, 8.22, 1),
--     
-- },
-- }