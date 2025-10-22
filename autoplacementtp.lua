--// AutoPlace TP - Yiv //--

-- Service Setup
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ToolActionEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Character"):WaitForChild("ToolAction")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

--  GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 270, 0, 430)
Frame.Position = UDim2.new(0.73, 0, 0.12, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 24, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Parent = ScreenGui
Frame.ClipsDescendants = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = Frame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(35, 40, 60)
Header.BorderSizePixel = 0
Header.Parent = Frame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

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

-- Minimize Button
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

-- Close Button
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
ScrollFrame.Size = UDim2.new(1, -20, 1, -150)
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
BottomFrame.Size = UDim2.new(1, -20, 0, 60)
BottomFrame.Position = UDim2.new(0, 10, 1, -70)
BottomFrame.BackgroundTransparency = 1
BottomFrame.Parent = Frame

local AddButton = Instance.new("TextButton")
AddButton.Size = UDim2.new(0.48, 0, 1, 0)
AddButton.Position = UDim2.new(0, 0, 0, 0)
AddButton.BackgroundColor3 = Color3.fromRGB(70, 145, 255)
AddButton.Text = "Tambah Koordinat"
AddButton.Font = Enum.Font.GothamBold
AddButton.TextSize = 14
AddButton.TextColor3 = Color3.new(1, 1, 1)
AddButton.BorderSizePixel = 0
AddButton.TextWrapped = true
AddButton.Parent = BottomFrame
Instance.new("UICorner", AddButton).CornerRadius = UDim.new(0, 8)

local ClearButton = Instance.new("TextButton")
ClearButton.Size = UDim2.new(0.48, 0, 1, 0)
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

-- Dragging System 
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
		Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Teleport logic 
local Teleports = {}

local function getGroundCFrameAbovePosition(position, rotation)
	local rayOrigin = position + Vector3.new(0, 70, 0)
	local rayDirection = Vector3.new(0, -140, 0)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	if result then
		return CFrame.new(result.Position) * CFrame.Angles(0, rotation, 0)
	else
		return CFrame.new(position) * CFrame.Angles(0, rotation, 0)
	end
end

local function attemptPlaceTeleport(cframe)
	local args = { [1] = 1, [2] = { [1] = "Teleporter", [2] = cframe } }
	pcall(function() ToolActionEvent:FireServer(unpack(args)) end)
end

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
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(95, 150, 255) end)
	btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(50, 55, 75) end)

	btn.MouseButton1Click:Connect(function()
		attemptPlaceTeleport(cframe)
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

AddButton.MouseButton1Click:Connect(function()
	local character = LocalPlayer.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local rootPart = character.HumanoidRootPart
		local pos = rootPart.Position
		local rot = select(2, rootPart.CFrame:ToEulerAnglesYXZ())
		local correctedCFrame = getGroundCFrameAbovePosition(pos, rot)
		local tpName = "Teleport " .. tostring(#Teleports + 1)
		table.insert(Teleports, { name = tpName, cframe = correctedCFrame })
		refreshTeleportButtons()
	end
end)

ClearButton.MouseButton1Click:Connect(function()
	Teleports = {}
	refreshTeleportButtons()
end)

--  Close & Minimize
local guiVisible = true
CloseButton.MouseButton1Click:Connect(function()
	guiVisible = not guiVisible
	Frame.Visible = guiVisible
end)

local wasMinimized = false
local storedSize = nil
MinimizeButton.MouseButton1Click:Connect(function()
	if not wasMinimized then
		storedSize = Frame.Size
		Frame:TweenSize(UDim2.new(0, 270, 0, 50), "Out", "Quad", 0.2, true)
		task.wait(0.15)
		for _, child in pairs(Frame:GetChildren()) do
			if child ~= Header then child.Visible = false end
		end
		wasMinimized = true
	else
		for _, child in pairs(Frame:GetChildren()) do
			child.Visible = true
		end
		Frame:TweenSize(storedSize or UDim2.new(0, 270, 0, 430), "Out", "Quad", 0.2, true)
		wasMinimized = false
	end
end)

refreshTeleportButtons()
