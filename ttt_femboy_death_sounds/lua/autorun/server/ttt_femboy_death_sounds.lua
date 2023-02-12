
local deathsounds = {
	Sound("nickb/femboy/femboy_death_01.wav"),
	Sound("nickb/femboy/femboy_death_02.wav"),
	Sound("nickb/femboy/femboy_death_03.wav"),
	Sound("nickb/femboy/femboy_death_04.wav"),
	Sound("nickb/femboy/femboy_death_05.wav"),
	Sound("nickb/femboy/femboy_death_06.wav"),
	Sound("nickb/femboy/femboy_death_07.wav"),
	Sound("nickb/femboy/femboy_death_08.wav"),
	Sound("nickb/femboy/femboy_death_09.wav"),
	Sound("nickb/femboy/femboy_death_10.wav"),
	Sound("nickb/femboy/femboy_death_11.wav"),
	Sound("nickb/femboy/femboy_death_12.wav"),
	Sound("nickb/femboy/femboy_death_13.wav"),
	Sound("nickb/femboy/femboy_death_14.wav"),
	Sound("nickb/femboy/femboy_death_15.wav"),
	Sound("nickb/femboy/femboy_death_16.wav"),
	Sound("nickb/femboy/femboy_death_17.wav"),
	Sound("nickb/femboy/femboy_death_18.wav")
}

for _, v in ipairs(deathsounds) do
	resource.AddFile("sound/" .. v)
end

hook.Add("PostGamemodeLoaded", "FemboyDeathSounds.PostGamemodeLoaded", function()
	-- bare-bones ttt gamemode check
	if GetRoundState == nil or DamageLog == nil or util.StartBleeding == nil then return end

	local function PlayDeathSound(victim)
		if not IsValid(victim) then return end

		sound.Play(table.Random(deathsounds), victim:GetShootPos(), 90, 100)
	end

	local function CreateDeathEffect(ent, marked)
		local pos = ent:GetPos() + Vector(0, 0, 20)

		local jit = 35.0

		local jitter = Vector(math.Rand(-jit, jit), math.Rand(-jit, jit), 0)
		util.PaintDown(pos + jitter, "Blood", ent)

		if marked then
			util.PaintDown(pos, "Cross", ent)
		end
	end

	-- See if we should award credits now
	local function CheckCreditAward(victim, attacker)
		if GetRoundState() != ROUND_ACTIVE then return end
		if not IsValid(victim) then return end

		-- DETECTIVE AWARD
		if IsValid(attacker) and attacker:IsPlayer() and attacker:IsActiveDetective() and victim:IsTraitor() then
			local amt = GetConVarNumber("ttt_det_credits_traitordead") or 1
			for _, ply in ipairs(player.GetAll()) do
				if ply:IsActiveDetective() then
					ply:AddCredits(amt)
				end
			end

			LANG.Msg(GetDetectiveFilter(true), "credit_det_all", {num = amt})
		end


		-- TRAITOR AWARD
		if (not victim:IsTraitor()) and (not GAMEMODE.AwardedCredits or GetConVar("ttt_credits_award_repeat"):GetBool()) then
			local inno_alive = 0
			local inno_dead = 0
			local inno_total = 0

			for _, ply in ipairs(player.GetAll()) do
				if not ply:GetTraitor() then
					if ply:IsTerror() then
						inno_alive = inno_alive + 1
					elseif ply:IsDeadTerror() then
						inno_dead = inno_dead + 1
					end
				end
			end

			-- we check this at the death of an innocent who is still technically
			-- Alive(), so add one to dead count and sub one from living
			inno_dead = inno_dead + 1
			inno_alive = math.max(inno_alive - 1, 0)
			inno_total = inno_dead + inno_alive

			-- Only repeat-award if we have reached the pct again since last time
			if GAMEMODE.AwardedCredits then
				inno_dead = inno_dead - GAMEMODE.AwardedCreditsDead
			end

			local pct = inno_dead / inno_total
			if pct >= GetConVarNumber("ttt_credits_award_pct") then
				-- Traitors have killed sufficient people to get an award
				local amt = GetConVarNumber("ttt_credits_award_size")

				-- If size is 0, awards are off
				if amt > 0 then
					LANG.Msg(GetTraitorFilter(true), "credit_tr_all", {num = amt})

					for _, ply in ipairs(player.GetAll()) do
						if ply:IsActiveTraitor() then
							ply:AddCredits(amt)
						end
					end
				end

				GAMEMODE.AwardedCredits = true
				GAMEMODE.AwardedCreditsDead = inno_dead + GAMEMODE.AwardedCreditsDead
			end
		end
	end

	function GAMEMODE:DoPlayerDeath(ply, attacker, dmginfo)
		if ply:IsSpec() then return end

		-- Experimental: Fire a last shot if ironsighting and not headshot
		if GetConVar("ttt_dyingshot"):GetBool() then
			local wep = ply:GetActiveWeapon()
			if IsValid(wep) and wep.DyingShot and not ply.was_headshot and dmginfo:IsBulletDamage() then
				local fired = wep:DyingShot()
				if fired then
					return
				end
			end

			-- Note that funny things can happen here because we fire a gun while the
			-- player is dead. Specifically, this DoPlayerDeath is run twice for
			-- him. This is ugly, and we have to return the first one to prevent crazy
			-- shit.
		end

		-- Drop all weapons
		for k, wep in ipairs(ply:GetWeapons()) do
			WEPS.DropNotifiedWeapon(ply, wep, true) -- with ammo in them
			wep:DampenDrop()
		end

		if IsValid(ply.hat) then
			ply.hat:Drop()
		end

		-- Create ragdoll and hook up marking effects
		local rag = CORPSE.Create(ply, attacker, dmginfo)
		ply.server_ragdoll = rag -- nil if clientside

		CreateDeathEffect(ply, false)

		util.StartBleeding(rag, dmginfo:GetDamage(), 15)

		-- Score only when there is a round active.
		if GetRoundState() == ROUND_ACTIVE then
			SCORE:HandleKill(ply, attacker, dmginfo)

			if IsValid(attacker) and attacker:IsPlayer() then
				attacker:RecordKill(ply)

				DamageLog(Format("KILL:\t %s [%s] killed %s [%s]", attacker:Nick(), attacker:GetRoleString(), ply:Nick(), ply:GetRoleString()))
			else
				DamageLog(Format("KILL:\t <something/world> killed %s [%s]", ply:Nick(), ply:GetRoleString()))
			end


			KARMA.Killed(attacker, ply, dmginfo)
		end

		-- Clear out any weapon or equipment we still have
		ply:StripAll()

		-- Tell the client to send their chat contents
		ply:SendLastWords(dmginfo)

		local killwep = util.WeaponFromDamage(dmginfo)

		-- headshots, knife damage, and weapons tagged as silent all prevent death
		-- sound from occurring
		if not (ply.was_headshot or
				  dmginfo:IsDamageType(DMG_SLASH) or
				  (IsValid(killwep) and killwep.IsSilent)) then
			PlayDeathSound(ply)
		end

		--- Credits
		CheckCreditAward(ply, attacker)

		-- Check for T killing D or vice versa
		if IsValid(attacker) and attacker:IsPlayer() then
			local reward = 0
			if attacker:IsActiveTraitor() and ply:GetDetective() then
				reward = math.ceil(GetConVarNumber("ttt_credits_detectivekill"))
			elseif attacker:IsActiveDetective() and ply:GetTraitor() then
				reward = math.ceil(GetConVarNumber("ttt_det_credits_traitorkill"))
			end

			if reward > 0 then
				attacker:AddCredits(reward)

				LANG.Msg(attacker, "credit_kill", {num = reward, role = LANG.NameParam(ply:GetRoleString())})
			end
		end
	end
end)
