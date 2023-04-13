game.Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	
	local bobux = Instance.new("IntValue")
	bobux.Name = "Bobux"
	bobux.Parent = leaderstats
	
	leaderstats.Parent = player
end)