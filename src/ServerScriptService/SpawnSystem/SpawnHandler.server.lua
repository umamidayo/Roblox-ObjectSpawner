local spawner = require(script.Parent.SpawnModule)

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		spawner.SetTimeDifference(player)
	end)
end)

game.ReplicatedStorage.Remotes.SpawnCollect.OnServerEvent:Connect(function(player, clientObject)
	local serverObject = game.ServerStorage:FindFirstChild(clientObject.Name)
	
	if serverObject then
		spawner.Collect(player, clientObject, serverObject)
	end
end)

while true do
	spawner.Spawn(game.ServerStorage.Bobux, 200, 100)
	spawner.Spawn(game.ServerStorage.Goldbux, 20, 25)
	spawner.Spawn(game.ServerStorage.Cola, 5, 25)
	spawner.Spawn(game.ServerStorage.Diamond, 1, 10)
	task.wait()
end