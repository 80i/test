--// LOAD
if not game:IsLoaded() then game.Loaded:Wait() end

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

--// CHARACTER HANDLING
local character, humanoid, root

local function loadChar(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")
end

player.CharacterAdded:Connect(loadChar)
if player.Character then loadChar(player.Character) end

--// THEME
local Theme = {
	BG = Color3.fromRGB(18,18,22),
	CARD = Color3.fromRGB(24,24,30),
	ACCENT = Color3.fromRGB(0,170,255),
	ON = Color3.fromRGB(0,200,120),
	OFF = Color3.fromRGB(40,40,50),
	TEXT = Color3.fromRGB(235,235,240)
}

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CypherX_Stable"
pcall(function() gui.Parent = game.CoreGui end)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,520,0,400)
main.Position = UDim2.new(0.3,0,0.25,0)
main.BackgroundColor3 = Theme.BG
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "CYPHERX STABLE HUB"
title.TextColor3 = Theme.TEXT
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundTransparency = 1

-- CONTAINER
local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1,0,1,-60)
container.Position = UDim2.new(0,0,0,40)
container.CanvasSize = UDim2.new(0,0,0,1500)
container.ScrollBarThickness = 4
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,8)

-- COORD DISPLAY
local coord = Instance.new("TextLabel", main)
coord.Size = UDim2.new(1,0,0,20)
coord.Position = UDim2.new(0,0,1,-20)
coord.BackgroundTransparency = 1
coord.TextColor3 = Theme.TEXT
coord.Font = Enum.Font.Gotham
coord.TextSize = 11

RunService.RenderStepped:Connect(function()
	if root then
		local p = root.Position
		coord.Text = ("X %.1f | Y %.1f | Z %.1f"):format(p.X,p.Y,p.Z)
	end
end)

--// FEATURE SYSTEM
local function createToggle(name, callbackOn, callbackOff)
	local enabled = false

	local frame = Instance.new("Frame", container)
	frame.Size = UDim2.new(1,-10,0,40)
	frame.BackgroundColor3 = Theme.CARD
	Instance.new("UICorner", frame)

	local label = Instance.new("TextLabel", frame)
	label.Text = name
	label.Size = UDim2.new(0.6,0,1,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Theme.TEXT
	label.Font = Enum.Font.GothamBold
	label.TextSize = 12

	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0,90,0,26)
	btn.Position = UDim2.new(1,-100,0.5,-13)
	btn.BackgroundColor3 = Theme.OFF
	btn.Text = "OFF"
	btn.TextColor3 = Theme.TEXT
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	Instance.new("UICorner", btn)

	local function update()
		btn.Text = enabled and "ON" or "OFF"
		TweenService:Create(btn, TweenInfo.new(0.15), {
			BackgroundColor3 = enabled and Theme.ON or Theme.OFF
		}):Play()
	end

	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		if enabled then
			if callbackOn then callbackOn() end
		else
			if callbackOff then callbackOff() end
		end
		update()
	end)

	update()
end

--// BUTTON (NON-TOGGLE)
local function createButton(name, callback)
	local frame = Instance.new("Frame", container)
	frame.Size = UDim2.new(1,-10,0,40)
	frame.BackgroundColor3 = Theme.CARD
	Instance.new("UICorner", frame)

	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1,-10,1,-10)
	btn.Position = UDim2.new(0,5,0,5)
	btn.Text = name
	btn.BackgroundColor3 = Theme.ACCENT
	btn.TextColor3 = Theme.TEXT
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(callback)
end

--// SLIDER
local function createSlider(name, min, max, default, callback)
	local value = default

	local frame = Instance.new("Frame", container)
	frame.Size = UDim2.new(1,-10,0,55)
	frame.BackgroundColor3 = Theme.CARD
	Instance.new("UICorner", frame)

	local label = Instance.new("TextLabel", frame)
	label.Text = name .. ": " .. default
	label.Size = UDim2.new(1,0,0,20)
	label.BackgroundTransparency = 1
	label.TextColor3 = Theme.TEXT
	label.Font = Enum.Font.GothamBold
	label.TextSize = 12

	local bar = Instance.new("Frame", frame)
	bar.Size = UDim2.new(1,-20,0,6)
	bar.Position = UDim2.new(0,10,0,30)
	bar.BackgroundColor3 = Theme.OFF
	Instance.new("UICorner", bar)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
	fill.BackgroundColor3 = Theme.ACCENT
	Instance.new("UICorner", fill)

	local dragging = false

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local rel = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
			rel = math.clamp(rel,0,1)

			fill.Size = UDim2.new(rel,0,1,0)

			value = math.floor(min + (max-min)*rel)
			label.Text = name .. ": " .. value

			if callback then callback(value) end
		end
	end)

	if callback then callback(default) end
end

--// INPUT BOX
local function createInput(name, default, callback)
	local frame = Instance.new("Frame", container)
	frame.Size = UDim2.new(1,-10,0,40)
	frame.BackgroundColor3 = Theme.CARD
	Instance.new("UICorner", frame)

	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(1,-10,1,-10)
	box.Position = UDim2.new(0,5,0,5)
	box.Text = tostring(default)
	box.PlaceholderText = name
	box.BackgroundColor3 = Theme.BG
	box.TextColor3 = Theme.TEXT
	box.Font = Enum.Font.GothamBold
	box.TextSize = 12
	Instance.new("UICorner", box)

	box.FocusLost:Connect(function()
		local num = tonumber(box.Text)
		if num and callback then
			callback(num)
		end
	end)
end

--// FEATURES

-- SPEED CONTROL
createSlider("WalkSpeed", 16, 300, 50, function(val)
	if humanoid then humanoid.WalkSpeed = val end
end)

createInput("Exact Speed", 50, function(val)
	if humanoid then humanoid.WalkSpeed = val end
end)

-- JUMP
createSlider("Jump Power", 50, 300, 50, function(val)
	if humanoid then humanoid.JumpPower = val end
end)

-- GRAVITY
createSlider("Gravity", 0, 300, 196, function(val)
	workspace.Gravity = val
end)

-- GODMODE
local godConn
createToggle("Godmode",
function()
	godConn = RunService.Heartbeat:Connect(function()
		if humanoid then
			humanoid.Health = humanoid.MaxHealth
		end
	end)
end,
function()
	if godConn then godConn:Disconnect() end
end)

-- NOCLIP
local noclipConn
createToggle("Noclip",
function()
	noclipConn = RunService.Stepped:Connect(function()
		if character then
			for _,v in ipairs(character:GetChildren()) do
				if v:IsA("BasePart") then v.CanCollide = false end
			end
		end
	end)
end,
function()
	if noclipConn then noclipConn:Disconnect() end
end)

-- SAVE / TP
local saved = {}

createButton("Save Position", function()
	if root then table.insert(saved, root.CFrame) end
end)

createButton("Teleport Slot 1", function()
	if root and saved[1] then root.CFrame = saved[1] end
end)

createButton("Teleport Slot 2", function()
	if root and saved[2] then root.CFrame = saved[2] end
end)

-- REJOIN
createButton("Rejoin Server", function()
	TeleportService:Teleport(game.PlaceId)
end)

-- UI TOGGLE
local visible = true
UIS.InputBegan:Connect(function(input,gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		visible = not visible
		main.Visible = visible
	end
end)
