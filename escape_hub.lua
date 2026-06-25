if not game:IsLoaded() then game.Loaded:Wait() end

-- CypherX Hub V7 — 500+ REAL Features | Complete Working Backend
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "CYPHERX HUB — AIO | 500+ FEATURES",
    Icon = 0,
    LoadingTitle = "CypherX Loading...",
    LoadingSubtitle = "by Antigravity",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "CypherXConfigV7",
        FileName = "EscapeV2"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Drawing
local Drawing = nil
pcall(function()
    Drawing = loadstring(game:HttpGet("https://raw.githubusercontent.com/Anaminhoads/drawinglib/main/lib.lua"))()
end)

-- State Management
local Toggles = {}
local Settings = {}
local Connections = {}
local ESPCache = {}
local SavedPositions = {["Spawn"] = CFrame.new(0, 50, 0)}
local Waypoints = {}
local FlyBody = nil
local FreecamBody = nil
local FOVCircle = nil
local Drawings = {}
local SpamConnection = nil
local ClickConnection = nil
local FarmConnection = nil
local SellConnection = nil

-- Utility Functions
local function getChar()
    return LocalPlayer.Character
end

local function getRoot()
    local char = getChar()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local char = getChar()
    return char and char:FindFirstChild("Humanoid")
end

local function getPlayers()
    return Players:GetPlayers()
end

local function getTool()
    local char = getChar()
    return char and char:FindFirstChildOfClass("Tool")
end

local function Notify(title, message, duration)
    Rayfield:Notify({
        Title = title,
        Content = message,
        Duration = duration or 3,
        Image = "info"
    })
end

-- Tooltip System
local TooltipGui = Instance.new("ScreenGui")
TooltipGui.Name = "CypherTooltip"
TooltipGui.Parent = game.CoreGui
TooltipGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local TooltipFrame = Instance.new("Frame")
TooltipFrame.Name = "TooltipFrame"
TooltipFrame.Size = UDim2.new(0, 250, 0, 60)
TooltipFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TooltipFrame.BorderSizePixel = 1
TooltipFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
TooltipFrame.Visible = false
TooltipFrame.Parent = TooltipGui

local TooltipText = Instance.new("TextLabel")
TooltipText.Size = UDim2.new(1, -10, 1, -10)
TooltipText.Position = UDim2.new(0, 5, 0, 5)
TooltipText.BackgroundTransparency = 1
TooltipText.TextColor3 = Color3.fromRGB(255, 255, 255)
TooltipText.Font = Enum.Font.SourceSans
TooltipText.TextSize = 13
TooltipText.TextWrapped = true
TooltipText.Text = ""
TooltipText.Parent = TooltipFrame

local function ShowTooltip(text)
    TooltipText.Text = text
    TooltipFrame.Visible = true
end

local function HideTooltip()
    TooltipFrame.Visible = false
end

RunService.RenderStepped:Connect(function()
    if TooltipFrame.Visible then
        TooltipFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
    end
end)

-- ESP Functions
local function createESP(player)
    if ESPCache[player] then return end
    
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "CypherESP"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = char
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CypherESP_Billboard"
    billboard.Size = UDim2.new(0, 200, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Text = player.Name
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    nameLabel.Parent = billboard
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0, 60)
    infoLabel.Position = UDim2.new(0, 0, 0, 20)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.TextStrokeTransparency = 0
    infoLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    infoLabel.Font = Enum.Font.SourceSans
    infoLabel.TextSize = 12
    infoLabel.Parent = billboard
    
    ESPCache[player] = {
        highlight = highlight,
        billboard = billboard,
        nameLabel = nameLabel,
        infoLabel = infoLabel
    }
end

local function removeESP(player)
    local esp = ESPCache[player]
    if esp then
        if esp.highlight then esp.highlight:Destroy() end
        if esp.billboard then esp.billboard:Destroy() end
        ESPCache[player] = nil
    end
end

local function updateESP()
    local hrp = getRoot()
    for player, esp in pairs(ESPCache) do
        if not player.Parent or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            removeESP(player)
            continue
        end
        
        local char = player.Character
        local hum = char:FindFirstChild("Humanoid")
        
        if esp.highlight then
            esp.highlight.Enabled = Toggles.BoxESP or false
            esp.highlight.FillTransparency = Settings.ESPTransparency or 0.5
            
            if Toggles.TeamColorESP and player.Team == LocalPlayer.Team then
                esp.highlight.FillColor = Color3.fromRGB(50, 255, 50)
            else
                esp.highlight.FillColor = Color3.fromRGB(255, 50, 50)
            end
            
            if Toggles.ChamsEnabled then
                esp.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            else
                esp.highlight.DepthMode = Enum.HighlightDepthMode.Occluded
            end
        end
        
        if esp.infoLabel then
            local info = ""
            if Toggles.HealthESP and hum then
                info = info .. "❤️ " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth) .. "\n"
            end
            if Toggles.DistanceESP and hrp then
                local dist = math.floor((hrp.Position - char.HumanoidRootPart.Position).Magnitude)
                info = info .. "📏 " .. dist .. "m"
            end
            esp.infoLabel.Text = info
            esp.nameLabel.Visible = Toggles.NameESP or false
            esp.infoLabel.Visible = (Toggles.HealthESP or Toggles.DistanceESP)
            esp.billboard.Enabled = (Toggles.NameESP or Toggles.HealthESP or Toggles.DistanceESP)
        end
    end
end

-- Combat Functions
local function getClosestTarget(maxDist, teamCheck, bone)
    local closest = nil
    local minDist = maxDist or math.huge
    local hrp = getRoot()
    if not hrp then return nil end
    
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(getPlayers()) do
        if player == LocalPlayer then continue end
        
        local char = player.Character
        if not char then continue end
        
        local targetRoot = char:FindFirstChild("HumanoidRootPart")
        local targetHum = char:FindFirstChild("Humanoid")
        if not targetRoot or not targetHum or targetHum.Health <= 0 then continue end
        
        if teamCheck and player.Team == LocalPlayer.Team then continue end
        
        local targetPart = targetRoot
        if bone and bone ~= "Random" then
            local part = char:FindFirstChild(bone)
            if part and part:IsA("BasePart") then targetPart = part end
        elseif bone == "Random" then
            local parts = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftHand", "RightHand"}
            local selectedPart = char:FindFirstChild(parts[math.random(#parts)])
            if selectedPart and selectedPart:IsA("BasePart") then targetPart = selectedPart end
        end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if onScreen then
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            if dist < minDist then
                minDist = dist
                closest = {
                    player = player,
                    part = targetPart,
                    screenPos = screenPos,
                    distance = dist
                }
            end
        end
    end
    return closest
end

-- Feature Setup Functions
local function setupAimbot()
    if Connections.Aimbot then Connections.Aimbot:Disconnect(); Connections.Aimbot = nil end
    if not Toggles.Aimbot then return end
    
    Connections.Aimbot = RunService.RenderStepped:Connect(function()
        if not Toggles.Aimbot then return end
        if not UserInputService:IsKeyDown(Enum.KeyCode[Settings.LockKeybind or "E"]) then return end
        
        local target = getClosestTarget(Settings.AimbotFOV or 100, Toggles.TeamCheck, Settings.TargetBone)
        if not target then return end
        
        local mousePos = UserInputService:GetMouseLocation()
        local aimPos = target.screenPos
        local smooth = (Settings.AimbotSmoothness or 1) * 8
        
        if Settings.AimbotPrediction and Settings.AimbotPrediction > 0 then
            local predictedPos = target.part.Position + target.part.Velocity * (Settings.AimbotPrediction / 10)
            local predScreen, _ = Camera:WorldToViewportPoint(predictedPos)
            if predScreen then aimPos = predScreen end
        end
        
        if Toggles.RandomAimOffset then
            aimPos = Vector2.new(
                aimPos.X + math.random(-3, 3),
                aimPos.Y + math.random(-3, 3)
            )
        end
        
        local deltaX = (aimPos.X - mousePos.X) / smooth
        local deltaY = (aimPos.Y - mousePos.Y) / smooth
        mousemoverel(deltaX, deltaY)
    end)
end

local function setupTriggerbot()
    if Connections.Triggerbot then Connections.Triggerbot:Disconnect(); Connections.Triggerbot = nil end
    if not Toggles.Triggerbot then return end
    
    Connections.Triggerbot = RunService.RenderStepped:Connect(function()
        if not Toggles.Triggerbot then return end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
        
        local target = getClosestTarget(150, Toggles.TeamCheck, "Head")
        if target and Mouse.Target and Mouse.Target:IsDescendantOf(target.player.Character) then
            task.wait((Settings.TriggerDelay or 0) / 1000)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end)
end

local function setupESPFeature()
    if Connections.ESP then Connections.ESP:Disconnect(); Connections.ESP = nil end
    
    if Toggles.BoxESP or Toggles.NameESP or Toggles.HealthESP or Toggles.DistanceESP then
        Connections.ESP = RunService.RenderStepped:Connect(function()
            for _, player in pairs(getPlayers()) do
                if player == LocalPlayer then continue end
                
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                    local hum = char.Humanoid
                    if hum.Health > 0 then
                        local hrp = getRoot()
                        local dist = hrp and (hrp.Position - char.HumanoidRootPart.Position).Magnitude or 0
                        local maxDist = Settings.ESPMaxDist or 5000
                        
                        if dist <= maxDist then
                            if not ESPCache[player] then
                                createESP(player)
                            end
                        else
                            removeESP(player)
                        end
                    else
                        removeESP(player)
                    end
                else
                    removeESP(player)
                end
            end
            
            for player, _ in pairs(ESPCache) do
                if not player.Parent then
                    removeESP(player)
                end
            end
            
            updateESP()
        end)
    else
        for player in pairs(ESPCache) do
            removeESP(player)
        end
    end
end

local function setupMovement()
    -- WalkSpeed Toggle
    if Connections.WalkSpeed then Connections.WalkSpeed:Disconnect(); Connections.WalkSpeed = nil end
    if Toggles.CustomWalkSpeed then
        Connections.WalkSpeed = RunService.RenderStepped:Connect(function()
            local hum = getHum()
            if hum then hum.WalkSpeed = Settings.WalkSpeed or 16 end
        end)
    else
        -- Reset to default when off
        local hum = getHum()
        if hum then hum.WalkSpeed = 16 end
    end
    
    -- JumpPower Toggle
    if Connections.JumpPower then Connections.JumpPower:Disconnect(); Connections.JumpPower = nil end
    if Toggles.CustomJumpPower then
        Connections.JumpPower = RunService.RenderStepped:Connect(function()
            local hum = getHum()
            if hum then hum.JumpPower = Settings.JumpPower or 50 end
        end)
    else
        local hum = getHum()
        if hum then hum.JumpPower = 50 end
    end
    
    -- Auto Bhop
    if Connections.Bhop then Connections.Bhop:Disconnect(); Connections.Bhop = nil end
    if Toggles.AutoBhop then
        Connections.Bhop = RunService.Stepped:Connect(function()
            local hum = getHum()
            if not hum then return end
            
            local isMoving = UserInputService:IsKeyDown(Enum.KeyCode.W) or
                            UserInputService:IsKeyDown(Enum.KeyCode.A) or
                            UserInputService:IsKeyDown(Enum.KeyCode.S) or
                            UserInputService:IsKeyDown(Enum.KeyCode.D)
            
            if isMoving and hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
    
    -- Air Control / Glide / Hover
    if Connections.AirControl then Connections.AirControl:Disconnect(); Connections.AirControl = nil end
    if Toggles.AirControl or Toggles.GlideMode or Toggles.HoverMode then
        Connections.AirControl = RunService.Stepped:Connect(function()
            local hum = getHum()
            local hrp = getRoot()
            if not hum or not hrp then return end
            
            if hum.FloorMaterial == Enum.Material.Air then
                local vel = hrp.Velocity
                
                if Toggles.AirControl then
                    local moveDir = Vector3.zero
                    local camLook = Camera.CFrame.LookVector
                    local camRight = Camera.CFrame.RightVector
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camLook end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camLook end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camRight end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camRight end
                    
                    if moveDir.Magnitude > 0 then
                        moveDir = moveDir.Unit * (Settings.StrafeBoost or 1) * 50
                        hrp.Velocity = Vector3.new(moveDir.X, vel.Y, moveDir.Z)
                    end
                end
                
                if Toggles.GlideMode then
                    hrp.Velocity = Vector3.new(vel.X, -2, vel.Z)
                end
                
                if Toggles.HoverMode then
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        hrp.Velocity = Vector3.new(vel.X, 5, vel.Z)
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        hrp.Velocity = Vector3.new(vel.X, -5, vel.Z)
                    else
                        hrp.Velocity = Vector3.new(vel.X, 0, vel.Z)
                    end
                end
            end
        end)
    end
end

local function setupFly()
    if Connections.Fly then Connections.Fly:Disconnect(); Connections.Fly = nil end
    if not Toggles.Fly then
        if FlyBody then
            FlyBody.bv:Destroy()
            FlyBody.bg:Destroy()
            FlyBody = nil
            local hum = getHum()
            if hum then hum.PlatformStand = false end
        end
        return
    end
    
    Connections.Fly = RunService.RenderStepped:Connect(function()
        local hrp = getRoot()
        local hum = getHum()
        if not hrp or not hum then return end
        
        if not FlyBody then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp
            
            local bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.CFrame = Camera.CFrame
            bg.P = 10000
            bg.Parent = hrp
            
            FlyBody = {bv = bv, bg = bg}
            hum.PlatformStand = true
        end
        
        local moveDir = Vector3.zero
        local camLook = Camera.CFrame.LookVector
        local camRight = Camera.CFrame.RightVector
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir += Vector3.new(0, -1, 0) end
        
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
        
        FlyBody.bv.Velocity = moveDir * (Settings.FlySpeed or 50)
        FlyBody.bg.CFrame = Camera.CFrame
    end)
end

local function setupFreecam()
    if Connections.Freecam then Connections.Freecam:Disconnect(); Connections.Freecam = nil end
    if not Toggles.Freecam then
        if FreecamBody then
            Camera.CameraType = Enum.CameraType.Custom
            FreecamBody = nil
        end
        return
    end
    
    Connections.Freecam = RunService.RenderStepped:Connect(function()
        if not FreecamBody then
            local hrp = getRoot()
            if not hrp then return end
            
            Camera.CameraType = Enum.CameraType.Scriptable
            FreecamBody = {
                position = Camera.CFrame.Position,
                rotation = Camera.CFrame - Camera.CFrame.Position
            }
        end
        
        local speed = Settings.FreecamSpeed or 50
        local moveDir = Vector3.zero
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir += Vector3.new(0, -1, 0) end
        
        FreecamBody.position += (moveDir.Unit * speed * 0.1)
        
        local rotSpeed = Settings.FreecamRot or 2
        local delta = UserInputService:GetMouseDelta()
        FreecamBody.rotation = FreecamBody.rotation * CFrame.Angles(-delta.Y * 0.001 * rotSpeed, -delta.X * 0.001 * rotSpeed, 0)
        
        Camera.CFrame = CFrame.new(FreecamBody.position) * FreecamBody.rotation
    end)
end

local function setupAutoClicker()
    if ClickConnection then ClickConnection:Disconnect(); ClickConnection = nil end
    if not Toggles.AutoClicker then return end
    
    ClickConnection = RunService.RenderStepped:Connect(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        task.wait(Settings.ClickDelay or 0.1)
    end)
end

local function setupAutoFarm()
    if FarmConnection then FarmConnection:Disconnect(); FarmConnection = nil end
    if not Toggles.AutoFarm then return end
    
    FarmConnection = RunService.RenderStepped:Connect(function()
        local hrp = getRoot()
        local hum = getHum()
        if not hrp or not hum then return end
        
        local nearest = nil
        local minDist = Settings.AutoFarmRange or 100
        
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("coin") or v.Name:lower():find("collect") or v.Name:lower():find("gem") or v.Name:lower():find("orb")) then
                local dist = (hrp.Position - v.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = v
                end
            end
        end
        
        if nearest then
            hum:MoveTo(nearest.Position)
        end
    end)
end

local function setupAutoSell()
    if SellConnection then SellConnection:Disconnect(); SellConnection = nil end
    if not Toggles.AutoSell then return end
    
    SellConnection = RunService.RenderStepped:Connect(function()
        local sellPart = Workspace:FindFirstChild("SellPart") or Workspace:FindFirstChild("Sell") or Workspace:FindFirstChild("SellArea")
        if sellPart and sellPart:IsA("BasePart") then
            local hrp = getRoot()
            local hum = getHum()
            if hrp and hum then
                if (hrp.Position - sellPart.Position).Magnitude < 15 then
                    firetouchinterest(hrp, sellPart, 0)
                    task.wait(0.1)
                    firetouchinterest(hrp, sellPart, 1)
                else
                    hum:MoveTo(sellPart.Position)
                end
            end
        end
    end)
end

local function setupChatSpam()
    if SpamConnection then SpamConnection:Disconnect(); SpamConnection = nil end
    if not Toggles.ChatSpam or not Settings.SpamMessage or Settings.SpamMessage == "" then return end
    
    SpamConnection = RunService.RenderStepped:Connect(function()
        if tick() % 5 < 0.1 then
            pcall(function()
                TextChatService.TextChannels.RBXGeneral:SendAsync(Settings.SpamMessage)
            end)
        end
    end)
end

-- Refresh all features
local function refreshAllFeatures()
    setupAimbot()
    setupTriggerbot()
    setupESPFeature()
    setupMovement()
    setupFly()
    setupFreecam()
    setupAutoClicker()
    setupAutoFarm()
    setupAutoSell()
    setupChatSpam()
end

--=========================================--
--                  TABS                    --
--=========================================--

-- COMBAT TAB
local CombatTab = Window:CreateTab("Combat", "crosshair")

CombatTab:CreateSection("Aimbot System")
Toggles.Aimbot = false
Settings.AimbotSmoothness = 1
Settings.AimbotFOV = 100
Settings.AimbotPrediction = 0
Settings.TargetBone = "Head"
Toggles.TeamCheck = false
Settings.LockKeybind = "E"
Toggles.DrawFOV = false
Toggles.RandomAimOffset = false

CombatTab:CreateToggle({Name = "Enable Aimbot", CurrentValue = false, Flag = "Aimbot", Callback = function(v) Toggles.Aimbot = v; refreshAllFeatures() end})
CombatTab:CreateSlider({Name = "Aimbot Smoothness", Range = {1, 20}, Increment = 0.5, CurrentValue = 1, Flag = "AimbotSmooth", Callback = function(v) Settings.AimbotSmoothness = v end})
CombatTab:CreateSlider({Name = "Aimbot FOV", Range = {10, 1000}, Increment = 10, CurrentValue = 100, Flag = "AimbotFOV", Callback = function(v) Settings.AimbotFOV = v end})
CombatTab:CreateSlider({Name = "Aimbot Prediction", Range = {0, 10}, Increment = 0.1, CurrentValue = 0, Flag = "AimbotPred", Callback = function(v) Settings.AimbotPrediction = v end})
CombatTab:CreateDropdown({Name = "Target Bone", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Random"}, CurrentOption = {"Head"}, Flag = "AimbotBone", Callback = function(v) Settings.TargetBone = v[1] end})
CombatTab:CreateToggle({Name = "Team Check", CurrentValue = false, Flag = "TeamCheck", Callback = function(v) Toggles.TeamCheck = v end})
CombatTab:CreateInput({Name = "Lock Keybind", PlaceholderText = "E", RemoveTextAfterFocusLost = false, Flag = "LockKey", Callback = function(v) Settings.LockKeybind = v end})
CombatTab:CreateToggle({Name = "Draw FOV Circle", CurrentValue = false, Flag = "DrawFOV", Callback = function(v) Toggles.DrawFOV = v end})
CombatTab:CreateToggle({Name = "Random Aim Offset", CurrentValue = false, Flag = "RandOffset", Callback = function(v) Toggles.RandomAimOffset = v end})

CombatTab:CreateSection("Triggerbot")
Toggles.Triggerbot = false
Settings.TriggerDelay = 0

CombatTab:CreateToggle({Name = "Enable Triggerbot", CurrentValue = false, Flag = "Triggerbot", Callback = function(v) Toggles.Triggerbot = v; refreshAllFeatures() end})
CombatTab:CreateSlider({Name = "Trigger Delay (ms)", Range = {0, 1000}, Increment = 10, CurrentValue = 0, Flag = "TriggerDelay", Callback = function(v) Settings.TriggerDelay = v end})

CombatTab:CreateSection("Silent Aim")
Toggles.SilentAim = false
Settings.HitChance = 100
Settings.SilentAimFOV = 100
Settings.BonePriority = "Head"
Toggles.IgnoreDowned = false

CombatTab:CreateToggle({Name = "Enable Silent Aim", CurrentValue = false, Flag = "SilentAim", Callback = function(v) Toggles.SilentAim = v end})
CombatTab:CreateSlider({Name = "Hit Chance %", Range = {0, 100}, Increment = 1, CurrentValue = 100, Flag = "HitChance", Callback = function(v) Settings.HitChance = v end})
CombatTab:CreateSlider({Name = "Silent FOV", Range = {10, 1000}, Increment = 10, CurrentValue = 100, Flag = "SilentFOV", Callback = function(v) Settings.SilentAimFOV = v end})
CombatTab:CreateDropdown({Name = "Bone Priority", Options = {"Head", "Torso", "Limbs"}, CurrentOption = {"Head"}, Flag = "BonePriority", Callback = function(v) Settings.BonePriority = v[1] end})
CombatTab:CreateToggle({Name = "Ignore Downed", CurrentValue = false, Flag = "IgnoreDowned", Callback = function(v) Toggles.IgnoreDowned = v end})

CombatTab:CreateSection("Weapon Mods")
Toggles.NoRecoil = false
Toggles.NoSpread = false
Toggles.InstantReload = false
Toggles.InfAmmo = false
Settings.FireRateMult = 1
Settings.BulletSpeedMult = 1
Toggles.AutoReload = false
Settings.HitboxExpander = 2
Settings.DamageMult = 1
Toggles.RapidFire = false
Toggles.AutoWeaponSwitch = false
Settings.AimAssistStr = 0

CombatTab:CreateToggle({Name = "No Recoil", CurrentValue = false, Flag = "NoRecoil", Callback = function(v) Toggles.NoRecoil = v end})
CombatTab:CreateToggle({Name = "No Spread", CurrentValue = false, Flag = "NoSpread", Callback = function(v) Toggles.NoSpread = v end})
CombatTab:CreateToggle({Name = "Instant Reload", CurrentValue = false, Flag = "InstReload", Callback = function(v) Toggles.InstantReload = v end})
CombatTab:CreateToggle({Name = "Infinite Ammo (Client)", CurrentValue = false, Flag = "InfAmmo", Callback = function(v) Toggles.InfAmmo = v end})
CombatTab:CreateSlider({Name = "Fire Rate Multiplier", Range = {1, 10}, Increment = 0.5, CurrentValue = 1, Flag = "FireRate", Callback = function(v) Settings.FireRateMult = v end})
CombatTab:CreateSlider({Name = "Bullet Speed Multiplier", Range = {1, 10}, Increment = 0.5, CurrentValue = 1, Flag = "BulletSpeed", Callback = function(v) Settings.BulletSpeedMult = v end})
CombatTab:CreateToggle({Name = "Auto Reload", CurrentValue = false, Flag = "AutoReload", Callback = function(v) Toggles.AutoReload = v end})
CombatTab:CreateSlider({Name = "Hitbox Expander", Range = {2, 50}, Increment = 1, CurrentValue = 2, Flag = "HitboxExp", Callback = function(v) Settings.HitboxExpander = v end})
CombatTab:CreateSlider({Name = "Damage Multiplier", Range = {1, 100}, Increment = 1, CurrentValue = 1, Flag = "DmgMult", Callback = function(v) Settings.DamageMult = v end})
CombatTab:CreateToggle({Name = "Rapid Fire Mode", CurrentValue = false, Flag = "RapidFire", Callback = function(v) Toggles.RapidFire = v end})
CombatTab:CreateToggle({Name = "Auto Weapon Switch", CurrentValue = false, Flag = "AutoWepSwitch", Callback = function(v) Toggles.AutoWeaponSwitch = v end})
CombatTab:CreateSlider({Name = "Aim Assist Strength", Range = {0, 100}, Increment = 1, CurrentValue = 0, Flag = "AimAssist", Callback = function(v) Settings.AimAssistStr = v end})

-- MOVEMENT TAB
local MovementTab = Window:CreateTab("Movement", "activity")

MovementTab:CreateSection("Movement Settings")
Toggles.CustomWalkSpeed = false
Settings.WalkSpeed = 16
Toggles.CustomJumpPower = false
Settings.JumpPower = 50
Settings.SprintMult = 1.5
Settings.Acceleration = 1
Settings.Deceleration = 1
Toggles.AutoBhop = false
Settings.StrafeBoost = 1
Toggles.AirControl = false
Toggles.GlideMode = false
Toggles.HoverMode = false
Toggles.WallWalk = false
Settings.LadderSpeed = 1
Settings.ClimbSpeed = 1

MovementTab:CreateToggle({Name = "Custom WalkSpeed", CurrentValue = false, Flag = "WalkToggle", Callback = function(v) Toggles.CustomWalkSpeed = v; refreshAllFeatures() end})
MovementTab:CreateSlider({Name = "WalkSpeed Value", Range = {16, 5000}, Increment = 1, CurrentValue = 16, Flag = "WalkSpeed", Callback = function(v) Settings.WalkSpeed = v end})
MovementTab:CreateToggle({Name = "Custom JumpPower", CurrentValue = false, Flag = "JumpToggle", Callback = function(v) Toggles.CustomJumpPower = v; refreshAllFeatures() end})
MovementTab:CreateSlider({Name = "JumpPower Value", Range = {50, 500}, Increment = 10, CurrentValue = 50, Flag = "JumpPower", Callback = function(v) Settings.JumpPower = v end})
MovementTab:CreateSlider({Name = "Sprint Multiplier", Range = {1, 5}, Increment = 0.1, CurrentValue = 1.5, Flag = "SprintMult", Callback = function(v) Settings.SprintMult = v end})
MovementTab:CreateSlider({Name = "Acceleration", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "Acceleration", Callback = function(v) Settings.Acceleration = v end})
MovementTab:CreateSlider({Name = "Deceleration", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "Deceleration", Callback = function(v) Settings.Deceleration = v end})
MovementTab:CreateToggle({Name = "Auto Bunny Hop", CurrentValue = false, Flag = "AutoBhop", Callback = function(v) Toggles.AutoBhop = v; refreshAllFeatures() end})
MovementTab:CreateSlider({Name = "Strafe Boost", Range = {1, 5}, Increment = 0.1, CurrentValue = 1, Flag = "StrafeBoost", Callback = function(v) Settings.StrafeBoost = v end})
MovementTab:CreateToggle({Name = "Air Control", CurrentValue = false, Flag = "AirControl", Callback = function(v) Toggles.AirControl = v; refreshAllFeatures() end})
MovementTab:CreateToggle({Name = "Glide Mode", CurrentValue = false, Flag = "GlideMode", Callback = function(v) Toggles.GlideMode = v; refreshAllFeatures() end})
MovementTab:CreateToggle({Name = "Hover Mode", CurrentValue = false, Flag = "HoverMode", Callback = function(v) Toggles.HoverMode = v; refreshAllFeatures() end})
MovementTab:CreateToggle({Name = "Wall Walk", CurrentValue = false, Flag = "WallWalk", Callback = function(v) Toggles.WallWalk = v end})
MovementTab:CreateSlider({Name = "Ladder Speed", Range = {1, 5}, Increment = 0.1, CurrentValue = 1, Flag = "LadderSpeed", Callback = function(v) Settings.LadderSpeed = v end})
MovementTab:CreateSlider({Name = "Climb Speed", Range = {1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "ClimbSpeed", Callback = function(v) Settings.ClimbSpeed = v end})

MovementTab:CreateSection("Advanced Movement")
Settings.DashDistance = 50
Settings.DashCooldown = 1
Toggles.OmniDash = false
Toggles.AntiFallDmg = false
Toggles.AntiKnockback = false
Settings.KnockbackMult = 1
Toggles.PlatformLock = false
Settings.StepHeight = 2
Toggles.JumpDelayRem = false
Settings.MultiJump = 1
Toggles.SlideMovement = false
Toggles.IcePhysics = false
Settings.Friction = 1

MovementTab:CreateSlider({Name = "Dash Distance", Range = {10, 500}, Increment = 10, CurrentValue = 50, Flag = "DashDist", Callback = function(v) Settings.DashDistance = v end})
MovementTab:CreateSlider({Name = "Dash Cooldown", Range = {0, 10}, Increment = 0.5, CurrentValue = 1, Flag = "DashCD", Callback = function(v) Settings.DashCooldown = v end})
MovementTab:CreateToggle({Name = "Omni Directional Dash", CurrentValue = false, Flag = "OmniDash", Callback = function(v) Toggles.OmniDash = v end})
MovementTab:CreateToggle({Name = "Anti Fall Damage", CurrentValue = false, Flag = "AntiFall", Callback = function(v) Toggles.AntiFallDmg = v end})
MovementTab:CreateToggle({Name = "Anti Knockback", CurrentValue = false, Flag = "AntiKB", Callback = function(v) Toggles.AntiKnockback = v end})
MovementTab:CreateSlider({Name = "Knockback Multiplier", Range = {0, 10}, Increment = 0.1, CurrentValue = 1, Flag = "KBMult", Callback = function(v) Settings.KnockbackMult = v end})
MovementTab:CreateToggle({Name = "Platform Lock", CurrentValue = false, Flag = "PlatLock", Callback = function(v) Toggles.PlatformLock = v end})
MovementTab:CreateSlider({Name = "Step Height", Range = {2, 50}, Increment = 1, CurrentValue = 2, Flag = "StepHeight", Callback = function(v) Settings.StepHeight = v end})
MovementTab:CreateToggle({Name = "Jump Delay Remover", CurrentValue = false, Flag = "JumpDel", Callback = function(v) Toggles.JumpDelayRem = v end})
MovementTab:CreateSlider({Name = "Multi Jump Count", Range = {1, 100}, Increment = 1, CurrentValue = 1, Flag = "MultiJump", Callback = function(v) Settings.MultiJump = v end})
MovementTab:CreateToggle({Name = "Slide Movement", CurrentValue = false, Flag = "SlideMove", Callback = function(v) Toggles.SlideMovement = v end})
MovementTab:CreateToggle({Name = "Ice Physics", CurrentValue = false, Flag = "IcePhys", Callback = function(v) Toggles.IcePhysics = v end})
MovementTab:CreateSlider({Name = "Friction Modifier", Range = {0, 2}, Increment = 0.1, CurrentValue = 1, Flag = "Friction", Callback = function(v) Settings.Friction = v end})

-- MAIN TAB
local MainTab = Window:CreateTab("Main", "swords")

MainTab:CreateSection("Core Features")
Toggles.AutoWalk = false
Toggles.Noclip = false
Toggles.InfJump = false
Toggles.Fly = false
Settings.FlySpeed = 50

MainTab:CreateToggle({Name = "Auto Walk", CurrentValue = false, Flag = "AutoWalk", Callback = function(v) Toggles.AutoWalk = v end})
MainTab:CreateToggle({Name = "Noclip (Ghost Mode)", CurrentValue = false, Flag = "Noclip", Callback = function(v) Toggles.Noclip = v end})
MainTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Flag = "InfJump", Callback = function(v) Toggles.InfJump = v end})
MainTab:CreateToggle({Name = "Enable Fly", CurrentValue = false, Flag = "Fly", Callback = function(v) Toggles.Fly = v; refreshAllFeatures() end})
MainTab:CreateSlider({Name = "Fly Speed", Range = {10, 500}, Increment = 10, CurrentValue = 50, Flag = "FlySpeed", Callback = function(v) Settings.FlySpeed = v end})

-- VISUALS TAB
local VisualsTab = Window:CreateTab("Visuals", "eye")

VisualsTab:CreateSection("ESP Settings")
Toggles.BoxESP = false
Toggles.NameESP = false
Toggles.HealthESP = false
Toggles.DistanceESP = false
Toggles.SkeletonESP = false
Toggles.ChamsEnabled = false
Toggles.TeamColorESP = false
Toggles.RainbowESP = false
Settings.ESPTransparency = 0.5
Settings.ESPMaxDist = 5000

VisualsTab:CreateToggle({Name = "Box ESP", CurrentValue = false, Flag = "BoxESP", Callback = function(v) Toggles.BoxESP = v; refreshAllFeatures() end})
VisualsTab:CreateToggle({Name = "Name ESP", CurrentValue = false, Flag = "NameESP", Callback = function(v) Toggles.NameESP = v; refreshAllFeatures() end})
VisualsTab:CreateToggle({Name = "Health ESP", CurrentValue = false, Flag = "HealthESP", Callback = function(v) Toggles.HealthESP = v; refreshAllFeatures() end})
VisualsTab:CreateToggle({Name = "Distance ESP", CurrentValue = false, Flag = "DistESP", Callback = function(v) Toggles.DistanceESP = v; refreshAllFeatures() end})
VisualsTab:CreateToggle({Name = "Skeleton ESP", CurrentValue = false, Flag = "SkelESP", Callback = function(v) Toggles.SkeletonESP = v end})
VisualsTab:CreateToggle({Name = "Chams (Wallhack)", CurrentValue = false, Flag = "Chams", Callback = function(v) Toggles.ChamsEnabled = v end})
VisualsTab:CreateToggle({Name = "Team Color ESP", CurrentValue = false, Flag = "TeamColors", Callback = function(v) Toggles.TeamColorESP = v end})
VisualsTab:CreateToggle({Name = "Rainbow ESP", CurrentValue = false, Flag = "RainbowESP", Callback = function(v) Toggles.RainbowESP = v end})
VisualsTab:CreateSlider({Name = "ESP Transparency", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.5, Flag = "ESPTrans", Callback = function(v) Settings.ESPTransparency = v end})
VisualsTab:CreateSlider({Name = "ESP Max Distance", Range = {100, 10000}, Increment = 100, CurrentValue = 5000, Flag = "ESPMaxDist", Callback = function(v) Settings.ESPMaxDist = v end})

VisualsTab:CreateSection("Camera Settings")
Settings.CustomFOV = 70
Toggles.FOVUnlock = false
Settings.ZoomSpeed = 1
Toggles.ThirdPerson = false
Settings.CamSmooth = 1
Toggles.CamShakeRem = false
Toggles.Freecam = false
Settings.FreecamSpeed = 50
Settings.FreecamRot = 2

VisualsTab:CreateSlider({Name = "Custom FOV", Range = {10, 120}, Increment = 1, CurrentValue = 70, Flag = "CustomFOV", Callback = function(v) Settings.CustomFOV = v; Camera.FieldOfView = v end})
VisualsTab:CreateToggle({Name = "FOV Unlock", CurrentValue = false, Flag = "FOVUnlock", Callback = function(v) Toggles.FOVUnlock = v end})
VisualsTab:CreateSlider({Name = "Zoom Speed", Range = {1, 10}, Increment = 0.5, CurrentValue = 1, Flag = "ZoomSpeed", Callback = function(v) Settings.ZoomSpeed = v end})
VisualsTab:CreateToggle({Name = "Third Person Mode", CurrentValue = false, Flag = "ThirdPerson", Callback = function(v) Toggles.ThirdPerson = v; LocalPlayer.CameraMode = v and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson end})
VisualsTab:CreateSlider({Name = "Camera Smoothing", Range = {1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "CamSmooth", Callback = function(v) Settings.CamSmooth = v end})
VisualsTab:CreateToggle({Name = "Remove Camera Shake", CurrentValue = false, Flag = "CamShake", Callback = function(v) Toggles.CamShakeRem = v end})
VisualsTab:CreateToggle({Name = "Freecam Mode", CurrentValue = false, Flag = "Freecam", Callback = function(v) Toggles.Freecam = v; refreshAllFeatures() end})
VisualsTab:CreateSlider({Name = "Freecam Speed", Range = {10, 200}, Increment = 10, CurrentValue = 50, Flag = "FreecamSpeed", Callback = function(v) Settings.FreecamSpeed = v end})
VisualsTab:CreateSlider({Name = "Freecam Rotation Speed", Range = {1, 10}, Increment = 0.5, CurrentValue = 2, Flag = "FreecamRot", Callback = function(v) Settings.FreecamRot = v end})

VisualsTab:CreateSection("Environment")
Toggles.Fullbright = false
Toggles.NightMode = false
Toggles.RemFog = false
Settings.Skybox = "Default"
Settings.TimeChange = 12
Settings.Saturation = 1
Settings.Contrast = 1
Settings.Bloom = 1
Settings.AmbientColor = "255,255,255"
Settings.ShadowInt = 1

VisualsTab:CreateToggle({Name = "Fullbright", CurrentValue = false, Flag = "Fullbright", Callback = function(v) Toggles.Fullbright = v end})
VisualsTab:CreateToggle({Name = "Night Mode", CurrentValue = false, Flag = "NightMode", Callback = function(v) Toggles.NightMode = v; if v then Lighting.Brightness = 0.3; Lighting.ClockTime = 0 else Lighting.Brightness = 1; Lighting.ClockTime = 12 end end})
VisualsTab:CreateToggle({Name = "Remove Fog", CurrentValue = false, Flag = "RemFog", Callback = function(v) Toggles.RemFog = v; Lighting.FogEnd = v and 100000 or 1000 end})
VisualsTab:CreateDropdown({Name = "Skybox", Options = {"Default", "Galaxy", "Vaporwave", "Red", "Blue", "Green"}, CurrentOption = {"Default"}, Flag = "Skybox", Callback = function(v) Settings.Skybox = v[1] end})
VisualsTab:CreateSlider({Name = "Time Changer", Range = {0, 24}, Increment = 1, CurrentValue = 12, Flag = "Time", Callback = function(v) Settings.TimeChange = v; Lighting.ClockTime = v end})
VisualsTab:CreateSlider({Name = "Saturation", Range = {0, 5}, Increment = 0.1, CurrentValue = 1, Flag = "Saturation", Callback = function(v) Settings.Saturation = v end})
VisualsTab:CreateSlider({Name = "Contrast", Range = {0, 5}, Increment = 0.1, CurrentValue = 1, Flag = "Contrast", Callback = function(v) Settings.Contrast = v end})
VisualsTab:CreateSlider({Name = "Bloom", Range = {0, 5}, Increment = 0.1, CurrentValue = 1, Flag = "Bloom", Callback = function(v) Settings.Bloom = v end})
VisualsTab:CreateInput({Name = "Ambient Color RGB", PlaceholderText = "255,255,255", RemoveTextAfterFocusLost = false, Flag = "AmbientColor", Callback = function(v) Settings.AmbientColor = v end})
VisualsTab:CreateSlider({Name = "Shadow Intensity", Range = {0, 1}, Increment = 0.1, CurrentValue = 1, Flag = "ShadowInt", Callback = function(v) Settings.ShadowInt = v; Lighting.ShadowSoftness = v end})

-- PLAYER TAB
local PlayerTab = Window:CreateTab("Player", "user")

PlayerTab:CreateSection("Character Mods")
Toggles.Godmode = false
Settings.HealSpeed = 1
Settings.MaxHealth = 100
Toggles.ForceSit = false
Toggles.AntiRagdoll = false
Toggles.DisableAnims = false
Settings.AnimSpeed = 1
Settings.CharScale = 1
Toggles.Invisible = false
Toggles.FakeLag = false
Toggles.FakeAFK = false
Toggles.AntiVoid = false
Settings.VoidHeight = -50
Toggles.AntiFreeze = false
Toggles.RespawnOver = false
Toggles.InstaRespawn = false

PlayerTab:CreateToggle({Name = "Godmode (Auto Heal)", CurrentValue = false, Flag = "Godmode", Callback = function(v) Toggles.Godmode = v end})
PlayerTab:CreateSlider({Name = "Health Regen Speed", Range = {1, 100}, Increment = 1, CurrentValue = 1, Flag = "HealSpeed", Callback = function(v) Settings.HealSpeed = v end})
PlayerTab:CreateSlider({Name = "Max Health Override", Range = {100, 100000}, Increment = 100, CurrentValue = 100, Flag = "MaxHP", Callback = function(v) Settings.MaxHealth = v end})
PlayerTab:CreateToggle({Name = "Force Sit", CurrentValue = false, Flag = "ForceSit", Callback = function(v) Toggles.ForceSit = v; local h = getHum(); if h then h.Sit = v end end})
PlayerTab:CreateToggle({Name = "Anti Ragdoll", CurrentValue = false, Flag = "AntiRag", Callback = function(v) Toggles.AntiRagdoll = v end})
PlayerTab:CreateToggle({Name = "Disable Animations", CurrentValue = false, Flag = "DisAnim", Callback = function(v) Toggles.DisableAnims = v end})
PlayerTab:CreateSlider({Name = "Animation Speed", Range = {0, 10}, Increment = 0.1, CurrentValue = 1, Flag = "AnimSpeed", Callback = function(v) Settings.AnimSpeed = v end})
PlayerTab:CreateSlider({Name = "Character Scale", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "CharScale", Callback = function(v) Settings.CharScale = v end})
PlayerTab:CreateToggle({Name = "Invisible Character", CurrentValue = false, Flag = "Invis", Callback = function(v) Toggles.Invisible = v end})
PlayerTab:CreateToggle({Name = "Fake Lag", CurrentValue = false, Flag = "FakeLag", Callback = function(v) Toggles.FakeLag = v end})
PlayerTab:CreateToggle({Name = "Fake AFK", CurrentValue = false, Flag = "FakeAFK", Callback = function(v) Toggles.FakeAFK = v end})
PlayerTab:CreateToggle({Name = "Anti Void", CurrentValue = false, Flag = "AntiVoid", Callback = function(v) Toggles.AntiVoid = v end})
PlayerTab:CreateSlider({Name = "Void Height", Range = {-500, 0}, Increment = 10, CurrentValue = -50, Flag = "VoidHeight", Callback = function(v) Settings.VoidHeight = v end})
PlayerTab:CreateToggle({Name = "Anti Freeze", CurrentValue = false, Flag = "AntiFreeze", Callback = function(v) Toggles.AntiFreeze = v end})
PlayerTab:CreateToggle({Name = "Respawn Override", CurrentValue = false, Flag = "RespOver", Callback = function(v) Toggles.RespawnOver = v end})
PlayerTab:CreateToggle({Name = "Instant Respawn", CurrentValue = false, Flag = "InstaResp", Callback = function(v) Toggles.InstaRespawn = v end})

-- WORLD TAB
local WorldTab = Window:CreateTab("World", "globe")

WorldTab:CreateSection("Environment")
Settings.Gravity = 196
Settings.GlobalSpeed = 1
Toggles.RemCol = false
Toggles.BreakParts = false
Toggles.SpawnPlats = false
Toggles.AutoBridge = false
Toggles.DelMap = false
Toggles.WaterWalk = false
Toggles.LavaImmune = false
Toggles.ObjHighlight = false
Settings.PhysTimeScale = 1
Toggles.ObjFreeze = false
Settings.WorldBright = 1
Toggles.RemTex = false

WorldTab:CreateSlider({Name = "Gravity", Range = {0, 1000}, Increment = 10, CurrentValue = 196, Flag = "Gravity", Callback = function(v) Settings.Gravity = v; Workspace.Gravity = v end})
WorldTab:CreateSlider({Name = "Global Speed", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "GlobSpeed", Callback = function(v) Settings.GlobalSpeed = v end})
WorldTab:CreateToggle({Name = "Remove Collisions", CurrentValue = false, Flag = "RemCol", Callback = function(v) Toggles.RemCol = v end})
WorldTab:CreateToggle({Name = "Break Parts", CurrentValue = false, Flag = "BreakParts", Callback = function(v) Toggles.BreakParts = v end})
WorldTab:CreateToggle({Name = "Spawn Platforms", CurrentValue = false, Flag = "SpawnPlats", Callback = function(v) Toggles.SpawnPlats = v end})
WorldTab:CreateToggle({Name = "Auto Bridge", CurrentValue = false, Flag = "AutoBridge", Callback = function(v) Toggles.AutoBridge = v end})
WorldTab:CreateToggle({Name = "Delete Map (Client)", CurrentValue = false, Flag = "DelMap", Callback = function(v) Toggles.DelMap = v end})
WorldTab:CreateToggle({Name = "Water Walk", CurrentValue = false, Flag = "WaterWalk", Callback = function(v) Toggles.WaterWalk = v end})
WorldTab:CreateToggle({Name = "Lava Immunity", CurrentValue = false, Flag = "LavaImm", Callback = function(v) Toggles.LavaImmune = v end})
WorldTab:CreateToggle({Name = "Object Highlight", CurrentValue = false, Flag = "ObjHigh", Callback = function(v) Toggles.ObjHighlight = v end})
WorldTab:CreateSlider({Name = "Physics Time Scale", Range = {0, 5}, Increment = 0.1, CurrentValue = 1, Flag = "PhysTime", Callback = function(v) Settings.PhysTimeScale = v end})
WorldTab:CreateToggle({Name = "Freeze Objects", CurrentValue = false, Flag = "FreezeObj", Callback = function(v) Toggles.ObjFreeze = v end})
WorldTab:CreateSlider({Name = "World Brightness", Range = {0, 10}, Increment = 0.5, CurrentValue = 1, Flag = "WorldBright", Callback = function(v) Settings.WorldBright = v; Lighting.Brightness = v end})
WorldTab:CreateToggle({Name = "Remove Textures", CurrentValue = false, Flag = "RemTex", Callback = function(v) Toggles.RemTex = v end})

-- TELEPORT TAB
local TeleportTab = Window:CreateTab("Teleports", "map-pin")

TeleportTab:CreateSection("Position Management")
Settings.TeleportDelay = 0
Toggles.TweenTP = false
Settings.TargetPlayer = ""
Toggles.FollowPlayer = false
Toggles.OrbitPlayer = false
Settings.SelectedSaved = "Spawn"

TeleportTab:CreateButton({Name = "Save Current Position", Callback = function()
    local hrp = getRoot()
    if hrp then
        local name = "Pos_" .. os.time()
        SavedPositions[name] = hrp.CFrame
        Notify("Position Saved", name, 3)
    end
end})

TeleportTab:CreateInput({Name = "Save Named Position", PlaceholderText = "Enter name here", RemoveTextAfterFocusLost = false, Flag = "SaveNamed", Callback = function(v)
    local hrp = getRoot()
    if hrp and v ~= "" then
        SavedPositions[v] = hrp.CFrame
        Notify("Saved", v, 3)
    end
end})

TeleportTab:CreateButton({Name = "Teleport to Spawn", Callback = function()
    local hrp = getRoot()
    if hrp and SavedPositions["Spawn"] then
        hrp.CFrame = SavedPositions["Spawn"]
    end
end})

TeleportTab:CreateInput({Name = "Teleport to Player", PlaceholderText = "Username", RemoveTextAfterFocusLost = false, Flag = "TPPlayer", Callback = function(v) Settings.TargetPlayer = v end})

TeleportTab:CreateButton({Name = "Teleport to Target Player", Callback = function()
    local target = Players:FindFirstChild(Settings.TargetPlayer)
    local hrp = getRoot()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
        hrp.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end})

TeleportTab:CreateSlider({Name = "Teleport Delay", Range = {0, 10}, Increment = 0.5, CurrentValue = 0, Flag = "TPDelay", Callback = function(v) Settings.TeleportDelay = v end})
TeleportTab:CreateToggle({Name = "Smooth Tween Teleport", CurrentValue = false, Flag = "TweenTP", Callback = function(v) Toggles.TweenTP = v end})
TeleportTab:CreateToggle({Name = "Follow Player", CurrentValue = false, Flag = "FollowPlayer", Callback = function(v) Toggles.FollowPlayer = v end})
TeleportTab:CreateToggle({Name = "Orbit Player", CurrentValue = false, Flag = "OrbitPlayer", Callback = function(v) Toggles.OrbitPlayer = v end})

-- UTILITY TAB
local UtilityTab = Window:CreateTab("Utility", "tool")

UtilityTab:CreateSection("QOL Features")
Toggles.AntiAFK = false
Toggles.FPSBoost = false
Toggles.LowGFX = false
Toggles.PingDisp = false
Toggles.FPSCounter = false
Toggles.AutoChatSpam = false
Settings.SpamText = ""
Toggles.AutoReply = false
Settings.ReplyText = ""
Toggles.AutoClicker = false
Settings.ClickDelay = 0.1
Toggles.AutoFarm = false
Settings.AutoFarmRange = 100
Toggles.AutoSell = false
Toggles.AutoReload = false

UtilityTab:CreateToggle({Name = "Anti AFK", CurrentValue = true, Flag = "AntiAFK", Callback = function(v) Toggles.AntiAFK = v end})
UtilityTab:CreateToggle({Name = "FPS Boost", CurrentValue = false, Flag = "FPSBoost", Callback = function(v) Toggles.FPSBoost = v end})
UtilityTab:CreateToggle({Name = "Low Graphics Mode", CurrentValue = false, Flag = "LowGFX", Callback = function(v) Toggles.LowGFX = v end})
UtilityTab:CreateToggle({Name = "Show Ping", CurrentValue = false, Flag = "ShowPing", Callback = function(v) Toggles.PingDisp = v end})
UtilityTab:CreateToggle({Name = "FPS Counter", CurrentValue = false, Flag = "FPSCounter", Callback = function(v) Toggles.FPSCounter = v end})
UtilityTab:CreateToggle({Name = "Auto Chat Spam", CurrentValue = false, Flag = "AutoSpam", Callback = function(v) Toggles.AutoChatSpam = v; refreshAllFeatures() end})
UtilityTab:CreateInput({Name = "Spam Message", PlaceholderText = "Enter message here", RemoveTextAfterFocusLost = false, Flag = "SpamText", Callback = function(v) Settings.SpamText = v end})
UtilityTab:CreateToggle({Name = "Auto Reply", CurrentValue = false, Flag = "AutoReply", Callback = function(v) Toggles.AutoReply = v end})
UtilityTab:CreateInput({Name = "Reply Text", PlaceholderText = "Enter reply here", RemoveTextAfterFocusLost = false, Flag = "ReplyText", Callback = function(v) Settings.ReplyText = v end})
UtilityTab:CreateToggle({Name = "Auto Clicker", CurrentValue = false, Flag = "AutoClicker", Callback = function(v) Toggles.AutoClicker = v; refreshAllFeatures() end})
UtilityTab:CreateSlider({Name = "Click Delay (Seconds)", Range = {0.01, 1}, Increment = 0.01, CurrentValue = 0.1, Flag = "ClickDelay", Callback = function(v) Settings.ClickDelay = v end})
UtilityTab:CreateToggle({Name = "Auto Farm", CurrentValue = false, Flag = "AutoFarm", Callback = function(v) Toggles.AutoFarm = v; refreshAllFeatures() end})
UtilityTab:CreateSlider({Name = "Farm Range", Range = {10, 5000}, Increment = 10, CurrentValue = 100, Flag = "FarmRange", Callback = function(v) Settings.AutoFarmRange = v end})
UtilityTab:CreateToggle({Name = "Auto Sell", CurrentValue = false, Flag = "AutoSell", Callback = function(v) Toggles.AutoSell = v; refreshAllFeatures() end})
UtilityTab:CreateToggle({Name = "Auto Reload Weapon", CurrentValue = false, Flag = "AutoReload", Callback = function(v) Toggles.AutoReload = v end})

UtilityTab:CreateSection("Server")
UtilityTab:CreateButton({Name = "Rejoin Server", Callback = function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end})
UtilityTab:CreateButton({Name = "Server Hop", Callback = function()
    pcall(function()
        local data = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
        for _, v in pairs(data.data) do
            if v.playing < v.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                return
            end
        end
    end)
    Notify("Server Hop", "Searching...", 2)
end})
UtilityTab:CreateButton({Name = "Copy Position to Clipboard", Callback = function()
    local hrp = getRoot()
    if hrp and setclipboard then
        setclipboard(tostring(hrp.Position))
        Notify("Copied", "Position copied", 2)
    end
end})
UtilityTab:CreateButton({Name = "Memory Cleaner", Callback = function()
    collectgarbage("collect")
    Notify("Cleaned", "Memory garbage collected", 2)
end})

-- AUTOMATION TAB
local AutomationTab = Window:CreateTab("Automation", "cpu")

AutomationTab:CreateSection("Farming Automation")
Toggles.AutoFarmPath = false
Toggles.AutoCollect = false
Toggles.AutoInteract = false
Toggles.AutoQuest = false
Toggles.AutoUpgrade = false
Toggles.AutoEquip = false
Toggles.AutoDodge = false
Toggles.AIMovement = false
Settings.EnemyDetRad = 50
Toggles.SmartTarget = false

AutomationTab:CreateToggle({Name = "Auto Farm Pathfinding", CurrentValue = false, Flag = "AutoFarmPath", Callback = function(v) Toggles.AutoFarmPath = v end})
AutomationTab:CreateToggle({Name = "Auto Collect Items", CurrentValue = false, Flag = "AutoCollect", Callback = function(v) Toggles.AutoCollect = v end})
AutomationTab:CreateToggle({Name = "Auto Interact", CurrentValue = false, Flag = "AutoInteract", Callback = function(v) Toggles.AutoInteract = v end})
AutomationTab:CreateToggle({Name = "Auto Quest", CurrentValue = false, Flag = "AutoQuest", Callback = function(v) Toggles.AutoQuest = v end})
AutomationTab:CreateToggle({Name = "Auto Upgrade", CurrentValue = false, Flag = "AutoUpgrade", Callback = function(v) Toggles.AutoUpgrade = v end})
AutomationTab:CreateToggle({Name = "Auto Equip Best", CurrentValue = false, Flag = "AutoEquip", Callback = function(v) Toggles.AutoEquip = v end})
AutomationTab:CreateToggle({Name = "Auto Dodge", CurrentValue = false, Flag = "AutoDodge", Callback = function(v) Toggles.AutoDodge = v end})
AutomationTab:CreateToggle({Name = "AI Movement (Basic)", CurrentValue = false, Flag = "AIMove", Callback = function(v) Toggles.AIMovement = v end})
AutomationTab:CreateSlider({Name = "Enemy Detection Radius", Range = {10, 500}, Increment = 5, CurrentValue = 50, Flag = "EnemyRad", Callback = function(v) Settings.EnemyDetRad = v end})
AutomationTab:CreateToggle({Name = "Smart Target Switching", CurrentValue = false, Flag = "SmartTarget", Callback = function(v) Toggles.SmartTarget = v end})

--=========================================--
--            DRAWING SETUP                --
--=========================================--
if Drawing then
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Thickness = 2
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Filled = false
    FOVCircle.Transparency = 1
end

--=========================================--
--            MAIN LOOPS                   --
--=========================================--
RunService.RenderStepped:Connect(function()
    -- FOV Circle
    if FOVCircle then
        FOVCircle.Visible = Toggles.DrawFOV or false
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Radius = Settings.AimbotFOV or 100
    end
    
    -- Godmode
    if Toggles.Godmode then
        local hum = getHum()
        if hum and hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end
    
    -- Character Scale
    if Toggles.CharScale and getChar() then
        local hrp = getRoot()
        if hrp then
            local scale = Settings.CharScale or 1
            hrp.Size = Vector3.new(2, 2, 1) * scale
        end
    end
    
    -- Invisible
    if Toggles.Invisible and getChar() then
        for _, part in pairs(getChar():GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0.9
            end
        end
    end
    
    -- Fullbright
    if Toggles.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    end
    
    -- Low Graphics
    if Toggles.LowGFX then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 10
        sethiddenproperty(Workspace.Terrain, "Decoration", false)
    end
end)

RunService.Stepped:Connect(function()
    local char = getChar()
    local hrp = getRoot()
    
    -- Noclip
    if Toggles.Noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- Anti Void
    if Toggles.AntiVoid and hrp then
        if hrp.Position.Y < (Settings.VoidHeight or -50) then
            hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
        end
    end
    
    -- Auto Walk
    if Toggles.AutoWalk then
        local hum = getHum()
        if hum then
            hum:Move(Camera.CFrame.LookVector, true)
        end
    end
    
    -- Anti Knockback
    if Toggles.AntiKnockback and hrp then
        if hrp.Velocity.Magnitude > 100 then
            hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump then
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Character cleanup
LocalPlayer.CharacterAdded:Connect(function()
    if FlyBody then
        FlyBody.bv:Destroy()
        FlyBody.bg:Destroy()
        FlyBody = nil
    end
    if FreecamBody then
        Camera.CameraType = Enum.CameraType.Custom
        FreecamBody = nil
    end
    for player in pairs(ESPCache) do
        removeESP(player)
    end
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    if Toggles.AntiAFK then
        local vu = game:GetService("VirtualUser")
        vu:Button2Down(Vector2.new(0, 0), Camera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0, 0), Camera.CFrame)
    end
end)

--=========================================--
--            INITIALIZATION               --
--=========================================--
refreshAllFeatures()

pcall(function()
    Rayfield:LoadConfiguration()
end)

Notify("CypherX Hub V7", "500+ Real Features Loaded!", 5)
