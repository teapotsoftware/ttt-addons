AddCSLuaFile()

SWEP.HoldType            = "pistol"

if CLIENT then
   SWEP.PrintName        = "Kugelspucker SMG"
   SWEP.Slot             = 2

   SWEP.ViewModelFlip    = false
   SWEP.ViewModelFOV     = 54

   SWEP.Icon             = "vgui/ttt/icon_tmp"
   SWEP.IconLetter       = "l"
end

SWEP.Base                = "weapon_tttbase"

SWEP.Kind                = WEAPON_HEAVY

SWEP.Primary.NumShots	 = 2
SWEP.Primary.Damage      = TTT_MAC10_DAMAGE * 0.6
SWEP.Primary.Delay       = TTT_MAC10_DELAY * 0.5
SWEP.Primary.Cone        = TTT_MAC10_CONE * 2
SWEP.Primary.ClipSize    = TTT_M16_CLIPSIZE
SWEP.Primary.ClipMax     = TTT_M16_CLIPMAX
SWEP.Primary.DefaultClip = TTT_M16_CLIPSIZE
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = TTT_AMMOTYPE_PISTOL
SWEP.Primary.Recoil      = TTT_M16_RECOIL
SWEP.Primary.Sound       = Sound("Weapon_Pistol.Single")

SWEP.AutoSpawnable       = true
SWEP.AmmoEnt             = TTT_AMMOENT_PISTOL

SWEP.UseHands            = true
SWEP.ViewModel           = "models/weapons/cstrike/c_smg_tmp.mdl"
SWEP.WorldModel          = "models/weapons/w_smg_tmp.mdl"

SWEP.IronSightsPos       = Vector(-3, -5, 0)
SWEP.IronSightsAng       = Vector(2, 0, 0)
