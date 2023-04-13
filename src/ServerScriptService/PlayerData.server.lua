local DataStore2 = require(game.ServerScriptService.DataStore2)
DataStore2.Combine("MainKey1", "Bobux")

game.Players.PlayerAdded:Connect(function(player)
	local bobuxStore = DataStore2("Bobux", player)
	local leaderstats = player:WaitForChild("leaderstats")
	local bobux = leaderstats:WaitForChild("Bobux")
	
	local function bobuxUpdate(updatedValue)
		bobux.Value = bobuxStore:Get(updatedValue)
	end
	
	bobuxUpdate(0)
	
	bobuxStore:OnUpdate(bobuxUpdate)
end)