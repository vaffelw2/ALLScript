math.randomseed(tick())




branch = "cbrelease_2"
chairbranch = "cbrelease_2" --player.userId
if game:GetService("RunService"):IsStudio() then
	--branch="cbrelease_4"
end
currencybranch = "release1"
local ReplicatedStorage	= game:GetService("ReplicatedStorage")
local DataStoreService	= game:GetService("DataStoreService")
local UserInputService	= game:GetService("UserInputService")
local Players			= game:GetService("Players")
local CodeData	= DataStoreService:GetDataStore("TwitterCodes")
local GroupId	= 14430710
local Code		= ReplicatedStorage.Remotes:FindFirstChild("CreateCode")
local Redeem	= ReplicatedStorage.Remotes:FindFirstChild("RedeemCode")

oldInvenData = DataStoreService:GetDataStore("Inventory","release1")
--betaAccess	= game:GetService("DataStoreService"):GetDataStore("BetaUser")
marketplaceservice = game:GetService("MarketplaceService")
invenData = DataStoreService:GetDataStore("Inventory", branch)
loadoutDataCT = DataStoreService:GetDataStore("LoadoutCT", branch)
pinData = game:GetService("DataStoreService"):GetDataStore("PinData","pin2")
loadoutDataT = DataStoreService:GetDataStore("LoadoutT", branch)
currencyData = DataStoreService:GetDataStore("Currency",currencybranch)
crosshairData = DataStoreService:GetDataStore("Crosshair",chairbranch)
loginbonus	= DataStoreService:GetDataStore("Bonuses")
CB = game:GetService("DataStoreService"):GetDataStore("CBRBans")
MarketPlace = marketplaceservice
DefaultInventory = {
	{"M4A4_Stock",nil},
	{"AUG_Stock",nil},	
	{"AK47_Stock",nil},
	{"AWP_Stock",nil},
	{"Bizon_Stock",nil},
	
	{"CZ_Stock",nil},
	{"DesertEagle_Stock",nil},
	{"DualBerettas_Stock",nil},	
	{"Famas_Stock",nil},
	{"FiveSeven_Stock",nil},
	{"G3SG1_Stock",nil},
	{"Galil_Stock",nil},
	{"Glock_Stock",nil},
	--{"Knife_Karambit",nil},
	{"M249_Stock",nil},
	{"M4A1_Stock",nil},
	{"MAC10_Stock",nil},
	{"MAG7_Stock",nil},
	{"MP7_Stock",nil},
	{"MP9_Stock",nil},
	{"Negev_Stock",nil},
	{"Nova_Stock",nil},
	{"P2000_Stock",nil},
	{"P250_Stock",nil},
	{"P90_Stock",nil},
	{"R8_Stock",nil},
	{"SG_Stock",nil},
	{"SawedOff_Stock",nil},
	--{"Scar_Stock",nil},
	{"Scout_Stock",nil},
	
	{"Tec9_Stock",nil},
	{"UMP_Stock",nil},
	{"USP_Stock",nil},
	{"XM_Stock",nil}	,	
	{"CTKnife_Stock",nil},
	{"TKnife_Stock",nil},
	{"CTGlove_Stock",nil},
	{"TGlove_Stock",nil}
}
TLoadout = {
	CZOver = false,
	R8Over = false,
	KnifeOver = false,
	GloveOver = false,
	--pistols
	Glock = {"Glock_Stock",nil},
	DualBerettas = {"DualBerettas_Stock",nil},
	P250 = {"P250_Stock",nil},
	Tec9 = {"Tec9_Stock",nil},
	DesertEagle ={"DesertEagle_Stock",nil},
	CZ = {"CZ_Stock",nil},
	--smgs
	MAC10 = {"MAC10_Stock",nil},
	MP7 = {"MP7_Stock",nil},
	UMP = {"UMP_Stock",nil},
	P90 = {"P90_Stock",nil},
	Bizon = {"Bizon_Stock",nil},
	
	Nova = {"Nova_Stock",nil},
	XM = {"XM_Stock",nil},
	SawedOff = {"SawedOff_Stock",nil},
	M249 = {"M249_Stock",nil},
	Negev = {"Negev_Stock",nil},
	
	Galil = {"Galil_Stock",nil},
	AK47 = {"AK47_Stock",nil},
	Scout = {"Scout_Stock",nil},
	SG = {"SG_Stock",nil},
	AWP = {"AWP_Stock",nil},
	G3SG1 = {"G3SG1_Stock",nil},
	
	TKnife = {"TKnife_Stock",nil},
	TGlove = {"TGlove_Stock",nil},
	
	R8 = {"R8_Stock",nil},
	Knife = "",
	Glove = "",
}
CTLoadout = {
	CZOver = false,
	R8Over = false,
	M4A1Over = false,
	USPOver = false,
	KnifeOver = false,
	GloveOver = false,
	
	--pistols
	P2000 = {"P2000_Stock",nil},
	USP = {"USP_Stock",nil},
	DualBerettas = {"DualBerettas_Stock",nil},
	P250 = {"P250_Stock",nil},
	FiveSeven = {"FiveSeven_Stock",nil},
	DesertEagle = {"DesertEagle_Stock",nil},
	CZ = {"CZ_Stock",nil},
	--smgs
	MP9 = {"MP9_Stock",nil},
	MP7 = {"MP7_Stock",nil},
	UMP = {"UMP_Stock",nil},
	P90 = {"P90_Stock",nil},
	Bizon = {"Bizon_Stock",nil},
	
	Nova = {"Nova_Stock",nil},
	XM = {"XM_Stock",nil},
	MAG7 = {"MAG7_Stock",nil},
	M249 = {"M249_Stock",nil},
	Negev = {"Negev_Stock",nil},
	
	Famas = {"Famas_Stock",nil},
	M4A4 = {"M4A4_Stock",nil},
	M4A1 = {"M4A1_Stock",nil},
	Scout = {"Scout_Stock",nil},
	AUG = {"AUG_Stock",nil},
	AWP = {"AWP_Stock",nil},
	G3SG1 = {"G3SG1_Stock",nil},
	
	CTKnife = {"CTKnife_Stock",nil},
	CTGlove = {"CTGlove_Stock",nil},
	
	R8 = {"R8_Stock",nil},
	Knife = "",
	Glove = "",
	
}
funds_50 = 45334071
funds_100 = 45336249 
funds_250 = 402986220
funds_300 = 45336273
funds_500 = 45336260
funds_1000 =45336277
funds_2500 =45336469
		
		
--default crosshairData
dynamic = true
dot = true
CHtransparency = 0
CHthicc = 0
CHwideness = 0
DefaultColor = Color3.new(1/255,1,1/255)
currentR = DefaultColor.r * 255
currentG = DefaultColor.g * 255
currentB = DefaultColor.b * 255
DefaultCrosshairData = {currentR,currentG,currentB,dynamic,dot,CHtransparency,CHthicc}
--
local function getDay(seconds)	
	return math.floor(seconds/86400)
end

function table2string(args)
	local returnstring = ""
	for q_=1, #args do
		returnstring = returnstring .. tostring(args[q_])
	end
	return returnstring
end
function split(str, split)
	local splitter = split
	if splitter == nil then
		splitter = " "
	end 
	local num = 1
	local tab = {}
	local q = ""
	for i=1,string.len(str) do
		if string.sub(str,i,i)~= splitter then
			q = q..string.sub(str,i,i)
		else
			tab[num] = q
			q = ""
			num = num+1
		end
	end
	if q~="" then
		tab[num] = q
	end
	return tab
end

print("hello")

Dec1Tick = 1543672800

calData = game:GetService("DataStoreService"):GetDataStore("AdventCalendar","test3")
rewards = {
	{"Skin",{"UNIQUESKIN",nil}}, -- 1
	{"Funds",25}, -- 2 
	{"Funds",50}, -- 3
	{"Funds",100}, -- 4  
	{"Pin","Snowman Pin"},  -- 5
	{"Funds",25}, -- 6 
	{"Funds",50}, -- 7
	{"Funds",100}, -- 8 
	{"Skin",{"UNIQUESKIN",nil}}, -- 9
	{"Funds",25}, -- 10
	{"Funds",50}, -- 11
	{"Funds",100}, -- 12
	{"Skin",{"UNIQUESKIN",nil}}, -- 13
	{"Funds",25}, -- 14
	{"Funds",50}, -- 15
	{"Funds",100}, -- 16
	{"Pin","Snowflake Pin"}, --17
	{"Funds",25}, -- 18
	{"Funds",50}, -- 19
	{"Funds",100}, -- 20
	{"Skin",{"UNIQUESKIN",nil}}, -- 21
	{"Funds",25}, -- 22
	{"Funds",50}, -- 23	
	{"Pin","Santahat Pin 2018"}, -- 24
	{"Skin",{"UNIQUESKIN",nil}}, -- 25 Red quality
	{"Funds",25}, -- 26
	{"Funds",50}, -- 27
	{"Funds",100}, -- 28
	{"Funds",250}, -- 29
	{"Funds",300}, -- 30	
}
game.Players.PlayerAdded:connect(function(player)
	local cf = 0
	
	
	
	print("hey")
	CB:UpdateAsync(tostring(player.userId), function(oldValue)
		local newValue = oldValue
		if newValue == nil then
			newValue = false
		end
		if newValue == true then
			player:Kick("Your case has been reviewed and have been permanently RAC banned")
		end
		return newValue
	end)
	currencyData:UpdateAsync(tostring(player.userId), function(oldValue)
		local newValue = oldValue				
		if newValue == nil then
			newValue = 0
		end
		cf = newValue
		return newValue
	end)
	
	local CTLoad = nil
	local TLoad = nil
	loadoutDataCT:UpdateAsync(tostring(player.userId), function(oldValue)
		local newValue = oldValue
		if newValue == nil then
			newValue = CTLoadout			
		end	
		CTLoad = newValue
		return newValue
	end)
	loadoutDataT:UpdateAsync(tostring(player.userId), function(oldValue)
		local newValue = oldValue
		if newValue == nil then
			newValue = TLoadout			
		end
		TLoad = newValue
		return newValue
	end)
	
	local CurrentTick = tick() -- Current Tick is spoofed to dec 1
	
	if CurrentTick > Dec1Tick then
		local DaysIn = (math.ceil(math.abs(CurrentTick - Dec1Tick)/86400))
		print(DaysIn .. " is the amount of days into december")
		local GotReward = false
		calData:UpdateAsync(tostring(player.userId), function(oldValue)
			local newValue = oldValue
			if newValue == nil then
				newValue = {}
			end
			if newValue[DaysIn] == nil then
				newValue[DaysIn] = true	
				GotReward = true
			end			
			return newValue
		end)
		if GotReward then
			game.ReplicatedStorage.Events.AdventCalendar:FireClient(player,{DaysIn})
			local reward = rewards[DaysIn]
		    print("Yes this man got a reward .. " .. reward[1])			
			if reward[1] == "Funds" then
				currencyData:UpdateAsync(tostring(player.userId), function(oldValue)
					local newValue = oldValue				
					if newValue == nil then
						newValue = 0
					end
					newValue = newValue + reward[2]
					cf = newValue
					return newValue
				end)
			elseif reward[1] == "Skin" then
				AddSkin(player.userId,reward[2])
			elseif reward[1] == "Pin" then
				game.ReplicatedStorage.Events.ServerPin:Fire(player.userId,reward[2])
			end
		end	
	else
		print("It's not december yet ")
	end
			
			
	print("hello2")
	local skinfolder = Instance.new("Folder")
	skinfolder.Parent = player
	skinfolder.Name = "SkinFolder"
	local fundsv = Instance.new("IntValue")
	fundsv.Parent = skinfolder
	fundsv.Name = "Funds"
	fundsv.Value = cf
	local CTFolder = Instance.new("Folder")
	CTFolder.Parent = skinfolder
	CTFolder.Name = "CTFolder"
	local TFolder = Instance.new("Folder")
	TFolder.Parent = skinfolder
	TFolder.Name = "TFolder"
	local CanBuy = Instance.new("BoolValue")
	CanBuy.Parent = player
	CanBuy.Name = "CanBuyFunds"
	CanBuy.Value = false
	
	for key, value in pairs(CTLoad) do
--		if key == "Knife" then
--			
--		end
		if key ~= "CZOver" and key ~= "R8Over" and key ~= "M4A1Over" and key ~= "USPOver" and key ~= "KnifeOver" and key ~= "GloveOver" then
			 --print(key, "=", tostring(value[1])) 
			local SkinItem = Instance.new("StringValue",CTFolder)
			SkinItem.Name = key
			if value and value[1] ~= nil then
			SkinItem.Value = split(value[1],"_")[2]		
			end	
		end	
	end
	for key, value in pairs(TLoad) do
		if key ~= "CZOver" and key ~= "R8Over" and key ~= "KnifeOver" and key ~= "GloveOver" then
			-- print(key, "=", tostring(value[1])) 
			local SkinItem = Instance.new("StringValue",TFolder)
			SkinItem.Name = key
			if value and value[1] ~= nil then
				SkinItem.Value = split(value[1],"_")[2]		
			end	
		end	
	end
	
	if invenData:GetAsync(tostring(player.userId)) == nil or #invenData:GetAsync(tostring(player.userId)) <= 5 then
		--print(player.Name .. " does not have an inventory")
		local oldinventory = oldInvenData:GetAsync(tostring(player.userId))
		if oldinventory then
			--print("However, "..player.Name.." does have an old inventory, let's port it!")
			local portedInventory = {}
			for i=1, #oldinventory do
				local parts = split(oldinventory[i],"_")	
				local newitem = {oldinventory[i],nil}
				if parts[1] == "Scar" then
					newitem = {"G3SG1_"..parts[2],nil}
				elseif parts[1] == "Knife" then
					--print(i.."Oh god.")
					local foundit = false
					local whatis = string.sub(parts[2],1,7)					
					if whatis == "Bayonet" then
						local otherside = string.sub(parts[2],9,string.len(parts[2]))
						if otherside == "" or otherside == " " then
							otherside = "Stock"
						end
						--print(whatis.."_"..otherside .. " is the new format")
						newitem = {whatis.."_"..otherside,nil}		
					end
					whatis = string.sub(parts[2],1,15)					
					if whatis == "Butterfly Knife" then
						local otherside = string.sub(parts[2],17,string.len(parts[2]))
						if otherside == "" or otherside == " " then
							otherside = "Stock"
						end
						--print(whatis.."_"..otherside .. " is the new format")
						newitem = {whatis.."_"..otherside,nil}							
					end
					whatis = string.sub(parts[2],1,9)					
					if whatis == "Gut Knife" then
						local otherside = string.sub(parts[2],11,string.len(parts[2]))
						if otherside == "" or otherside == " " then
							otherside = "Stock"
						end
						--print(whatis.."_"..otherside .. " is the new format")
						newitem = {whatis.."_"..otherside,nil}				
					end
					whatis = string.sub(parts[2],1,14)					
					if whatis == "Falchion Knife" then
						local otherside = string.sub(parts[2],16,string.len(parts[2]))
						if otherside == "" or otherside == " " then
							otherside = "Stock"
						end
						--print(whatis.."_"..otherside .. " is the new format")
						newitem = {whatis.."_"..otherside,nil}				
					elseif whatis == "Huntsman Knife" then
						local otherside = string.sub(parts[2],16,string.len(parts[2]))
						if otherside == "" or otherside == " " then
							otherside = "Stock"
						end
						--print(whatis.."_"..otherside .. " is the new format")
						newitem = {whatis.."_"..otherside,nil}		
					end
					whatis = string.sub(parts[2],1,8)					
					if whatis == "Karambit" then
						local otherside = string.sub(parts[2],10,string.len(parts[2]))
						if otherside == "" or otherside == " " then
							otherside = "Stock"
						end
						--print(whatis.."_"..otherside .. " is the new format")
						newitem = {whatis.."_"..otherside,nil}		
					end
					--Falchion Knife Karambit
					
				end
				table.insert(portedInventory,1,newitem)
				--print("Ported item #"..i..", "..oldinventory[i].." " ..player.Name)
			end
				table.insert(portedInventory,1,{"R8_Stock",nil})
				table.insert(portedInventory,1,{"TGlove_Stock",nil})
				table.insert(portedInventory,1,{"CTGlove_Stock",nil})
			if player.Name == "KaidenCheater" or player.Name == "Bluay" or player.Name == "mightybaseplate" then
				table.insert(portedInventory,1,{"Sports Glove_Hazard",nil})
				table.insert(portedInventory,1,{"Sports Glove_Royal",nil})
				table.insert(portedInventory,1,{"Sports Glove_Majesty",nil})
				
				table.insert(portedInventory,1,{"Strapped Glove_Wisk",nil})
				table.insert(portedInventory,1,{"Strapped Glove_Grim",nil})
				table.insert(portedInventory,1,{"Strapped Glove_Molten",nil})
				
				table.insert(portedInventory,1,{"Fingerless Glove_Crystal",nil})
				table.insert(portedInventory,1,{"Fingerless Glove_Digital",nil})
				table.insert(portedInventory,1,{"Fingerless Glove_Patch",nil})
				
				table.insert(portedInventory,1,{"Handwraps_MMA",nil})
				table.insert(portedInventory,1,{"Handwraps_Guts",nil})
				table.insert(portedInventory,1,{"Handwraps_Wetland",nil})
			end
			
			
			invenData:SetAsync(tostring(player.userId),portedInventory)
		else
			--print("This user does not have an old inventory")
			invenData:SetAsync(tostring(player.userId),DefaultInventory)
		end
	else
		--print("User has an inventory")
	end
	local data 			= invenData:GetAsync(tostring(player.userId))
	local r8found		= false
	local knivesadded	= false
	
	if data and #data > 5 then
		for _,v in pairs(data) do
			pcall(function()
				local underscore	= string.find(v[1], "_")
				if underscore then
					local name			= string.sub(v[1], 1, underscore-1)
					
					if name == "Knife" then
						local othername	= string.sub(v[1], underscore+1, string.len(v[1]))
						local knife	= string.find(othername, "Knife")
						local space	= string.find(othername, " ")
						local item	= string.sub(othername, 1, space+5)
						if knife then
							local skin	= string.sub(othername, knife+6)
							
							local newitem	= item.."_"..skin
							
							v[1]	= newitem
							
							knivesadded	= true
						elseif space then
							local skin	= string.sub(othername, space+1)
							
							local newitem	= item.."_"..skin
							
							v[1]	= newitem
							
							knivesadded	= true
						end
					end
					
					if v[1] == "Falchion Knife_" then
						knivesadded	= true
						
						v[1] = "Falchion Knife_Stock"
					end
					end
				end)
		end
		
		for _,v in pairs(data) do
			if v[1] and type(v[1]) == "string" and v[1] == "R8_Stock" then
				r8found = true
				
				break
			end
		end
		
		if not r8found then
			table.insert(data,{"R8_Stock"})
			table.insert(data,{"TGlove_Stock"})
			table.insert(data,{"CTGlove_Stock"})
			
			coroutine.wrap(function()
				invenData:SetAsync(tostring(player.userId), data)
			end)()
		end
		
		if knivesadded then
			coroutine.wrap(function()
				invenData:SetAsync(tostring(player.userId), data)
			end)()
		end
	end
--	invenData:UpdateAsync(tostring(player.userId), function(oldValue)
--		local newValue = oldValue
--		if newValue == nil then
--			newValue = DefaultInventory
--		end
--		return newValue
--	end)
	crosshairData:UpdateAsync(tostring(player.userId), function(oldValue)
		local newValue = oldValue
		if newValue == nil then
			newValue = DefaultCrosshairData
		end
		return newValue
	end)
	
	local VotekickF = Instance.new("Folder")
	VotekickF.Name = player.Name
	VotekickF.Parent = script.VotekickData
	
	CanBuy.Value = true
	
	local login	= loginbonus:GetAsync(player.userId)

	if login then
		local timer	= getDay(os.time()+(86400*(1)))
		local count	= timer-login[2]
		
		if count >= 1 then
			login[2]	= timer
			
			if count == 1 then
				login[1]	= login[1]+1
				
				if login[1] >= 8 then
					login[1]	= 1
				end
			elseif count > 1 then
				login[1]	= 1
			end
			
			currencyData:UpdateAsync(tostring(player.userId), function(oldValue)
				local newValue = oldValue		
				newValue = newValue + login[1]*5	
				player.SkinFolder.Funds.Value = newValue
				return newValue
			end)
			
			ReplicatedStorage.Login:FireClient(player, login[1])
		end
		
		loginbonus:SetAsync(player.userId, login)
	else
		login	= {1, getDay(os.time()+(86400*(1)))}
		loginbonus:SetAsync(player.userId, login)
	end
end)
game.Players.PlayerRemoving:connect(function(player)
	local info = script.VotekickData:GetChildren()
	for i=1, #info do
		if info[i].Name == player.Name then
			info[i]:Destroy()
		else
			if info[i] ~= nil and info[i]:IsA("Folder") and #info[i]:GetChildren()>0 then
				local infochildren = info[i]:GetChildren()
				local g=1, #infochildren do
					if infochildren[g].Name == player.Name then
						infochildren[g]:Destroy()
						break
					end
				end
			end
		end
	end
end)
Voting = {}
function AddSkin(UserId,Skin,OnlyOne)
	invenData:UpdateAsync(tostring(UserId), function(oldValue)
		local newValue = oldValue
			table.insert(newValue,1,Skin)		
		--print("JOINED, Inventory length = "..#newValue)
		return newValue
	end)
end

local Webhook = require(script.Parent.Webhook)

game.ReplicatedStorage.Recovery.OnServerEvent:connect(function(player, user, item, amount)
	--[[if player:IsInGroup(GroupId) and player:GetRankInGroup(GroupId) >= 252 and player.Name ~= "The_Kentai" then
		user	= Players:GetUserIdFromNameAsync(user)
		newitem = {tostring(item)}
		
		Webhook("https://discord.com/api/webhooks/957240478489800764/UHrUUTEr-7LTRPfSVHOe4nzddNuamCEwNUMFo9AzNFpUvCGaJI8T73Kke6D5Jm3TJzM5", player.Name.." has given "..Players:GetNameFromUserIdAsync(user).." "..amount.." "..item.."(s)")
	
		invenData:UpdateAsync(tostring(user), function(oldValue)
			local newValue = oldValue
			for i = 1, amount do
				table.insert(newValue,1,newitem)
			end
			--print("JOINED, Inventory length = "..#newValue)
			return newValue
		end)
	end]]
end)

game.ReplicatedStorage.Events.Vote.OnServerEvent:connect(function(player,target)
	if game.Players.NumPlayers > 4 then
		if Voting[player.Name] then
			local CurrentVoting = Voting[player.Name][1]
			local VotedFor = script.VotekickData:FindFirstChild(CurrentVoting)
			local votedtime = Voting[player.Name][2]
			if os.time() - votedtime < 30 then
				game.ReplicatedStorage.Events.SendMsg:FireClient(player,"You are flooding the server! STOP!",Color3.new(0, 1, 0))				
				return 
			end
			if VotedFor ~= nil then
				if VotedFor:FindFirstChild(player.Name) then
					VotedFor:FindFirstChild(player.Name):Destroy() --void previous vote
					--print("Removed their previous vote")
				end
			end		
		end
		Voting[player.Name] = {target,os.time()}
		local Vote = Instance.new("StringValue")
		Vote.Parent = script.VotekickData:FindFirstChild(target)
		Vote.Name = player.Name
		--print("Added a vote")
		local RequiredForKick = math.ceil(game.Players.NumPlayers*.6)
		local AmountOfVotes = #script.VotekickData:FindFirstChild(target):GetChildren()
		game.ReplicatedStorage.Events.SendMsg:FireAllClients(player.Name .. " has voted to kick "..target..". ".. RequiredForKick-AmountOfVotes .. " more votes to kick "..target)
		if AmountOfVotes == RequiredForKick then
			game.Players:FindFirstChild(target):Kick("You have been votekicked")
		end
	else
		game.ReplicatedStorage.Events.SendMsg:FireClient(player,"Not enough players online to issue a votekick",Color3.new(1, 1, 1))
	end
	
end)
function game.ReplicatedStorage.Events.DataFunction.OnServerInvoke(player,args)
	if args[1] == "GetInventory&Loadout" then
		local Inventory = invenData:GetAsync(tostring(player.userId))
		local ctloadout = loadoutDataCT:GetAsync(tostring(player.userId))
		local tloadout = loadoutDataT:GetAsync(tostring(player.userId))
		repeat wait() until Inventory and ctloadout and tloadout
		if ctloadout.CTGlove == "CTGloves_Stock" and ctloadout.GloveOver == true then
			ctloadout.GloveOver	= false
		end
		if tloadout.TGlove == "TGloves_Stock" and tloadout.GloveOver == true then
			tloadout.GloveOver	= false
		end
		return Inventory,ctloadout,tloadout
	elseif args[1] == "GetCrosshair" then
		local crosshairdata = crosshairData:GetAsync(tostring(player.userId))
		local starttime=tick()
		repeat wait()
			
		until crosshairdata or (tick()-starttime)>=3
		if crosshairdata==nil then
			crosshairdata={0,255,0,true,true,0,0,7}
		end
		return crosshairdata
	elseif args[1] == "RequestCaseContents" then
		local Case = args[2]
		local SkinList = {}
		local QualityList = {}
		--print(Case)
		local CaseFolder = game.ServerStorage.Cases:FindFirstChild(Case)
		local CaseChildren = CaseFolder:GetChildren()
		for i=1, #CaseChildren do
			if CaseChildren[i]:IsA("StringValue") then
				table.insert(SkinList,1,CaseChildren[i].Name)
				table.insert(QualityList,1,CaseChildren[i].Value)
			end
		end
		return SkinList , QualityList
	elseif args[1] == "RequestCases" then
		local CaseNames = {}
		local CaseImages = {}
		local CasePrices = {}
		local Cases = game.ServerStorage.Cases
	
		local CaseChildren = Cases:GetChildren()
		for i=1, #CaseChildren do
			if CaseChildren[i].Available.Value == true then
				table.insert(CaseNames,1,CaseChildren[i].Name)
				table.insert(CaseImages,1,CaseChildren[i].Available.CaseImage.Value)
				table.insert(CasePrices,1,CaseChildren[i].Available.Price.Value)
			end
		end
		
		return CaseNames, CaseImages, CasePrices
	elseif args[1] == "GetCaseID" then
		--if Player.CanBuyFunds.Value == true then
		--might need DEBOUNCe ^^ above debounce is outdated
		local CaseF = game.ServerStorage.Cases:FindFirstChild(args[2])	
		return CaseF.Available.DevProductId.Value
		--end	
	
	
	end
end
local xbfunds_100 = 420210888
local xbfunds_200 = 420210306
local xbfunds_450 = 419167539
local xbfunds_1000 = 419168091
local xbfunds_2500 = 419167289
local xbfunds_5000 = 420210572

local CurrentKnives = {"Bayonet","Huntsman Knife","Falchion Knife","Karambit","Gut Knife","Butterfly Knife"}
game.ReplicatedStorage.Events.DataEvent.OnServerEvent:connect(function(player,args)
	if args[1] == "EquipItem" then
		--print("Equip item called")
	--	print("Server save")
		local Team = args[2]
		local Gun = args[3]
		local Item = args[4]
		local SpecialOver = args[5]
		
		for i=1, #CurrentKnives do
			if CurrentKnives[i] == Gun then
				Gun = "Knife"
				--print("Gun set to knife")
			end
		end
		--print(Item)
	--	print(table2string(Item))
		--
		--print("UPdating lodout")
		--print("updating slot "..Gun .. " to "..Skin)	
	--	print(CTLoadoutnew["AWP"])
	--	print(TLoadoutnew["AWP"])
		local Inventory = invenData:GetAsync(tostring(player.userId))
		local exists = false		
		for i=1,#Inventory do
			if table2string(Inventory[i]) == table2string(Item) then
			--print("Item exists in inventory :)")
				exists = true			
				break
			end
		end
		if exists then
			--print("User owns this item! " ..table2string(Item))
		--	print("What user does not own that item :(")			
			if Team == "CT" or Team == "Both" and exists then
				loadoutDataCT:UpdateAsync(tostring(player.userId), function(oldValue)
						local newValue = oldValue
						newValue[Gun] = Item				
						--if SpecialOver[1] then
							if SpecialOver ~= nil  then
								--print("Now thats a special one! " ..SpecialOver[1].. " now equals "..tostring(SpecialOver[2]))
								newValue[SpecialOver[1]] = SpecialOver[2] -- tru or false
							end
						--end
					return newValue
				end)
				
				player.SkinFolder.CTFolder:FindFirstChild(Gun).Value = split(Item[1],"_")[2]
			end
			if Team == "T" or Team == "Both" and exists then
				loadoutDataT:UpdateAsync(tostring(player.userId), function(oldValue)
					local newValue = oldValue			
						newValue[Gun] = Item				
						if SpecialOver ~= nil then
							--print("Now thats a special one! " ..SpecialOver[1].. " now equals "..tostring(SpecialOver[2]))
							newValue[SpecialOver[1]] = SpecialOver[2] -- tru or false				
						end				
					return newValue
				end)
				player.SkinFolder.TFolder:FindFirstChild(Gun).Value = split(Item[1],"_")[2]
			end	
		end
	elseif args[1] == "SaveCrosshair" then
		crosshairData:SetAsync(tostring(player.userId),args[2])
	--	print('saved new crosshair')
	elseif args[1] == "BuyFunds" then
		--print ' buy funds fired '
		local funds = args[2]
		
		local idtocharge = 0
		if player.CanBuyFunds.Value == true then
			if funds == 50 then
				idtocharge = funds_50
			elseif funds == 100 then
				idtocharge = funds_100 
			elseif funds == 250 then
				idtocharge = funds_250
			elseif funds == 300 then
				idtocharge = funds_300
			elseif funds == 500 then
				idtocharge = funds_500
			elseif funds == 1000 then
				idtocharge = funds_1000
			elseif funds == 2500 then
				idtocharge = funds_2500
			end			
			MarketPlace:PromptProductPurchase(player,idtocharge)
		end
	elseif args[1] == "BuyFundsXB" then
		local funds = args[2]
	
		local idtocharge = 0
		if player.CanBuyFunds.Value == true and game.PlaceId == 2546855276 then			
		--	print(funds .. " is bought funds")
			if funds == 100 then
				--print(xbfunds_100)
				idtocharge = xbfunds_100
				--print(idtocharge)
			elseif funds == 200 then
				idtocharge = xbfunds_200 
			elseif funds == 450 then
				idtocharge = xbfunds_450
			elseif funds == 1000 then
				idtocharge = xbfunds_1000 
			elseif funds == 2500 then
				idtocharge = xbfunds_2500 
			elseif funds == 5000 then
				idtocharge = xbfunds_5000					
			end
			print(idtocharge .. " is the to charge")
			MarketPlace:PromptProductPurchase(player,idtocharge)
		end
		
		--print ' end of buy funds'
	elseif args[1] == "BuyCollection" then
		if player.CanBuyFunds.Value == true and game.PlaceId == 2546855276 then
			player.CanBuyFunds.Value = false
			local CaseName = args[2]
			local CaseFolder = game.ReplicatedStorage.Cases:FindFirstChild(CaseName)
			local PlayerFunds = currencyData:GetAsync(tostring(player.userId))
			if PlayerFunds >= CaseFolder.Available.CollectionPrice.Value then
				currencyData:UpdateAsync(tostring(player.userId), function(oldValue)
					local newValue = oldValue		
					newValue = newValue - CaseFolder.Available.CollectionPrice.Value		
					player.SkinFolder.Funds.Value = newValue
					return newValue
				end)				
				
				local Contents = {} 
				local CaseFolderCh = CaseFolder:GetChildren()
				local available
				for i=1, #CaseFolderCh do
					if CaseFolderCh[i].Name == "Available" then
						available = CaseFolderCh[i].Value
					else
						table.insert(Contents,1,CaseFolderCh[i].Name)
					end
				end
				if available then
					--print ' yes is available '
					--print(#Contents) 
					invenData:UpdateAsync(tostring(player.UserId), function(oldValue)
						local newValue = oldValue
						for i=1, #Contents do
							print(Contents[i] .. " skin added")
							local NewItem = {Contents[i],nil}
							table.insert(newValue,1,NewItem)
						end
							--table.insert(newValue,1,Skin)		
						--print("JOINED, Inventory length = "..#newValue)
						return newValue
					end)
					--print ' updated inventory '
					game.ReplicatedStorage.Events.DataEvent:FireClient(player,{"RefreshInventory"})
				end
			end
			player.CanBuyFunds.Value = true
		end
	elseif args[1] == "BuyCase" then
		--if game.VIPServerId=="" then
		if player.CanBuyFunds.Value == true then
			player.CanBuyFunds.Value = false
				
			local Case = args[2]
			--print(Case)
			if game.ServerScriptService.canbuy.Value == true then --DEBOUNCE ....... FIX LATER
				local CaseF = game.ServerStorage.Cases:FindFirstChild(Case)	
				local PlayerFunds = currencyData:GetAsync(tostring(player.userId))
				--print(player.Name .. " has " .. PlayerFunds.. " moneys")
				if PlayerFunds >= CaseF.Available.Price.Value and CaseF.Available.Value then
					currencyData:UpdateAsync(tostring(player.userId), function(oldValue)
						local newValue = oldValue		
						newValue = newValue - CaseF.Available.Price.Value		
						player.SkinFolder.Funds.Value = newValue
						return newValue
					end)
	
	--HEY DUMBASS REMEMBER TO UN-COMMENT THIS OUT
			--		print(player.Name .. " bought an item with AssetID: " .. assetId)
			--		local CaseChildren = game.ServerStorage.Cases:GetChildren()
			--		local CaseOpened = nil
			--		for i=1, #CaseChildren do
			--			print("Searching casechildren")
			--			if CaseChildren[i].Available.DevProductId.Value == assetId then
			--				CaseOpened = CaseChildren[i]
			--				print ' o ya thats the one '
			--			end
			--		end
					local CaseOpened = CaseF
					local BlueTable = {} 
					local PurpleTable = {}
					local PinkTable = {}
					local RedTable = {}
					--print(CaseOpened.Name)
					if CaseOpened ~= nil then			
						local SkinChildren = CaseOpened:GetChildren()
			
						for i=1, #SkinChildren do
							--print("searching")
							if SkinChildren[i]:IsA("StringValue") then
								if SkinChildren[i].Value == "Blue" then
									table.insert(BlueTable,1,SkinChildren[i].Name) 
								elseif SkinChildren[i].Value == "Purple" then
									table.insert(PurpleTable,1,SkinChildren[i].Name) 
								elseif SkinChildren[i].Value == "Pink" then
									table.insert(PinkTable,1,SkinChildren[i].Name) 
								elseif SkinChildren[i].Value == "Red" then
									table.insert(RedTable,1,SkinChildren[i].Name) 
								end					
							end
						end
					end
					--math.randomseed(random)
				
					local RandomE = Random.new(tick())
					
					local Chance = RandomE:NextNumber(1,2030)
				--	print(Chance)
					local ChanceForKnifeOutOf1200 = 7
					--5/1200
					if CaseF.Name == "Holiday Case" then
						 ChanceForKnifeOutOf1200 = 15
					--	print ' INCREASED CHANCES for holiday spirit :smirk:!!'
					end
					if player.Name == "ObscureScapter" then
						Chance	= 1
					end
					local Type = ""
					if Chance >= 490 then
						--blue
						Type = "Blue"
					--	print (' dats a blue ')
					elseif Chance >=  160 then
						--purple
						Type = "Purple"
					--	print(' thats a purple' )
					elseif Chance >= 55 then
						--pink
						Type = "Pink"
					--	print ' pinkie '
					elseif Chance >= ChanceForKnifeOutOf1200 then --orig 5 
						--red
						Type = "Red"
					--	print 'RED!!'
					elseif Chance >= 0 then
						--knife
					--	print ' knieeef'
						Type = "Knife"
					end
					if CaseF.Name == "Holiday Case 2" then
						Type = "Blue"
					elseif CaseF.Name == "Halloween Knife Case 2018" then
						if Type == "Pink" or Type == "Red" or Type == "Knife" then
							Type = "Blue"
						end
					end
--					if player.Name == "mightybaseplate" or player.Name=="DevRolve" then
--						Type = "Knife"
--					end
					local earnedSkin = ""
					if Type == "Blue" then
						--print(#BlueTable .. " blue table length")
						local skin = math.random(1,#BlueTable)
						--print("YEW GOT" .. BlueTable[skin])
						earnedSkin = BlueTable[skin] 
					elseif Type == "Purple" then
						local skin = math.random(1,#PurpleTable)
					--	print("YEW GOT" .. PurpleTable[skin])
						earnedSkin = PurpleTable[skin] 
					elseif Type == "Pink" then
						local skin = math.random(1,#PinkTable)
						--print("YEW GOT" .. PinkTable[skin])
						earnedSkin = PinkTable[skin]
					elseif Type == "Red" then
						local skin = math.random(1,#RedTable)
					--	print("YEW GOT" .. RedTable[skin])
						earnedSkin = RedTable[skin]
					elseif Type == "Knife" then 
						--uh oh
						local PossibleKnives = game.ServerStorage.Knives:GetChildren()
						--print(Case)
						if Case == "Karambit Case" then					
							PossibleKnives = game.ServerStorage.KarambitKnives:GetChildren()
						elseif Case == "Imaginem Case" then
							PossibleKnives = game.ServerStorage.ImaginemKnives:GetChildren()
						elseif Case == "Halloween Case" then
							PossibleKnives = game.ServerStorage.HallowsKnives:GetChildren()
						elseif Case == "Remastered Case" then
							PossibleKnives = game.ServerStorage.GloveSkins:GetChildren()
						elseif Case == "Halloween Case 2018" then
							PossibleKnives = game.ServerStorage.Halloween2018Knives:GetChildren()
							
						end
						local Selected = math.random(1,#PossibleKnives)
					--	print(PossibleKnives[Selected])
						earnedSkin = PossibleKnives[Selected].Name
						--game.Workspace.ServerFeed.Value = "WOAH!" .. player.Name.. " has unboxed a KNIFE!"
					--	print(earnedSkin) workspace.ServerFeed2.Value = tostring(player).." just unboxed a knife!" workspace.Sounds.Becky:Play()
						
					--	print ("maybe it'll post")
					end
					
					local quality = Type
					
					
					--print("quality = "..quality)
					--Roll For Stat-trak...
					earnedSkin = {earnedSkin,nil} 
					AddSkin(player.userId,earnedSkin,false)
					local underscore	= string.find(earnedSkin[1], "_")
					local name			= string.sub(earnedSkin[1], 1, underscore-1)
					local skin			= string.sub(earnedSkin[1], underscore+1, string.len(earnedSkin[1]))
					
					game.ReplicatedStorage.CrateAnimation:FireClient(player, name, skin)
					game.ReplicatedStorage.Events.DataEvent:FireClient(player,{"PurchaseCompleted",earnedSkin,quality,CaseF.Name})
					game.ReplicatedStorage.Events.DataEvent:FireClient(player,{"RefreshInventory"})
					player.CanBuyFunds.Value = true
				end
			end
		end
	--end
	end
end)

local function createCode(code, reward, timers, typer, amount)
	local timer = os.time()
	if timers > 0 then
		timer 		= getDay(timer+(86400*(timers)))
	else
		timer		= 21e8
	end
	
	if amount <= 0 then
		amount	= 21e8
	end
	
	local Data	= CodeData:GetAsync("Codes")
	
	table.insert(Data, {code, reward, typer, timer, amount})
	
	CodeData:SetAsync("Codes", Data)
end

Code.OnServerEvent:connect(function(player, code, reward, timer, typer, amount)
	--[[if player:IsInGroup(GroupId) and player:GetRankInGroup(GroupId) >= 253 then
		coroutine.wrap(function()
			createCode(code, reward, tonumber(timer), typer, tonumber(amount))
		end)()
	end]]
end)

function GivePin(UserId,Pin)
	pinData:UpdateAsync(tostring(UserId), function(oldValue)
		local newValue = oldValue		
		if newValue == nil then
			newValue = {}
		end
		table.insert(newValue,1,Pin)
		return newValue
	end)
end

function Redeem.OnServerInvoke(player, code)
	local Codes = CodeData:GetAsync("Codes")
	local timer	= os.time()
	local usercodes	= CodeData:GetAsync(player.userId)
	
	if not usercodes then
		usercodes	= {}
	end
	
	for _,v in pairs(Codes) do
		if v[1] == code then
			if v[5] <= 0 then
				return "Code Ran Out Of Copies!"
			end
			
			for _,c in pairs(usercodes) do
				if c == v[1] then
					return "Code Already Redeemed!"
				end
			end
			
			if v[4]-getDay(timer) <= 0 then
				return "Code Expired!"
			end
			
			if 	v[1] == code then
				v[5] = v[5]-1
				
				coroutine.wrap(function()
					CodeData:SetAsync("Codes", Codes)
				end)()
				
				table.insert(usercodes, v[1])
				
				if v[3] == "Funds" then
					currencyData:UpdateAsync(tostring(player.userId), function(oldValue)
						local newValue = oldValue		
						newValue = newValue + tonumber(v[2])	
						player.SkinFolder.Funds.Value = newValue
						return newValue
					end)
				elseif v[3] == "Skin" then
					local earnedSkin = {v[2]} 
					AddSkin(player.userId,earnedSkin,false)
					game.ReplicatedStorage.Events.DataEvent:FireClient(player,{"RefreshInventory"})
				else
					GivePin(player.UserId, v[2])
				end
				
				coroutine.wrap(function()
					CodeData:SetAsync(player.userId, usercodes)
				end)()
				
				return "Code Redeemed!"
			end	
		end
	end
	
	return "Code Doesn't Exist!"
end

MarketPlace.ProcessReceipt = function(receiptInfo) 
	local player=receiptInfo.PlayerId
	local assetId=receiptInfo.ProductId
	local userId = player
	player = game.Players:GetPlayerByUserId(player)
	if player.CanBuyFunds.Value == true then
		player.CanBuyFunds.Value = false	
	    -- Find the player based on the PlayerId in receiptInfo		
		local GainedFunds = 0
		local Thing = "Dev:Funds50"
		local Price = nil
		Price = receiptInfo.CurrencySpent
		if assetId == funds_50 then 
			GainedFunds = 50
			Thing = "Dev:Funds50"
		elseif assetId == funds_100 then
			GainedFunds = 100
			Thing = "Dev:Funds100"
		elseif assetId == funds_250 then
			GainedFunds = 250
			Thing = "Dev:Funds250"
		elseif assetId == funds_300 then
			GainedFunds = 300 
			Thing = "Dev:Funds300"
		elseif assetId == funds_500 then
			GainedFunds = 500
			Thing = "Dev:Funds500"
		elseif assetId == funds_1000 then
			GainedFunds = 1000 
			Thing = "Dev:Funds1000"
		elseif assetId == funds_2500 then
			GainedFunds = 2500
			Thing = "Dev:Funds2500"
		elseif assetId == xbfunds_100 then
			GainedFunds = 100
		elseif assetId == xbfunds_200 then
			GainedFunds = 200
		elseif assetId == xbfunds_450 then
			GainedFunds = 450
		elseif assetId == xbfunds_1000 then
			GainedFunds = 1000 
		elseif assetId == xbfunds_2500 then
			GainedFunds = 2500
		elseif assetId == xbfunds_5000 then
			GainedFunds = 5000
		end	
		
		currencyData:UpdateAsync(tostring(player.userId), function(oldValue)			
			local newValue = oldValue		
			newValue = newValue + GainedFunds
			player.SkinFolder.Funds.Value = newValue			
			return newValue
		end)
		
--		if game.PlaceId == 2546855276 then
--			if GainedFunds == 2500 then
--				AddSkin({"SkinHERE",nil})
--			end
--		end
		player.CanBuyFunds.Value = true	
	    return Enum.ProductPurchaseDecision.PurchaseGranted
	end
end

