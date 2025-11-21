wait(0.5)


function ConstructTerrain(model)
	for _,v in pairs (model:GetChildren()) do
		if v:IsA("BasePart") then
			game.Workspace.Terrain:FillBlock(v.CFrame, v.Size, Enum.Material.Water)
			v:Destroy()
		end
	end
end
ConstructTerrain(script.Parent.TerrainParts.Water)

script:Destroy()