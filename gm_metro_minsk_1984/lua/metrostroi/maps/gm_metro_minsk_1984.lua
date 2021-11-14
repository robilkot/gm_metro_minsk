local Map = game.GetMap() or ""
if Map:find("gm_metro_minsk_1984") then
    Metrostroi.PlatformMap = "gm_metro_minsk_1984"
    Metrostroi.CurrentMap = "gm_metro_minsk_1984"
else
    return
end

Metrostroi.AddLastStationTex("717", 114, "metrostroi_skins/81-717/route_ik")
Metrostroi.AddLastStationTex("717", 121, "metrostroi_skins/81-717/route_mos")
Metrostroi.AddLastStationTex("702", 114, "metrostroi_skins/81-702/route_ik")
Metrostroi.AddLastStationTex("702", 121, "metrostroi_skins/81-702/route_mos")

Metrostroi.AddANSPAnnouncer("ASNP Minsk",
	{
		asnp = true,
		click1 = {"subway_announcers/minsk/click1.mp3", 0.522},
		click2 = {"subway_announcers/minsk/click2.mp3", 0.480},
		last = {"subway_announcers/minsk/last.mp3", 4.356},
		odz = {"subway_announcers/minsk/odz.mp3", 2.478},
		
		spec_attention_doors = {"subway_announcers/minsk/spec_attention_doors.mp3", 7.486},
		spec_attention_pl_edge = {"subway_announcers/minsk/spec_attention_pl_edge.mp3", 9.312},
		spec_attention_handrails = {"subway_announcers/minsk/spec_attention_politeness.mp3", 8.738},
		spec_attention_last = {"subway_announcers/minsk/spec_attention_last.mp3", 9.227},
		spec_attention_objects1 = {"subway_announcers/minsk/spec_attention_objects1.mp3", 4.304}, 
		spec_attention_objects2 = {"subway_announcers/minsk/spec_attention_objects2.mp3", 14.711},
		spec_attention_politeness = {"subway_announcers/minsk/spec_attention_politeness.mp3", 8.680},
		spec_attention_things = {"subway_announcers/minsk/spec_attention_things.mp3", 4.852},
		spec_attention_train_depart = {"subway_announcers/minsk/spec_attention_train_depart.mp3", 10.642},
		spec_attention_train_stop = {"subway_announcers/minsk/spec_attention_train_stop.mp3", 10.642},
		train_goes_to = {"subway_announcers/minsk/train_goes_to.mp3", 2.905},
		announcer_ready = {"subway_announcers/minsk/train_goes_to.mp3", 2.496},
		
		next_ik = {"subway_announcers/minsk/moskovskaya/next_ik.mp3", 3.156},
		arr_ik = {"subway_announcers/minsk/moskovskaya/arr_ik.mp3", 2.739},
		ik = {"subway_announcers/minsk/moskovskaya/ik.mp3", 1.408},
		next_pl = {"subway_announcers/minsk/moskovskaya/next_pl.mp3", 3.286},
		arr_pl = {"subway_announcers/minsk/moskovskaya/arr_pl.mp3", 6.756},
		pl = {"subway_announcers/minsk/moskovskaya/pl.mp3", 1.591},
		next_okt = {"subway_announcers/minsk/moskovskaya/next_okt.mp3", 3.052},
		arr_okt = {"subway_announcers/minsk/moskovskaya/arr_okt.mp3", 2.791},
		okt = {"subway_announcers/minsk/moskovskaya/okt.mp3", 1.252},
		next_pp = {"subway_announcers/minsk/moskovskaya/next_pp.mp3", 3.208},
		arr_pp = {"subway_announcers/minsk/moskovskaya/arr_pp.mp3", 3.000},
		pp = {"subway_announcers/minsk/moskovskaya/pp.mp3", 1.513},
		next_pk = {"subway_announcers/minsk/moskovskaya/next_pk.mp3", 3.834},
		arr_pk = {"subway_announcers/minsk/moskovskaya/arr_pk.mp3", 2.895},
		pk = {"subway_announcers/minsk/moskovskaya/pk.mp3", 1.826},
		next_an = {"subway_announcers/minsk/moskovskaya/next_an.mp3", 3.313},
		arr_an = {"subway_announcers/minsk/moskovskaya/arr_an.mp3", 2.634},
		an = {"subway_announcers/minsk/moskovskaya/an.mp3", 1.591},
		next_pch = {"subway_announcers/minsk/moskovskaya/next_pch.mp3", 3.182},
		arr_pch = {"subway_announcers/minsk/moskovskaya/arr_pch.mp3", 2.947},
		pch = {"subway_announcers/minsk/moskovskaya/pch.mp3", 1.487},
		next_mos = {"subway_announcers/minsk/moskovskaya/next_mos.mp3", 2.895},
		arr_mos = {"subway_announcers/minsk/moskovskaya/arr_mos.mp3", 2.191},
		mos = {"subway_announcers/minsk/moskovskaya/mos.mp3", 1.200},
	},
	{
		{
			LED = {4, 4, 3, 4, 4, 3, 4, 4},
			Name = "Московская Линия",
			Loop = false,
			spec_last = {"last", "spec_attention_things"},
			spec_wait = {{"spec_attention_train_stop"}, {"spec_attention_train_depart"}},
			{
				114,
				"Институт Культуры",
				arrlast = {nil, {"arr_ik", "last1"}, "ik"},
				dep = {{"odz", "next_pl"}, nil},
			},
			{
				115,
				"Площадь Ленина",
				arr = {"arr_pl", "arr_pl"},
				dep = {{"odz", "next_okt", "spec_attention_objects1"}, {"odz", "next_ik"}},
			},
			{
				116,
				"Октябрьская",
				arr = {{"arr_okt"}, {"arr_okt"}},
				dep = {{"odz", "next_pp"}, {"odz", "next_pl"}},
			},
			{
				117,
				"Площадь Победы",
				arr = {"arr_pp", "arr_pp"},
				dep = {{"odz", "next_pk", "spec_attention_handrails"}, {"odz", "next_okt", "spec_attention_doors"}},
			},
			{
				118,
				"Пл. Якуба Коласа",
				arr = {{"arr_pk", "spec_attention_pl_edge"}, {"arr_pk"}},
				dep = {{"odz", "next_an"}, {"odz", "next_pp"}}
			},
			{
				119,
				"Академия Наук",
				arr = {{"arr_an", "spec_attention_pl_edge"}, {"arr_an"}},
				dep = {{"odz", "next_pch"}, {"odz", "next_pk", "spec_attention_politeness"}}
			},
			{
				120,
				"Парк Челюскинцев",
				arr = {{"arr_pch", "spec_attention_pl_edge"}, {"arr_pch"}},
				dep = {{"odz", "next_mos"}, {"odz", "next_an", "spec_attention_objects1"}}
			},
			{
				121,
				"Московская",
				arrlast = {{"arr_mos", "last", "spec_attention_things"}, nil, "mos"},
				dep = {nil, {"odz", "next_pch"}}
			}
		}
	}
)

Metrostroi.StationConfigurations = {
	[114] = {
		names = {"Институт Культуры","Institut Kultury","ik"},
		positions = {
			{Vector(858,10201,7486-56),Angle(0,-43,0)}
		}
	},
	[115] = {
		names = {"Площадь Ленина","Lenina Square","pl","len"},
		positions = {
			{Vector(52, -1173, 7118-56),Angle(0,-90,0)}
		}
	},
	[116] = {
		names = {"Октябрьская","Oktyabrskaya","okt","ok"},
		positions = {
			{Vector(-15000, -1338, 6461-56),Angle(0,90,0)}
		}
	},
	[117] = {
		names = {"Площадь Победы","Pobedy Square","pp"},
		positions = {
			{Vector(2038, -7218, 6109-56),Angle(0,-180,0)}
		}
	},
	[118] = {
		names = {"Площадь Якуба Коласа","yak","pyak","kolasa"},
		positions = {
			{Vector(-500, -1600, 6109-56),Angle(0,-180,0)}
		}
	},
	[119] = {
		names = {"Академия Наук","Akademiya Nauk","an","akn"},
		positions = {
			{Vector(-2744, -11831, 6444-56),Angle(0,180,0)}
		}
	},
	[120] = {
		names = {"Парк Челюскинцев","Park Cheluskintsev","pch","pc"},
		positions = {
			{Vector(-1959, -814, 7869-56),Angle(0,165,0)}
		}
	},
	[121] = {
		names = {"Московская","Moskovskaya","ms","mos",",msk"},
		positions = {
			{Vector(-198, -66, 8354-56),Angle(0,180,0)}
		}
	},
	depot = {
		names = {"Депо Московское", "Depo Moskovskoye", "dm", "tch1"},
		positions = {
			{Vector(-9183, -7688, 7779-54),Angle(0,-90,0)}
		}
	},
	tupik1 = {
		names = {"Тупик Институт Культуры", "obinstitut","t1", "ob1"},
		positions = {
			{Vector(8692, 2765, 7494-56),Angle(0,135,0)}
		}
	},
	tupik2 = {
		names = {"Тупик Московская", "obmoskovskaya", "ob2", "t2"},
		positions = {
			{Vector(10363, -77, 8361-56),Angle(0,180,0)}
		}
	},
	portal = {
		names = {"Портал"},
		positions = {
			{Vector(14038, -8659, 7849-56),Angle(0,-117,0)}
		}
	}
}