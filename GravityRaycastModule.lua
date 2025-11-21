--[[
	Handles the computation of parabolic paths, aiming towards efficiency and leaving other implementation
	to the user. 
	
	Working (open source) example of this module can be found at: https://www.roblox.com/games/33516870/G
	

				
		shoot()
			Handles the computation of a projectile on a parabolic path.
			This function will compute the travel path of the projectile in real time, 
			yielding until the projectile's path has ended.
				origin - (Vector3) starting position of the projectile
				dir - (Vector3) direction of the projectile 
				speed - (scalar) speed of the projectile in ft/s
				gravity - (Vector3) force of gravity applied to the projectile's velocity
						Forces can be applied in all directions, not just downward; this allows for simulation of wind, etc.
				ignore - table of objects that should be ignored during raycasting collision
				func_step - (function) a callback called once per 'step' of the projectile
						This callback is called with the parameters func_step(lastPos, pos)
						lastPos and pos being the previous and current positions of the projectile.	
						
						This callback should return a true or false value: true indicating that computation of
						the projectile should continue, and false indicating that it should not. (projectile 'dies')
						
						TODO: Consider possibility of optional tuple to pass miscellaneous values, providing an easy
						way for the func_step to be defined a single time earlier in the script and still access
						projectile variables, etc.
--]]

local module = {}


local rs = game:GetService("RunService")
module.shoot = function(origin, dir, speed, gravity, ignore, func_step,bullettime) 	
	-- (This has been replaced with a delta based system but will remain until the impact has been adequately determined.)
	-- Assume that each step will take exactly 1/30 of a second
	-- This is false but increases performance and vastly simplifies the script

	local lastPos = origin
	local pos = origin
	local vel = dir.unit * speed -- Call .unit in case it was not called by the user
	local drop = Vector3.new(0, 0, 0) -- Begin with no deviation due to 'gravity'
	local hit
	local normal
	local delta = rs.RenderStepped:wait()
    local timestart=tick()
	-- Failing to return a value in func_step (thus nil) will instantly kill the projectile
	while func_step(lastPos, pos) do
		lastPos = pos
		hit, pos,normal = game.Workspace:FindPartOnRayWithWhitelist(Ray.new(lastPos, vel * delta + drop), ignore, false, true)
		if hit and hit:IsA("Terrain") or hit and hit:IsA("BasePart") and hit.Transparency==0 and hit.Parent:FindFirstChild("Humanoid") or hit and hit:IsA("BasePart") and hit.Transparency==0 and hit.CanCollide==true then
if hit and hit.Parent and hit.Parent.className and hit.Parent.className~="Accessory" then			
			return lastPos, pos, hit, normal
			end
		end
		drop = drop + gravity * delta
		delta = rs.RenderStepped:wait()
        if (tick()-timestart)>=bullettime then
return lastPos, pos, hit, normal
end
	end
end

return module