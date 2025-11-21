--this script has been optimized by oozlebachr's optimizer !!!!

--====================BEGIN OPTIMIZATIONS

--==========BEGIN FUNCTIONS:
--a total of 2 functions have been replaced with local variables
local sgsub = string.gsub
local ssub = string.sub
--==========END FUNCTIONS

--====================END OPTIMIZATIONS

wait()

local name, num = sgsub(script.Parent.Parent.Name, "Button", "")

script.Parent.Changed:connect(function()
	if script.Parent.Value == true then
		for i, v in pairs (script.Parent.Parent.Parent:GetChildren()) do
			if v:IsA("Frame") then
				if tonumber(ssub(v.Name, 7)) > tonumber(ssub(name, 7)) then
					v.Position = v.Position + UDim2.new(0, 0, 0, 30)
				end
			elseif v:IsA("TextButton") then
				local name2, num2 = sgsub(v.Name, "Button", "")
				if tonumber(ssub(name2, 7)) > tonumber(ssub(name, 7)) then
					v.Position = v.Position + UDim2.new(0, 0, 0, 30)
				end
			end
		end
	else
		for i, v in pairs (script.Parent.Parent.Parent:GetChildren()) do
			if v:IsA("Frame") then
				if tonumber(ssub(v.Name, 7)) > tonumber(ssub(name, 7)) then
					v.Position = v.Position - UDim2.new(0, 0, 0, 30)
				end
			elseif v:IsA("TextButton") then
				local name2, num2 = sgsub(v.Name, "Button", "")
				if tonumber(ssub(name2, 7)) > tonumber(ssub(name, 7)) then
					v.Position = v.Position - UDim2.new(0, 0, 0, 30)
				end
			end
		end
	end
end)