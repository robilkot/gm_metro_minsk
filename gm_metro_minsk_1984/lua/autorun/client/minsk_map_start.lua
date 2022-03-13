hook.Add( "Initialize", "Minsk client init", function()
	if (game.GetMap() == "gm_metro_minsk_1984") then 
		RunConsoleCommand("mat_specular", "1")
	end
end)