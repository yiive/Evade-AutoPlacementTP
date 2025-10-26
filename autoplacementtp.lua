--// AutoPlace TP - Yiv //-- 

-- Service Setup
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ToolActionEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Character"):WaitForChild("ToolAction")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 270, 0, 430)
Frame.Position = UDim2.new(0.73, 0, 0.12, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 24, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(35, 40, 60)
Header.BorderSizePixel = 0
Header.Parent = Frame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Text = " Yiv "
HeaderLabel.Font = Enum.Font.GothamBold
HeaderLabel.TextSize = 17
HeaderLabel.TextColor3 = Color3.new(1, 1, 1)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Size = UDim2.new(1, -90, 1, 0)
HeaderLabel.Position = UDim2.new(0, 12, 0, 0)
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Parent = Header

-- Buttons
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
MinimizeButton.Position = UDim2.new(1, -78, 0, 8)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(95, 105, 135)
MinimizeButton.Text = "—"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.TextSize = 20
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = Header
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 5)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -42, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
CloseButton.Text = "✖"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextSize = 18
CloseButton.BorderSizePixel = 0
CloseButton.Parent = Header
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 5)

-- Scroll
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -200)
ScrollFrame.Position = UDim2.new(0, 10, 0, 55)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 8
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = Frame
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Bottom Buttons
local BottomFrame = Instance.new("Frame")
BottomFrame.Size = UDim2.new(1, -20, 0, 130)
BottomFrame.Position = UDim2.new(0, 10, 1, -140)
BottomFrame.BackgroundTransparency = 1
BottomFrame.Parent = Frame

local AddButton = Instance.new("TextButton")
AddButton.Size = UDim2.new(0.48, 0, 0, 40)
AddButton.BackgroundColor3 = Color3.fromRGB(70, 145, 255)
AddButton.Text = "Tambah Koordinat"
AddButton.Font = Enum.Font.GothamBold
AddButton.TextSize = 14
AddButton.TextColor3 = Color3.new(1, 1, 1)
AddButton.BorderSizePixel = 0
AddButton.TextWrapped = true
AddButton.TextXAlignment = Enum.TextXAlignment.Center
AddButton.TextYAlignment = Enum.TextYAlignment.Center
AddButton.Parent = BottomFrame
Instance.new("UICorner", AddButton).CornerRadius = UDim.new(0, 8)

local ClearButton = Instance.new("TextButton")
ClearButton.Size = UDim2.new(0.48, 0, 0, 40)
ClearButton.Position = UDim2.new(0.52, 0, 0, 0)
ClearButton.BackgroundColor3 = Color3.fromRGB(230, 85, 85)
ClearButton.Text = "Clear Semua"
ClearButton.Font = Enum.Font.GothamBold
ClearButton.TextSize = 14
ClearButton.TextColor3 = Color3.new(1, 1, 1)
ClearButton.BorderSizePixel = 0
ClearButton.TextWrapped = true
ClearButton.Parent = BottomFrame
Instance.new("UICorner", ClearButton).CornerRadius = UDim.new(0, 8)

-- Mode Button
local ModeButton = Instance.new("TextButton")
ModeButton.Size = UDim2.new(1, 0, 0, 35)
ModeButton.Position = UDim2.new(0, 0, 0, 45)
ModeButton.BackgroundColor3 = Color3.fromRGB(60, 65, 90)
ModeButton.Text = "Mode: Normal"
ModeButton.Font = Enum.Font.GothamBold
ModeButton.TextSize = 14
ModeButton.TextColor3 = Color3.new(1, 1, 1)
ModeButton.BorderSizePixel = 0
ModeButton.Parent = BottomFrame
Instance.new("UICorner", ModeButton).CornerRadius = UDim.new(0, 8)

-- Copy & Place Button
local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(1, 0, 0, 35)
CopyButton.Position = UDim2.new(0, 0, 0, 85)
CopyButton.BackgroundColor3 = Color3.fromRGB(85, 120, 200)
CopyButton.Text = "Copy & Place Terakhir"
CopyButton.Font = Enum.Font.GothamBold
CopyButton.TextSize = 14
CopyButton.TextColor3 = Color3.new(1, 1, 1)
CopyButton.BorderSizePixel = 0
CopyButton.Parent = BottomFrame
Instance.new("UICorner", CopyButton).CornerRadius = UDim.new(0, 8)

-- Dragging
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
Header.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Teleport Logic
local Teleports = {}
local AccurateMode = false
local LastPlacedCFrame = nil -- Menyimpan titik terakhir

-- Raycast helper
local function getGroundBelow(position)
	local rayOrigin = position + Vector3.new(0, 5, 0)
	local rayDirection = Vector3.new(0, -100, 0)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	return Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
end

-- Mode Normal: Raycast dari badan
local function getGroundCFrameAbovePosition(position, rotation)
	local result = getGroundBelow(position)
	if result then
		return CFrame.new(result.Position + Vector3.new(0, 0.0, 0)) * CFrame.Angles(0, rotation, 0)
	else
		return CFrame.new(position) * CFrame.Angles(0, rotation, 0)
	end
end

-- Mode Akurat: Raycast dari kaki
local function getAccurateFootPositionCFrame(rootPart)
	local character = LocalPlayer.Character
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local offset = humanoid and humanoid.RigType == Enum.HumanoidRigType.R6 and 2.5 or 2.8

	local pos = rootPart.Position - Vector3.new(0, offset, 0)
	local rot = select(2, rootPart.CFrame:ToEulerAnglesYXZ())
	local result = getGroundBelow(pos)

	if result then
		return CFrame.new(result.Position) * CFrame.Angles(0, rot, 0)
	else
		return CFrame.new(pos) * CFrame.Angles(0, rot, 0)
	end
end

-- Fire event
local function attemptPlaceTeleport(cframe)
	local args = { [1] = 1, [2] = { [1] = "Teleporter", [2] = cframe } }
	pcall(function() ToolActionEvent:FireServer(unpack(args)) end)
end

-- Buat tombol teleport
local function createTeleportButton(name, cframe)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 39)
	btn.BackgroundColor3 = Color3.fromRGB(50, 55, 75)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.Text = name
	btn.BorderSizePixel = 0
	btn.Parent = ScrollFrame
	btn.TextWrapped = true
	btn.TextXAlignment = Enum.TextXAlignment.Center
	btn.TextYAlignment = Enum.TextYAlignment.Center
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(95, 150, 255) end)
	btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(50, 55, 75) end)
	btn.MouseButton1Click:Connect(function()
		attemptPlaceTeleport(cframe)
		LastPlacedCFrame = cframe
	end)
end

local function refreshTeleportButtons()
	for _, child in pairs(ScrollFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	for i, tp in ipairs(Teleports) do
		createTeleportButton(tp.name, tp.cframe)
	end
	ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #Teleports * 44)
end

-- Tombol utama
AddButton.MouseButton1Click:Connect(function()
	local character = LocalPlayer.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local root = character.HumanoidRootPart
		local cframe
		if AccurateMode then
			cframe = getAccurateFootPositionCFrame(root)
		else
			local pos = root.Position
			local rot = select(2, root.CFrame:ToEulerAnglesYXZ())
			cframe = getGroundCFrameAbovePosition(pos, rot)
		end
		local tpName = "Teleport " .. tostring(#Teleports + 1)
		table.insert(Teleports, { name = tpName, cframe = cframe })
		refreshTeleportButtons()
	end
end)

ClearButton.MouseButton1Click:Connect(function()
	Teleports = {}
	refreshTeleportButtons()
end)

ModeButton.MouseButton1Click:Connect(function()
	AccurateMode = not AccurateMode
	if AccurateMode then
		ModeButton.Text = "Mode: Akurat"
		ModeButton.BackgroundColor3 = Color3.fromRGB(70, 200, 100)
	else
		ModeButton.Text = "Mode: Normal"
		ModeButton.BackgroundColor3 = Color3.fromRGB(60, 65, 90)
	end
end)

CopyButton.MouseButton1Click:Connect(function()
	if LastPlacedCFrame then
		attemptPlaceTeleport(LastPlacedCFrame)
	else
		warn("❗ Belum ada teleport terakhir yang disalin!")
	end
end)

-- Smooth minimize
local minimized = false
local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local fullSize = UDim2.new(0, 270, 0, 430)
local miniSize = UDim2.new(0, 270, 0, 45)

MinimizeButton.MouseButton1Click:Connect(function()
	if not minimized then
		for _, child in pairs(Frame:GetChildren()) do
			if child ~= Header and not child:IsA("UICorner") then child.Visible = false end
		end
		TweenService:Create(Frame, tweenInfo, {Size = miniSize}):Play()
		minimized = true
	else
		for _, child in pairs(Frame:GetChildren()) do
			if child ~= Header and not child:IsA("UICorner") then child.Visible = true end
		end
		TweenService:Create(Frame, tweenInfo, {Size = fullSize}):Play()
		minimized = false
	end
end)

CloseButton.MouseButton1Click:Connect(function()
	TweenService:Create(Frame, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
	task.wait(0.25)
	ScreenGui:Destroy()
end)

-- Toggle GUI dengan T
local guiVisible = true
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.T then
		guiVisible = not guiVisible
		ScreenGui.Enabled = guiVisible
	end
end)

refreshTeleportButtons()
