function destroy()
	for i,v in pairs(script.Parent:GetChildren()) do
		if v:IsA("TextButton") then
			v:destroy()
		end
	end
end

function update()
	destroy()
	for i,v in pairs(game.Players:GetChildren()) do
		local cl = script.Template:Clone()
		cl.Name = v.Name
		cl.Text = v.Name
		cl.Parent = script.Parent
	end
end

while wait(0.5) do
	update()
end