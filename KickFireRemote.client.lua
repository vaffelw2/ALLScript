script.Parent.MouseButton1Down:Connect(function()
	if script.Parent.Parent.Username.Text == "" or script.Parent.Parent.Reason.Text == "" then
	else
		script.Disabled = true
		game.ReplicatedStorage.Ban:FireServer("Kick",script.Parent.Parent.Username.Text,script.Parent.Parent.Reason.Text)
		wait(2)
		script.Disabled = false
	end
end)