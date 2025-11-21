pinData = game:GetService("DataStoreService"):GetDataStore("PinData","pin2")
equippedPin =  game:GetService("DataStoreService"):GetDataStore("EquippedPin","pin2")
pinAwarder = game:GetService("DataStoreService"):GetDataStore("Got")

badge = game:GetService("BadgeService")

webhook = require(script.Parent.Webhook)
function GivePin(UserId,Pin)

	pinData:UpdateAsync(tostring(UserId), function(oldValue)
		local newValue = oldValue		
		if newValue == nil then
			newValue = {}
		end
		table.insert(newValue,1,Pin)
		print("Gave "..Pin.." to "..UserId)
		return newValue
	end)
end
function game.ReplicatedStorage.RequestPins.OnServerInvoke(Player)

	local Pins = pinData:GetAsync(tostring(Player.userId))
	repeat wait()

	until Pins
	return Pins
end

game.ReplicatedStorage.Events.ServerPin.Event:Connect(function(uid,pin)
	GivePin(uid,pin)
end)
game.ReplicatedStorage.EquipPin.OnServerEvent:connect(function(player,pinname)
	--Check if they got the pin 
	local Pins = pinData:GetAsync(tostring(player.userId))
	repeat wait() until Pins
	local haspin = false
	for i=1, #Pins do
		if Pins[i] == pinname then
			haspin = true
			--print("He has the pin!")
		end
	end
	if haspin then
		--print("Equipping pin!")
		equippedPin:SetAsync(player.userId,pinname)
		player.EquippedPin.Value = pinname
	end
end)

game.Players.PlayerAdded:connect(function(player)
	local PinDecal = Instance.new("StringValue",player)

	equippedPin:UpdateAsync(tostring(player.userId), function(oldValue)
		local newValue = oldValue		
		if newValue == nil then
			newValue = ""
		end
		return newValue
	end)

	PinDecal.Name = "EquippedPin"
	PinDecal.Value = equippedPin:GetAsync(player.userId)
end)

--



--GivePin(368128037,"rbxassetid://9438607916")
--GivePin(3490255027,"rbxassetid://9412672311")

--GivePin(9960695,"rbxassetid://331180718") -- rolve pin ID 
--GivePin(65945437,"rbxassetid://331180718")
--GivePin(26525555,"rbxassetid://331180718")
--GivePin(5682414,"http://www.roblox.com/asset/?id=853161120")
--GivePin(65945437,"http://www.roblox.com/asset/?id=853161120")
--GivePin(9960695,"rbxassetid://734723378")
--http://www.roblox.com/asset/?id=
--GivePin(9960695 ,"rbxassetid://734723378")
--GivePin(72220657 ,"rbxassetid://734723378")
--GivePin(193963839 ,"rbxassetid://734723378")
--GivePin(80001980 ,"rbxassetid://734723378")
--GivePin(156589564 ,"rbxassetid://734723378")
--GivePin(1095419 ,"rbxassetid://734723378")
--GivePin(8440650 ,"rbxassetid://734723378")
--GivePin(33184799 ,"rbxassetid://734723378")
--GivePin(93922792 ,"rbxassetid://734723378")
--GivePin(37971598 ,"rbxassetid://734723378")
--GivePin(7216006 ,"rbxassetid://734723378")
--GivePin(91222766 ,"rbxassetid://734723378")
--GivePin(124108911 ,"rbxassetid://734723378")
--GivePin(1588895808 ,"rbxassetid://734723378")

--GivePin(65945437, "http://www.roblox.com/asset/?id=6834541992")
--GivePin(65945437, "http://www.roblox.com/asset/?id=6834541544")
--GivePin(65945437, "http://www.roblox.com/asset/?id=6834529073")
--GivePin(65945437, "http://www.roblox.com/asset/?id=6834539864")
--GivePin(65945437, "http://www.roblox.com/asset/?id=6834540399")
--GivePin(65945437, "http://www.roblox.com/asset/?id=6801843512")


--GivePin(9960695,"rbxassetid://734835644")
--GivePin(8440650,"rbxassetid://734835644")
--GivePin(52874418,"rbxassetid://734835644")
--GivePin(78017717,"rbxassetid://734835644")
--GivePin(144246133,"rbxassetid://734835644")
--GivePin(43215400,"rbxassetid://734835644")
--GivePin(124108911,"rbxassetid://734835644")
--GivePin(1588895808 ,"rbxassetid://734723378")
--GivePin(70153639,"rbxassetid://734835644")
--GivePin(925726981,"rbxassetid://734835644")
--GivePin(31351185,"rbxassetid://734835644")
--GivePin(156589564,"rbxassetid://734835644")
--GivePin(21650006,"rbxassetid://734835644")
--GivePin(102911582,"rbxassetid://734835644")
--GivePin(52436542,"rbxassetid://734835644")
--GivePin(21863788,"rbxassetid://734835644")
--GivePin(1095419,"rbxassetid://734835644")
--GivePin(10542259,"rbxassetid://734835644")
--GivePin(8440650,"rbxassetid://734835644")
--GivePin(65945437,"rbxassetid://734835644")
--GivePin(8440650,"rbxassetid://734835644")
--GivePin(8886653,"rbxassetid://734723378")
--GivePin(65945437,"http://www.roblox.com/asset/?id=853161120")
--GivePin(568241,"http://www.roblox.com/asset/?id=853161120")

--GivePin(65945437,"rbxassetid://572276697")
--GivePin(35345603, "rbxassetid://572276697")

--GivePin(298871133,"http://www.roblox.com/asset/?id=919142867")
--GivePin(1588895808 ,"http://www.roblox.com/asset/?id=919142867")
--GivePin(922200,"http://www.roblox.com/asset/?id=919142867")
--GivePin(135654536,"http://www.roblox.com/asset/?id=919142867")
--GivePin(1372083,"http://www.roblox.com/asset/?id=919142867")
--GivePin(26155266,"http://www.roblox.com/asset/?id=919142867")
--GivePin(20147650,"http://www.roblox.com/asset/?id=919142867")
--GivePin(71551098,"http://www.roblox.com/asset/?id=919142867")
--GivePin(55982225,"http://www.roblox.com/asset/?id=919142867")
--GivePin(61205357,"http://www.roblox.com/asset/?id=919142867")
--GivePin(47497235,"http://www.roblox.com/asset/?id=919142867")
--GivePin(162134957,"http://www.roblox.com/asset/?id=919142867")
--GivePin(18733947,"http://www.roblox.com/asset/?id=919142867")
--GivePin(152970776,"http://www.roblox.com/asset/?id=919142867")
--GivePin(154067054,"http://www.roblox.com/asset/?id=919142867")
--GivePin(33081733,"http://www.roblox.com/asset/?id=919142867")
--GivePin(32221068,"http://www.roblox.com/asset/?id=919142867")
--GivePin(21709412,"http://www.roblox.com/asset/?id=919142867")
--GivePin(312949085,"http://www.roblox.com/asset/?id=919142867")
--GivePin(128404425,"http://www.roblox.com/asset/?id=919142867")
--GivePin(204818617,"http://www.roblox.com/asset/?id=919142867")
--GivePin(52436542,"http://www.roblox.com/asset/?id=919142867")
--GivePin(43334162,"http://www.roblox.com/asset/?id=919142867")
--GivePin(14232281,"http://www.roblox.com/asset/?id=919142867")
--GivePin(193933445,"http://www.roblox.com/asset/?id=919142867")
--GivePin(20848772,"http://www.roblox.com/asset/?id=919142867")
--GivePin(339886536,"http://www.roblox.com/asset/?id=919142867")
--GivePin(47469424,"http://www.roblox.com/asset/?id=919142867")
--GivePin(55941878,"http://www.roblox.com/asset/?id=919142867")
--GivePin(28913567,"http://www.roblox.com/asset/?id=919142867")
--GivePin(2483723,"http://www.roblox.com/asset/?id=919142867")
--GivePin(93868462,"http://www.roblox.com/asset/?id=919142867")
--GivePin(25971264,"http://www.roblox.com/asset/?id=919142867")
--GivePin(162849117,"http://www.roblox.com/asset/?id=919142867")
--GivePin(31857035,"http://www.roblox.com/asset/?id=919142867")
--GivePin(88892950,"http://www.roblox.com/asset/?id=919142867")
--GivePin(273655045,"http://www.roblox.com/asset/?id=919142867")
--GivePin(224715005,"http://www.roblox.com/asset/?id=919142867")

--GivePin(52436542,"http://www.roblox.com/asset/?id=919142867")
--GivePin(193933445,"http://www.roblox.com/asset/?id=919142867")
--GivePin(20848772 ,"http://www.roblox.com/asset/?id=919142867")
--GivePin(339886536 ,"http://www.roblox.com/asset/?id=919142867")
--GivePin(14232281 ,"http://www.roblox.com/asset/?id=919142867")
--GivePin(36565012 ,"http://www.roblox.com/asset/?id=919142867")
--GivePin(183247549 ,"http://www.roblox.com/asset/?id=919142867")
--GivePin(43334162,"http://www.roblox.com/asset/?id=919142867")
--GivePin(319448184,"http://www.roblox.com/asset/?id=919142867")
--GivePin(192347094,"http://www.roblox.com/asset/?id=919142867")
--GivePin(37971598,"http://www.roblox.com/asset/?id=919142867")
--GivePin(7252081,"http://www.roblox.com/asset/?id=919142867")
--GivePin(74234162,"http://www.roblox.com/asset/?id=919142867")
--GivePin(81783746,"http://www.roblox.com/asset/?id=919142867")
--GivePin(7216006,"http://www.roblox.com/asset/?id=919142867")
--GivePin(49900130,"http://www.roblox.com/asset/?id=919142867")
--GivePin(326115692,"http://www.roblox.com/asset/?id=919142867")
--GivePin(324372861,"http://www.roblox.com/asset/?id=919142867")
--GivePin(158133678,"http://www.roblox.com/asset/?id=919142867")
--GivePin(303113196,"http://www.roblox.com/asset/?id=919142867") 
--GivePin(109643321,"http://www.roblox.com/asset/?id=919142867")
--GivePin(56625562,"http://www.roblox.com/asset/?id=919142867")
--GivePin(57028266,"http://www.roblox.com/asset/?id=919142867")
--GivePin(336901936,"http://www.roblox.com/asset/?id=919142867")
--GivePin(14204335,"http://www.roblox.com/asset/?id=919142867")
--GivePin(39504803,"http://www.roblox.com/asset/?id=919142867")
--GivePin(340719913,"http://www.roblox.com/asset/?id=919142867")
--GivePin(45316255,"http://www.roblox.com/asset/?id=919142867")
--GivePin(52963178,"http://www.roblox.com/asset/?id=919142867")
--GivePin(65945437,"http://www.roblox.com/asset/?id=919142867")
--GivePin(13415699,"http://www.roblox.com/asset/?id=919142867")
--GivePin(29974172,"http://www.roblox.com/asset/?id=919142867")
--GivePin(294941697,"http://www.roblox.com/asset/?id=919142867")
--GivePin(49405424,"http://www.roblox.com/asset/?id=919142867")
--GivePin(72220657,"http://www.roblox.com/asset/?id=919142867")
--GivePin(138146802,"http://www.roblox.com/asset/?id=919142867")
--GivePin(30926698,"http://www.roblox.com/asset/?id=919142867")
--GivePin(264295678,"http://www.roblox.com/asset/?id=919142867")
--GivePin(33931141,"http://www.roblox.com/asset/?id=919142867")
--GivePin(293260159,"http://www.roblox.com/asset/?id=919142867")
--GivePin(35599871,"http://www.roblox.com/asset/?id=919142867")
--GivePin(61693266,"http://www.roblox.com/asset/?id=6924364912")

--print("DONE WITH PINS!!")
--print("DONE WITH PINS!!")
--print("DONE WITH PINS!!")
--print("DONE WITH PINS!!")
--print("DONE WITH PINS!!")

