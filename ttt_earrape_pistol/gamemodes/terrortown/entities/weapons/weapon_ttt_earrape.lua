AddCSLuaFile()

SWEP.HoldType              = "pistol"

local earrapesounds = {
	Sound("earrape/earrape_gun_01.mp3"),
	Sound("earrape/earrape_gun_02.mp3"),
	Sound("earrape/earrape_gun_03.mp3"),
	Sound("earrape/earrape_gun_04.mp3"),
	Sound("earrape/earrape_gun_05.mp3"),
	Sound("earrape/earrape_gun_06.mp3"),
	Sound("earrape/earrape_gun_07.mp3"),
	Sound("earrape/earrape_gun_08.mp3"),
	Sound("earrape/earrape_gun_09.mp3"),
	Sound("earrape/earrape_gun_10.mp3"),
	Sound("earrape/earrape_gun_11.mp3"),
	Sound("earrape/earrape_gun_12.mp3"),
	Sound("earrape/earrape_gun_13.mp3"),
	Sound("earrape/earrape_gun_14.mp3"),
	Sound("earrape/earrape_gun_15.mp3"),
	Sound("earrape/earrape_gun_16.mp3"),
	Sound("earrape/earrape_gun_17.mp3"),
	Sound("earrape/earrape_gun_18.mp3")
}

if SERVER then
	for _, v in ipairs(earrapesounds) do
		resource.AddFile("sound/" .. v)
	end
	resource.AddFile("materials/vgui/ttt/icon_ear.vtf")

	hook.Add("EntityFireBullets", "TTT.EarrapeGun", function(ent, data)
		if not IsValid(ent) or not ent:IsPlayer() then return end
		local wep = ent:GetActiveWeapon()
		if not IsValid(wep) or not wep.EarRape then return end
		data.Callback = function(atk, tr, dmg)
			sound.Play(earrapesounds[math.random(#earrapesounds)], tr.HitPos)
		end
		return true	
	end)
else
	SWEP.PrintName          = "Ear Destroyer 9000"
	SWEP.Slot               = 6

	SWEP.ViewModelFlip      = false
	SWEP.ViewModelFOV       = 54

	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "Shoot at someone to distorient them\nwith extremely loud music."
	};

	SWEP.Icon               = "vgui/ttt/icon_ear"
	SWEP.IconLetter         = "a"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Primary.Recoil        = 0
SWEP.Primary.Damage        = 10
SWEP.Primary.Delay         = 2
SWEP.Primary.Cone          = 0
SWEP.Primary.ClipSize      = 6
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 6
SWEP.Primary.ClipMax       = 6
SWEP.Primary.Ammo          = "None"
SWEP.Primary.Sound         = Sound("Weapon_USP.SilencedShot")
SWEP.Primary.SoundLevel    = 50

SWEP.Kind                  = WEAPON_EQUIP
SWEP.CanBuy                = {ROLE_TRAITOR} -- only traitors can buy

SWEP.AmmoEnt               = nil
SWEP.IsSilent              = true

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_usp_silencer.mdl"

SWEP.IronSightsPos         = Vector(-5.91, -4, 2.84)
SWEP.IronSightsAng         = Vector(-0.5, 0, 0)

SWEP.PrimaryAnim           = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim            = ACT_VM_RELOAD_SILENCED

SWEP.NoSights = true

SWEP.EarRape = true

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
	return self.BaseClass.Deploy(self)
end
