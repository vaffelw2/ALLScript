wait(0.5)

local click = game:GetService("ReplicatedStorage"):WaitForChild("Other"):WaitForChild("Click")
local buttonClick = game:GetService("ReplicatedStorage"):WaitForChild("Other"):WaitForChild("ButtonClick")

for i, v in pairs (script.Parent:WaitForChild("ROBLOXians"):GetChildren()) do
	if v:IsA("Frame") then
		for j, k in pairs (v:GetChildren()) do
			if k:IsA("TextButton") and k.Name ~= "Tag" then
				buttonClick:Clone().Parent = k
			end
		end
	elseif v:IsA("TextButton") then
		click:Clone().Parent = v
	end
end