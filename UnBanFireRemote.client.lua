script.Parent.MouseButton1Down:Connect(function()
	if script.Parent.Parent.Username.Text == "" then
	else
		script.Disabled = true 
		game.ReplicatedStorage.Ban:FireServer("Unban",script.Parent.Parent.Username.Text)
		wait(2)
		script.Disabled = false
		print("UnBanned User Named: "..script.Parent.Parent.Username.Text)
	end
end)