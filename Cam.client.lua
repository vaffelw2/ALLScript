repeat wait() until workspace.CurrentCamera and game.Players.LocalPlayer
local hum=game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
local shithead=nil
local killer=nil
local deathcam=false
if hum and hum:FindFirstChild("creator") then
killer=hum.creator.Value
end
local lookAt
local position
local camera=workspace.CurrentCamera
local camerashit=game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("mecameramyboy")
local firstshit=false
local debounce=false
				camera.CameraType = Enum.CameraType.Custom
				camera.CameraSubject=camerashit
cframenew = CFrame.new
raynew = Ray.new
tweeninfonew = TweenInfo.new
game:GetService("RunService").RenderStepped:connect(function()
local deley=0
if hum and hum.Parent and hum.Parent:FindFirstChild("Head") then
	shithead=hum.Parent.Head
end
				if workspace and workspace:FindFirstChild("Debris") and workspace.Debris:FindFirstChild(game.Players.LocalPlayer.Name) and workspace.Debris[game.Players.LocalPlayer.Name]:FindFirstChild("Head") then
					shithead=workspace.Debris[game.Players.LocalPlayer.Name].Head
				end
				if deathcam==true and killer and killer.Name then
					if killer and workspace and workspace:FindFirstChild("Debris") and workspace.Debris:FindFirstChild(killer.Name) and workspace.Debris:FindFirstChild(killer.Name):FindFirstChild("Head") then
						shithead=workspace.Debris[killer.Name].Head
					end
					if workspace:FindFirstChild(killer.Name) and workspace[killer.Name]:FindFirstChild("Head") then
						shithead=workspace[killer.Name].Head
					end
				end
				if shithead then
					if game.ReplicatedStorage.gametype.Value=="TTT" then
						camerashit.CFrame=shithead:GetRenderCFrame()*cframenew(0,0,-0.5)
						camera.CoordinateFrame=camerashit.CFrame
						return
					end
					if firstshit==false then
					firstshit=true
					camerashit.CFrame=shithead.CFrame
					else
						if debounce==false then
 							deley=(shithead.Position-camera.CoordinateFrame.p).magnitude/200
							if deley>.1 then
								local tweenInfo = tweeninfonew(
									deley,								-- Length of an interpolation
									Enum.EasingStyle.Sine,		-- Easing Style of the interpolation
									Enum.EasingDirection.Out,		-- Easing Direction of the interpolation
									0,								-- Number of times the sequence will be repeated
									false,							-- Should the sequence play in reverse as well?
									0								-- Delay between each interpolation (including reverse)
								)
								
								
								game:GetService("TweenService"):Create(camerashit,tweenInfo,{CFrame=shithead:GetRenderCFrame()}):Play()
								debounce=true
								delay(deley,function()
									debounce=false
								end)
							else
								camerashit.CFrame=shithead:GetRenderCFrame()
							end
						end
					end
				end
				local ray = raynew(camerashit.CFrame.p, camera.CFrame.p - camerashit.CFrame.p)
				local hit, position, normal = workspace:FindPartOnRayWithWhitelist(ray, {workspace.Map.Geometry})
				if hit and position and deley<=.1 then
					camera.CoordinateFrame=cframenew(position, camerashit.Position)
				end
end)
wait(1.5)
if game.ReplicatedStorage.gametype.Value~="TTT" then
	deathcam=true
end
