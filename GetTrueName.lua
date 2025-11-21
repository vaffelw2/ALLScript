

API = {}

function API.getName(tag)
	local weapon = tag
	if tag then
		if tag == "Glock" then
			weapon = "Glock-17"
		elseif tag == "P2000" then
			weapon = "PX4"
        elseif tag == "MAG7" then
			weapon = "MAG-7"
		elseif tag == "C4" then
			weapon = "C4"
        elseif tag == "Negev" then
			weapon = "MG42"
        elseif tag == "P90" then
			weapon = "P90"
        elseif tag == "P250" then
			weapon = "P250" 
        elseif tag == "SawedOff" then
			weapon = "Sawed Off"
        elseif tag == "SCAR-20" then
			weapon = "SCAR-20"
        elseif tag == "Scout" then
			weapon = "Scout"
        elseif tag == "Tec9" then
			weapon = "TEC-9"
        elseif tag == "UMP" then
			weapon = "UMP-45"
        elseif tag == "XM" then
			weapon = "XM1014"
        elseif tag == "Golden Knife" then
			weapon = "GOLDEN KNIFE"
        elseif tag == "T Knife" then
			weapon = "T Knife"
		elseif tag == "CT Knife" then
			weapon = "CT Knife"
		elseif tag == "AUG" then
			weapon = "AUG A3"
		elseif tag == "SG" then
			weapon = "SG 553"
        elseif tag == "MAC10" then
			weapon = "MAC-10"
        elseif tag == "M4A4" then
			weapon = "M4A4"
        elseif tag == "FiveSeven" then
			weapon = "Five-seveN"
        elseif tag == "Famas" then
			weapon = "FAMAS F1"
        elseif tag == "DualBerettas" then
			weapon = "Dual Berettas"
        elseif tag == "CZ" then
			weapon = "CZ75-Auto"
        elseif tag == "DesertEagle" then
			weapon = "Deagle"
        elseif tag == "AWP" then
			weapon = "AWP"
        elseif tag == "AK47" then
			weapon = "AK-47"
        elseif tag == "HE Grenade" then
			weapon = "HE Grenade"
        elseif tag == "Nova" then
			weapon = "Nova"
        elseif tag == "Galil" then
			weapon = "Galil SAR"
        elseif tag == "M249" then
			weapon = "M249"
        elseif tag == "M4A1" then
			weapon = "M4A1-S"
		elseif tag == "R8" then
			weapon = "44 Magnum"
        elseif tag == "MP7" then
			weapon = "MP5"
        elseif tag == "MP9" then
			weapon = "MP9"
        elseif tag == "G3SG1" then
			weapon = "G3SG1"
        elseif tag == "Bizon" then
			weapon = "Thompson"
        elseif tag == "USP" then
			weapon = "USP-S"
		elseif tag == "Kevlar Vest" then
			weapon = "Kevlar Vest"
		elseif tag == "Zeus" then
			weapon = "Zeus"
		elseif tag == "Defuse Kit" then
			weapon = "Defuse Kit"
		elseif tag == "Kevlar + Helmet" then
			weapon = "Kevlar + Helmet"
		else
			weapon = tag
		end
		return weapon
	end
	return nil
end



return API







