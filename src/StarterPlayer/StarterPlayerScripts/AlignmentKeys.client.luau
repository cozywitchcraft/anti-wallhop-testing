local ContextActionService = game:GetService("ContextActionService")

local NUDGE = 1e-5

local SNAP_PITCH = math.pi / 8
local SNAP_YAW = math.pi / 4

local PITCH_MIN = math.rad(10)
local PITCH_MAX = math.rad(170)

local currentCamera = workspace.CurrentCamera

local function snapAngle(theta: number, snap: number, add: boolean): number
	local alpha = theta / snap
	local newAlpha

	if add then
		newAlpha = math.ceil(alpha + NUDGE)
	else
		newAlpha = math.floor(alpha - NUDGE)
	end

	return newAlpha * snap
end

local function alignCameraYaw(left: boolean)
	local cframe = currentCamera.CFrame
	local focus = currentCamera.Focus

	local _, yaw, _ = cframe:ToOrientation()
	local newYaw = snapAngle(yaw, SNAP_YAW, left)

	local offset = CFrame.fromOrientation(0, newYaw - yaw, 0)

	currentCamera.CFrame = focus:ToWorldSpace(offset * focus:ToObjectSpace(cframe))
end

local function alignCameraPitch(down: boolean)
	local cframe = currentCamera.CFrame
	local focus = currentCamera.Focus

	local pitch = math.acos(cframe.LookVector:Dot(Vector3.yAxis))
	local newPitch = math.clamp(snapAngle(pitch, SNAP_PITCH, down), PITCH_MIN, PITCH_MAX)

	local offset = CFrame.fromAxisAngle(cframe.RightVector, pitch - newPitch)

	currentCamera.CFrame = focus:ToWorldSpace(offset * focus:ToObjectSpace(cframe))
end

local function handleAction(actionName: string, inputState: Enum.UserInputState)
	if inputState ~= Enum.UserInputState.Begin then
		return Enum.ContextActionResult.Pass
	end

	if actionName == "AlignLeft" then
		alignCameraYaw(true)
	elseif actionName == "AlignRight" then
		alignCameraYaw(false)
	elseif actionName == "AlignDown" then
		alignCameraPitch(true)
	elseif actionName == "AlignUp" then
		alignCameraPitch(false)
	end

	return Enum.ContextActionResult.Sink
end

ContextActionService:BindAction("AlignLeft", handleAction, false, Enum.KeyCode.Comma)
ContextActionService:BindAction("AlignRight", handleAction, false, Enum.KeyCode.Period)

ContextActionService:BindAction("AlignDown", handleAction, false, Enum.KeyCode.PageDown)
ContextActionService:BindAction("AlignUp", handleAction, false, Enum.KeyCode.PageUp)
