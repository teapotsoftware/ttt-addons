AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "KleinLabs Sidearm"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/icon_pistol"
   SWEP.IconLetter         = "u"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_PISTOL

SWEP.Primary.Recoil        = 1.5
SWEP.Primary.Damage        = 25
SWEP.Primary.Delay         = 0.38
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 20
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Sound         = Sound( "Weapon_Pistol.Single" )

SWEP.AutoSpawnable         = false
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/c_pistol.mdl"
SWEP.WorldModel            = "models/weapons/w_pistol.mdl"

SWEP.IronSightsPos         = Vector(-6, 0, 2.88)
SWEP.IronSightsAng         = Vector(0.5, -1.201, 0)