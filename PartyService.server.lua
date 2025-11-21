-- Copyright @CloneTrooper1019, 2014
-- Server-side Party Manager & Operator
-- Also the map data holder.
--[[
serverData = game:GetService("DataStoreService"):GetDataStore("VIPData")
local self   = game.ReplicatedStorage:WaitForChild("PartyService")
create = self:WaitForChild("CreateParty")
join   = self:WaitForChild("JoinParty")
getp   = self:WaitForChild("GetParties")
getm   = self:WaitForChild("GetMapData")
leave  = self:WaitForChild("LeaveParty")
event  = self:WaitForChild("PartyEvent")
hstart = self:WaitForChild("HostStart")
http   = game:GetService("HttpService")
asset  = game:GetService("AssetService")

mapData = {
   	{	Name     = "Casual"; 
		PlaceID  = 9198438999;
		Image    = 0;
	};
	{	Name     = "Competitive";
		PlaceID  = 1069912173;
		Image    = 0;
	};
	{	Name     = "Trouble in Robloxity";
		PlaceID  = 1069912173;
		Image    = 0;
	};
};

partyData = {}

function DestroyParty(identity,reason)
	reason = reason or "N/A"
	if partyData[identity] then
		partyData[identity] = nil
		event:FireAllClients("PartyDestroyed",identity)
		print("PARTY DESTROYED: "..identity.."(Reason: "..reason..")")
	end
end

function isRealServer()
	for _,v in pairs(game.Players:GetPlayers()) do
		if v.userId <= 0 and not string.find(v.Name,"Guest ") then
			return false
		end
	end
	return true
end

function getMapData(map)
	for k,v in pairs(mapData) do
		if v.Name == map then
			return v,k
		end
	end
end

create.OnServerEvent:connect(function (partyHost,partyName,maxPlayers,password,mapName)
	if partyHost==nil or type(partyName) ~= "string" or type(maxPlayers) ~= "number" or type(password) ~= "string" or type(mapName) ~= "string" then return end
	local myMap,mapIndex = getMapData(mapName)
	if not myMap then
		myMap = mapData[1]
		mapIndex = 1
	end
	myMap = mapData[2]
	maxPlayers = math.min(16,math.max(1,math.floor(maxPlayers)))
	partyID = http:GenerateGUID() -- Used as a unique identifier in case two parties share the same name :/
	local newParty = {}
	newParty.PartyName = "  "..game.Chat:FilterStringForBroadcast(partyName,partyHost)
	newParty.MaxPlayers = maxPlayers;  
	newParty.Password=password;
	local placeName = myMap.Name.." Server"
	local TS = game:GetService("TeleportService")
	local placeID = TS:ReserveServer(myMap.PlaceID)
	print(placeID)
	newParty.Host = partyHost
	newParty.HostName=partyHost.Name
	newParty.Identity = partyID
	newParty.Players = {}
	newParty.placeID=myMap.PlaceID
	newParty.GameID = placeID
	newParty.Map = mapIndex
	newParty.MapName=mapName
	partyData[partyID] = newParty
	event:FireAllClients("NewParty",newParty)
	event:FireClient(partyHost,"OwnerCode",placeID)
	print("New Party Created: "..partyName.." - Identity ID: "..partyID)
	game.Players.PlayerRemoving:connect(function (p)
		if p == newParty.Host then
			event:FireAllClients("PartyDestroyed",partyID)
			DestroyParty(partyID,"Host disconnected")
		end
	end)
	hstart.OnServerEvent:connect(function (host,partyID)
		print("setting data...")
		print(myMap.PlaceID)
		serverData:SetAsync(tostring(myMap.PlaceID),{"true",host.userId,})
		print("esketit")
		wait(3)
		local party = partyData[partyID]
		if party then
			if party.Host == newParty.Host then
				print("teleporting my boy"..newParty.Host.Name)
				event:FireAllClients("PartyTeleport",partyID,placeID,party,myMap.PlaceID)
				local plastics={}
				for i=1,#party.Players do
					table.insert(plastics,party.Players[i])
				end
				table.insert(plastics,partyHost)
				TS:TeleportToPrivateServer(myMap.PlaceID,placeID,plastics,nil,nil, game.ReplicatedStorage.Loading)
				DestroyParty(partyID,"Teleporting party to place")
			end
		end
	end)
	spawn(function()
		while wait(0.1) do
			for k,v in pairs(newParty.Players) do
				if not v or v.Parent == nil then
					table.remove(newParty.Players,k)
					event:FireAllClients("PlayerPartyLeave",v,partyID)
				end
			end
		end
	end)
end)

join.OnServerInvoke = function (user,partyID,password)
	local party = partyData[partyID]
	if not party then
		return false,"Error: Party not found!"
	elseif #party.Players >= party.MaxPlayers-1 then
		return false,"Error: Party is full!"
	elseif party.Password~="" and party.Password~=password  then
		return false,"Error: Invalid password!"
	else
		wait(1) -- Confirm it still exists
		if partyData[partyID] then
			table.insert(party.Players,user)
			event:FireAllClients("PlayerPartyJoin",user,party)
			print("Player: "..user.Name.." added to party: "..partyID)
		end
	end
end

game.ReplicatedStorage.PartyService.JoinExisting.OnServerEvent:connect(function(player,id)
	player = {player}
	local TS = game:GetService("TeleportService")
	TS:TeleportToPrivateServer(9198438999,id,player,nil,nil, game.ReplicatedStorage.Loading)
end)
leave.OnServerInvoke = function (user,partyID)
	local party = partyData[partyID]
	if party then
		local removed = false
		if user == party.Host then
			event:FireAllClients("PartyDestroyed",partyID)
			DestroyParty(partyID,"Host disconnected")
		else
			for k,v in pairs(party.Players) do
				if v == user then
					removed = true
					table.remove(party.Players,k)
				end
			end
		end
		if removed then
			event:FireAllClients("PlayerPartyLeave",user,partyID)
			print("Player: "..user.Name.." removed from party: "..partyID)
		end
	end
	event:FireAllClients("PlayerPartyLeave",user,partyID)
end

getp.OnServerInvoke = function () return partyData end
getm.OnServerInvoke = function () return mapData   end]]