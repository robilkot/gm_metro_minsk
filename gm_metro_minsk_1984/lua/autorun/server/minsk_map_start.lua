hook.Add("InitPostEntity", "MinskTunnelLightSSVInitialize", function() 
	if (game.GetMap() == "gm_metro_minsk_1984") then 
		RunConsoleCommand("minsk_tunnel_light_on", "ssv", "1")
		RunConsoleCommand("minsk_tunnel_light_on", "ssv", "2")
	end
end)
