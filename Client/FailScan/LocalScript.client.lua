wait()

wait(1)
while script.Parent.TextTransparency ~= 1 do
	script.Parent.TextTransparency = script.Parent.TextTransparency + 0.1
	wait(0.2)
end
script.Parent:Destroy()