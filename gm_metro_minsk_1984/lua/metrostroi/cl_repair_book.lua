-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2021 году для карты gm_metro_minsk_1984.
--	Аддон добавляет книгу ремонта в составы.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------


if (game.GetMap() != "gm_metro_minsk_1984") then return end

local function createFont(name, font, size)
	surface.CreateFont(name, {
		font = font, 
		size = size or 45,
		weight = 650,
		blursize = false,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = false,
		outline = false,
		extended = true,
		scanlines = false,
	})
end

createFont("Metrostroi_RapairBook_Text", "Times New Roman", 150)
createFont("Metrostroi_RapairBook_Text_Small", "Times New Roman", 100)


hook.Add("InitPostEntity", "RepairBookInitialize", function()       --Хук, вызываемый после инциализации игры, начало тела функции с кодом


local Trains = {						
	["gmod_subway_81-717_mvm"] = {	
		{pos = Vector(438, -42, -5.8), ang = Angle(0, -64, 0)},	
		{pos = Vector(438, -42, -5.8), ang = Angle(0, -0, 0)},	
		{pos = Vector(438.95, -36.71, -5.61), ang = Angle(1.1, -55.35, 0.78)},	
		{pos = Vector(438.9, -49.8, -5.8), ang = Angle(0, -240, 0)},		
		{pos = Vector(438.3, -37.8, -5.8), ang = Angle(0, 88.8, 0)},		
	},
}

for trainName, location in pairs(Trains) do
	ENT = scripted_ents.GetStored(trainName).t
	
	ENT.ClientProps["repair_book"] = {
		model = "models/kniga_remonta.mdl",
		pos = location[1].pos,
		ang = location[1].ang,
		hideseat=1.5
	}
	
	local pos, ang = LocalToWorld(Vector(100*0.0625/2, 165*0.0625/2, 0.2), Angle(0, -90, 0), ENT.ClientProps["repair_book"].pos, ENT.ClientProps["repair_book"].ang)
	ENT.ButtonMap["RepairBookScreen"] = {
		pos = pos,
		ang = ang,
		width = 1650,
		height = 1000,
		scale = 0.00625,
	}

	ENT.RepairBook = ENT.RepairBook or {}

	ENT.RepairBook.Think = ENT.RepairBook.Think or ENT.Think
	function ENT:Think()
		self.RepairBook.Think(self)
		
		self.RepairBook.SetRandomPos(self)

		self:ShowHide("repair_book", self:GetNW2Bool("RepairBook"))
		self:HidePanel("RepairBookScreen", not self:GetNW2Bool("RepairBook"))

		self.RepairBook.DrawRepairBook(self)
	end

	ENT.RepairBook.DrawPost = ENT.RepairBook.DrawPost or ENT.DrawPost
	function ENT:DrawPost(special)
		local distance = self:GetPos():Distance(LocalPlayer():GetPos())

		if distance < 512 or not special then 
			if (self.RepairBookRT == nil) then
				self.RepairBookRT = self:CreateRT("717RepairBook", 1650, 1000)
			end
	
			self.RTMaterial:SetTexture("$basetexture", self.RepairBookRT)
			self:DrawOnPanel("RepairBookScreen", function(...)
				surface.SetMaterial(self.RTMaterial)
				surface.SetDrawColor(255, 255, 255)
				surface.DrawTexturedRectRotated(1650/2, 1200/2, 1650, 1200, 0)
			end)
		end
		return self.RepairBook.DrawPost(self, special)
	end

	function ENT.RepairBook.DrawRepairBook(self)
		if not self:ShouldDrawPanel("RepairBookScreen") then return end

		if not self.DrawTimer then
			render.PushRenderTarget(self.RepairBookRT, 0, 0, 1650, 1000)
			render.Clear(0, 0, 0, 0)
			render.PopRenderTarget()
		end

		if self.DrawTimer and CurTime()-self.DrawTimer < 0.1 then return end

		self.DrawTimer = CurTime()

		render.PushRenderTarget(self.RepairBookRT, 0, 0, 1650, 1000)
			render.Clear(0, 0, 0, 0)
			cam.Start2D()
				local black = surface.GetTextureID("")
				surface.SetTexture(black)
				surface.SetDrawColor(Color(0,0,0))
				self.RepairBook.DrawTrainNumbers(self)
			cam.End2D()
		render.PopRenderTarget()
	end

	function ENT.RepairBook.DrawTrainNumbers(self)
		local wagonNumbers = util.JSONToTable(self:GetNW2String("RepairBookWagonNumbers"))

		if (wagonNumbers) then
			draw.SimpleText(Format("%04d", wagonNumbers[1]) or "", "Metrostroi_RapairBook_Text", 230, 300, Color(0,0,0), TEXT_ALIGN_CENTER)
			if (#wagonNumbers != 1) then
				draw.SimpleText(Format("%04d", wagonNumbers[#wagonNumbers]) or "", "Metrostroi_RapairBook_Text", 1440, 300, Color(0,0,0), TEXT_ALIGN_CENTER)
				if (#wagonNumbers - 2 == 3) then
					draw.SimpleText(Format("%04d", wagonNumbers[2]), "Metrostroi_RapairBook_Text_Small", 825 - 330, 520, Color(0,0,0), TEXT_ALIGN_CENTER)
					draw.SimpleText(Format("%04d", wagonNumbers[3]), "Metrostroi_RapairBook_Text_Small", 825, 520, Color(0,0,0), TEXT_ALIGN_CENTER)
					draw.SimpleText(Format("%04d", wagonNumbers[4]), "Metrostroi_RapairBook_Text_Small", 825 + 330, 520, Color(0,0,0), TEXT_ALIGN_CENTER)
				elseif (#wagonNumbers - 2 == 2) then
					draw.SimpleText(Format("%04d", wagonNumbers[2]), "Metrostroi_RapairBook_Text_Small", 825 - 330 / 2, 520, Color(0,0,0), TEXT_ALIGN_CENTER)
					draw.SimpleText(Format("%04d", wagonNumbers[3]), "Metrostroi_RapairBook_Text_Small", 825 + 330 / 2, 520, Color(0,0,0), TEXT_ALIGN_CENTER)
				elseif (#wagonNumbers - 2 == 1) then
					draw.SimpleText(Format("%04d", wagonNumbers[2]), "Metrostroi_RapairBook_Text_Small", 825, 520, Color(0,0,0), TEXT_ALIGN_CENTER)
				end
			end
			
		end
	end

	function ENT.RepairBook.SetRandomPos(self)
		if self.RepairBook.Initialize then return end
		if (not IsValid(self.ClientEnts["repair_book"])) then return end

		local locationNum = math.ceil(math.random() * #location)
		local pos = location[locationNum].pos 
		local ang = location[locationNum].ang
		
		self.ClientEnts["repair_book"]:SetPos(self:LocalToWorld(pos))
		self.ClientEnts["repair_book"]:SetAngles(self:LocalToWorldAngles(ang))

		pos, ang = LocalToWorld(Vector(100*0.0625/2, 165*0.0625/2, 0.2), Angle(0, -90, 0), pos, ang)

		self.ButtonMap["RepairBookScreen"].pos = pos
		self.ButtonMap["RepairBookScreen"].ang = ang

		self.RepairBook.Initialize = true
		return
	end
end
	

end) --Окончание тела функции хука



	

