

API = {}

function API.getWeaponOfKiller(tag)


local weapon = "rbxassetid://430080758"

	if tag then
		if tag then
		if tag == "Glock" then
		weapon = "rbxassetid://1784884358"
		elseif tag == "P2000" then
		weapon = "rbxassetid://1784890670"
        elseif tag == "MAG7" then
		weapon = "rbxassetid://1784886738"
		elseif tag == "C4" then
		weapon = "rbxassetid://960099089"
        elseif tag == "Negev" then
		weapon = "rbxassetid://1784889308"
        elseif tag == "P90" then
		weapon = "rbxassetid://1784889951"
        elseif tag == "P250" then
		weapon = "rbxassetid://1784890224" 
        elseif tag == "SawedOff" then
		weapon = "rbxassetid://1784891342"
        elseif tag == "SCAR-20" then
		weapon = "rbxassetid://464915678"
        elseif tag == "Scout" then
		weapon = "rbxassetid://1784891607"
        elseif tag == "Tec9" then
		weapon = "rbxassetid://1784892286"
        elseif tag == "UMP" then
		weapon = "rbxassetid://1784893326"
        elseif tag == "XM" then
		weapon = "rbxassetid://1784894646"
        elseif tag == "Golden Knife" then
		weapon = "rbxassetid://1784892698"
        elseif tag == "T Knife" then
		weapon = "rbxassetid://1784892698"
		elseif tag == "CT Knife" then
		weapon = "rbxassetid://1784880969"
		elseif tag == "AUG" then
		weapon = "rbxassetid://1784880429"
		elseif tag == "SG" then
		weapon = "rbxassetid://1784892019"
        elseif tag == "MAC10" then
		weapon = "rbxassetid://1784886467"
        elseif tag == "M4A4" then
		weapon = "rbxassetid://1784885559"
        elseif tag == "FiveSeven" then
		weapon = "rbxassetid://1784883536"
        elseif tag == "Famas" then
		weapon = "rbxassetid://1784883269"
        elseif tag == "DualBerettas" then
		weapon = "rbxassetid://464915621"
        elseif tag == "CZ" then
		weapon = "rbxassetid://1784881184"
        elseif tag == "DesertEagle" then
		weapon = "rbxassetid://1784882993"
        elseif tag == "AWP" then
		weapon = "rbxassetid://1784880647"
        elseif tag == "AK47" then
		weapon = "rbxassetid://1784880132"
        elseif tag == "HE Grenade" then
		weapon = "rbxassetid://469548318"
        elseif tag == "Nova" then
		weapon = "rbxassetid://1784889624"
        elseif tag == "Galil" then
		weapon = "rbxassetid://1784884618"
        elseif tag == "M249" then
		weapon = "rbxassetid://1784886231"
        elseif tag == "M4A1" then
		weapon = "rbxassetid://1784885275"
		elseif tag == "R8" then
		weapon = "rbxassetid://1784891026"
        elseif tag == "MP7" then
		weapon = "rbxassetid://1784887021"
        elseif tag == "MP9" then
		weapon = "rbxassetid://1784888791"
        elseif tag == "G3SG1" then
		weapon = "rbxassetid://1784883884"
        elseif tag == "Bizon" then
		weapon = "rbxassetid://1784892936"
        elseif tag == "USP" then
		weapon = "rbxassetid://1784893598"
		elseif tag == "Kevlar Vest" then
		weapon = "rbxassetid://966822751"
		elseif tag == "Zeus" then
		weapon = "rbxassetid://1784893598"
		elseif tag == "Defuse Kit" then
		weapon = "rbxassetid://966822523"
		elseif tag == "Kevlar + Helmet" then
		weapon = "rbxassetid://966822842"
		end
		return weapon
		end
	end
	return nil
end

function API.getWeaponFromID(id)
	local cash = 0
	if id then -- In order, pistol, knife, smg, p90, shotgun, awp, the rest
		if id then 
		if id == "rbxassetid://1784884358" or id == "rbxassetid://1784893598" or id == "rbxassetid://1784890670" or id == "rbxassetid://1784890224" or id ==  "rbxassetid://1784892286" or id == "rbxassetid://1784883536" or id == "rbxassetid://1784882993" or id == "rbxassetid://1784881184" or id == "rbxassetid://464915621" then -- Pistol
		cash = 150
		elseif id == "rbxassetid://1784892698" or id == "rbxassetid://1784880969" then -- Knife
		cash = 750
		elseif id ==  "rbxassetid://1784892936" or id == "rbxassetid://1784888791" or id == "rbxassetid://1784887021" or id == "rbxassetid://1784886467" or id == "rbxassetid://1784893326" then -- SMG
		cash = 300 
		elseif id == "rbxassetid://1784889951" then -- P90
		cash = 150
		elseif id == "rbxassetid://1784894646" or id == "rbxassetid://1784889624" or id == "rbxassetid://1784891342" or id == "rbxassetid://1784886738" then -- shotgun
		cash = 450 
		elseif id == "rbxassetid://1784880647" then -- awp
		cash = 50
		else
		cash = 150
		end
		return cash
		end
	end
	return nil
end


return API







