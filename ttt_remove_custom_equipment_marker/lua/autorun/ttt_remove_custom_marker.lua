
-- remove the little yellow c
hook.Add("PostGamemodeLoaded", "TTT.RemoveCustomEquipmentIcon", function()
	if DefaultEquipment == nil then return end

	for k, v in pairs(weapons.GetList()) do
		local canBuy = v.CanBuy
		local class = v.ClassName
		if istable(canBuy) and table.HasValue(canBuy, ROLE_TRAITOR) then
			table.insert(DefaultEquipment[ROLE_TRAITOR], class)
		end
		if istable(canBuy) and table.HasValue(canBuy, ROLE_DETECTIVE) then
			table.insert(DefaultEquipment[ROLE_DETECTIVE], class)
		end
		table.insert(DefaultEquipment[ROLE_NONE], class)
	end
end)
