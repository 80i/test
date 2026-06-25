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

--// CHARACTER
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

--// FEATURE SYSTEM
local Features = {}
function Features.new(name, onEnable, onDisable)
	return {
		Name = name,
		Enabled = false,
		Enable = function(self)
			if self.Enabled then return end
			self.Enabled = true
			onEnable()
		end,
		Disable = function(self)
			if not self.Enabled then return end
			self.Enabled = false
			onDisable()
		end,
		Toggle = function(self)
			if self.Enabled then self:Disable() else self:Enable() end
		end
	}
end

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "CypherX_Ultra"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,520,0,380)
main.Position = UDim2.new(0.3,0,0.25,0)
main.BackgroundColor3 = Theme.BG
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "CYPHERX ULTRA HUB"
title.TextColor3 = Theme.TEXT
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundTransparency = 1

-- CONTAINER
local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1,0,1,-60)
container.Position = UDim2.new(0,0,0,40)
container.CanvasSize = UDim2.new(0,0,0,1200)
container.ScrollBarThickness = 4
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,8)

-- COORDS
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

--// TOGGLE UI
local function createToggle(name, feature)
	local frame = Instance.new("Frame", container)
	frame.Size = UDim2.new(1,-10,0,40)
	frame.BackgroundColor3 = Theme.CARD
	Instance.new("UICorner", frame)

	local txt = Instance.new("TextLabel", frame)
	txt.Text = name
	txt.Size = UDim2.new(0.6,0,1,0)
	txt.BackgroundTransparency = 1
	txt.TextColor3 = Theme.TEXT
	txt.Font = Enum.Font.GothamBold
	txt.TextSize = 12

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
		TweenService:Create(btn, TweenInfo.new(0.15), {
			BackgroundColor3 = feature.Enabled and Theme.ON or Theme.OFF
		}):Play()
		btn.Text = feature.Enabled and "ON" or "OFF"
	end

	btn.MouseButton1Click:Connect(function()
		feature:Toggle()
		update()
	end)

	update()
end

--// SAVE POSITIONS
local saved = {}

local function savePos()
	if root then table.insert(saved, root.CFrame) end
end

local function tpPos(i)
	if saved[i] and root then root.CFrame = saved[i] end
end

--// FEATURES

-- GODMODE
local godConn
local God = Features.new("Godmode",
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

-- SPEED
local Speed = Features.new("Speed",
function() humanoid.WalkSpeed = 120 end,
function() humanoid.WalkSpeed = 16 end)

-- JUMP
local Jump = Features.new("Super Jump",
function() humanoid.JumpPower = 120 end,
function() humanoid.JumpPower = 50 end)

-- INF JUMP
local infConn
local InfJump = Features.new("Infinite Jump",
function()
	infConn = UIS.JumpRequest:Connect(function()
		humanoid:ChangeState("Jumping")
	end)
end,
function()
	if infConn then infConn:Disconnect() end
end)

-- NOCLIP
local noclipConn
local Noclip = Features.new("Noclip",
function()
	noclipConn = RunService.Stepped:Connect(function()
		for _,v in ipairs(character:GetChildren()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end)
end,
function()
	if noclipConn then noclipConn:Disconnect() end
end)

-- FLY
local flyConn
local Fly = Features.new("Fly",
function()
	flyConn = RunService.RenderStepped:Connect(function()
		root.Velocity = Vector3.new(0,50,0)
	end)
end,
function()
	if flyConn then flyConn:Disconnect() end
end)

-- FULLBRIGHT
local Bright = Features.new("FullBright",
function() Lighting.Brightness = 5 end,
function() Lighting.Brightness = 1 end)

-- LOW GRAVITY
local Grav = Features.new("Low Gravity",
function() workspace.Gravity = 50 end,
function() workspace.Gravity = 196 end)

-- SPIN
local spinConn
local Spin = Features.new("Spin",
function()
	spinConn = RunService.RenderStepped:Connect(function()
		root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(10), 0)
	end)
end,
function()
	if spinConn then spinConn:Disconnect() end
end)

-- FREEZE
local Freeze = Features.new("Freeze",
function() humanoid.WalkSpeed = 0 end,
function() humanoid.WalkSpeed = 16 end)

-- AUTO WALK
local walkConn
local Walk = Features.new("Auto Walk",
function()
	walkConn = RunService.Heartbeat:Connect(function()
		humanoid:Move(Vector3.new(1,0,0), true)
	end)
end,
function()
	if walkConn then walkConn:Disconnect() end
end)

-- REJOIN
local Rejoin = Features.new("Rejoin",
function()
	TeleportService:Teleport(game.PlaceId)
end,
function() end)

-- SAVE POS
local Save = Features.new("Save Position",
function() savePos() end,
function() end)

-- TP SLOT1
local TP1 = Features.new("Teleport Slot 1",
function() tpPos(1) end,
function() end)

-- TP SLOT2
local TP2 = Features.new("Teleport Slot 2",
function() tpPos(2) end,
function() end)

--// REGISTER
createToggle("Godmode", God)
createToggle("Speed", Speed)
createToggle("Super Jump", Jump)
createToggle("Infinite Jump", InfJump)
createToggle("Noclip", Noclip)
createToggle("Fly", Fly)
createToggle("FullBright", Bright)
createToggle("Low Gravity", Grav)
createToggle("Spin", Spin)
createToggle("Freeze", Freeze)
createToggle("Auto Walk", Walk)
createToggle("Rejoin Server", Rejoin)
createToggle("Save Position", Save)
createToggle("Teleport Slot 1", TP1)
createToggle("Teleport Slot 2", TP2)

--// UI TOGGLE
local visible = true
UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == Enum.KeyCode.RightShift then
		visible = not visible
		main.Visible = visible
	end
end)
