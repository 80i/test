if not game:IsLoaded() then game.Loaded:Wait() end

local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

-- Modern GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomEscapeHub"
ScreenGui.ResetOnSpawn = false
local success, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

-- Main UI Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 240)
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner", MainFrame)
mainCorner.CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Color3.fromRGB(45, 45, 55)
mainStroke.Thickness = 1

-- Header Title
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.Text = "⚡ ESCAPE HUB V2"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 14
Header.Parent = MainFrame

local headerCorner = Instance.new("UICorner", Header)
headerCorner.CornerRadius = UDim.new(0, 10)

-- In-Game Notification System
local function showNotification(message, color)
    local Notif = Instance.new("TextLabel")
    Notif.Size = UDim2.new(0, 180, 0, 30)
    Notif.Position = UDim2.new(0.5, -90, 0, -40)
    Notif.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Notif.Text = message
    Notif.TextColor3 = color
    Notif.Font = Enum.Font.GothamBold
    Notif.TextSize = 12
    Notif.Parent = MainFrame
    
    Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", Notif)
    stroke.Color = color
    stroke.Thickness = 1
    
    tweenService:Create(Notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -90, 0, -45)}):Play()
    task.wait(1.5)
    local fade = tweenService:Create(Notif, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})
    fade:Play()
    fade.Completed:Connect(function() Notif:Destroy() end)
end

-- Reusable Button Stylist
local function createModernButton(text, yPos, defaultColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = defaultColor
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = MainFrame
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- FEATURE 1: Instant Teleport
local TeleportBtn = createModernButton("TELEPORT TO END", 50, Color3.fromRGB(0, 120, 255))
local destination = Vector3.new(7986.58, 718.30, 5143.11)

TeleportBtn.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(destination)
        showNotification("Teleported successfully!", Color3.fromRGB(0, 255, 120))
    else
        showNotification("Character not found!", Color3.fromRGB(255, 50, 50))
    end
end)

-- FEATURE 2: Smart Auto-Walk
local AutoWalkBtn = createModernButton("AUTO-WALK: DISABLED", 100, Color3.fromRGB(35, 35, 40))
local autoWalking = false
local walkConnection

AutoWalkBtn.MouseButton1Click:Connect(function()
    autoWalking = not autoWalking
    if autoWalking then
        AutoWalkBtn.Text = "AUTO-WALK: ENABLED"
        AutoWalkBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        showNotification("Auto-Walk Enabled", Color3.fromRGB(0, 255, 120))
        
        walkConnection = runService.Heartbeat:Connect(function()
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:Move(Vector3.new(1, 0, 0), true)
            end
        end)
    else
        AutoWalkBtn.Text = "AUTO-WALK: DISABLED"
        AutoWalkBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        showNotification("Auto-Walk Disabled", Color3.fromRGB(255, 100, 0))
        if walkConnection then walkConnection:Disconnect() end
    end
end)

-- FEATURE 3: Speed Boost
local SpeedBtn = createModernButton("SPEED BOOST: DISABLED", 150, Color3.fromRGB(35, 35, 40))
local speedActive = false

SpeedBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if speedActive then
            SpeedBtn.Text = "SPEED BOOST: ENABLED"
            SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
            humanoid.WalkSpeed = 150
            showNotification("Speed Set to 150", Color3.fromRGB(0, 255, 120))
        else
            SpeedBtn.Text = "SPEED BOOST: DISABLED"
            SpeedBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            humanoid.WalkSpeed = 16
            showNotification("Speed Reset", Color3.fromRGB(255, 100, 0))
        end
    else
        showNotification("Humanoid missing!", Color3.fromRGB(255, 50, 50))
    end
end)

-- FEATURE 4: Noclip Toggle
local NoclipBtn = createModernButton("NOCLIP: DISABLED", 195, Color3.fromRGB(35, 35, 40))
local noclipActive = false
local noclipConnection

NoclipBtn.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    if noclipActive then
        NoclipBtn.Text = "NOCLIP: ENABLED"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        showNotification("Noclip Enabled", Color3.fromRGB(0, 255, 120))
        
        noclipConnection = runService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        NoclipBtn.Text = "NOCLIP: DISABLED"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        showNotification("Noclip Disabled", Color3.fromRGB(255, 100, 0))
        if noclipConnection then noclipConnection:Disconnect() end
    end
end)
