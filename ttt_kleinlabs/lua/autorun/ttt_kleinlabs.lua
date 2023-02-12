
if SERVER then
	util.AddNetworkString("ActivateKittyTrap")

	function ActivateKittyTrap()
		net.Start("ActivateKittyTrap")
		net.Broadcast()
	end
else
	--local lastHalluc = 0
	--local lastDir = false

	hook.Add("PostDrawTranslucentRenderables", "KleinLabs.Hallucinations", function(depth, sky, sky3d)
		--if CurTime() - lastHalluc < 3 and CurTime() - lastHalluc > 0 then return end

		local ply = LocalPlayer()
		--local curDir = ply:GetAngles().y

		--if lastDir then
			--local diff = math.abs(curDir - lastDir)
			if ply:GetPos().z > 5000 and CurTime() % 20 < 0.1 then
				local x = ScrW() * (math.random(100) > 50 and math.Rand(0, 0.1) or math.Rand(0.9, 1))
				local y = ScrH() * math.Rand(0.4, 0.6)
				--ply:ChatPrint("x:" .. x .. ",y:" .. y)
				local pos = ply:GetShootPos() + gui.ScreenToVector(x, y) * math.random(300, 500)
				--pos.z = ply:GetPos().z + math.random(-40, 40)
				render.Model({
					model = "models/kleiner.mdl",
					pos = pos,
					angle = (pos - ply:GetShootPos()):Angle() + Angle(0, 180, 0)
				})
				--lastHalluc = CurTime() - 0.1
			end
		--end

		--lastDir = curDir
	end)

	local lastKittyTrap = -10
	net.Receive("ActivateKittyTrap", function(len)
		lastKittyTrap = CurTime()
	end)

	local color_red = Color(255, 0, 0)

	local kittyMat = Material("ttt_kleinlabs/kitty")
	hook.Add("DrawOverlay", "KleinLabs.KittyTrap", function()
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
				surface.DrawTexturedRect((w-s)*0.5, (h-s)*0.5, s, s)
			end
		end
	end)
end
