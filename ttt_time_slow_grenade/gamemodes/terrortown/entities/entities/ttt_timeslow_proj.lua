AddCSLuaFile()

local slow_time = CreateConVar("ttt_time_slow_grenade_time", "16", FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_NOTIFY, "Effect duration of time slow grenade.", 0.1, 100)
local slow_amt = CreateConVar("ttt_time_slow_grenade_amount", "0.3", FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_NOTIFY, "Time scale multiplier from time slow grenade.", 0.01, 1)

if SERVER then
	resource.AddFile("sound/slowmo/slowmo_start.wav")
	resource.AddFile("sound/slowmo/slowmo_end.wav")

	util.AddNetworkString("TimeSlow.PlaySound")

	TIME_SLOW_ACTIVE = false
	TIME_SLOW_START = 0

	function SetSlowTime(b)
		if b then
			TIME_SLOW_ACTIVE = true
			TIME_SLOW_START = RealTime()
			game.SetTimeScale(slow_amt:GetFloat())
			net.Start("TimeSlow.PlaySound")
			net.WriteBool(true)
			net.Broadcast()
		else
			TIME_SLOW_ACTIVE = false
			game.SetTimeScale(1)
			net.Start("TimeSlow.PlaySound")
			net.WriteBool(false)
			net.Broadcast()
		end
	end

	hook.Add("Think", "TimeSlowGrenade.Think", function()
		if TIME_SLOW_ACTIVE and RealTime() - TIME_SLOW_START >= slow_time:GetFloat() then
			SetSlowTime(false)
		end
	end)

	hook.Add("TTTEndRound", "TimeSlowGrenade.TTTEndRound", function()
		if TIME_SLOW_ACTIVE then
			SetSlowTime(false)
		end
	end)
else
	net.Receive("TimeSlow.PlaySound", function(len)
		local b = net.ReadBool()
		surface.PlaySound("slowmo/slowmo_" .. (b and "start" or "end") .. ".wav")
	end)
end

hook.Add("EntityEmitSound", "TimeSlowGrenade.TimeWarpSounds", function(t)
	local p = t.Pitch

	if game.GetTimeScale() ~= 1 then
		p = p * game.GetTimeScale()
	end

	if p ~= t.Pitch then
		t.Pitch = math.Clamp(p, 0, 255)
		return true
	end

	if CLIENT and engine.GetDemoPlaybackTimeScale() ~= 1 then
		t.Pitch = math.Clamp(t.Pitch * engine.GetDemoPlaybackTimeScale(), 0, 255)
		return true
	end
end)

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/items/combine_rifle_ammo01.mdl")
ENT.Icon = "vgui/ttt/icon_timeslow"

function ENT:Explode(tr)
	if SERVER then
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)

		-- pull out of the surface
		if tr.Fraction != 1.0 then
		self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
		end

		local pos = self:GetPos()

	  -- make sure we are removed, even if errors occur later
      self:Remove()

      local effect = EffectData()
      effect:SetStart(pos)
      effect:SetOrigin(pos)

      if tr.Fraction != 1.0 then
         effect:SetNormal(tr.HitNormal)
      end

      util.Effect("cball_explode", effect, true, true)

		SetSlowTime(true)
   else
      local spos = self.Entity:GetPos()
      local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
      util.Decal("SmallScorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      

      self:SetDetonateExact(0)
   end
end

function ENT:PhysicsCollide(data,phys)
	if data.Speed > 50 then
		self:EmitSound("SolidMetal.ImpactHard")
	end
end
