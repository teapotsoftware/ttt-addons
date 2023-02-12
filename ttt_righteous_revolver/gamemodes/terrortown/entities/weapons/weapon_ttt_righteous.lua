AddCSLuaFile()

SWEP.HoldType = "pistol"

if SERVER then
	resource.AddFile("materials/vgui/ttt/icon_357.vtf")
else
	SWEP.PrintName          = "Righteous Revolver"
	SWEP.Slot               = 6

	SWEP.ViewModelFlip      = false
	SWEP.ViewModelFOV       = 54

	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = [[
Will instantly kill traitors, but will
kill you if you shoot an innocent.

Does the opposite if used by a traitor.
]]
	};

	SWEP.Icon               = "vgui/ttt/icon_357"
	SWEP.IconLetter         = "a"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Primary.Recoil        = 5
SWEP.Primary.Damage        = 10
SWEP.Primary.Delay         = 1
SWEP.Primary.Cone          = 0
SWEP.Primary.ClipSize      = 6
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 6
SWEP.Primary.ClipMax       = 6
SWEP.Primary.Ammo          = "None"
SWEP.Primary.Sound         = Sound("Weapon_357.Single")

SWEP.Kind                  = WEAPON_EQUIP
SWEP.CanBuy                = {ROLE_DETECTIVE}
SWEP.LimitedStock		   = true

SWEP.AmmoEnt               = nil

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/c_357.mdl"
SWEP.WorldModel            = "models/weapons/w_357.mdl"

SWEP.IronSightsPos         = Vector(-4.72, 0, 0.6)
SWEP.IronSightsAng         = Vector(0.1, -0.201, 0)

SWEP.NoSights = true

local GuiltSound = Sound("vo/npc/male01/ohno.wav")
local DeathSound = Sound("Flesh.Break")

function SWEP:PrimaryAttack(worldsnd)
   self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet(0, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone())

   self:TakePrimaryAmmo( 1 )

   local owner = self:GetOwner()
   if not IsValid(owner) or owner:IsNPC() then return end

	if owner.ViewPunch then
		owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )
	end

	if CLIENT then return end

	owner:LagCompensation(true)
	local tr = owner:GetEyeTrace()
	owner:LagCompensation(false)

	if IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity:IsTerror() and tr.Entity:Alive() then
		local myrole = owner:IsTraitor()
		local theirrole = tr.Entity:IsTraitor()
		local dmg = DamageInfo()
		dmg:SetDamage(1337)
		dmg:SetDamageType(DMG_BULLET)
		dmg:SetDamageForce(VectorRand(-1000, 1000))
		dmg:SetInflictor(self)
		dmg:SetAttacker(owner)
		if theirrole == myrole then
			owner:EmitSound(GuiltSound)
			timer.Simple(0.4, function()
				if not IsValid(owner) or not owner:Alive() then return end
				owner:TakeDamageInfo(dmg)
				owner:EmitSound("Weapon_357.Single")
				owner:EmitSound(DeathSound)
			end)
		else
			tr.Entity:TakeDamageInfo(dmg)
		end
	end
end

if CLIENT then
	local clr_grn = Color(0, 255, 0)
	local clr_red = Color(255, 0, 0)

	function SWEP:DrawHUD()
		local x = ScrW() * 0.5
		local y = ScrH() * 0.5

		local length = 10
		local gap = 7

		local ent = LocalPlayer():GetEyeTrace().Entity
		if IsValid(ent) and ent:IsPlayer() and ent:IsTerror() and ent:Alive() then
			if LocalPlayer():IsTraitor() then
				surface.SetDrawColor(255, 0, 0)
			else
				surface.SetDrawColor(0, 255, 0)
			end
			gap = 4
			length = 9
		else
			surface.SetDrawColor(255, 255, 255)
			gap = 7
			length = 12
		end

		surface.DrawLine(x - length, y, x - gap, y)
		surface.DrawLine(x + length, y, x + gap, y)
		surface.DrawLine(x, y - length, x, y - gap)
		surface.DrawLine(x, y + length, x, y + gap)

		if LocalPlayer():IsTraitor() then
			draw.SimpleText("Shoot INNOCENT: Instant kill", "TabLarge", x, ScrH() * 0.75 - 2, clr_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText("Shoot TRAITOR: Kill yourself", "TabLarge", x, ScrH() * 0.75 + 2, clr_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		else
			draw.SimpleText("Shoot TRAITOR: Instant kill", "TabLarge", x, ScrH() * 0.75 - 2, clr_grn, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText("Shoot INNOCENT: Kill yourself", "TabLarge", x, ScrH() * 0.75 + 2, clr_grn, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
	end
end
