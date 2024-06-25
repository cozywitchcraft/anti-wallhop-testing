local MAX_SIZE = 1040

local camera = workspace.CurrentCamera

local uiScale = script.Parent:WaitForChild("UIScale")

local function onViewportSizeChanged()
	uiScale.Scale = math.min(camera.ViewportSize.X / MAX_SIZE, 1)
end

camera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged)

onViewportSizeChanged()
