AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "SCRT-16"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 64

   SWEP.Icon               = "vgui/ttt/icon_m16"
   SWEP.IconLetter         = "w"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_HEAVY

SWEP.Primary.Delay         = 0.19
SWEP.Primary.Recoil        = 1.6
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Damage        = 23
SWEP.Primary.Cone          = 0.018
SWEP.Primary.ClipSize      = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.Sound         = Sound( "Weapon_M4A1.Silenced" )

SWEP.AmmoEnt               = "item_ammo_pistol_ttt"
SWEP.IsSilent              = true

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel            = "models/weapons/w_rif_m4a1_silencer.mdl"

SWEP.IronSightsPos         = Vector(-8, -9.2, 0.55)
SWEP.IronSightsAng         = Vector(0, -3.4, -3.6)

SWEP.PrimaryAnim           = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim            = ACT_VM_RELOAD_SILENCED

function SWEP:Deploy()
   self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
   return self.BaseClass.Deploy(self)
end
