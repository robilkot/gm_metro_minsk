local Map = game.GetMap():lower() or ""

if Map:find("gm_metro") and Map:find("kalinin") then
    Metrostroi.PlatformMap = "kalinin"
    Metrostroi.CurrentMap = "kalinin"
else
    return
end

local Perovo = "Перово"
local Perovo_eng = "Perovo"
if (math.random() >0.95) then 
Perovo = "Херово"
Perovo_eng = "Herovo" 
end

Metrostroi.AddCISConfig("Moscow Metro", {
        {
	    	LED = {3, 4, 4, 4, 4, 4, 4, 3},
	    	Name = "Новокосино - Третьяковская",
            Loop = false,
	    	
	    	Line = 8,
	    	Color = Color(255,205,30),	
	    	English = true,				
            {
                801,
                "Новокосино","Novokosino"
            },
	    	{
                802,
                "Новогиреево","Novogireyevo",
            },
            {
                803,
                Perovo, Perovo_eng,
            },
            {
                804,
                "Шоссе Энтузиастов","Shosse Entuziastov",true,"Шоссе Энтузиастов",14,"Shosse Entuziastov",Color(198,70,64),
            },
            {
                805,
                "Авиамоторная","Aviamotornaya",true,"Авиамоторная",15,"Aviamotornaya",Color(242,135,182),
            },
            {
                806,
                "Площадь Ильича","Ploschad Ilyicha",true,"Римская",10,"Rimskaya",Color(190,209,46),
            },
            {
                807,
                "Марксистская","Marksistskaya",true,"Таганская",5,"Taganskaya",Color(146,82,51),"Таганская",7,"Taganskaya",Color(148,63,144),
            },
            {
                808,
                "Третьяковская","Tretyakovskaya",true,"Третьяковская",6,"Tretyakovskaya",Color(239,126,36),"Новокузнецкая",2,"Novokuznetskaya",Color(75,175,79),
            },
        }
    }   
)
