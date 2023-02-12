AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "KleinLabs Blaster"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/icon_sg552"
   SWEP.IconLetter         = "n"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_HEAVY

SWEP.Primary.Delay         = 0.25
SWEP.Primary.Recoil        = 1.8
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.NumShots	   = 3
SWEP.Primary.Damage        = 10
SWEP.Primary.Cone          = 0.018
SWEP.Primary.ClipSize      = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.Sound         = Sound("Weapon_SG552.Single")

SWEP.Secondary.Sound       = Sound("Default.Zoom")

SWEP.HeadshotMultiplier    = 2

SWEP.AutoSpawnable         = false
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = Model("models/weapons/cstrike/c_rif_sg552.mdl")
SWEP.WorldModel            = Model("models/weapons/w_rif_sg552.mdl")

SWEP.IronSightsPos         = Vector(-7.5, -5, -2.3)
SWEP.IronSightsAng         = Vector(0, 0, 0)

function SWEP:SetZoom(state)
   if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
      if state then
         self:GetOwner():SetFOV(20, 0.3)
      else
         self:GetOwner():SetFOV(0, 0.2)
      end
   end
end

function SWEP:PrimaryAttack( worldsnd )
   self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )
   self:SetNextSecondaryFire( CurTime() + 0.1 )
	if self:GetIronsights() then
		self:SetNextPrimaryFire(CurTime() + 0.35)
	else
		self:SetNextPrimaryFire(CurTime() + 0.25)
	end
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self:GetNextSecondaryFire() > CurTime() then return end

   local bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )

   self:SetZoom(bIronsights)
   if (CLIENT) then
      self:EmitSound(self.Secondary.Sound)
   end

   self:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   self:DefaultReload( ACT_VM_RELOAD )
   self:SetIronsights( false )
   self:SetZoom( false )
end


function SWEP:Holster()
   self:SetIronsights(false)
   self:SetZoom(false)
   return true
end

local function ModifiedSparklies(attacker, tr, dmginfo)
   if tr.HitWorld then
      local eff = EffectData()
      eff:SetOrigin(tr.HitPos)
      eff:SetNormal(tr.HitNormal)
      util.Effect("cball_bounce", eff)
   end
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )
   self:SendWeaponAnim(self.PrimaryAnim)

   self:GetOwner():MuzzleFlash()
   self:GetOwner():SetAnimation( PLAYER_ATTACK1 )

   local sights = self:GetIronsights()

   numbul = numbul or 1
   cone   = cone   or 0.01

   local bullet = {}
   bullet.Num    = numbul
   bullet.Src    = self:GetOwner():GetShootPos()
   bullet.Dir    = self:GetOwner():GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 1
   bullet.TracerName = "AirboatGunHeavyTracer"
   bullet.Force  = 10
   bullet.Damage = dmg
   if CLIENT then
      bullet.Callback = ModifiedSparklies
   end

   self:GetOwner():FireBullets( bullet )

   -- Owner can die after firebullets
   if (not IsValid(self:GetOwner())) or (not self:GetOwner():Alive()) or self:GetOwner():IsNPC() then return end

   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.6) or recoil

      local eyeang = self:GetOwner():EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self:GetOwner():SetEyeAngles( eyeang )
   end
end

if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local scrW = ScrW()
         local scrH = ScrH()

         local x = scrW / 2.0
         local y = scrH / 2.0
         local scope_size = scrH

         -- crosshair
         local gap = 80
         local length = scope_size
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )

         gap = 0
         length = 50
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )


         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)
         
         -- cover gaps on top and bottom of screen
         surface.DrawLine( 0, 0, scrW, 0 )
         surface.DrawLine( 0, scrH - 1, scrW, scrH - 1 )

         surface.SetDrawColor(255, 0, 0, 255)
         surface.DrawLine(x, y, x + 1, y + 1)

         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)

         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
      else
         return self.BaseClass.DrawHUD(self)
      end
   end

   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end
