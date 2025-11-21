local Cnew = Color3.new
local rs = game:GetService("RunService")

game.Players.PlayerAdded:connect(function(player)
	rs.Heartbeat:wait()
	for i, v in pairs (game.Players:GetPlayers()) do
		rs.Heartbeat:wait()
		if v.Name ~= player.Name then
			local playerName = Instance.new("StringValue", v:WaitForChild("Tags"))
			playerName.Name = player.Name
			playerName.Value = player.Name
			local tag = Instance.new("StringValue", playerName)
			tag.Name = "Tag"
			tag.Value = ""
			local color = Instance.new("Color3Value", playerName)
			color.Name = "TagColor"
			color.Value = Cnew(255, 255, 255)
		else
			local tags = Instance.new("Folder", player)
			tags.Name = "Tags"
			for j, k in pairs (game.Players:GetPlayers()) do
				rs.Heartbeat:wait()
				local playerName = Instance.new("StringValue", tags)
				playerName.Name = k.Name
				playerName.Value = k.Name
				local tag = Instance.new("StringValue", playerName)
				tag.Name = "Tag"
				tag.Value = ""
				local color = Instance.new("Color3Value", playerName)
				color.Name = "TagColor"
				color.Value = Cnew(255, 255, 255)
			end
		end
	end
end)

game.Players.PlayerRemoving:connect(function(player)
	for i, v in pairs (game.Players:GetPlayers()) do
		local playerName = v:WaitForChild("Tags"):FindFirstChild(player.Name)
		if playerName then
			playerName:ClearAllChildren()
			playerName:Destroy()
		end
	end
end)