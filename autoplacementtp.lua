--// AutoPlace TP - Yiv (KODE FINAL YANG DIPERBAIKI) //--
--ResetOnSpawn, dan Drag sudah diperbaiki.
--nextMinimaze button

-- Service Setup
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ToolActionEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Character"):WaitForChild("ToolAction")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Data GUI & Status
local Teleports = {}
local guiVisible = true
local wasMinimized = false
local fullSize = UDim2.new(0, 270, 0, 430)
local minimizedSize = UDim2.new(0, 270, 0, 45) 

-- === GUI Construction ===

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false 

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Size = fullSize
Frame.Position = UDim2.new(0.73, 0, 0.12, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 24, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Parent = ScreenGui
Frame.ClipsDescendants = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = Frame

-- Header Frame
local Header = Instance.new("Frame")
Header.Name = "Header"
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

-- Tombol Minimize (— / □)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
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

-- Tombol Close (✖)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
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

-- Scroll Frame untuk daftar koordinat
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -20, 1, -150)
ScrollFrame.Position = UDim2.new(0, 10, 0, 55)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 8
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Name = "UIListLayout"
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Bottom Buttons Frame
local BottomFrame = Instance.new("Frame")
BottomFrame.Name = "BottomFrame"
BottomFrame.Size = UDim2.new(1, -20, 0, 60)
BottomFrame.Position = UDim2.new(0, 10, 1, -70)
BottomFrame.BackgroundTransparency = 1
BottomFrame.Parent = Frame

-- Tambah Koordinat Button
local AddButton = Instance.new("TextButton")
AddButton.Name = "AddButton"
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

-- Clear Semua Button
local ClearButton = Instance.new("TextButton")
ClearButton.Name = "ClearButton"
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

-- === Core Functions (Teleport) ===
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
	ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #Teleports * 44 + (#Teleports > 0 and 5 or 0))
end

-- === Events and Connections ===

-- 1. Dragging System
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
		
		local connection
		local endConnection
		
		connection = UserInputService.InputChanged:Connect(function(inputChanged)
			if dragging and inputChanged.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = inputChanged.Position - dragStart
				Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
		
		endConnection = UserInputService.InputEnded:Connect(function(inputEnded)
			if inputEnded.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
				connection:Disconnect()
				endConnection:Disconnect()
			end
		end)
	end
end)


-- 2. Add Button Logic
AddButton.MouseButton1Click:Connect(function()
	local character = LocalPlayer.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local rootPart = character.HumanoidRootPart
		local pos = rootPart.Position
		local _, rot, _ = rootPart.CFrame:ToEulerAnglesYXZ() 
		
		local correctedCFrame = getGroundCFrameAbovePosition(pos, rot)
		local tpName = "Teleport " .. tostring(#Teleports + 1)
		table.insert(Teleports, { name = tpName, cframe = correctedCFrame })
		refreshTeleportButtons()
	end
end)

-- 3. Clear Button Logic
ClearButton.MouseButton1Click:Connect(function()
	Teleports = {}
	refreshTeleportButtons()
end)

-- 4. Close/Hide Button Logic
CloseButton.MouseButton1Click:Connect(function()
	guiVisible = not guiVisible
	Frame.Visible = guiVisible
	if wasMinimized and not guiVisible then
		wasMinimized = false
		MinimizeButton.Text = "—"
		Frame.Size = fullSize 
		for _, child in pairs(Frame:GetChildren()) do
            child.Visible = true
        end
	end
end)

-- 5. Minimize Button Logic (FINAL FIX)
MinimizeButton.MouseButton1Click:Connect(function()
    local currentSize = Frame.Size
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	if not wasMinimized then
        for _, child in pairs(Frame:GetChildren()) do
            if child.Name ~= "Header" then
                child.Visible = false
            end
        end

        local minimizeTween = TweenService:Create(Frame, tweenInfo, {Size = minimizedSize})
		minimizeTween:Play()
		
		wasMinimized = true
		MinimizeButton.Text = "□" 
	else
        local restoreTween = TweenService:Create(Frame, tweenInfo, {Size = fullSize})
        restoreTween.Completed:Once(function()
            for _, child in pairs(Frame:GetChildren()) do
                child.Visible = true
            end
        end)
        
        restoreTween:Play()
		
		wasMinimized = false
		MinimizeButton.Text = "—" 
	end
end)

-- Inisialisasi awal
refreshTeleportButtons()
