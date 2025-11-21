local parts = script.Parent:GetChildren()
for i = 1, #parts do
	if parts[i]:IsA("BasePart") then
		if parts[i].Anchored == false then
			local dink=Instance.new("StringValue")
			dink.Name="Origin"
			dink.Value=parts[i].Name
			dink.Parent=parts[i]
			parts[i].Name = "Prop"
			local items = script:GetChildren()
			for p=1,#items do
				local item = items[p]:clone()
				item.Parent = parts[i]
				if items[p].ClassName == "Script" then
					item.Disabled = false
				end
			end
		end
	end
end
