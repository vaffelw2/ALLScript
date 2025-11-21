local DataStore = game:GetService("DataStoreService"):GetDataStore("CHANGETHIS")

game.Players.PlayerAdded:Connect(function(player)
	local key = "player-"..player.UserId

	local savedValues = DataStore:GetAsync(key)

	local statsFolder = Instance.new("Folder", player)
	statsFolder.Name = "Stats"

	if(savedValues) then		
		for i,v in pairs(script.Stats:GetChildren()) do
			local stat = Instance.new(v.ClassName, player.Stats)
			stat.Name = v.Name
		end

		for i,v in pairs(player.Stats:GetChildren()) do
			v.Value = savedValues[i]
		end
	else	 
		local save = {} 
		for i,v in pairs(script.Stats:GetChildren()) do
			local stat = Instance.new(v.ClassName, player.Stats)
			stat.Name = v.Name
			table.insert(save, stat.Value)
		end
		DataStore:SetAsync(key, save)
	end

end)

game.Players.PlayerRemoving:Connect(function(player)
	local key = "player-"..player.UserId

	local save = {}

	for i,v in pairs(player.Stats:GetChildren()) do
		table.insert(save, v.Value)
	end
	DataStore:SetAsync(key, save)

end)


