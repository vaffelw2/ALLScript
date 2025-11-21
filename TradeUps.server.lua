math.randomseed(tick())

--	services

local DataStoreService	= game:GetService("DataStoreService")
local ReplicatedStorage	= game:GetService("ReplicatedStorage")

--	constants

local InventoryData	= DataStoreService:GetDataStore("Inventory", "cbrelease_2")
local Remotes		= ReplicatedStorage:FindFirstChild("Remotes")
local Inventory		= Remotes:FindFirstChild("Inventory")
local TradeUp		= Remotes:FindFirstChild("TradeUp")
local Sorting		= {
	Blue	= "Purple",
	Purple	= "Pink",
	Pink	= "Red",
}

--	functions

local function removeItem(player, item)
	local playerData = InventoryData:GetAsync(tostring(player.userId))
	
	for i,v in pairs(playerData) do
		if v[1] == item then
			table.remove(playerData, i)
			
			return true
		end
	end
	
	return false
end

local function giveItem(player, rarity, playerData)
	local options = {}
	
	for _,v in pairs(script.Rarities:GetChildren()) do
		if v.Value == rarity then
			table.insert(options, v.Name)
		end
	end
	
	local picked	= options[math.random(1, #options)]
	
	table.insert(playerData, {picked})
	
	InventoryData:SetAsync(tostring(player.userId), playerData)
	
	return picked
end

function Inventory.OnServerInvoke(player)
	return InventoryData:GetAsync(tostring(player.userId))
end

function TradeUp.OnServerInvoke(player, offers)
	if #offers == 10 then
		local rarity	= ""
		local broke		= false
		
		for _,v in pairs(offers) do
			rarity	= Sorting[script.Rarities[v].Value]
			
			local removed	= removeItem(player, v)
			
			if not removed then
				broke	= true
				break
			end
		end
		
		if not broke then
			local playerData = InventoryData:GetAsync(tostring(player.userId))
			for _,v in pairs(offers) do
				for i,c in pairs(playerData) do
					if v == c[1] then
						table.remove(playerData, i)
						
						break
					end
				end
			end
			
			local item = giveItem(player, rarity, playerData)
			
			game.ReplicatedStorage.Events.DataEvent:FireClient(player,{"RefreshInventory"})
			
			return item
		else
			return false
		end
	else
		return false
	end
end