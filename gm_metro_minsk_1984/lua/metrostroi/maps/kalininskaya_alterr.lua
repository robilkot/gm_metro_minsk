local Map = game.GetMap():lower() or ""

if Map:find("gm_metro") and Map:find("kalinin") then
    Metrostroi.PlatformMap = "kalinin"
    Metrostroi.CurrentMap = "kalinin"
else
    return
end

Metrostroi.AddPassSchemeTex("720", "Moscow Metro",{
	"metrostroi_skins/81-720_schemes/alterr_kalininskaya_2020",
	"metrostroi_skins/81-720_schemes/alterr_kalininskaya_2020_r",
})

Metrostroi.AddPassSchemeTex("722", "Moscow Metro",{
	"metrostroi_skins/81-722_schemes/alterr_kalininskaya_2020",
	"metrostroi_skins/81-722_schemes/alterr_kalininskaya_2020_r",
})

Metrostroi.AddPassSchemeTex("717_new", "Moscow Metro",{
	"metrostroi_skins/81-717_schemes/alterr_kalininskaya_2020",
})

Metrostroi.AddPassSchemeTex("760", "Moscow Metro",{
	"metrostroi_skins/81-760_schemes/alterr_kalininskaya_2020",
})

Metrostroi.AddLastStationTex("702", 801, "metrostroi_skins/81-702_names/kall_801")
Metrostroi.AddLastStationTex("702", 802, "metrostroi_skins/81-702_names/kall_802")
Metrostroi.AddLastStationTex("702", 804, "metrostroi_skins/81-702_names/kall_804")
Metrostroi.AddLastStationTex("702", 807, "metrostroi_skins/81-702_names/kall_807")
Metrostroi.AddLastStationTex("702", 808, "metrostroi_skins/81-702_names/kall_808")
Metrostroi.AddLastStationTex("710", 801, "metrostroi_skins/81-710_names/kall_801")
Metrostroi.AddLastStationTex("710", 802, "metrostroi_skins/81-710_names/kall_802")
Metrostroi.AddLastStationTex("710", 804, "metrostroi_skins/81-710_names/kall_804")
Metrostroi.AddLastStationTex("710", 807, "metrostroi_skins/81-710_names/kall_807")
Metrostroi.AddLastStationTex("710", 808, "metrostroi_skins/81-710_names/kall_808")
Metrostroi.AddLastStationTex("717", 801, "metrostroi_skins/81-717_names/kall_801")
Metrostroi.AddLastStationTex("717", 802, "metrostroi_skins/81-717_names/kall_802")
Metrostroi.AddLastStationTex("717", 804, "metrostroi_skins/81-717_names/kall_804")
Metrostroi.AddLastStationTex("717", 807, "metrostroi_skins/81-717_names/kall_807")
Metrostroi.AddLastStationTex("717", 808, "metrostroi_skins/81-717_names/kall_808")
Metrostroi.AddLastStationTex("720", 801, "metrostroi_skins/81-717_names/kall_801")
Metrostroi.AddLastStationTex("720", 802, "metrostroi_skins/81-717_names/kall_802")
Metrostroi.AddLastStationTex("720", 804, "metrostroi_skins/81-717_names/kall_804")
Metrostroi.AddLastStationTex("720", 807, "metrostroi_skins/81-717_names/kall_807")
Metrostroi.AddLastStationTex("720", 808, "metrostroi_skins/81-717_names/kall_808")

Metrostroi.TickerAdverts = {
    "УВАЖАЕМЫЕ ПАССАЖИРЫ, О ПОДОЗРИТЕЛЬНЫХ ПРЕДМЕТАХ СООБЩАЙТЕ МАШИНИСТУ",
    "РАЗОБЛАЧАЙ ВРАГА ПОД ЛЮБОЙ МАСКОЙ",
}

Metrostroi.SetRRIAnnouncer({
		click_start = {"subway_announcers/kalininskaya_real_old/click.mp3", 0.2},
		click_end = {"subway_announcers/kalininskaya_real_old/click.mp3", 0.2},
		announcer_ready = {"subway_announcers/kalininskaya_real_old/announcer_ready.mp3", 3.87},
		click1 = {"subway_announcers/kalininskaya_real_old/click.mp3", 0.2},
		click2 = {"subway_announcers/kalininskaya_real_old/click.mp3", 0.2},
		spec_attention_train_depart = {"subway_announcers/kalininskaya_real_old/spec_attention_train_depart.mp3", 5.16},
		spec_attention_train_stop = {"subway_announcers/kalininskaya_real_old/spec_attention_train_stop.mp3", 6.5},
		spec_attention_train_fast = {"subway_announcers/kalininskaya_real_old/spec_attention_train_fast.mp3", 4.37},

        --  STATIONS
		
		otpr_01_g = {"subway_announcers/kalininskaya_real_old/otpr_01_g.mp3", 6.22},
		prib_01_g = {"subway_announcers/kalininskaya_real_old/prib_01_g.mp3", 13.07},
 
		otpr_02_g = {"subway_announcers/kalininskaya_real_old/otpr_02_g.mp3", 6.27},
		otpr_02_m = {"subway_announcers/kalininskaya_real_old/otpr_02_m.mp3", 6.7},
		prib_02_g = {"subway_announcers/kalininskaya_real_old/prib_02_g.mp3", 2.77},
		prib_02_m = {"subway_announcers/kalininskaya_real_old/prib_02_m.mp3", 8.04},	
		
		prib_02_g_neid = {"subway_announcers/kalininskaya_real_old/prib_02_g_neid.mp3", 12.08},
		prib_02_m_neid = {"subway_announcers/kalininskaya_real_old/prib_02_m_neid.mp3", 13.28},
		sled_02 = {"subway_announcers/kalininskaya_real_old/sled_02.mp3", 4.01},
		
		otpr_03_g = {"subway_announcers/kalininskaya_real_old/otpr_03_g.mp3", 15.19},
		otpr_03_m = {"subway_announcers/kalininskaya_real_old/otpr_03_m.mp3", 15.96},
		prib_03_g = {"subway_announcers/kalininskaya_real_old/prib_03_g.mp3", 2.63},
		prib_03_m = {"subway_announcers/kalininskaya_real_old/prib_03_m.mp3", 2.85},

		otpr_04_g = {"subway_announcers/kalininskaya_real_old/otpr_04_g.mp3", 16.12},
		otpr_04_m = {"subway_announcers/kalininskaya_real_old/otpr_04_m.mp3", 7.33},
		prib_04_g = {"subway_announcers/kalininskaya_real_old/prib_04_g.mp3", 3.41},
		prib_04_m = {"subway_announcers/kalininskaya_real_old/prib_04_m.mp3", 3.89},

		prib_04_g_neid = {"subway_announcers/kalininskaya_real_old/prib_04_g_neid.mp3", 12.7},
		prib_04_m_neid = {"subway_announcers/kalininskaya_real_old/prib_04_m_neid.mp3", 13.81},
		sled_04 = {"subway_announcers/kalininskaya_real_old/sled_04.mp3", 4.57},

		otpr_05_g = {"subway_announcers/kalininskaya_real_old/otpr_05_g.mp3", 6.41},
		otpr_05_m = {"subway_announcers/kalininskaya_real_old/otpr_05_m.mp3", 16.51},
		prib_05_g = {"subway_announcers/kalininskaya_real_old/prib_05_g.mp3", 3.15},
		prib_05_m = {"subway_announcers/kalininskaya_real_old/prib_05_m.mp3", 3.49},

		otpr_06_g = {"subway_announcers/kalininskaya_real_old/otpr_06_g.mp3", 6.58},
		otpr_06_m = {"subway_announcers/kalininskaya_real_old/otpr_06_m.mp3", 7.1},
		prib_06_g = {"subway_announcers/kalininskaya_real_old/prib_06_g.mp3", 5.58},
		prib_06_m = {"subway_announcers/kalininskaya_real_old/prib_06_m.mp3", 12.25},

		otpr_07_g = {"subway_announcers/kalininskaya_real_old/otpr_07_g.mp3", 6.23},
		otpr_07_m = {"subway_announcers/kalininskaya_real_old/otpr_07_m.mp3", 6.38},
		prib_07_g = {"subway_announcers/kalininskaya_real_old/prib_07_g.mp3", 12.52},
		prib_07_m = {"subway_announcers/kalininskaya_real_old/prib_07_m.mp3", 13.19},
		
		prib_07_m_neid = {"subway_announcers/kalininskaya_real_old/prib_07_m_neid.mp3", 17.25},
		sled_07 = {"subway_announcers/kalininskaya_real_old/sled_07.mp3", 4.08},

		otpr_08_m = {"subway_announcers/kalininskaya_real_old/otpr_08_m.mp3", 6.67},
		prib_08_m = {"subway_announcers/kalininskaya_real_old/prib_08_m.mp3", 18.2},

		name_01_g = {"subway_announcers/kalininskaya_real_old/name_01_g.mp3", 1.16},
		name_02_g = {"subway_announcers/kalininskaya_real_old/name_02_g.mp3", 1.15},
		name_04_g = {"subway_announcers/kalininskaya_real_old/name_04_g.mp3", 1.65},
		name_07_g = {"subway_announcers/kalininskaya_real_old/name_07_g.mp3", 1.21},
		name_08_g = {"subway_announcers/kalininskaya_real_old/name_08_g.mp3", 1.36},			
},
	{
		{
            LED = {3, 3, 3, 4, 4, 4, 4, 5},
            Name = "Калининская линия",
			spec_last = {"spec_attention_train_fast"},
			spec_wait = {{"spec_attention_train_stop"},{"spec_attention_train_depart"}},
			Loop = false,
            {
                801,"Новокосино",
				arrlast = {nil, {"prib_01_g"}, "name_01_g"},
				dep = {{"otpr_02_m"}, nil},
				have_inrerchange = true,
            },
            {
                802,"Новогиреево",
                arr = {"prib_02_m","prib_02_g"},
                dep = {"otpr_03_m","otpr_01_g"},
			    not_last = {"sled_02"},
				arrlast = {{"prib_02_m_neid"},{"prib_02_g_neid"}, "name_02_g"},
				have_inrerchange = true,
            },
            {
                803,"Перово",
                arr = {"prib_03_m","prib_03_g"},
                dep = {"otpr_04_m","otpr_02_g"},
				have_inrerchange = true,
            },
            {
                804,"Ш. Энтузиастов",
                arr = {"prib_04_m","prib_04_g"},
                dep = {"otpr_05_m","otpr_03_g"},
				not_last = {"sled_04"},
				arrlast = {{"prib_04_m_neid"},{"prib_04_g_neid"}, "name_04_g"},
				have_inrerchange = true,
            },
            {
                805,"Авиамоторная",
                arr = {"prib_05_m","prib_05_g"},
                dep = {"otpr_06_m","otpr_04_g"},
				have_inrerchange = true,
            },
            {
                806,"Площадь Ильича",
                arr = {"prib_06_m","prib_06_g"},
                dep = {"otpr_07_m","otpr_05_g"},
				have_inrerchange = true,
            },
            {
                807,"Марксистская",
                arr = {"prib_07_m","prib_07_g"},
                dep = {"otpr_08_m","otpr_06_g"},
			    not_last = {"sled_07"},
				arrlast = {{"prib_07_m_neid"}, nil, "name_07_g"},
				have_inrerchange = true,
            },	
            {
                808,"Третьяковск.",
				arrlast = {{"prib_08_m"}, nil, "name_08_g"},
                dep = {nil, {"otpr_07_g"}},
				have_inrerchange = true,
            }
        }
    }
)

Metrostroi.AddANSPAnnouncer("Moscow Metro",
	{
		click_start = {"subway_announcers/kalininskaya_real/click.mp3", 0.2},
		click_end = {"subway_announcers/kalininskaya_real/click.mp3", 0.2},
		announcer_ready = {"subway_announcers/kalininskaya_real/announcer_ready.mp3", 3.87},
		click1 = {"subway_announcers/kalininskaya_real/click.mp3", 0.2},
		click2 = {"subway_announcers/kalininskaya_real/click.mp3", 0.2},
		spec_attention_train_depart = {"subway_announcers/kalininskaya_real/spec_attention_train_depart.mp3", 5.16},
		spec_attention_train_stop = {"subway_announcers/kalininskaya_real/spec_attention_train_stop.mp3", 6.5},
		spec_attention_train_fast = {"subway_announcers/kalininskaya_real/spec_attention_train_fast.mp3", 4.37},

		maska_perchatki_g = {"subway_announcers/kalininskaya_real/maska_perchatki_g.mp3", 5.07},
		maska_perchatki_m = {"subway_announcers/kalininskaya_real/maska_perchatki_m.mp3", 5.25},

        --  STATIONS
		
		otpr_01_g = {"subway_announcers/kalininskaya_real/otpr_01_g.mp3", 13.75},
		prib_01_g = {"subway_announcers/kalininskaya_real/prib_01_g.mp3", 25.8},
 
		otpr_02_g = {"subway_announcers/kalininskaya_real/otpr_02_g.mp3", 9.33},
		otpr_02_m = {"subway_announcers/kalininskaya_real/otpr_02_m.mp3", 14.62},
		prib_02_g = {"subway_announcers/kalininskaya_real/prib_02_g.mp3", 8.61},
		prib_02_m = {"subway_announcers/kalininskaya_real/prib_02_m.mp3", 13.63},	
		
		prib_02_g_neid = {"subway_announcers/kalininskaya_real/prib_02_g_neid.mp3", 28.33},
		prib_02_m_neid = {"subway_announcers/kalininskaya_real/prib_02_m_neid.mp3", 29.33},
		sled_02 = {"subway_announcers/kalininskaya_real/sled_02.mp3", 4.04},
		
		otpr_03_g = {"subway_announcers/kalininskaya_real/otpr_03_g.mp3", 18.02},
		otpr_03_m = {"subway_announcers/kalininskaya_real/otpr_03_m.mp3", 17.64},
		prib_03_g = {"subway_announcers/kalininskaya_real/prib_03_g.mp3", 4.34},
		prib_03_m = {"subway_announcers/kalininskaya_real/prib_03_m.mp3", 4.52},

		otpr_04_g = {"subway_announcers/kalininskaya_real/otpr_04_g.mp3", 24.94},
		otpr_04_m = {"subway_announcers/kalininskaya_real/otpr_04_m.mp3", 10.35},
		prib_04_g = {"subway_announcers/kalininskaya_real/prib_04_g.mp3", 15.24},
		prib_04_m = {"subway_announcers/kalininskaya_real/prib_04_m.mp3", 15.92},

		prib_04_g_neid = {"subway_announcers/kalininskaya_real/prib_04_g_neid.mp3", 35.25},
		prib_04_m_neid = {"subway_announcers/kalininskaya_real/prib_04_m_neid.mp3", 37.04},
		sled_04 = {"subway_announcers/kalininskaya_real/sled_04.mp3", 4.7},

		otpr_05_g = {"subway_announcers/kalininskaya_real/otpr_05_g.mp3", 9.49},
		otpr_05_m = {"subway_announcers/kalininskaya_real/otpr_05_m.mp3", 24.26},
		prib_05_g = {"subway_announcers/kalininskaya_real/prib_05_g.mp3", 16.19},
		prib_05_m = {"subway_announcers/kalininskaya_real/prib_05_m.mp3", 16.79},

		otpr_06_g = {"subway_announcers/kalininskaya_real/otpr_06_g.mp3", 9.81},
		otpr_06_m = {"subway_announcers/kalininskaya_real/otpr_06_m.mp3", 9.59},
		prib_06_g = {"subway_announcers/kalininskaya_real/prib_06_g.mp3", 18.83},
		prib_06_m = {"subway_announcers/kalininskaya_real/prib_06_m.mp3", 24.82},

		otpr_07_g = {"subway_announcers/kalininskaya_real/otpr_07_g.mp3", 18.69},
		otpr_07_m = {"subway_announcers/kalininskaya_real/otpr_07_m.mp3", 8.93},
		prib_07_g = {"subway_announcers/kalininskaya_real/prib_07_g.mp3", 17.24},
		prib_07_m = {"subway_announcers/kalininskaya_real/prib_07_m.mp3", 17.83},
		
		prib_07_m_neid = {"subway_announcers/kalininskaya_real/prib_07_m_neid.mp3", 33.44},
		sled_07 = {"subway_announcers/kalininskaya_real/sled_07.mp3", 4.06},

		otpr_08_m = {"subway_announcers/kalininskaya_real/otpr_08_m.mp3", 20.38},
		prib_08_m = {"subway_announcers/kalininskaya_real/prib_08_m.mp3", 31.61},

		name_01_g = {"subway_announcers/kalininskaya_real/name_01_g.mp3", 1.16},
		name_02_g = {"subway_announcers/kalininskaya_real/name_02_g.mp3", 1.15},
		name_04_g = {"subway_announcers/kalininskaya_real/name_04_g.mp3", 1.65},
		name_07_g = {"subway_announcers/kalininskaya_real/name_07_g.mp3", 1.21},
		name_08_g = {"subway_announcers/kalininskaya_real/name_08_g.mp3", 1.36},		
},
	{
		{
            LED = {3, 3, 3, 4, 4, 4, 4, 5},
            Name = "Калининская линия",
			spec_last = {"spec_attention_train_fast"},
			spec_wait = {{"spec_attention_train_stop"},{"spec_attention_train_depart"}},
			Loop = false,
            {
                801,"Новокосино",
				arrlast = {nil, {"prib_01_g"}, "name_01_g"},
				dep = {{"otpr_02_m", "maska_perchatki_m"}, nil},
				have_inrerchange = true,
            },
            {
                802,"Новогиреево",
                arr = {"prib_02_m","prib_02_g"},
                dep = {"otpr_03_m","otpr_01_g"},
			    not_last = {"sled_02"},
				arrlast = {{"prib_02_m_neid"},{"prib_02_g_neid"}, "name_02_g"},
				have_inrerchange = true,
            },
            {
                803,"Перово",
                arr = {"prib_03_m","prib_03_g"},
                dep = {{"otpr_04_m", "maska_perchatki_m"},{"otpr_02_g", "maska_perchatki_g"}},
				have_inrerchange = true,
            },
            {
                804,"Ш. Энтузиастов",
                arr = {"prib_04_m","prib_04_g"},
                dep = {"otpr_05_m","otpr_03_g"},
				not_last = {"sled_04"},
				arrlast = {{"prib_04_m_neid"},{"prib_04_g_neid"}, "name_04_g"},
				have_inrerchange = true,
            },
            {
                805,"Авиамоторная",
                arr = {"prib_05_m","prib_05_g"},
                dep = {{"otpr_06_m"},{"otpr_04_g", "maska_perchatki_g"}},
				have_inrerchange = true,
            },
            {
                806,"Площадь Ильича",
                arr = {"prib_06_m","prib_06_g"},
                dep = {{"otpr_07_m", "maska_perchatki_m"},{"otpr_05_g"}},
				have_inrerchange = true,
            },
            {
                807,"Марксистская",
                arr = {"prib_07_m","prib_07_g"},
                dep = {"otpr_08_m","otpr_06_g"},
			    not_last = {"sled_07"},
				arrlast = {{"prib_07_m_neid"}, nil, "name_07_g"},
				have_inrerchange = true,
            },	
            {
                808,"Третьяковск.",
				arrlast = {{"prib_08_m"}, nil, "name_08_g"},
                dep = {nil, {"otpr_07_g", "maska_perchatki_g"}},
				have_inrerchange = true,
            }
        }
    }
)

Metrostroi.AddANSPAnnouncer("Moscow Metro (old)",
	{
		click_start = {"subway_announcers/kalininskaya_real_717/click.mp3", 0.2},
		click_end = {"subway_announcers/kalininskaya_real_717/click.mp3", 0.2},
		announcer_ready = {"subway_announcers/kalininskaya_real_717/announcer_ready.mp3", 3.87},
		click1 = {"subway_announcers/kalininskaya_real_717/click.mp3", 0.2},
		click2 = {"subway_announcers/kalininskaya_real_717/click.mp3", 0.2},
		spec_attention_train_depart = {"subway_announcers/kalininskaya_real_717/spec_attention_train_depart.mp3", 5.16},
		spec_attention_train_stop = {"subway_announcers/kalininskaya_real_717/spec_attention_train_stop.mp3", 6.5},
		spec_attention_train_fast = {"subway_announcers/kalininskaya_real_717/spec_attention_train_fast.mp3", 4.37},

        --  STATIONS
		
		otpr_01_g = {"subway_announcers/kalininskaya_real_717/otpr_01_g.mp3", 6.22},
		prib_01_g = {"subway_announcers/kalininskaya_real_717/prib_01_g.mp3", 13.19},
 
		otpr_02_g = {"subway_announcers/kalininskaya_real_717/otpr_02_g.mp3", 6.27},
		otpr_02_m = {"subway_announcers/kalininskaya_real_717/otpr_02_m.mp3", 6.7},
		prib_02_g = {"subway_announcers/kalininskaya_real_717/prib_02_g.mp3", 7.42},
		prib_02_m = {"subway_announcers/kalininskaya_real_717/prib_02_m.mp3", 8.04},	
		
		prib_02_g_neid = {"subway_announcers/kalininskaya_real_717/prib_02_g_neid.mp3", 12.27},
		prib_02_m_neid = {"subway_announcers/kalininskaya_real_717/prib_02_m_neid.mp3", 13.72},
		sled_02 = {"subway_announcers/kalininskaya_real_717/sled_02.mp3", 4.01},
		
		otpr_03_g = {"subway_announcers/kalininskaya_real_717/otpr_03_g.mp3", 16.12},
		otpr_03_m = {"subway_announcers/kalininskaya_real_717/otpr_03_m.mp3", 16.59},
		prib_03_g = {"subway_announcers/kalininskaya_real_717/prib_03_g.mp3", 2.63},
		prib_03_m = {"subway_announcers/kalininskaya_real_717/prib_03_m.mp3", 2.85},

		otpr_04_g = {"subway_announcers/kalininskaya_real_717/otpr_04_g.mp3", 17.02},
		otpr_04_m = {"subway_announcers/kalininskaya_real_717/otpr_04_m.mp3", 7.33},
		prib_04_g = {"subway_announcers/kalininskaya_real_717/prib_04_g.mp3", 3.41},
		prib_04_m = {"subway_announcers/kalininskaya_real_717/prib_04_m.mp3", 3.89},

		prib_04_g_neid = {"subway_announcers/kalininskaya_real_717/prib_04_g_neid.mp3", 12.9},
		prib_04_m_neid = {"subway_announcers/kalininskaya_real_717/prib_04_m_neid.mp3", 14.22},
		sled_04 = {"subway_announcers/kalininskaya_real_717/sled_04.mp3", 4.57},

		otpr_05_g = {"subway_announcers/kalininskaya_real_717/otpr_05_g.mp3", 6.41},
		otpr_05_m = {"subway_announcers/kalininskaya_real_717/otpr_05_m.mp3", 17.13},
		prib_05_g = {"subway_announcers/kalininskaya_real_717/prib_05_g.mp3", 3.15},
		prib_05_m = {"subway_announcers/kalininskaya_real_717/prib_05_m.mp3", 3.49},

		otpr_06_g = {"subway_announcers/kalininskaya_real_717/otpr_06_g.mp3", 6.58},
		otpr_06_m = {"subway_announcers/kalininskaya_real_717/otpr_06_m.mp3", 7.1},
		prib_06_g = {"subway_announcers/kalininskaya_real_717/prib_06_g.mp3", 5.58},
		prib_06_m = {"subway_announcers/kalininskaya_real_717/prib_06_m.mp3", 12.25},

		otpr_07_g = {"subway_announcers/kalininskaya_real_717/otpr_07_g.mp3", 6.23},
		otpr_07_m = {"subway_announcers/kalininskaya_real_717/otpr_07_m.mp3", 6.38},
		prib_07_g = {"subway_announcers/kalininskaya_real_717/prib_07_g.mp3", 12.52},
		prib_07_m = {"subway_announcers/kalininskaya_real_717/prib_07_m.mp3", 13.19},
		
		prib_07_m_neid = {"subway_announcers/kalininskaya_real_717/prib_07_m_neid.mp3", 17.7},
		sled_07 = {"subway_announcers/kalininskaya_real_717/sled_07.mp3", 4.08},

		otpr_08_m = {"subway_announcers/kalininskaya_real_717/otpr_08_m.mp3", 6.67},
		prib_08_m = {"subway_announcers/kalininskaya_real_717/prib_08_m.mp3", 18.61},

		name_01_g = {"subway_announcers/kalininskaya_real_717/name_01_g.mp3", 1.16},
		name_02_g = {"subway_announcers/kalininskaya_real_717/name_02_g.mp3", 1.15},
		name_04_g = {"subway_announcers/kalininskaya_real_717/name_04_g.mp3", 1.65},
		name_07_g = {"subway_announcers/kalininskaya_real_717/name_07_g.mp3", 1.21},
		name_08_g = {"subway_announcers/kalininskaya_real_717/name_08_g.mp3", 1.36},		
},
	{
		{
            LED = {3, 3, 3, 4, 4, 4, 4, 5},
            Name = "Калининская линия",
			spec_last = {"spec_attention_train_fast"},
			spec_wait = {{"spec_attention_train_stop"},{"spec_attention_train_depart"}},
			Loop = false,
            {
                801,"Новокосино",
				arrlast = {nil, {"prib_01_g"}, "name_01_g"},
				dep = {{"otpr_02_m"}, nil},
				have_inrerchange = true,
            },
            {
                802,"Новогиреево",
                arr = {"prib_02_m","prib_02_g"},
                dep = {"otpr_03_m","otpr_01_g"},
			    not_last = {"sled_02"},
				arrlast = {{"prib_02_m_neid"},{"prib_02_g_neid"}, "name_02_g"},
				have_inrerchange = true,
            },
            {
                803,"Перово",
                arr = {"prib_03_m","prib_03_g"},
                dep = {"otpr_04_m","otpr_02_g"},
				have_inrerchange = true,
            },
            {
                804,"Ш. Энтузиастов",
                arr = {"prib_04_m","prib_04_g"},
                dep = {"otpr_05_m","otpr_03_g"},
				not_last = {"sled_04"},
				arrlast = {{"prib_04_m_neid"},{"prib_04_g_neid"}, "name_04_g"},
				have_inrerchange = true,
            },
            {
                805,"Авиамоторная",
                arr = {"prib_05_m","prib_05_g"},
                dep = {"otpr_06_m","otpr_04_g"},
				have_inrerchange = true,
            },
            {
                806,"Площадь Ильича",
                arr = {"prib_06_m","prib_06_g"},
                dep = {"otpr_07_m","otpr_05_g"},
				have_inrerchange = true,
            },
            {
                807,"Марксистская",
                arr = {"prib_07_m","prib_07_g"},
                dep = {"otpr_08_m","otpr_06_g"},
			    not_last = {"sled_07"},
				arrlast = {{"prib_07_m_neid"}, nil, "name_07_g"},
				have_inrerchange = true,
            },	
            {
                808,"Третьяковск.",
				arrlast = {{"prib_08_m"}, nil, "name_08_g"},
                dep = {nil, {"otpr_07_g"}},
				have_inrerchange = true,
            }
        }
    }
)


Metrostroi.AddSarmatUPOAnnouncer("SARMAT Moscow Metro",
	{
		click_start = {"subway_announcers/kalininskaya_real/click.mp3", 0.05},
		click_end = {"subway_announcers/kalininskaya_real/click.mp3", 0.05},
		click1 = {"subway_announcers/kalininskaya_real/click.mp3", 0.05},
		click2 = {"subway_announcers/kalininskaya_real/click.mp3", 0.05},
		tone = {"subway_announcers/kalininskaya_real/click.mp3", 0.05},

        --  STATIONS
		
		otpr_01_g = {"subway_announcers/kalininskaya_real/otpr_01_g.mp3", 13.75},
		prib_01_g = {"subway_announcers/kalininskaya_real/prib_01_g.mp3", 25.8},
 
		otpr_02_g = {"subway_announcers/kalininskaya_real/otpr_02_g.mp3", 9.33},
		otpr_02_m = {"subway_announcers/kalininskaya_real/otpr_02_m.mp3", 14.62},
		prib_02_g = {"subway_announcers/kalininskaya_real/prib_02_g.mp3", 8.61},
		prib_02_m = {"subway_announcers/kalininskaya_real/prib_02_m.mp3", 13.63},	
		
		prib_02_g_neid = {"subway_announcers/kalininskaya_real/prib_02_g_neid.mp3", 28.33},
		prib_02_m_neid = {"subway_announcers/kalininskaya_real/prib_02_m_neid.mp3", 29.33},
		sled_02 = {"subway_announcers/kalininskaya_real/sled_02.mp3", 4.04},
		
		otpr_03_g = {"subway_announcers/kalininskaya_real/otpr_03_g.mp3", 18.02},
		otpr_03_m = {"subway_announcers/kalininskaya_real/otpr_03_m.mp3", 17.64},
		prib_03_g = {"subway_announcers/kalininskaya_real/prib_03_g.mp3", 4.34},
		prib_03_m = {"subway_announcers/kalininskaya_real/prib_03_m.mp3", 4.52},

		otpr_04_g = {"subway_announcers/kalininskaya_real/otpr_04_g.mp3", 24.94},
		otpr_04_m = {"subway_announcers/kalininskaya_real/otpr_04_m.mp3", 10.35},
		prib_04_g = {"subway_announcers/kalininskaya_real/prib_04_g.mp3", 15.24},
		prib_04_m = {"subway_announcers/kalininskaya_real/prib_04_m.mp3", 15.92},

		prib_04_g_neid = {"subway_announcers/kalininskaya_real/prib_04_g_neid.mp3", 35.25},
		prib_04_m_neid = {"subway_announcers/kalininskaya_real/prib_04_m_neid.mp3", 37.04},
		sled_04 = {"subway_announcers/kalininskaya_real/sled_04.mp3", 4.7},

		otpr_05_g = {"subway_announcers/kalininskaya_real/otpr_05_g.mp3", 9.49},
		otpr_05_m = {"subway_announcers/kalininskaya_real/otpr_05_m.mp3", 24.26},
		prib_05_g = {"subway_announcers/kalininskaya_real/prib_05_g.mp3", 16.19},
		prib_05_m = {"subway_announcers/kalininskaya_real/prib_05_m.mp3", 16.79},

		otpr_06_g = {"subway_announcers/kalininskaya_real/otpr_06_g.mp3", 9.81},
		otpr_06_m = {"subway_announcers/kalininskaya_real/otpr_06_m.mp3", 9.59},
		prib_06_g = {"subway_announcers/kalininskaya_real/prib_06_g.mp3", 18.83},
		prib_06_m = {"subway_announcers/kalininskaya_real/prib_06_m.mp3", 24.82},

		otpr_07_g = {"subway_announcers/kalininskaya_real/otpr_07_g.mp3", 18.69},
		otpr_07_m = {"subway_announcers/kalininskaya_real/otpr_07_m.mp3", 8.93},
		prib_07_g = {"subway_announcers/kalininskaya_real/prib_07_g.mp3", 17.24},
		prib_07_m = {"subway_announcers/kalininskaya_real/prib_07_m.mp3", 17.83},
		
		prib_07_m_neid = {"subway_announcers/kalininskaya_real/prib_07_m_neid.mp3", 33.44},
		sled_07 = {"subway_announcers/kalininskaya_real/sled_07.mp3", 4.06},

		otpr_08_m = {"subway_announcers/kalininskaya_real/otpr_08_m.mp3", 20.38},
		prib_08_m = {"subway_announcers/kalininskaya_real/prib_08_m.mp3", 31.61},
	},
	{
		{
            LED = {4, 4, 4, 4, 4, 4, 4, 4},
            Name = "Калининская",
            {
                801,"Новокосино",
    			arrlast = {nil, {"prib_01_g"}},
    			dep = {{"otpr_02_m"}, nil},
    			tone = "tone", dist = 100,
				have_inrerchange = true,
            },
            {
                802,"Новогиреево",
                arr = {"prib_02_m","prib_02_g"},
                dep = {"otpr_03_m","otpr_01_g"},
    		    not_last = {0.5, "sled_02"},
    			arrlast = {"prib_02_m_neid","prib_02_g_neid"},
    			tone = "tone", dist = 50,
				have_inrerchange = true,
            },
            {
                803,"Перово",
                arr = {"prib_03_m","prib_03_g"},
                dep = {"otpr_04_m","otpr_02_g"},
    			tone = "tone", dist = 25,
				have_inrerchange = true,
            },
            {
                804,"Ш. Энтузиастов",
                arr = {"prib_04_m","prib_04_g"},
                dep = {"otpr_05_m","otpr_03_g"},
    		    not_last = {0.5, "sled_04"},
    			arrlast = {"prib_04_m_neid","prib_04_g_neid"},
    			tone = "tone", dist = 75,
				have_inrerchange = true,
            },
            {
                805,"Авиамоторная",
                arr = {"prib_05_m","prib_05_g"},
                dep = {"otpr_06_m","otpr_04_g"},
    			tone = "tone", dist = 75,
 				have_inrerchange = true,
            },
            {
                806,"Площадь Ильича",
                arr = {"prib_06_m","prib_06_g"},
                dep = {"otpr_07_m","otpr_05_g"},
    			tone = "tone", dist = 100,
				have_inrerchange = true,
            },
            {
                807,"Марксистская",
                arr = {"prib_07_m","prib_07_g"},
                dep = {"otpr_08_m","otpr_06_g"},
			    not_last = {0.5, "sled_07"},
				arrlast = {{"prib_07_m_neid"}, nil},
    			tone = "tone", dist = 100,
				have_inrerchange = true,
            },	
            {
                808,"Третьяковская",
    			arrlast = {{"prib_08_m"}, nil},
                dep = {nil, {"otpr_07_g"}},
    			tone = "tone", dist = 100,
				have_inrerchange = true,
            }
	    }
    }
)


Metrostroi.SetUPOAnnouncer (
	{
		name = "UPO Moscow Metro",
		click_start = {"subway_announcers/kalininskaya_real/click.mp3", 0.05},
		click_end = {"subway_announcers/kalininskaya_real/click.mp3", 0.05},
		click1 = {"subway_announcers/kalininskaya_real/click.mp3", 0.05},
		click2 = {"subway_announcers/kalininskaya_real/click.mp3", 0.05},
		tone = {"subway_announcers/kalininskaya_real/click.mp3", 0.05},

        --  STATIONS
		
		otpr_01_g = {"subway_announcers/kalininskaya_real/otpr_01_g.mp3", 13.75},
		prib_01_g = {"subway_announcers/kalininskaya_real/prib_01_g.mp3", 25.8},
 
		otpr_02_g = {"subway_announcers/kalininskaya_real/otpr_02_g.mp3", 9.33},
		otpr_02_m = {"subway_announcers/kalininskaya_real/otpr_02_m.mp3", 14.62},
		prib_02_g = {"subway_announcers/kalininskaya_real/prib_02_g.mp3", 8.61},
		prib_02_m = {"subway_announcers/kalininskaya_real/prib_02_m.mp3", 13.63},	
		
		prib_02_g_neid = {"subway_announcers/kalininskaya_real/prib_02_g_neid.mp3", 28.33},
		prib_02_m_neid = {"subway_announcers/kalininskaya_real/prib_02_m_neid.mp3", 29.33},
		sled_02 = {"subway_announcers/kalininskaya_real/sled_02.mp3", 4.04},
		
		otpr_03_g = {"subway_announcers/kalininskaya_real/otpr_03_g.mp3", 18.02},
		otpr_03_m = {"subway_announcers/kalininskaya_real/otpr_03_m.mp3", 17.64},
		prib_03_g = {"subway_announcers/kalininskaya_real/prib_03_g.mp3", 4.34},
		prib_03_m = {"subway_announcers/kalininskaya_real/prib_03_m.mp3", 4.52},

		otpr_04_g = {"subway_announcers/kalininskaya_real/otpr_04_g.mp3", 24.94},
		otpr_04_m = {"subway_announcers/kalininskaya_real/otpr_04_m.mp3", 10.35},
		prib_04_g = {"subway_announcers/kalininskaya_real/prib_04_g.mp3", 15.24},
		prib_04_m = {"subway_announcers/kalininskaya_real/prib_04_m.mp3", 15.92},

		prib_04_g_neid = {"subway_announcers/kalininskaya_real/prib_04_g_neid.mp3", 35.25},
		prib_04_m_neid = {"subway_announcers/kalininskaya_real/prib_04_m_neid.mp3", 37.04},
		sled_04 = {"subway_announcers/kalininskaya_real/sled_04.mp3", 4.7},

		otpr_05_g = {"subway_announcers/kalininskaya_real/otpr_05_g.mp3", 9.49},
		otpr_05_m = {"subway_announcers/kalininskaya_real/otpr_05_m.mp3", 24.26},
		prib_05_g = {"subway_announcers/kalininskaya_real/prib_05_g.mp3", 16.19},
		prib_05_m = {"subway_announcers/kalininskaya_real/prib_05_m.mp3", 16.79},

		otpr_06_g = {"subway_announcers/kalininskaya_real/otpr_06_g.mp3", 9.81},
		otpr_06_m = {"subway_announcers/kalininskaya_real/otpr_06_m.mp3", 9.59},
		prib_06_g = {"subway_announcers/kalininskaya_real/prib_06_g.mp3", 18.83},
		prib_06_m = {"subway_announcers/kalininskaya_real/prib_06_m.mp3", 24.82},

		otpr_07_g = {"subway_announcers/kalininskaya_real/otpr_07_g.mp3", 18.69},
		otpr_07_m = {"subway_announcers/kalininskaya_real/otpr_07_m.mp3", 8.93},
		prib_07_g = {"subway_announcers/kalininskaya_real/prib_07_g.mp3", 17.24},
		prib_07_m = {"subway_announcers/kalininskaya_real/prib_07_m.mp3", 17.83},
		
		prib_07_m_neid = {"subway_announcers/kalininskaya_real/prib_07_m_neid.mp3", 33.44},
		sled_07 = {"subway_announcers/kalininskaya_real/sled_07.mp3", 4.06},

		otpr_08_m = {"subway_announcers/kalininskaya_real/otpr_08_m.mp3", 20.38},
		prib_08_m = {"subway_announcers/kalininskaya_real/prib_08_m.mp3", 31.61},
},{
        {
            801,"Новокосино",
    		arrlast = {nil, {"prib_01_g"}},
    		dep = {{"otpr_02_m"}, nil},
    		tone = "tone", dist = 100,
			noises = {1,2,3},noiserandom = 0.2,
        },
        {
            802,"Новогиреево",
            arr = {"prib_02_m","prib_02_g"},
            dep = {"otpr_03_m","otpr_01_g"},
    		tone = "tone", dist = 50,
			noises = {1,2,3},noiserandom = 0.2,
        },
        {
            803,"Перово",
            arr = {"prib_03_m","prib_03_g"},
            dep = {"otpr_04_m","otpr_02_g"},
			tone = "tone", dist = 25,
			noises = {1,2,3},noiserandom = 0.2,
        },
        {
            804,"Ш. Энтузиастов",
            arr = {"prib_04_m","prib_04_g"},
            dep = {"otpr_05_m","otpr_03_g"},
			tone = "tone", dist = 75,
			noises = {1,2,3},noiserandom = 0.2,
        },
        {
            805,"Авиамоторная",
            arr = {"prib_05_m","prib_05_g"},
            dep = {"otpr_06_m","otpr_04_g"},
			tone = "tone", dist = 75,
			noises = {1,2,3},noiserandom = 0.2,
        },
        {
            806,"Площадь Ильича",
            arr = {"prib_06_m","prib_06_g"},
            dep = {"otpr_07_m","otpr_05_g"},
			tone = "tone", dist = 100,
			noises = {1,2,3},noiserandom = 0.2,
        },
        {
            807,"Марксистская",
            arr = {"prib_07_m","prib_07_g"},
            dep = {"otpr_08_m","otpr_06_g"},
			tone = "tone", dist = 100,
			noises = {1,2,3},noiserandom = 0.2,
        },	
        {
            808,"Третьяковская",
    		arrlast = {{"prib_08_m"}, nil},
            dep = {nil, {"otpr_07_g"}},
			tone = "tone", dist = 100,
			noises = {1,2,3},noiserandom = 0.2,
        },
	}
)

Metrostroi.StationSound = {
    {"subway_stations/announces/kalinin/kalinin_1.mp3",100},
    {"subway_stations/announces/kalinin/kalinin_2.mp3",100},
    {"subway_stations/announces/kalinin/kalinin_3.mp3",100},
    {"subway_stations/announces/kalinin/kalinin_4.mp3",100},
    {"subway_stations/announces/kalinin/kalinin_5.mp3",100},
    {"subway_stations/announces/kalinin/kalinin_6.mp3",100},
    {"subway_stations/announces/kalinin/kalinin_7.mp3",100},
    {"subway_stations/announces/kalinin/kalinin_8.mp3",100},
    {"subway_stations/announces/kalinin/kalinin_9.mp3",100},
}

Metrostroi.StationConfigurations = {


	[801] =
	{
		names = {"Новокосино", "Novokosino", "НК", "NK"},
		positions = {
			{Vector(1499.724854, -15275.563477, 9389.031250),Angle(0, -180, 0)},
		}
	},
	[802] =
	{
		names = {"Новогиреево", "Novogireevo", "Novogireyevo", "НВ", "NV"},
		positions = {
			{Vector(-3265.316162, -14341.180664, 8759.031250),Angle(0, 180, 0)},
		}
	},
	[803] =
	{
		names = {"Перово", "Perovo"},
		positions = {
			{Vector(-170.018173, -12234.596680, 8536.031250),Angle(0, 180, 0)},
		}
	},
	[804] =
	{
		names = {"Шоссе Энтузиастов", "Shosse Entuziastov", "ШЭ", "ЩЭ", "ShE"},
		positions = {
			{Vector(-13349.800781, -5215.446289, 6657.031250),Angle(0, -90, 0)},
		}
	},
	[805] =
	{
		names = {"Авиамоторная", "Aviamotornaya"},
		positions = {
			{Vector(-15308.013672, 1199.006470, 5899.031250),Angle(0, -90, 0)},
		}
	},
	[806] =
	{
		names = {"Площадь Ильича", "Ploschad Ilyicha"},
		positions = {
			{Vector(2369.622314, -11243.684570, 4900.031250),Angle(2.2, -180, 0)},
		}
	},
	[807] =
	{
		names = {"Марксистская", "Marksistskaya", "МР", "MR"},
		positions = {
			{Vector(-11400.570313, -4759.392090, 4079.031250),Angle(0, -80, 0)},
		}
	},
	[808] =
	{
		names = {"Третьяковская", "Tretyakovskaya", "ТР", "TR"},
		positions = {
			{Vector(4292.302246, -2965.617432, 3400.031250),Angle(0, 90, 0)},
		}
	},
	pto =
	{
		names = {"ПТО", "пто"},
		positions = {
			{Vector(15680.558594, -15274.958008, 9321.031250),Angle(4, -180, 0)},
		}
	},
	depot =
	{
		names = {"Депо"},
		positions = {
			{Vector(-8635.637695, -5667.125488, 9203.031250),Angle(0.5, -53.9, 0)},
		}
	},
}

