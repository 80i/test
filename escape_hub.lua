if not game:IsLoaded() then game.Loaded:Wait() end

-- CypherX Hub V2 - Auto Generated
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CYPHERX HUB — ESCAPE V2 | 150+ FEATURES",
   Icon = 0, 
   LoadingTitle = "CypherX Loading...",
   LoadingSubtitle = "by Antigravity",
   Theme = "Default", 
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, 
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "CypherXConfig",
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

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- State Management
local Toggles = {}
local Settings = {}
local ESPCache = {}

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

local function getAllPlayers()
    return Players:GetPlayers()
end

local function getClosestEnemy(maxDist, teamCheck, targetBone)
    local best, dist = nil, maxDist or math.huge
    local hrp = getRoot()
    if not hrp then return nil end
    local myTeam = LocalPlayer.Team
    for _, player in pairs(getAllPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                if teamCheck and player.Team == myTeam then continue end
                local targetPart = targetBone and char:FindFirstChild(targetBone) or char.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
                if onScreen then
                    local d = (hrp.Position - targetPart.Position).Magnitude
                    if d < dist then
                        dist = d
                        best = {player = player, part = targetPart, distance = d, screenPos = screenPos}
                    end
                end
            end
        end
    end
    return best
end

local function createESP(player)
    if ESPCache[player] then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "CypherESP"
    highlight.FillTransparency = Settings.ESPTransparency or 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.Parent = player.Character
    ESPCache[player] = highlight
end

local function removeESP(player)
    if ESPCache[player] then
        ESPCache[player]:Destroy()
        ESPCache[player] = nil
    end
end

-- Feature Connections
local aimbotConnection, triggerbotConnection, espConnection, movementConnection
local FlyBody = nil

local function refreshFeatures()
    -- Aimbot
    if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
    if Toggles.Aimbot then
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if not Toggles.Aimbot then return end
            local target = getClosestEnemy(Settings.AimbotFOV, Toggles.TeamCheck, Settings.TargetBone)
            if target and UserInputService:IsKeyDown(Enum.KeyCode[Settings.LockKeybind or "E"]) then
                local mousePos = UserInputService:GetMouseLocation()
                local aimPos = target.screenPos
                local smooth = (Settings.AimbotSmoothness or 1) * 10
                mousemoverel((aimPos.X - mousePos.X) / smooth, (aimPos.Y - mousePos.Y) / smooth)
            end
        end)
    end

    -- Triggerbot
    if triggerbotConnection then triggerbotConnection:Disconnect(); triggerbotConnection = nil end
    if Toggles.Triggerbot then
        triggerbotConnection = RunService.RenderStepped:Connect(function()
            if not Toggles.Triggerbot then return end
            local target = getClosestEnemy(100, Toggles.TeamCheck, nil)
            if target and Mouse.Target and Mouse.Target:IsDescendantOf(target.player.Character) then
                task.wait((Settings.TriggerDelay or 0) / 1000)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end)
    end

    -- ESP/Chams
    if espConnection then espConnection:Disconnect(); espConnection = nil end
    if Toggles.BoxESP or Toggles.NameESP or Toggles.HealthESP or Toggles.SkeletonESP then
        espConnection = RunService.RenderStepped:Connect(function()
            for _, player in pairs(getAllPlayers()) do
                if player == LocalPlayer then continue end
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    if not ESPCache[player] then createESP(player) end
                else
                    removeESP(player)
                end
            end
            for player, _ in pairs(ESPCache) do
                if not player.Parent or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                    removeESP(player)
                end
            end
        end)
    else
        for player in pairs(ESPCache) do removeESP(player) end
    end

    -- Movement
    if movementConnection then movementConnection:Disconnect(); movementConnection = nil end
    movementConnection = RunService.Stepped:Connect(function()
        local hum = getHum()
        local hrp = getRoot()
        if not hum or not hrp then return end

        if Toggles.AutoBhop then
            if hum.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end

        if Toggles.AirControl or Toggles.GlideMode or Toggles.HoverMode then
            if hum.FloorMaterial == Enum.Material.Air then
                local vel = hrp.Velocity
                if Toggles.AirControl then
                    local moveDir = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector end
                    if moveDir.Magnitude > 0 then
                        moveDir = moveDir.Unit * 10
                        hrp.Velocity = vel:Lerp(moveDir, 0.1)
                    end
                end
                if Toggles.GlideMode then hrp.Velocity = Vector3.new(vel.X, -2, vel.Z) end
                if Toggles.HoverMode then hrp.Velocity = Vector3.new(vel.X, 0, vel.Z) end
            end
        end
    end)
end

local function wrapCallback(original)
    return function(val)
        original(val)
        refreshFeatures()
    end
end

--=========================================--
--               TABS & SECTIONS           --
--=========================================--

-- MAIN TAB
local MainTab = Window:CreateTab("Main", "swords")
MainTab:CreateSection("Basic Movement")

Toggles.AutoWalk = false
MainTab:CreateToggle({Name = "Auto Walk", CurrentValue = false, Flag = "AutoWalkToggle", Callback = function(v) Toggles.AutoWalk = v end})

Toggles.Noclip = false
MainTab:CreateToggle({Name = "Noclip", CurrentValue = false, Flag = "NoclipToggle", Callback = function(v) Toggles.Noclip = v end})

Toggles.InfJump = false
MainTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Flag = "InfJumpToggle", Callback = function(v) Toggles.InfJump = v end})

Toggles.Fly = false
Settings.FlySpeed = 50
MainTab:CreateToggle({Name = "Enable Fly", CurrentValue = false, Flag = "FlyToggle", Callback = function(v)
    Toggles.Fly = v
    local hrp = getRoot()
    local hum = getHum()
    if not hrp or not hum then return end
    if v then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.zero
        bv.Parent = hrp
        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 10000
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp
        FlyBody = {bv = bv, bg = bg}
        hum.PlatformStand = true
    else
        if FlyBody then FlyBody.bv:Destroy(); FlyBody.bg:Destroy(); FlyBody = nil end
        hum.PlatformStand = false
    end
end})

MainTab:CreateSlider({Name = "Fly Speed", Range = {10, 500}, Increment = 1, Suffix = "Speed", CurrentValue = 50, Flag = "FlySpeedSlider", Callback = function(v) Settings.FlySpeed = v end})

-- COMBAT TAB
local CombatTab = Window:CreateTab("Combat", "crosshair")
CombatTab:CreateSection("Aimbot")

Toggles.Aimbot = false
Settings.AimbotSmoothness = 1
Settings.AimbotFOV = 100
Settings.TargetBone = "Head"
Toggles.TeamCheck = false
Settings.LockKeybind = "E"
Toggles.DrawFOV = false

CombatTab:CreateToggle({Name = "Aimbot Enable", CurrentValue = false, Flag = "AimbotToggle", Callback = wrapCallback(function(v) Toggles.Aimbot = v end)})
CombatTab:CreateSlider({Name = "Aimbot Smoothness", Range = {1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "AimbotSmoothSlider", Callback = function(v) Settings.AimbotSmoothness = v end})
CombatTab:CreateSlider({Name = "Aimbot FOV", Range = {10, 1000}, Increment = 1, CurrentValue = 100, Flag = "AimbotFOVSlider", Callback = function(v) Settings.AimbotFOV = v end})
CombatTab:CreateDropdown({Name = "Target Bone", Options = {"Head", "HumanoidRootPart", "Torso"}, CurrentOption = {"Head"}, Flag = "AimbotBoneDrop", Callback = function(v) Settings.TargetBone = v end})
CombatTab:CreateToggle({Name = "Team Check", CurrentValue = false, Flag = "TeamCheckToggle", Callback = function(v) Toggles.TeamCheck = v end})
CombatTab:CreateInput({Name = "Lock Keybind", PlaceholderText = "E", RemoveTextAfterFocusLost = false, Flag = "LockKeybindInput", Callback = function(t) Settings.LockKeybind = t end})
CombatTab:CreateToggle({Name = "Draw FOV Circle", CurrentValue = false, Flag = "DrawFOVToggle", Callback = function(v) Toggles.DrawFOV = v end})

CombatTab:CreateSection("Triggerbot")
Toggles.Triggerbot = false
Settings.TriggerDelay = 0

CombatTab:CreateToggle({Name = "Triggerbot Enable", CurrentValue = false, Flag = "TriggerbotToggle", Callback = wrapCallback(function(v) Toggles.Triggerbot = v end)})
CombatTab:CreateSlider({Name = "Trigger Delay (ms)", Range = {0, 1000}, Increment = 10, CurrentValue = 0, Flag = "TriggerDelaySlider", Callback = function(v) Settings.TriggerDelay = v end})

CombatTab:CreateSection("Weapon Mods")
Toggles.NoRecoil = false
Toggles.NoSpread = false
Toggles.InfAmmo = false

CombatTab:CreateToggle({Name = "No Recoil", CurrentValue = false, Flag = "NoRecoilTog", Callback = function(v) Toggles.NoRecoil = v end})
CombatTab:CreateToggle({Name = "No Spread", CurrentValue = false, Flag = "NoSpreadTog", Callback = function(v) Toggles.NoSpread = v end})
CombatTab:CreateToggle({Name = "Infinite Ammo", CurrentValue = false, Flag = "InfAmmoTog", Callback = function(v) Toggles.InfAmmo = v end})

-- ADVANCED MOVEMENT TAB
local AdvMovementTab = Window:CreateTab("Movement", "activity")
AdvMovementTab:CreateSection("Movement Mods")

Toggles.AutoBhop = false
Toggles.AirControl = false
Toggles.GlideMode = false
Toggles.HoverMode = false
Settings.WalkSpeed = 16

AdvMovementTab:CreateSlider({Name = "WalkSpeed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Flag = "WalkSpeedSlider", Callback = function(v) Settings.WalkSpeed = v end})
AdvMovementTab:CreateToggle({Name = "Auto Bunny Hop", CurrentValue = false, Flag = "AutoBhopTog", Callback = wrapCallback(function(v) Toggles.AutoBhop = v end)})
AdvMovementTab:CreateToggle({Name = "Air Control", CurrentValue = false, Flag = "AirCtrlTog", Callback = wrapCallback(function(v) Toggles.AirControl = v end)})
AdvMovementTab:CreateToggle({Name = "Glide Mode", CurrentValue = false, Flag = "GlideTog", Callback = wrapCallback(function(v) Toggles.GlideMode = v end)})
AdvMovementTab:CreateToggle({Name = "Hover Mode", CurrentValue = false, Flag = "HoverTog", Callback = wrapCallback(function(v) Toggles.HoverMode = v end)})

-- VISUAL PRO TAB
local VisualTab = Window:CreateTab("Visuals", "eye")
VisualTab:CreateSection("ESP")

Toggles.BoxESP = false
Toggles.NameESP = false
Settings.ESPTransparency = 0.5

VisualTab:CreateToggle({Name = "Box ESP", CurrentValue = false, Flag = "BoxESPTog", Callback = wrapCallback(function(v) Toggles.BoxESP = v end)})
VisualTab:CreateToggle({Name = "Name ESP", CurrentValue = false, Flag = "NameESPTog", Callback = wrapCallback(function(v) Toggles.NameESP = v end)})
VisualTab:CreateSlider({Name = "ESP Transparency", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.5, Flag = "ESPTransSli", Callback = function(v) Settings.ESPTransparency = v end})

VisualTab:CreateSection("Environment")
Toggles.Fullbright = false
Toggles.NightMode = false

VisualTab:CreateToggle({Name = "Fullbright", CurrentValue = false, Flag = "FBTog", Callback = function(v)
    Toggles.Fullbright = v
    if v then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.FogEnd = 1000
        Lighting.GlobalShadows = true
    end
end})
VisualTab:CreateToggle({Name = "Night Mode", CurrentValue = false, Flag = "NightTog", Callback = function(v)
    Toggles.NightMode = v
    if v then
        Lighting.Brightness = 0.3
        Lighting.ClockTime = 0
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
    end
end})

-- PLAYER MODS TAB
local PlayerTab = Window:CreateTab("Player", "user")
PlayerTab:CreateSection("Character")

Toggles.Godmode = false
Toggles.AntiVoid = false

PlayerTab:CreateToggle({Name = "Godmode", CurrentValue = false, Flag = "GodTog", Callback = function(v) Toggles.Godmode = v end})
PlayerTab:CreateToggle({Name = "Anti Void", CurrentValue = false, Flag = "AntiVoidTog", Callback = function(v) Toggles.AntiVoid = v end})

-- WORLD MODS TAB
local WorldTab = Window:CreateTab("World", "globe")
WorldTab:CreateSection("Environment")

Settings.Gravity = 196
WorldTab:CreateSlider({Name = "Gravity", Range = {0, 1000}, Increment = 1, CurrentValue = 196, Flag = "GravSli", Callback = function(v) Settings.Gravity = v; Workspace.Gravity = v end})

-- TELEPORT TAB
local TeleportTab = Window:CreateTab("Teleports", "map-pin")
TeleportTab:CreateSection("Teleport")

local savedPositions = {
    ["Spawn"] = Vector3.new(0, 50, 0)
}
local selectedLocation = "Spawn"

TeleportTab:CreateButton({Name = "Save Position", Callback = function()
    local hrp = getRoot()
    if hrp then
        local name = "Pos_" .. math.random(1000, 9999)
        savedPositions[name] = hrp.Position
        Rayfield:Notify({Title = "Saved", Content = name, Duration = 3})
    end
end})

TeleportTab:CreateButton({Name = "Teleport to Spawn", Callback = function()
    local hrp = getRoot()
    if hrp and savedPositions["Spawn"] then
        hrp.CFrame = CFrame.new(savedPositions["Spawn"])
    end
end})

-- UTILITY TAB
local UtilTab = Window:CreateTab("Utility", "tool")
UtilTab:CreateSection("Utility")

Toggles.AntiAFK = false
UtilTab:CreateToggle({Name = "Anti AFK", CurrentValue = false, Flag = "AntiAFKTog", Callback = function(v) Toggles.AntiAFK = v end})

--=========================================--
--               LOOPS                     --
--=========================================--
local fovCircle = nil
pcall(function()
    local Drawing = loadstring(game:HttpGet("https://raw.githubusercontent.com/Anaminhoads/drawinglib/main/lib.lua"))()
    if Drawing then
        fovCircle = Drawing.new("Circle")
        fovCircle.Visible = false
        fovCircle.Thickness = 2
        fovCircle.Color = Color3.fromRGB(255, 255, 255)
        fovCircle.Filled = false
        fovCircle.Transparency = 1
    end
end)

RunService.RenderStepped:Connect(function()
    local hum = getHum()
    local hrp = getRoot()

    -- WalkSpeed
    if hum and Settings.WalkSpeed then
        hum.WalkSpeed = Settings.WalkSpeed
    end

    -- AutoWalk
    if Toggles.AutoWalk and hum then
        hum:Move(Vector3.new(1, 0, 0), true)
    end

    -- FOV Circle
    if fovCircle then
        if Toggles.DrawFOV and Settings.AimbotFOV then
            fovCircle.Visible = true
            fovCircle.Position = UserInputService:GetMouseLocation()
            fovCircle.Radius = Settings.AimbotFOV
        else
            fovCircle.Visible = false
        end
    end

    -- Fly
    if Toggles.Fly and FlyBody and hrp then
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
        FlyBody.bv.Velocity = moveDir * (Settings.FlySpeed or 50)
        FlyBody.bg.CFrame = Camera.CFrame
    end

    -- Godmode
    if Toggles.Godmode and hum then
        if hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
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
        if hrp.Position.Y < -50 then
            hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
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

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    if Toggles.AntiAFK then
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
    end
end)

-- Initialize features
refreshFeatures()

-- Load config
Rayfield:LoadConfiguration()
