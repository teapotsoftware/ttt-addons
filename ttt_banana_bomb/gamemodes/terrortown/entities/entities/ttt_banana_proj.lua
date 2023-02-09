AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/props/cs_italy/bananna_bunch.mdl")
ENT.Icon = "vgui/ttt/icon_banana"

AccessorFunc(ENT, "radius", "Radius", FORCE_NUMBER)
AccessorFunc(ENT, "dmg", "Dmg", FORCE_NUMBER)

function ENT:Initialize()
	if not self:GetRadius() then self:SetRadius(400) end
	if not self:GetDmg() then self:SetDmg(100) end

	return self.BaseClass.Initialize(self)
end

function ENT:Explode(tr)
	if SERVER then
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)

		-- pull out of the surface
		if tr.Fraction != 1.0 then
		self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
	end

	local pos = self:GetPos()

	util.BlastDamage(self, self:GetThrower(), pos, self:GetRadius(), self:GetDmg())

	-- RAIN HELL BOYS!
	for i = 0, math.random(8, 16) do
		local ent = ents.Create("ttt_banana_split")
		ent:SetPos(self:GetPos() + Vector(0, 0, 10) + VectorRand() * 5)
		ent:SetOwner(self.Owner)
		ent:SetAngles(Angle(math.Rand(0, 360), math.Rand(0, 360), math.Rand(0, 360)))
		ent:Spawn()
		ent:Activate()
		
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			local vrnd = VectorRand()
			timer.Simple(0.1, function()
				if not IsValid(phys) then return end
				phys:ApplyForceCenter((800 * vrnd * math.Rand(4, 8)) + Vector(0, 0, 100))
			end)
		end
	  end

	  -- make sure we are removed, even if errors occur later
      self:Remove()

      local effect = EffectData()
      effect:SetStart(pos)
      effect:SetOrigin(pos)

      if tr.Fraction != 1.0 then
         effect:SetNormal(tr.HitNormal)
      end

      util.Effect("Explosion", effect, true, true)
      util.Effect("cball_explode", effect, true, true)

   else
      local spos = self.Entity:GetPos()
      local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
      util.Decal("SmallScorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      

      self:SetDetonateExact(0)
   end
end

function ENT:PhysicsCollide(data,phys)
	if data.Speed > 50 then
		self:EmitSound("Rubber.ImpactHard")
	end

	local impulse = -data.Speed * data.HitNormal * .4 + (data.OurOldVelocity * -.6)
	phys:ApplyForceCenter(impulse)
end
