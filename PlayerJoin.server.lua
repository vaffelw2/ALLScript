local dss = game:GetService("DataStoreService")
local TimedBans = dss:GetDataStore("TimedBans")

game.Players.PlayerAdded:Connect(function(plr)
	
	local data = TimedBans:GetAsync(plr.UserId)
	if data and data[1] == plr.UserId then
		
		if os.time() >= data[3] then
			print(os.time())
			TimedBans:SetAsync(plr.UserId,{".",".","."})
		else
			local d = data[3] - os.time()
			local s = d/86400
			local f = math.round(s)
			plr:Kick("\nYou've Been Banned By: RAC\nFor The Reason of: "..data[2].."\n"..f.." Days Remaining Until Unban")
		end
	end
	wait(5)
	while wait(10) do
		if game.Players:FindFirstChild(plr.Name) then
			local data = TimedBans:GetAsync(plr.UserId)
			if data ~= nil then
				if data[1] == plr.UserId then
					local d = data[3] - os.time()
					local s = d/86400
					local f = math.round(s)
					plr:Kick("\nYou've Been Banned By: RAC\nFor The Reason of: "..data[2].."\n"..f.." Days Remaining Until Unban")
					game.Workspace.RacBanFeed.Value = plr.Name
				end
			end
		end
	end
end)