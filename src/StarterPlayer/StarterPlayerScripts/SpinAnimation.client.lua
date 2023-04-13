local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local bobuxTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

local rotating = nil

local function rotate(object)
	TS:Create(object, bobuxTweenInfo, {CFrame = object.CFrame * CFrame.Angles(0, math.rad(45), 0)}):Play()
end

RS.RenderStepped:Connect(function()
	if rotating == true then return end
	rotating = true
	
	task.spawn(function()
		local objects = workspace.Spawns:GetChildren()
		
		for i,v in pairs(objects) do
			rotate(v)
		end
	end)
	
	task.wait(0.3)
	rotating = nil
end)