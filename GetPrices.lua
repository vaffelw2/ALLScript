

API = {}

function API.getprice(tag)


local weapon = "rbxassetid://430080758"

	if tag then
		if tag then
		if tag == "Glock" then
		weapon = 200
		elseif tag == "P2000" then
		weapon = 200
        elseif tag == "MAG7" then
		weapon = 1300
        elseif tag == "Negev" then
		weapon = 2000
        elseif tag == "P90" then
		weapon = 2350
        elseif tag == "P250" then
		weapon = 300
        elseif tag == "SawedOff" then
		weapon = 1100
        elseif tag == "SCAR-20" then
		weapon = 5000
        elseif tag == "Scout" then
		weapon = 1700
        elseif tag == "Tec9" then
		weapon = 500
        elseif tag == "UMP" then
		weapon = 1200
        elseif tag == "XM" then
		weapon = 2000
        elseif tag == "Golden Knife" then
		weapon = 696969
        elseif tag == "T Knife" then
		weapon = 0
		elseif tag == "CT Knife" then
		weapon = 0
		elseif tag == "AUG" then
		weapon = 3300
		elseif tag == "SG" then
		weapon = 3000
        elseif tag == "MAC10" then
		weapon = 1050
        elseif tag == "M4A4" then
		weapon = 3100
        elseif tag == "FiveSeven" then
		weapon = 500
        elseif tag == "Famas" then
		weapon = 2250
        elseif tag == "DualBerettas" then
		weapon = 300
		elseif tag == "Beretta" then
		weapon = 250
        elseif tag == "CZ" then
		weapon = 500
        elseif tag == "DesertEagle" then
		weapon = 700
		elseif tag == "R8" then
		weapon = 700
        elseif tag == "AWP" then
		weapon = 5250
        elseif tag == "AK47" then
		weapon = 2700
        elseif tag == "HE Grenade" then
		weapon = 300
        elseif tag == "Nova" then
		weapon = 1050
        elseif tag == "Galil" then
		weapon = 1800
        elseif tag == "M249" then
		weapon = 5200
        elseif tag == "M4A1" then
		weapon = 2900
        elseif tag == "MP7" then
		weapon = 1500
        elseif tag == "MP9" then
		weapon = 1250
        elseif tag == "G3SG1" then
		weapon = 5000
        elseif tag == "Bizon" then
		weapon = 1400
        elseif tag == "USP" then
		weapon = 200
        elseif tag == "Kevlar + Helmet" then
		weapon = 1000
        elseif tag == "Kevlar Vest" then
		weapon = 650
        elseif tag == "Defuse Kit" then
		weapon = 400
        elseif tag == "Zeus" then
		weapon = 200
		elseif tag == "Smoke Grenade" then
			weapon = 300
		elseif tag == "HE Grenade" then
			weapon = 300
		elseif tag == "Flashbang" then
			weapon = 200
		elseif tag == "Molotov" then
			weapon = 400
		elseif tag == "Incendiary Grenade" then
			weapon = 600
		elseif tag == "Decoy Grenade" then
			weapon = 50
		end
		return weapon
		end
	end
	return nil
end

function API.getstats(tag)
	local weapon = {"rbxassetid://430080758",10,10,10,10,"30/90","N/A","U.S.A."}
	--damage
	--fire rate
	--accuracy
	--recoil
	if tag then
		if tag then
		if tag == "Glock" then
		weapon = {"http://www.roblox.com/asset/?id=1760450961",5,10,10,20,"20/80","3x Burst","Austria"}
		elseif tag == "P2000" then
		weapon = {"http://www.roblox.com/asset/?id=1760450233",10,10,15,15,"13/52","N/A","Italy"}
        elseif tag == "MAG7" then
		weapon = {"http://www.roblox.com/asset/?id=1760461555",7,3,5,4,"5/20","N/A","South Africa"}
        elseif tag == "Negev" then
		weapon = {"http://www.roblox.com/asset/?id=1760462131",4,9,3,2,"150/200","Suppressive Fire","Germany"}
        elseif tag == "P90" then
		weapon = {"http://www.roblox.com/asset/?id=929105150",5,20,5,15,"50/100","N/A","Belgium"}
        elseif tag == "P250" then
		weapon = {"http://www.roblox.com/asset/?id=1760451751",13,10,8,18,"13/52","N/A","United States"}
        elseif tag == "SawedOff" then
		weapon = {"http://www.roblox.com/asset/?id=929142170",8,3,1,4,"13/52","N/A","United States"}
        elseif tag == "SCAR-20" then
		weapon = {"http://www.roblox.com/asset/?id=929142806",6,4,9,3,"13/52","N/A","Belgium"}
        elseif tag == "Scout" then
		weapon = {"http://www.roblox.com/asset/?id=929142913",15,8,20,15,"10/30","2x Zoom","Austria"}
        elseif tag == "Tec9" then
		weapon = {"http://www.roblox.com/asset/?id=1760452864",15,10,8,8,"13/52","N/A","Sweden"}
        elseif tag == "UMP" then
		weapon = {"http://www.roblox.com/asset/?id=1760462699",15,8,15,15,"25/100","N/A","Germany"}
        elseif tag == "XM" then
		weapon = {"http://www.roblox.com/asset/?id=929147844",15,15,3,2,"7/28","N/A","Italy"}
        elseif tag == "Golden Knife" then
		weapon = {"rbxassetid://430080758",3,7,5,4,"13/52","N/A","I.D.K"}
        elseif tag == "T Knife" then
		weapon = {"rbxassetid://430080758",3,7,5,4,"13/52","N/A","I.D.K"}
		elseif tag == "CT Knife" then
		weapon = {"rbxassetid://430080758",3,7,5,4,"13/52","N/A","I.D.K"}
		elseif tag == "AUG" then
		weapon = {"http://www.roblox.com/asset/?id=929141651",12,12,14,10,"13/52","Zoom","Austria"}
		elseif tag == "SG" then
		weapon = {"http://www.roblox.com/asset/?id=929141934",15,12,12,8,"13/52","Zoom","Switzerland"}
        elseif tag == "MAC10" then
		weapon = {"http://www.roblox.com/asset/?id=929142369",3,7,5,4,"13/52","N/A","United States"}
        elseif tag == "M4A4" then
		weapon = {"http://www.roblox.com/asset/?id=1760463859",5,15,15,10,"30/90","N/A","United States"}
        elseif tag == "FiveSeven" then
		weapon = {"http://www.roblox.com/asset/?id=1760452565",16,10,8,8,"20/80","N/A","Belgium"}
        elseif tag == "Famas" then
		weapon = {"http://www.roblox.com/asset/?id=929141778",3,7,5,4,"13/52","3x Burst","France"}
        elseif tag == "DualBerettas" then
		weapon = {"http://www.roblox.com/asset/?id=1760451496",5,15,15,15,"30/120","N/A","Italy"}
		elseif tag == "Beretta" then
		weapon = {"rbxassetid://430080758",3,7,5,4,"13/52","N/A","I.D.K"}
        elseif tag == "CZ75" then
		weapon = {"http://www.roblox.com/asset/?id=929140982",3,7,5,4,"13/52","N/A","Czech Republic"}
        elseif tag == "DesertEagle" then
		weapon = {"http://www.roblox.com/asset/?id=1760453517",20,8,4,4,"7/35","N/A","Israel"}
		elseif tag == "R8" then
		weapon = {"http://www.roblox.com/asset/?id=1760453855",3,7,5,4,"13/52","Fanning","United States"}
        elseif tag == "AWP" then
		weapon = {"http://www.roblox.com/asset/?id=1760466582",20,5,10,5,"10/30","2x Zoom","United Kingdom"}
        elseif tag == "AK47" then
		weapon = {"http://www.roblox.com/asset/?id=1760463374",20,10,5,9,"30/90","N/A","Soviet Union"}
        elseif tag == "Nova" then
		weapon = {"http://www.roblox.com/asset/?id=1760461314",15,5,15,2,"8/32","N/A","Italy"}
        elseif tag == "Galil" then
		weapon = {"http://www.roblox.com/asset/?id=516702294",15,15,3,7,"13/52","N/A","Israel"}
        elseif tag == "M249" then
		weapon = {"http://www.roblox.com/asset/?id=1760461955",10,18,12,8,"13/52","N/A","United States"}
        elseif tag == "M4A1" then
		weapon = {"http://www.roblox.com/asset/?id=1760463598",5,12,15,10,"20/60","N/A","United States"}
        elseif tag == "MP7" then
		weapon = {"http://www.roblox.com/asset/?id=1760465938",10,15,15,10,"13/52","N/A","West Germany"}
        elseif tag == "MP9" then
		weapon = {"http://www.roblox.com/asset/?id=1760464318",3,7,5,4,"13/52","N/A","Switzerland"}
        elseif tag == "G3SG1" then
		weapon = {"http://www.roblox.com/asset/?id=1760466841",3,7,5,4,"13/52","2x Zoom","West Germany"}
        elseif tag == "Bizon" then
		weapon = {"http://www.roblox.com/asset/?id=929142284",3,7,5,4,"13/52","N/A","United States"}
        elseif tag == "USP" then
		weapon = {"http://www.roblox.com/asset/?id=516703037",11,8,16,16,"12/48","N/A","Germany"}
		elseif tag == "Kevlar Vest" then
		weapon = {"http://www.roblox.com/asset/?id=966822456",nil,nil,nil,nil,nil,nil,nil,"Body armor that reduces damage taken to the chest/stomach."}
		elseif tag == "Kevlar + Helmet" then
		weapon = {"http://www.roblox.com/asset/?id=966822401",nil,nil,nil,nil,nil,nil,nil,"Helmet that reduces damage taken to the head along with a kevlar vest."}
		elseif tag == "Defuse Kit" then
		weapon = {"http://www.roblox.com/asset/?id=966822311",nil,nil,nil,nil,nil,nil,nil,"Kit used to reduce the time taken to defuse the bomb."}
        elseif tag == "Zeus" then
		weapon = {"http://www.roblox.com/asset/?id=516703037",nil,nil,nil,nil,nil,nil,nil,"Perfect for close-range ambushes and enclosed area encounters, the single-shot x27 Zeus is capable of incapacitating an enemy in a single hit."}
		elseif tag == "Flashbang" then
		weapon = {"http://www.roblox.com/asset/?id=1760458455",nil,nil,nil,nil,nil,nil,nil,"The non-lethal flashbang grenade temporarily blinds anybody within its concussive blast, making it perfect for flushing out closed-in areas. Its loud explosion also temporarily masks the sound of footsteps."}
		elseif tag == "Molotov" then
		weapon = {"http://www.roblox.com/asset/?id=1760459168",nil,nil,nil,nil,nil,nil,nil,"The Molotov is a powerful and unpredictable area denial weapon that bursts into flames when thrown on the ground, injuring any player in its radius."}
		elseif tag == "Incendiary Grenade" then
		weapon = {"http://www.roblox.com/asset/?id=1760458954",nil,nil,nil,nil,nil,nil,nil,"When thrown, the incendiary grenade releases a high-temperature chemical reaction capable of burning anyone within its wide blast radius."}
		elseif tag == "Smoke Grenade" then
		weapon = {"http://www.roblox.com/asset/?id=1760459412",nil,nil,nil,nil,nil,nil,nil,"The smoke grenade creates a medium-area smoke screen. It can effectively hide your team from snipers, or even just create a useful distraction."}
        elseif tag == "HE Grenade" then
		weapon = {"http://www.roblox.com/asset/?id=1760458695",nil,nil,nil,nil,nil,nil,nil,"The high explosive fragmentation grenade administers high damage through a wide area, making it ideal for clearing out hostile rooms."}
		end
		if game.ReplicatedStorage.Weapons:FindFirstChild(tag) then
		weapon[6]=game.ReplicatedStorage.Weapons[tag].Ammo.Value.."/"..game.ReplicatedStorage.Weapons[tag].StoredAmmo.Value
		end
		return weapon
		end
	end
	return nil
end

return API







