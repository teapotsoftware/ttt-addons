
if game.GetMap() ~= "ttt_vicodin" then
	return
end

if SERVER then
	util.AddNetworkString("TTT_Vicodin.ActivateKittyTrap")

	function ActivateKittyTrap()
		net.Start("TTT_Vicodin.ActivateKittyTrap")
		net.Broadcast()
	end

	hook.Add("TTTPrepareRound", "TTT_Vicodin.FixSlottedDoor", function()
		local slotted_door = ents.FindByName("slotted_door")[1]
		if IsValid(slotted_door) then
			slotted_door:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		end
	end)

	local StartPos = Vector(-16, 1712, 0)
	local DestPos = Vector(1536, 4560, 0)
	local dejavu = {
		"This place seems familiar...",
		"I've been here before...",
		"Hey, I recognize this place..."
		-- "Something isn't quite right..."
	}

	function BackroomsTP()
		local trig = ents.FindByName("backrooms_tp")[1]
		for _, ply in ipairs(ents.FindInSphere(trig:GetPos(), 420)) do
			if ply:IsPlayer() then
				ply:SetEyeAngles(ply:EyeAngles() + Angle(0, 180, 0))
				local pos = ply:GetPos()
				local fpos = DestPos - (pos - StartPos)
				fpos.z = pos.z
				ply:SetPos(fpos)
				ply:ChatPrint(dejavu[math.random(1, #dejavu)])
			end
		end
	end
else
	hook.Add("PostDrawTranslucentRenderables", "TTT_Vicodin.Hallucinations", function(depth, sky, sky3d)
		local ply = LocalPlayer()

		if ply:GetPos().z < -3000 and CurTime() % 13 < 0.1 then
			local x = ScrW() * (math.random(100) > 50 and math.Rand(0, 0.1) or math.Rand(0.9, 1))
			local y = ScrH() * math.Rand(0.4, 0.6)
			local pos = ply:GetShootPos() + gui.ScreenToVector(x, y) * math.random(300, 500)
			render.Model({
				model = "models/player.mdl",
				pos = pos,
				angle = (pos - ply:GetShootPos()):Angle() + Angle(0, 180, 0)
			})
		end
	end)

	local lastKittyTrap = -10
	net.Receive("TTT_Vicodin.ActivateKittyTrap", function(len)
		lastKittyTrap = CurTime()
	end)

	local color_red = Color(255, 0, 0)

	local kittyMat = Material("ttt_kleinlabs/kitty")
	hook.Add("DrawOverlay", "TTT_Vicodin.KittyTrap", function()
		local ply = LocalPlayer()
		if IsValid(ply) and ply:Alive() and CurTime() - lastKittyTrap <= 10 then
			local w = ScrW()
			local h = ScrH()
			if ply:IsTraitor() then
				draw.SimpleTextOutlined(string.format("Innocents have a kitty covering their screen for %.2f seconds...", math.Round((lastKittyTrap + 10) - CurTime(), 2)), "DermaLarge", w * 0.5, h * 0.35, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
			else
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(kittyMat)
				local s = math.min(w, h) * 0.5
				surface.DrawTexturedRect((w - s) * 0.5, (h - s) * 0.5, s, s)
			end
		end
	end)
end
