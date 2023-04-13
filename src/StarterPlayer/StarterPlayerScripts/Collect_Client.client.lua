if game:IsLoaded() == false then game.Loaded:Wait() end

local soundService = game:WaitForChild("SoundService")
local debris = game:GetService("Debris")

local sounds = {
	["Bobux"] = soundService:WaitForChild("BobuxCollect"),
	["Goldbux"] = soundService:WaitForChild("GoldbuxCollect"),
	["Cola"] = soundService:WaitForChild("ColaCollect"),
	["Diamond"] = soundService:WaitForChild("DiamondCollect")
}

local emitAmounts = {
	["Bobux"] = 1,
	["Goldbux"] = 1,
	["Cola"] = 1,
	["Diamond"] = 1
}

local particles = {
	["Bobux"] = game.ReplicatedStorage:WaitForChild("Particles").Bobux.Attachment:Clone(),
	["Goldbux"] = game.ReplicatedStorage:WaitForChild("Particles").Goldbux.Attachment:Clone(),
	["Cola"] = game.ReplicatedStorage:WaitForChild("Particles").Flash.Attachment:Clone(),
	["Diamond"] = game.ReplicatedStorage:WaitForChild("Particles").Diamond.Attachment:Clone()
}

local function collectFX(particle, sound, emitAmount)
	for i,v in pairs(particle:GetChildren()) do
		if v:IsA("ParticleEmitter") then
			v:Emit(emitAmount)
		end
	end
	
	sound:Play()
end

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
	for i,v in pairs(particles) do
		v.Parent = character:WaitForChild("HumanoidRootPart")
	end
	
	character:WaitForChild("HumanoidRootPart").Touched:Connect(function(hit)
		if hit.Parent == workspace.Spawns then
			game.ReplicatedStorage.Remotes.SpawnCollect:FireServer(hit)
			game.ReplicatedStorage.Remotes.SpawnCollect.OnClientEvent:Wait()
			collectFX(particles[hit.Name], sounds[hit.Name], emitAmounts[hit.Name])
		end
	end)
end)