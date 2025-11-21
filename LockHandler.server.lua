game.Players.PlayerAdded:Connect(function(plr)
	if _G.Locked == true then
		plr:Kick("\n This server is currently Locked, Try again later!")
	elseif _G.Locked == false then
		print(plr.Name.." has Joined the game!")
	end
end)