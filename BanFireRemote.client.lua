script.Parent.MouseButton1Down:Connect(function()
	if script.Parent.Parent.Username.Text == ""  or script.Parent.Parent.Reason.Text =="" or script.Parent.Parent.Time.Text == "" then
	else
		script.Disabled = true 
		game.ReplicatedStorage.Ban:FireServer("Ban",script.Parent.Parent.Username.Text,script.Parent.Parent.Reason.Text,script.Parent.Parent.Time.Text)
		wait(2)
		script.Disabled = false
		print("Banned User Named: "..script.Parent.Parent.Username.Text)
	end
end)