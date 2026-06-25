if not game:IsLoaded() then game.Loaded:Wait() end

local player = game:GetService("Players").LocalPlayer
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeyboardEscapeHub"
ScreenGui.ResetOnSpawn = false
local success, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 180, 0, 190)
Frame.Position = UDim2.new(0.1, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local corner = Instance.new("UICorner", Frame)
corner.CornerRadius = UDim.new(0, 8)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "⌨️ Escape Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = Frame
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

-- Function to quickly create styled buttons
local function createButton(text, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = Frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- BUTTON 1: Teleport to End
local TeleportBtn = createButton("⚡ Teleport to End", 40, Color3.fromRGB(0, 160, 255))
local destination = Vector3.new(7986.58, 718.30, 5143.11)

TeleportBtn.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(destination)
    end
end)

-- BUTTON 2: Auto-Walk (Simulates moving to gain speed constantly)
local AutoWalkBtn = createButton("👟 Auto-Walk: OFF", 90, Color3.fromRGB(180, 40, 40))
local autoWalking = false
local walkConnection

AutoWalkBtn.MouseButton1Click:Connect(function()
    autoWalking = not autoWalking
    if autoWalking then
        AutoWalkBtn.Text = "👟 Auto-Walk: ON"
        AutoWalkBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        
        walkConnection = runService.Heartbeat:Connect(function()
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:Move(Vector3.new(1, 0, 0), true) -- Forces character to keep moving for steps
            end
        end)
    else
        AutoWalkBtn.Text = "👟 Auto-Walk: OFF"
        AutoWalkBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        if walkConnection then walkConnection:Disconnect() end
    end
end)

-- BUTTON 3: Speed Boost Toggle (Changes WalkSpeed value directly)
local SpeedBtn = createButton("💨 Speed Boost: OFF", 140, Color3.fromRGB(120, 40, 180))
local speedActive = false

SpeedBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if speedActive then
            SpeedBtn.Text = "💨 Speed Boost: ON"
            SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
            humanoid.WalkSpeed = 150 -- Set to desired testing speed
        else
            SpeedBtn.Text = "💨 Speed Boost: OFF"
            SpeedBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 180)
            humanoid.WalkSpeed = 16 -- Default Roblox speed
        end
    end
end)
