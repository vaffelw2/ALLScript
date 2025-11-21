whitelist ={
	110072972,
	296138400,
	162098911,
	
}

game.Players.PlayerAdded:Connect(function(player)
	print(player:GetRankInGroup(14430710))
	if not (player:GetRankInGroup(14430710) >= 0) then
		local canjoin = false	
		for i=1, #whitelist do			
			if player.userId == whitelist[i] then
				canjoin = true
				break
			end
		end
		if canjoin == false then
			player:Kick()
			wait(math.huge)
		end		
	end
end)