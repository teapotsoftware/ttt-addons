AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "Burst AR"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 60

   SWEP.Icon               = "vgui/ttt/icon_famas"
   SWEP.IconLetter         = "w"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_HEAVY

SWEP.Primary.Delay         = TTT_M16_DELAY
SWEP.Primary.Recoil        = TTT_M16_RECOIL * 0.8
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = TTT_AMMOTYPE_PISTOL
SWEP.Primary.Damage        = TTT_M16_DAMAGE
SWEP.Primary.Cone          = TTT_M16_CONE * 1.5
SWEP.Primary.ClipSize      = 18
SWEP.Primary.ClipMax       = TTT_M16_CLIPMAX
SWEP.Primary.DefaultClip   = 18
SWEP.Primary.Sound         = Sound("Weapon_Famas.Single")

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = TTT_AMMOENT_PISTOL

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel            = "models/weapons/w_rif_famas.mdl"

SWEP.IronSightsPos         = Vector( -6.2, -5, 0.75 )
SWEP.IronSightsAng         = Vector( 2, 0, 0.5 )

function SWEP:PrimaryAttack(worldsnd)
	local delay = 0.07
	if self:Clip1() % 3 == 1 then
		delay = 0.55
	end

   self:SetNextSecondaryFire( CurTime() + delay )
   self:SetNextPrimaryFire( CurTime() + delay )

   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )

   self:TakePrimaryAmmo( 1 )

   local owner = self:GetOwner()
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )
end
