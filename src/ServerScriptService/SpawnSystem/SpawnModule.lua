local module = {}

local debris = game:GetService("Debris")
local DataStore2 = require(game.ServerScriptService.DataStore2)
DataStore2.Combine("MainKey1", "Bobux")

module.objectPositions = {}
module.collectTime = {}
module.lastPosition = {}
module.spawns = {}
module.spawnLimits = {}
module.spawnChance = {}
module.boostDuration = {}

module.Values = {
	["Bobux"] = 10,
	["Goldbux"] = 100,
	["Cola"] = 0,
	["Diamond"] = 500,
}

function module.Spawn(serverObject, spawnLimit, spawnChance)
	if module.spawns[serverObject] == nil and serverObject then module.spawns[serverObject] = 0 end
	if module.spawnLimits[serverObject] == nil and spawnLimit then module.spawnLimits[serverObject] = spawnLimit end
	if module.spawnChance[serverObject] == nil and spawnChance then module.spawnChance[serverObject] = spawnChance end
	if module.spawns[serverObject] >= module.spawnLimits[serverObject] then return end
	if math.random(0, 100) > module.spawnChance[serverObject] then return end
	
	local newObject = serverObject:Clone()
	newObject.Parent = workspace.Spawns
	newObject.Position = Vector3.new(math.random(-200, 200), 3, math.random(-200, 200))
	module.spawns[serverObject] += 1
end

function module.Speedboost(player, boostgui)
	while module.boostDuration[player] > 0 do
		if player.Character:FindFirstChild("HumanoidRootPart") == nil then
			repeat task.wait() until player.Character:FindFirstChild("HumanoidRootPart")
		end
		
		if player.Character.Humanoid.Health <= 0 then player.CharacterAdded:Wait() end
		
		if boostgui.Parent ~= player.Character.HumanoidRootPart then
			boostgui.Parent = player.Character.HumanoidRootPart
		end
		
		boostgui.Duration.Text = module.boostDuration[player]
		
		if player.Character.Humanoid.Health > 0 then
			player.Character.Humanoid.WalkSpeed = game.StarterPlayer.CharacterWalkSpeed * 2
		end
		
		task.wait(1)
		module.boostDuration[player] -= 1
	end
	
	player.Character.Humanoid.WalkSpeed = game.StarterPlayer.CharacterWalkSpeed
	boostgui.Duration.Text = ""
end

function module.Collect(player, clientObject, serverObject)
	if clientObject.Parent ~= workspace.Spawns then return end
	if module.boostDuration[player] == nil then module.boostDuration[player] = 0 end
	local speed = module.GetTimeDifference(player, clientObject.Position)
	if speed > (game.StarterPlayer.CharacterWalkSpeed + 20) and module.boostDuration[player] <= 0 then return end
	local bobuxStore = DataStore2("Bobux", player)
	bobuxStore:Increment(module.Values[serverObject.Name])
	module.spawns[serverObject] -= 1
	module.SetTimeDifference(player)
	debris:AddItem(clientObject, 0)
	
	game.ReplicatedStorage.Remotes.SpawnCollect:FireClient(player)
	
	if serverObject.Name == "Cola" then
		local boostgui = player.Character.HumanoidRootPart:FindFirstChild("BoostGui")

		if boostgui == nil then
			boostgui = game.ServerStorage.BoostGui:Clone()
			boostgui.Parent = player.Character.HumanoidRootPart
		end

		boostgui.Duration.Text = module.boostDuration[player]
		
		if module.boostDuration[player] <= 0 then
			module.boostDuration[player] += 5
			task.spawn(function()
				module.Speedboost(player, boostgui)
			end)
		else
			module.boostDuration[player] += 10
			boostgui.Duration.Text = module.boostDuration[player]
		end
	end
end

function module.SetTimeDifference(player)
	module.collectTime[player] = tick()
	module.lastPosition[player] = player.Character.HumanoidRootPart.Position
end

function module.GetTimeDifference(player, position)
	local tickDiff = tick() - module.collectTime[player]
	local magnitude = (module.lastPosition[player] - position).Magnitude
	local speed = magnitude / tickDiff
	return speed
end

return module
