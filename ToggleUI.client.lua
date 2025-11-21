local uis = game:GetService("UserInputService")
local Group_ID = 14673267

uis.InputBegan:Connect(function(input)
	if game.Players.LocalPlayer:IsInGroup(Group_ID) then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.RightBracket then		
				if script.Parent.Parent.Parent.GUI.Main.GlobalChat.ActiveOne.Value == false then
					script.Parent.Visible = not script.Parent.Visible		
				end	
			end
		end
	end
end)