local debounce = false

script.Parent.Touched:connect(function(p)
	if not game.Workspace:WaitForChild("Status"):WaitForChild("Preparation").Value and script.Parent.Velocity.magnitude > math.max(script.Parent.Size.X,script.Parent.Size.Y,script.Parent.Size.Z) then
		local humanoid = nil
		if p and p.Parent:FindFirstChild("Humanoid") then
			humanoid = p.Parent:FindFirstChild("Humanoid")
		end
		if p and p.Parent.Parent:FindFirstChild("Humanoid") then
			humanoid = p.Parent.Parent:FindFirstChild("Humanoid")
		end
		if humanoid and script.Parent.creator.Value ~= nil and script.Parent.creator.Value.Name and humanoid.Parent.Name ~= script.Parent.creator.Value.Name then
			if script.Parent:FindFirstChild("BodyPosition") == nil then
				if script.Parent.creator.Value ~= nil then
					if humanoid:FindFirstChild("creator") then
						humanoid.creator:Destroy()
					end
					local person = script.Parent.creator:clone()
					person.Parent = humanoid
					game.Debris:AddItem(person, 1)
					local piece = Instance.new("StringValue")
					piece.Parent = person
					piece.Name = "NameTag"
					piece.Value = "Prop"
					local piece=Instance.new("StringValue")
					piece.Parent = humanoid
					piece.Name = "Propped"
					piece.Value = "Prop"
					game.Debris:AddItem(piece, 1)
					script.Parent.creator.Value = nil
				end
				local Damage = math.min(120,script.Parent.Velocity.magnitude/4) * script.Parent:GetMass()
				humanoid:TakeDamage(Damage*2)
				debounce = true
				script.Parent.Break.Pitch = 1 + (Damage/100)
				script.Parent.Break:Play()
				--script.Parent.Velocity = script.Parent.Velocity + (Vector3.new(math.random(-50,50), math.random(30,70), math.random(-50,50)))
				wait(.1)
				debounce = false
			end
		end
	end
	
	if not p:IsDescendantOf(game.Workspace:WaitForChild("Ray_Ignore")) then
		if script.Parent.creator.Value ~= nil and script.Parent.creator.Value.Name then
			if not script.Parent.creator.Value.Character or script.Parent.creator.Value.Character and not p:IsDescendantOf(script.Parent.creator.Value.Character) then
				script.Parent.creator.Value = nil
			end
		end
	end
end)
