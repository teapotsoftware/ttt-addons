AddCSLuaFile()

SWEP.HoldType            = "ar2"

if CLIENT then
   SWEP.PrintName        = "MP5 Navy"
   SWEP.Slot             = 2

   SWEP.ViewModelFlip    = false
   SWEP.ViewModelFOV     = 54

   SWEP.Icon             = "vgui/ttt/icon_mp5"
   SWEP.IconLetter       = "l"
end

SWEP.Base                = "weapon_tttbase"

SWEP.Kind                = WEAPON_HEAVY

SWEP.Primary.Damage      = TTT_MAC10_DAMAGE * 1.25
SWEP.Primary.Delay       = TTT_MAC10_DELAY * 1.2
SWEP.Primary.Cone        = TTT_MAC10_CONE
SWEP.Primary.ClipSize    = TTT_MAC10_CLIPSIZE
SWEP.Primary.ClipMax     = TTT_MAC10_CLIPMAX
SWEP.Primary.DefaultClip = TTT_MAC10_CLIPSIZE
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = TTT_AMMOTYPE_SMG
SWEP.Primary.Recoil      = TTT_MAC10_RECOIL
SWEP.Primary.Sound       = Sound( "Weapon_mp5navy.Single" )

SWEP.AutoSpawnable       = true
SWEP.AmmoEnt             = TTT_AMMOENT_SMG

SWEP.UseHands            = true
SWEP.ViewModel           = "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel          = "models/weapons/w_smg_mp5.mdl"

SWEP.IronSightsPos       = Vector( -5.25, -3, 1.5 )
SWEP.IronSightsAng       = Vector( 2, 0, 0 )
