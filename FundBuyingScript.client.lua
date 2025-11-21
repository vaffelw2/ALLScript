local Children = script.Parent:GetChildren()
for i=1, #Children do
	if Children[i]:IsA("TextButton") then --if you redesign, be smart you know what this does
		Children[i].MouseButton1Down:connect(function()
			--print ' lil pressie '
			game.ReplicatedStorage.Events.DataEvent:FireServer({"BuyFunds",tonumber(Children[i].Name)})
			--print ' pressie finessed'
		end)
	end
end
