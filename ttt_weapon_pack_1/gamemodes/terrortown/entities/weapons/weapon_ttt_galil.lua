AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "Galil AR"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 60

   SWEP.Icon               = "vgui/ttt/icon_galil"
   SWEP.IconLetter         = "w"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_HEAVY

SWEP.Primary.Delay         = TTT_M16_DELAY * 0.7
SWEP.Primary.Recoil        = TTT_M16_RECOIL * 1.2
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = TTT_AMMOTYPE_SMG
SWEP.Primary.Damage        = TTT_M16_DAMAGE * 0.75
SWEP.Primary.Cone          = TTT_M16_CONE * 1.5
SWEP.Primary.ClipSize      = TTT_MAC10_CLIPSIZE
SWEP.Primary.ClipMax       = TTT_MAC10_CLIPMAX
SWEP.Primary.DefaultClip   = TTT_MAC10_CLIPSIZE
SWEP.Primary.Sound         = Sound( "Weapon_Galil.Single" )

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = TTT_AMMOENT_SMG

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_rif_galil.mdl"
SWEP.WorldModel            = "models/weapons/w_rif_galil.mdl"

SWEP.IronSightsPos         = Vector( -6.35, -5, 0.75 )
SWEP.IronSightsAng         = Vector( 3, 0, 0.5 )
