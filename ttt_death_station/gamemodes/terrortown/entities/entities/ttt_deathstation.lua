---- Health dispenser

AddCSLuaFile()

local SoundNames = {}
for i = 0, 6, 1 do
	SoundNames[#SoundNames + 1] = "^phx/explode0" .. i .. ".wav"
end

sound.Add({
	name = "DeathStation.Explode",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 120,
	pitch = {95, 110},
	sound = SoundNames
})

if CLIENT then
   -- this entity can be DNA-sampled so we need some display info
   ENT.Icon = "vgui/ttt/icon_health"
   ENT.PrintName = "hstation_name"

   local GetPTranslation = LANG.GetParamTranslation

   ENT.TargetIDHint = {
      name = "hstation_name",
      hint = "hstation_hint",
      fmt  = function(ent, txt)
                return GetPTranslation(txt,
                                       { usekey = Key("+use", "USE"),
                                         num    = ent:GetStoredHealth() or 0 } )
             end
   };

end

ENT.Type = "anim"
ENT.Model = Model("models/props/cs_office/microwave.mdl")

--ENT.CanUseKey = true
ENT.CanHavePrints = true
ENT.MaxHeal = 25
ENT.MaxStored = 200
ENT.RechargeRate = 1
ENT.RechargeFreq = 2 -- in seconds

ENT.NextHeal = 0
ENT.HealRate = 1
ENT.HealFreq = 0.2

AccessorFuncDT(ENT, "StoredHealth", "StoredHealth")

AccessorFunc(ENT, "Placer", "Placer")

function ENT:SetupDataTables()
   self:DTVar("Int", 0, "StoredHealth")
   self:NetworkVar("Bool", 0, "Trapped")
end

function ENT:Initialize()
   self:SetModel(self.Model)

   self:PhysicsInit(SOLID_VPHYSICS)
   self:SetMoveType(MOVETYPE_VPHYSICS)
   self:SetSolid(SOLID_BBOX)

   local b = 32
   self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b,b,b))

   self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
   if SERVER then
      self:SetMaxHealth(200)

      local phys = self:GetPhysicsObject()
      if IsValid(phys) then
         phys:SetMass(200)
      end

      self:SetUseType(CONTINUOUS_USE)
   end
   self:SetHealth(200)

   self:SetColor(Color(180, 180, 250, 255))

   self:SetStoredHealth(200)

   self:SetPlacer(nil)

   self.NextHeal = 0

   self.fingerprints = {}
end


function ENT:AddToStorage(amount)
   self:SetStoredHealth(math.min(self.MaxStored, self:GetStoredHealth() + amount))
end

function ENT:TakeFromStorage(amount)
   -- if we only have 5 healthpts in store, that is the amount we heal
   amount = math.min(amount, self:GetStoredHealth())
   self:SetStoredHealth(math.max(0, self:GetStoredHealth() - amount))
   return amount
end

local triggersound = Sound("deathstation/deathstation_trigger.mp3")
local explodesound = Sound("DeathStation.Explode")

function ENT:Boom()
	self:EmitSound(triggersound)
	local pos = self:GetPos()

	timer.Simple(0.5, function()
		ParticleEffect("explosion_huge", pos, vector_up:Angle())
		self:EmitSound(explodesound)

		util.Decal("Rollermine.Crater", pos, pos - Vector(0, 0, 500), self)
		util.Decal("Scorch", pos, pos - Vector(0, 0, 500), self)

		SafeRemoveEntity(self)

		util.BlastDamage(self, self:GetPlacer(), pos, 1000, 230)
	end)
end

local healsound = Sound("items/medshot4.wav")
local failsound = Sound("items/medshotno1.wav")

local last_sound_time = 0
function ENT:GiveHealth(ply, max_heal)
   if ply:GetRole() == ROLE_TRAITOR then
	   if self:GetStoredHealth() > 0 then
		  max_heal = max_heal or self.MaxHeal
		  local dmg = ply:GetMaxHealth() - ply:Health()
		  if dmg > 0 then
			 -- constant clamping, no risks
			 local healed = self:TakeFromStorage(math.min(max_heal, dmg))
             local new = math.min(ply:GetMaxHealth(), ply:Health() + healed)

			 if self:GetTrapped() then
				ply:SetHealth(new)
				hook.Run("TTTPlayerUsedHealthStation", ply, self, healed)
			 end

			 if last_sound_time + 2 < CurTime() then
				self:EmitSound(healsound)
				last_sound_time = CurTime()
			 end

			 if not table.HasValue(self.fingerprints, ply) then
				table.insert(self.fingerprints, ply)
			 end

			 return true
		  else
			 self:EmitSound(failsound)
		  end
	   else
		  self:EmitSound(failsound)
	   end
   else
		if not self.DidBoom then
			self.DidBoom = true
			self:Boom()
		end
   end

   return false
end

function ENT:Use(ply)
   if IsValid(ply) and ply:IsPlayer() and ply:IsActive() then
      local t = CurTime()
      if t > self.NextHeal then
         local healed = self:GiveHealth(ply, self.HealRate)

         self.NextHeal = t + (self.HealFreq * (healed and 1 or 2))
      end
   end
end

-- traditional equipment destruction effects
function ENT:OnTakeDamage(dmginfo)
   if dmginfo:GetAttacker() == self:GetPlacer() then return end

   self:TakePhysicsDamage(dmginfo)

   self:SetHealth(self:Health() - dmginfo:GetDamage())

   local att = dmginfo:GetAttacker()
   if IsPlayer(att) then
      DamageLog(Format("%s damaged death station for %d dmg",
                       att:Nick(), dmginfo:GetDamage()))
   end

   if self:Health() < 0 then
      self:Remove()

      util.EquipmentDestroyed(self:GetPos())

      if IsValid(self:GetPlacer()) then
         LANG.Msg(self:GetPlacer(), "hstation_broken")
      end
   end
end

if SERVER then
	-- recharge
	local nextcharge = 0
	function ENT:Think()
		if nextcharge < CurTime() then
			self:AddToStorage(self.RechargeRate)

			nextcharge = CurTime() + self.RechargeFreq
		end
	end

	-- trap existing health stations (but only one)
	function ENT:Touch(other)
		if (not self:GetTrapped()) and other.IsHealthStation then
			self:SetTrapped(true)
			SafeRemoveEntity(other)

			-- save cpu
			self.Touch = nil
		end
	end
end