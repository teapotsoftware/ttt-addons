AddCSLuaFile()

SWEP.HoldType            = "ar2"

if CLIENT then
   SWEP.PrintName        = "P90"
   SWEP.Slot             = 2

   SWEP.ViewModelFlip    = false
   SWEP.ViewModelFOV     = 57

   SWEP.Icon             = "vgui/ttt/icon_p90"
   SWEP.IconLetter       = "l"
end

SWEP.Base                = "weapon_tttbase"

SWEP.Kind                = WEAPON_HEAVY

SWEP.Primary.Damage      = TTT_MAC10_DAMAGE
SWEP.Primary.Delay       = TTT_MAC10_DELAY
SWEP.Primary.Cone        = TTT_MAC10_CONE * 1.6
SWEP.Primary.ClipSize    = TTT_MAC10_CLIPSIZE * 2
SWEP.Primary.ClipMax     = TTT_MAC10_CLIPMAX * 2
SWEP.Primary.DefaultClip = TTT_MAC10_CLIPSIZE * 2
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = TTT_AMMOTYPE_SMG
SWEP.Primary.Recoil      = TTT_HUGE_RECOIL
SWEP.Primary.Sound       = Sound( "Weapon_P90.Single" )

SWEP.AutoSpawnable       = true
SWEP.AmmoEnt             = TTT_AMMOENT_SMG

SWEP.UseHands            = true
SWEP.ViewModel           = "models/weapons/cstrike/c_smg_p90.mdl"
SWEP.WorldModel          = "models/weapons/w_smg_p90.mdl"

SWEP.IronSightsPos       = Vector( -3, 0, 2 )
SWEP.IronSightsAng       = Vector( 0, 0, 0 )
