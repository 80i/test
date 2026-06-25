if not game:IsLoaded() then game.Loaded:Wait() end

local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

-- Main ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumEscapeHub"
ScreenGui.ResetOnSpawn = false
local success, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

-- MAIN WINDOW CONTAINER
local MainWindow = Instance.new("Frame")
MainWindow.Size = UDim2.new(0, 480, 0, 300)
MainWindow.Position = UDim2.new(0.25, 0, 0.3, 0)
MainWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainWindow.BorderSizePixel = 0
MainWindow.Active = true
MainWindow.Draggable = true
MainWindow.Parent = ScreenGui

local mainCorner = Instance.new("UICorner", MainWindow)
mainCorner.CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", MainWindow)
mainStroke.Color = Color3.fromRGB(35, 35, 45)
mainStroke.Thickness = 1.5

-- TOP TITLE BAR
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainWindow

local titleCorner = Instance.new("UICorner", TitleBar)
titleCorner.CornerRadius = UDim.new(0, 12)

-- Visual fix to keep bottom of TitleBar flat
local titleFlat = Instance.new("Frame")
titleFlat.Size = UDim2.new(1, 0, 0, 10)
titleFlat.Position = UDim2.new(0, 0, 1, -10)
titleFlat.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
titleFlat.BorderSizePixel = 0
titleFlat.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -20, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.Text = "CYPHERX HUB — ESCAPE V2"
TitleText.TextColor3 = Color3.fromRGB(240, 240, 245)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 13
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.BackgroundTransparency = 1
TitleText.Parent = TitleBar

-- SIDEBAR (LEFT NAV)
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 130, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainWindow

local sideLine = Instance.new("Frame")
sideLine.Size = UDim2.new(0, 1, 1, 0)
sideLine.Position = UDim2.new(1, -1, 0, 0)
sideLine.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
sideLine.BorderSizePixel = 0
sideLine.Parent = SideBar

-- CONTAINER FOR PAGES
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -130, 1, -40)
PageContainer.Position = UDim2.new(0, 130, 0, 40)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainWindow

-- PAGE 1: Main Cheats
local MainPage = Instance.new("Frame")
MainPage.Size = UDim2.new(1, 0, 1, 0)
MainPage.BackgroundTransparency = 1
MainPage.Visible = true
MainPage.Parent = PageContainer

-- PAGE 2: Teleports
local TeleportPage = Instance.new("Frame")
TeleportPage.Size = UDim2.new(1, 0, 1, 0)
TeleportPage.BackgroundTransparency = 1
TeleportPage.Visible = false
TeleportPage.Parent = PageContainer

-- TAB CLICKS LOGIC
local function switchTab(showPage, hidePage, activeBtn, inactiveBtn)
    showPage.Visible = true
    hidePage.Visible = false
    activeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    activeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    inactiveBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    inactiveBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
end

-- SIDEBAR BUTTONS
local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Size = UDim2.new(0.9, 0, 0, 35)
MainTabBtn.Position = UDim2.new(0.05, 0, 0, 15)
MainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainTabBtn.Text = "⚙️ Main Autofarm"
MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.TextSize = 11
MainTabBtn.BorderSizePixel = 0
MainTabBtn.Parent = SideBar
Instance.new("UICorner", MainTabBtn).CornerRadius = UDim.new(0, 6)

local TeleportTabBtn = Instance.new("TextButton")
TeleportTabBtn.Size = UDim2.new(0.9, 0, 0, 35)
TeleportTabBtn.Position = UDim2.new(0.05, 0, 0, 55)
TeleportTabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
TeleportTabBtn.Text = "📍 Teleports"
TeleportTabBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
TeleportTabBtn.Font = Enum.Font.GothamBold
TeleportTabBtn.TextSize = 11
TeleportTabBtn.BorderSizePixel = 0
TeleportTabBtn.Parent = SideBar
Instance.new("UICorner", TeleportTabBtn).CornerRadius = UDim.new(0, 6)

MainTabBtn.MouseButton1Click:Connect(function() switchTab(MainPage, TeleportPage, MainTabBtn, TeleportTabBtn) end)
TeleportTabBtn.MouseButton1Click:Connect(function() switchTab(TeleportPage, MainPage, TeleportTabBtn, MainTabBtn) end)

-- IN-GAME NOTIFICATION TOAST
local function showNotification(message, color)
    local Notif = Instance.new("TextLabel")
    Notif.Size = UDim2.new(0, 200, 0, 35)
    Notif.Position = UDim2.new(0.5, -100, 0, -50)
    Notif.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Notif.Text = message
    Notif.TextColor3 = color
    Notif.Font = Enum.Font.GothamBold
    Notif.TextSize = 11
    Notif.Parent = MainWindow
    
    Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", Notif)
    stroke.Color = color
    stroke.Thickness = 1
    
    tweenService:Create(Notif, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -100, 0, -55)}):Play()
    task.wait(1.5)
    local fade = tweenService:Create(Notif, TweenInfo.new(0.4), {TextTransparency = 1, BackgroundTransparency = 1})
    fade:Play()
    fade.Completed:Connect(function() Notif:Destroy() end)
end

-- RENDERING UTILITY FOR CHEAT TOGGLES
local function createFeatureToggle(text, yPos, parentPage)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 45)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    frame.BorderSizePixel = 0
    frame.Parent = parentPage
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 235)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 28)
    btn.Position = UDim2.new(1, -105, 0.5, -14)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = "DISABLED"
    btn.TextColor3 = Color3.fromRGB(160, 160, 170)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    return btn
end

-- CONFIGURING MODULES (MAIN TAB)
local AutoWalkBtn = createFeatureToggle("⚡ Smart Auto-Walk", 15, MainPage)
local SpeedBtn = createFeatureToggle("💨 Hyper Speed (150)", 70, MainPage)
local NoclipBtn = createFeatureToggle("🧱 Ghost Noclip Mode", 125, MainPage)

-- CONFIGURING MODULES (TELEPORT TAB)
local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Size = UDim2.new(0.9, 0, 0, 45)
TeleportBtn.Position = UDim2.new(0.05, 0, 0, 15)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
TeleportBtn.Text = "TELEPORT TO THE END STAGE"
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.Font = Enum.Font.GothamBold
TeleportBtn.TextSize = 12
TeleportBtn.BorderSizePixel = 0
TeleportBtn.Parent = TeleportPage
Instance.new("UICorner", TeleportBtn).CornerRadius = UDim.new(0, 6)

-- LOGIC FOR IMPLEMENTED ACTIONS
local destination = Vector3.new(7986.58, 718.30, 5143.11)
TeleportBtn.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(destination)
        showNotification("Teleported to end stage successfully!", Color3.fromRGB(0, 255, 120))
    else
        showNotification("Failed: Character root missing!", Color3.fromRGB(255, 50, 50))
    end
end)

local autoWalking = false
local walkConnection
AutoWalkBtn.MouseButton1Click:Connect(function()
    autoWalking = not autoWalking
    if autoWalking then
        AutoWalkBtn.Text = "ENABLED"
        AutoWalkBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 90)
        AutoWalkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        showNotification("Auto-Walk Module Activated", Color3.fromRGB(0, 255, 120))
        walkConnection = runService.Heartbeat:Connect(function()
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:Move(Vector3.new(1, 0, 0), true) end
        end)
    else
        AutoWalkBtn.Text = "DISABLED"
        AutoWalkBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        AutoWalkBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
        showNotification("Auto-Walk Disabled", Color3.fromRGB(255, 100, 0))
        if walkConnection then walkConnection:Disconnect() end
    end
end)

local speedActive = false
SpeedBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if speedActive then
            SpeedBtn.Text = "ENABLED"
            SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 90)
            SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            humanoid.WalkSpeed = 150
            showNotification("WalkSpeed Modified to 150", Color3.fromRGB(0, 255, 120))
        else
            SpeedBtn.Text = "DISABLED"
            SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            SpeedBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
            humanoid.WalkSpeed = 16
            showNotification("WalkSpeed Reset to Default", Color3.fromRGB(255, 100, 0))
        end
    end
end)

local noclipActive = false
local noclipConnection
NoclipBtn.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    if noclipActive then
        NoclipBtn.Text = "ENABLED"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 90)
        NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        showNotification("Noclip Status: Active", Color3.fromRGB(0, 255, 120))
        noclipConnection = runService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        NoclipBtn.Text = "DISABLED"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        NoclipBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
        showNotification("Noclip Terminated", Color3.fromRGB(255, 100, 0))
        if noclipConnection then noclipConnection:Disconnect() end
    end
end)
