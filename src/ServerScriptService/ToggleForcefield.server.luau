local ReplicatedStorage = game:GetService("ReplicatedStorage")

local forcefieldToggled = ReplicatedStorage.ForcefieldToggled

local function removeForcefields(character: Model)
	for _, instance in character:GetChildren() do
		if instance.ClassName == "ForceField" then
			instance:Destroy()
		end
	end
end

forcefieldToggled.OnServerEvent:Connect(function(player, isForcefieldEnabled: boolean)
	local character = player.Character

	if not character then
		return
	end

	if isForcefieldEnabled then
		local forcefield = Instance.new("ForceField")
		forcefield.Parent = character
	else
		removeForcefields(character)
	end
end)
