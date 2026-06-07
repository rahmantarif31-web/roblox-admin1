-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- VARIABLES
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- SYSTEM SETUP STATE
local hackSettings = {
	aimActive = false, wallCheckActive = false, teamCheckActive = false,
	aimStrengthValue = 25, speedEngineValue = 16, flightActive = false, espActive = false
}

LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	char:WaitForChild("Humanoid").WalkSpeed = hackSettings.speedEngineValue
end)

-- UI ENGINE CREATION
local Gui = Instance.new("ScreenGui")
Gui.Name = "MalwareMenu"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Safe Top-Left Placement For Mobile Devices
local MainToggle = Instance.new("TextButton")
MainToggle.Size = UDim2.new(0, 110, 0, 35)
MainToggle.Position = UDim2.new(0, 15, 0, 75)
MainToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
MainToggle.Font = Enum.Font.GothamBold
MainToggle.TextSize = 13
MainToggle.Text = "HACK MENU"
MainToggle.Parent = Gui

local Menu = Instance.new("Frame")
Menu.Size = UDim2.new(0, 260, 0, 340)
Menu.Position = UDim2.new(0.5, -130, 0.5, -170)
Menu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Menu.BorderSizePixel = 1
Menu.BorderColor3 = Color3.fromRGB(255, 0, 0)
Menu.Visible = false
Menu.Parent = Gui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "☣️ CHEAT ENGINE UI ☣️"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Menu

local List = Instance.new("ScrollingFrame")
List.Size = UDim2.new(1, -20, 1, -45)
List.Position = UDim2.new(0, 10, 0, 40)
List.BackgroundTransparency = 1
List.CanvasSize = UDim2.new(0, 0, 0, 420)
List.ScrollBarThickness = 3
List.Parent = Menu

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = List

MainToggle.MouseButton1Click:Connect(function() Menu.Visible = not Menu.Visible end)

-- UI ELEMENT HELPER GENERATORS
local function addToggle(label, default, onAction)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, -5, 0, 30)
	Row.BackgroundTransparency = 1
	Row.Parent = List

	local Txt = Instance.new("TextLabel")
	Txt.Size = UDim2.new(0.7, 0, 1, 0)
	Txt.BackgroundTransparency = 1
	Txt.Text = label
	Txt.TextColor3 = Color3.fromRGB(220, 220, 220)
	Txt.Font = Enum.Font.Gotham
	Txt.TextSize = 13
	Txt.TextXAlignment = Enum.TextXAlignment.Left
	Txt.Parent = Row

	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0.25, 0, 0.9, 0)
	Btn.Position = UDim2.new(0.75, 0, 0.05, 0)
	Btn.Font = Enum.Font.GothamBold
	Btn.TextSize = 11
	Btn.Parent = Row

	local state = default
	local function redraw()
		Btn.Text = state and "ON" or "OFF"
		Btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
	end
	redraw()

	Btn.MouseButton1Click:Connect(function()
		state = not state
		redraw()
		onAction(state)
	end)
end

local function addSlider(label, min, max, default, onAction)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, -5, 0, 45)
	Row.BackgroundTransparency = 1
	Row.Parent = List

	local Txt = Instance.new("TextLabel")
	Txt.Size = UDim2.new(1, 0, 0, 20)
	Txt.BackgroundTransparency = 1
	Txt.Text = label .. " [" .. default .. "]"
	Txt.TextColor3 = Color3.fromRGB(220, 220, 220)
	Txt.Font = Enum.Font.Gotham
	Txt.TextSize = 12
	Txt.TextXAlignment = Enum.TextXAlignment.Left
	Txt.Parent = Row

	local Bar = Instance.new("Frame")
	Bar.Size = UDim2.new(1, 0, 0, 6)
	Bar.Position = UDim2.new(0, 0, 0, 24)
	Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Bar.Parent = Row

	local Progress = Instance.new("Frame")
	Progress.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	Progress.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	Progress.Parent = Bar

	local Interactor = Instance.new("TextButton")
	Interactor.Size = UDim2.new(1, 0, 1, 0)
	Interactor.BackgroundTransparency = 1
	Interactor.Text = ""
	Interactor.Parent = Bar

	local drag = false
	local function update(input)
		local x = math.clamp(input.Position.X - Bar.AbsolutePosition.X, 0, Bar.AbsoluteSize.X)
		local ratio = x / Bar.AbsoluteSize.X
		local val = math.floor(min + (ratio * (max - min)))
		Progress.Size = UDim2.new(ratio, 0, 1, 0)
		Txt.Text = label .. " [" .. val .. "]"
		onAction(val)
	end

	Interactor.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = true; update(i)
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			update(i)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = false
		end
	end)
end

-- POPULATE FEATURES
addToggle("Aimbot Master", false, function(v) hackSettings.aimActive = v end)
addToggle("Wall Check Target", false, function(v) hackSettings.wallCheckActive = v end)
addToggle("Team Check Shield", false, function(v) hackSettings.teamCheckActive = v end)
addSlider("Aimbot Speed Adjust", 1, 50, 25, function(v) hackSettings.aimStrengthValue = v end)
addSlider("Speed Hack Override", 16, 100, 16, function(v)
	hackSettings.speedEngineValue = v
	if Character and Character:FindFirstChildOfClass("Humanoid") then
		Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
	end
end)
addToggle("Anti-Gravity Fly", false, function(v) hackSettings.flightActive = v end)
addToggle("X-Ray ESP Visuals", false, function(v) hackSettings.espActive = v end)

-- VISIBILITY RAYCAST SENSOR
local function raycastCheck(targetHead)
	if not hackSettings.wallCheckActive then return true end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {Character, targetHead.Parent}
	local res = Workspace:Raycast(Camera.CFrame.Position, targetHead.Position - Camera.CFrame.Position, params)
	return res == nil
end

-- SCANNER TARGET PIPELINE (Tracks closest target to the literal center of viewport)
local function scanTargets()
	local closest, minDistance = nil, math.huge
	local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and (not hackSettings.teamCheckActive or p.Team ~= LocalPlayer.Team) then
			local hd = p.Character:FindFirstChild("Head")
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			if hd and hum and hum.Health > 0 then
				local sPos, visual = Camera:WorldToViewportPoint(hd.Position)
				if visual and raycastCheck(hd) then
					local mag = (Vector2.new(sPos.X, sPos.Y) - centerScreen).Magnitude
					if mag < minDistance then 
						minDistance = mag
						closest = hd 
					end
				end
			end
		end
	end
	return closest
end

-- MAIN ENGINE PIPELINE LOOP
RunService.RenderStepped:Connect(function()
	-- FIXED UNIVERSAL AIMBOT ENGINE
	if hackSettings.aimActive then
		local t = scanTargets()
		if t then
			local look = CFrame.new(Camera.CFrame.Position, t.Position)
			-- Mapping strength smoothly (Higher slider = faster lock on)
			local lerpWeight = math.clamp(hackSettings.aimStrengthValue / 50, 0.05, 1)
			Camera.CFrame = Camera.CFrame:Lerp(look, lerpWeight)
		end
	end

	-- CHASSIS WALL ESP
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local box = p.Character:FindFirstChild("EspBox")
			if hackSettings.espActive then
				if not box then
					box = Instance.new("Highlight")
					box.Name = "EspBox"
					box.FillTransparency = 0.4
					box.OutlineColor = Color3.fromRGB(255, 255, 255)
					box.Parent = p.Character
				end
				box.FillColor = (p.Team == LocalPlayer.Team) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
			else
				if box then box:Destroy() end
			end
		end
	end

	-- FLIGHT ENGINE
	local root = Character:FindFirstChild("HumanoidRootPart")
	if root then
		local flyGyro = root:FindFirstChild("FlyGyro")
		local flyVel = root:FindFirstChild("FlyVelocity")
		
		if hackSettings.flightActive then
			if not flyGyro then
				flyGyro = Instance.new("BodyGyro")
				flyGyro.Name = "FlyGyro"
				flyGyro.maxTorque = Vector3.new(math.huge, math.huge, math.huge)
				flyGyro.CFrame = root.CFrame
				flyGyro.Parent = root
				
				flyVel = Instance.new("BodyVelocity")
				flyVel.Name = "FlyVelocity"
				flyVel.maxForce = Vector3.new(math.huge, math.huge, math.huge)
				flyVel.Velocity = Vector3.new(0,0,0)
				flyVel.Parent = root
			end
			flyGyro.CFrame = Camera.CFrame
			local hum = Character:FindFirstChildOfClass("Humanoid")
			if hum and hum.MoveDirection.Magnitude > 0 then
				flyVel.Velocity = Camera.CFrame.LookVector * hackSettings.speedEngineValue * 1.5
			else
				flyVel.Velocity = Vector3.new(0, 0, 0)
			end
		else
			if flyGyro then flyGyro:Destroy() end
			if flyVel then flyVel:Destroy() end
		end
	end
end)
