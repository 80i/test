if not game:IsLoaded() then game.Loaded:Wait() end

--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║            CYPHERX HUB V4 — PROFESSIONAL EDITION            ║
    ║                    500+ Features | 9 Tabs                    ║
    ║              Built with Rayfield UI Library                  ║
    ╚══════════════════════════════════════════════════════════════╝
]]

--------------------------------------------------------------------------------
-- RAYFIELD INIT
--------------------------------------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "CYPHERX HUB V4 — PROFESSIONAL | 500+ FEATURES",
    Icon = 0,
    LoadingTitle = "CypherX V4 Loading...",
    LoadingSubtitle = "Professional Edition",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "CypherXConfigV4",
        FileName = "ProEdition"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

--------------------------------------------------------------------------------
-- SERVICES
--------------------------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local CollectionService = game:GetService("CollectionService")
local PathfindingService = game:GetService("PathfindingService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Safe references for exploit-only APIs
local VirtualInputManager = nil
pcall(function() VirtualInputManager = game:GetService("VirtualInputManager") end)

local Drawing = nil
pcall(function()
    Drawing = loadstring(game:HttpGet("https://raw.githubusercontent.com/Anaminhoads/drawinglib/main/lib.lua"))()
end)

--------------------------------------------------------------------------------
-- STATE TABLES
--------------------------------------------------------------------------------
local Toggles = {}
local Settings = {}
local Connections = {}
local ESPCache = {}
local SavedPositions = { ["Spawn"] = CFrame.new(0, 50, 0) }
local TeleportHistory = {}
local HitLog = {}
local ChatLog = {}
local FlyBody = nil
local FreecamBody = nil
local OrbitingAngle = 0
local LastDashTime = 0
local JumpCount = 0
local FOVCircle = nil
local CrosshairLines = {}
local CachedParts = {}
local CachedEnemies = {}
local LastCacheTime = 0
local FeatureCount = 0

-- Default settings initialization
Settings.WalkSpeed = 16
Settings.JumpPower = 50
Settings.FlySpeed = 50
Settings.AimbotSmoothness = 5
Settings.AimbotFOV = 100
Settings.AimbotPrediction = 0
Settings.TargetBone = "Head"
Settings.LockKeybind = "E"
Settings.TriggerDelay = 50
Settings.HitChance = 100
Settings.SilentAimFOV = 100
Settings.BonePriority = "Head"
Settings.HitboxExpander = 2
Settings.FireRateMult = 1
Settings.BulletSpeedMult = 1
Settings.DamageMult = 1
Settings.ReachDistance = 10
Settings.KillAuraRange = 10
Settings.KillAuraSpeed = 5
Settings.KillAuraTargets = 3
Settings.ParryTiming = 0.1
Settings.HitLogMax = 50
Settings.SprintMult = 1.5
Settings.Acceleration = 1
Settings.Deceleration = 1
Settings.StrafeBoost = 1
Settings.RampSpeed = 2
Settings.AirSpeed = 50
Settings.GlideSpeed = 2
Settings.HoverHeight = 50
Settings.FlyAcceleration = 1
Settings.FlyAltitude = 100
Settings.WallClimbSpeed = 20
Settings.DashDistance = 50
Settings.DashCooldown = 1
Settings.DashSpeed = 100
Settings.BlinkDistance = 30
Settings.PhaseDistance = 50
Settings.MoonJumpForce = 100
Settings.TerminalVelocity = 196
Settings.KnockbackMult = 1
Settings.Friction = 1
Settings.StepHeight = 2
Settings.MultiJump = 1
Settings.SlideSpeed = 50
Settings.SlideFriction = 0.5
Settings.CoyoteFrames = 5
Settings.LongJumpMult = 2
Settings.RocketJumpForce = 100
Settings.ESPTransparency = 0.5
Settings.ESPMaxDist = 5000
Settings.ESPOutlineColor = {255, 255, 255}
Settings.ESPFillColor = {255, 50, 50}
Settings.ESPTeamColor = {50, 255, 50}
Settings.TracerOrigin = "Bottom"
Settings.TracerThickness = 1
Settings.BBoxStyle = "Corner"
Settings.ChamsTransparency = 0.3
Settings.ChamsColor = {0, 255, 255}
Settings.ItemESPRange = 200
Settings.CustomFOV = 70
Settings.ZoomSpeed = 1
Settings.CamSmooth = 1
Settings.FreecamSpeed = 50
Settings.FreecamRot = 2
Settings.SpectateTarget = ""
Settings.OrbitCamRadius = 15
Settings.OrbitCamSpeed = 1
Settings.CineSpeed = 1
Settings.CrosshairStyle = "Cross"
Settings.CrosshairSize = 10
Settings.CrosshairThickness = 2
Settings.CrosshairGap = 3
Settings.CrosshairColor = {0, 255, 0}
Settings.TimeChange = 12
Settings.Saturation = 0
Settings.Contrast = 0
Settings.Bloom = 0
Settings.ShadowInt = 1
Settings.Skybox = "Default"
Settings.AmbientR = 128
Settings.AmbientG = 128
Settings.AmbientB = 128
Settings.Exposure = 0
Settings.ColorTemp = 6500
Settings.XRayTransparency = 0.7
Settings.TeleportDelay = 0
Settings.TweenSpeed = 50
Settings.LoopTPDelay = 1
Settings.RandomTPRadius = 100
Settings.RandomTPHeight = 10
Settings.TargetPlayer = ""
Settings.FollowDistance = 5
Settings.OrbitRadius = 10
Settings.OrbitSpeed = 1
Settings.OrbitHeight = 0
Settings.SafeTPHeight = 5
Settings.VoidHeight = -50
Settings.CoordX = 0
Settings.CoordY = 0
Settings.CoordZ = 0
Settings.WaypointName = ""
Settings.PathTimeout = 10
Settings.HealSpeed = 1
Settings.MaxHealth = 100
Settings.AnimSpeed = 1
Settings.CharScale = 1
Settings.HeadScale = 1
Settings.BodyTransparency = 0
Settings.HipHeight = 0
Settings.SwimSpeed = 50
Settings.CrawlSpeed = 10
Settings.AntiFlingForce = 1000
Settings.DamageLogMax = 50
Settings.EmoteSpeed = 1
Settings.WalkAnimId = ""
Settings.IdleAnimId = ""
Settings.Gravity = 196
Settings.GlobalSpeed = 1
Settings.PhysTimeScale = 1
Settings.WorldBright = 1
Settings.WaterLevel = 0
Settings.WindForceX = 0
Settings.WindForceY = 0
Settings.WindForceZ = 0
Settings.AirDensity = 1
Settings.Elasticity = 0.5
Settings.GlobalVolume = 1
Settings.AmbientSoundId = ""
Settings.OutdoorAmbR = 128
Settings.OutdoorAmbG = 128
Settings.OutdoorAmbB = 128
Settings.FogStart = 0
Settings.FogEnd = 100000
Settings.FogColorR = 128
Settings.FogColorG = 128
Settings.FogColorB = 128
Settings.ClickDelay = 0.1
Settings.AutoFarmRange = 100
Settings.SpamText = ""
Settings.ReplyText = ""
Settings.SpamDelay = 5
Settings.NotifDuration = 3
Settings.MemCleanInterval = 60
Settings.EnemyDetRad = 50
Settings.FarmPriority = "Nearest"
Settings.LootFilter = "All"
Settings.AttackPattern = "Single"
Settings.SkillDelay = 0.5
Settings.PositionUpdateRate = 0.1
Settings.TradeMinValue = 0
Settings.LagSwitchDuration = 1
Settings.GravityX = 0
Settings.GravityY = -196
Settings.GravityZ = 0
Settings.BurstCount = 3
Settings.AimAcceleration = 1
Settings.FlickSpeed = 5
Settings.PredictionMode = "Linear"
Settings.MaxAimDist = 500
Settings.TracerColorR = 255
Settings.TracerColorG = 255
Settings.TracerColorB = 0
Settings.ScopeZoom = 2
Settings.BulletTracerLen = 50

--------------------------------------------------------------------------------
-- SAFETY UTILITIES
--------------------------------------------------------------------------------
local function safeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[CypherX] Error: " .. tostring(err))
    end
    return ok, err
end

local function getChar()
    return LocalPlayer.Character
end

local function getRoot()
    local char = getChar()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local char = getChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getHead()
    local char = getChar()
    return char and char:FindFirstChild("Head")
end

local function getPlayers()
    return Players:GetPlayers()
end

local function getTool()
    local char = getChar()
    return char and char:FindFirstChildOfClass("Tool")
end

local function safeDisconnect(key)
    if Connections[key] then
        pcall(function() Connections[key]:Disconnect() end)
        Connections[key] = nil
    end
end

local function safeDisconnectMulti(prefix)
    local toRemove = {}
    for k, v in pairs(Connections) do
        if type(k) == "string" and k:sub(1, #prefix) == prefix then
            pcall(function() v:Disconnect() end)
            table.insert(toRemove, k)
        end
    end
    for _, k in ipairs(toRemove) do
        Connections[k] = nil
    end
end

local function cleanupAll()
    for k, v in pairs(Connections) do
        pcall(function() v:Disconnect() end)
    end
    Connections = {}
end

local function Notify(title, message, duration)
    duration = duration or 3
    pcall(function()
        Rayfield:Notify({
            Title = title,
            Content = message,
            Duration = duration,
            Image = "info"
        })
    end)
end

local function isAlive(player)
    if not player or not player.Parent then return false end
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return false end
    return hum.Health > 0
end

local function getPlayerList()
    local list = {}
    for _, p in ipairs(getPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

-- Throttled workspace scan (caches results for performance)
local function getCachedParts(filterFn, cacheKey, interval)
    interval = interval or 2
    local now = tick()
    if CachedParts[cacheKey] and (now - (CachedParts[cacheKey .. "_time"] or 0)) < interval then
        return CachedParts[cacheKey]
    end
    local results = {}
    pcall(function()
        for _, v in ipairs(Workspace:GetChildren()) do
            pcall(function()
                if v:IsA("BasePart") and filterFn(v) then
                    table.insert(results, v)
                end
                for _, child in ipairs(v:GetChildren()) do
                    if child:IsA("BasePart") and filterFn(child) then
                        table.insert(results, child)
                    end
                end
            end)
        end
    end)
    CachedParts[cacheKey] = results
    CachedParts[cacheKey .. "_time"] = now
    return results
end

--------------------------------------------------------------------------------
-- ESP SYSTEM
--------------------------------------------------------------------------------
local function createESP(player)
    if ESPCache[player] then return end

    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "CX_ESP"
    highlight.FillTransparency = Settings.ESPTransparency or 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(unpack(Settings.ESPFillColor))
    highlight.OutlineColor = Color3.fromRGB(unpack(Settings.ESPOutlineColor))
    highlight.Parent = char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CX_Billboard"
    billboard.Size = UDim2.new(0, 200, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Text = player.Name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.Parent = billboard

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "InfoLabel"
    infoLabel.Size = UDim2.new(1, 0, 0, 60)
    infoLabel.Position = UDim2.new(0, 0, 0, 20)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.TextStrokeTransparency = 0
    infoLabel.Font = Enum.Font.Gotham
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
        pcall(function() if esp.highlight then esp.highlight:Destroy() end end)
        pcall(function() if esp.billboard then esp.billboard:Destroy() end end)
        ESPCache[player] = nil
    end
end

local function updateESP()
    local hrp = getRoot()
    for player, esp in pairs(ESPCache) do
        if not player.Parent or not isAlive(player) then
            removeESP(player)
            continue
        end

        local char = player.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local targetHRP = char:FindFirstChild("HumanoidRootPart")

        if esp.highlight then
            esp.highlight.FillTransparency = Settings.ESPTransparency or 0.5

            if Toggles.TeamColorESP and player.Team and player.Team == LocalPlayer.Team then
                esp.highlight.FillColor = Color3.fromRGB(unpack(Settings.ESPTeamColor))
            else
                esp.highlight.FillColor = Color3.fromRGB(unpack(Settings.ESPFillColor))
            end

            esp.highlight.Enabled = Toggles.BoxESP or false
        end

        if esp.infoLabel and hum and targetHRP then
            local info = ""
            if Toggles.HealthESP then
                info = info .. "HP: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth) .. "\n"
            end
            if Toggles.DistanceESP and hrp then
                local dist = math.floor((hrp.Position - targetHRP.Position).Magnitude)
                info = info .. "Dist: " .. dist .. "m\n"
            end
            if Toggles.WeaponESP then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    info = info .. "Wep: " .. tool.Name .. "\n"
                end
            end
            if Toggles.VelocityESP and targetHRP then
                local vel = math.floor(targetHRP.Velocity.Magnitude)
                info = info .. "Vel: " .. vel .. "\n"
            end
            esp.infoLabel.Text = info

            esp.nameLabel.Visible = Toggles.NameESP or false
            esp.infoLabel.Visible = (Toggles.HealthESP or Toggles.DistanceESP or Toggles.WeaponESP or Toggles.VelocityESP) or false
            esp.billboard.Enabled = (Toggles.NameESP or Toggles.HealthESP or Toggles.DistanceESP or Toggles.WeaponESP or Toggles.VelocityESP) or false
        end
    end
end

--------------------------------------------------------------------------------
-- COMBAT FUNCTIONS
--------------------------------------------------------------------------------
local function getClosestTarget(maxDist, teamCheck, bone)
    local closest = nil
    local minDist = maxDist or math.huge
    local hrp = getRoot()
    if not hrp then return nil end

    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(getPlayers()) do
        if player == LocalPlayer then continue end
        if not isAlive(player) then continue end

        local char = player.Character
        local targetRoot = char:FindFirstChild("HumanoidRootPart")
        local targetHum = char:FindFirstChildOfClass("Humanoid")
        if not targetRoot or not targetHum then continue end

        if teamCheck and player.Team and player.Team == LocalPlayer.Team then continue end

        if Toggles.IgnoreDowned and targetHum.Health <= (targetHum.MaxHealth * 0.1) then continue end

        local targetPart = targetRoot
        if bone and bone ~= "Random" and bone ~= "Auto" then
            local part = char:FindFirstChild(bone)
            if part and part:IsA("BasePart") then
                targetPart = part
            end
        elseif bone == "Random" then
            local parts = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftFoot", "RightFoot", "LeftHand", "RightHand"}
            local randomPart = parts[math.random(#parts)]
            local part = char:FindFirstChild(randomPart)
            if part and part:IsA("BasePart") then
                targetPart = part
            end
        end

        -- Distance check
        local worldDist = (hrp.Position - targetPart.Position).Magnitude
        if Settings.MaxAimDist and worldDist > Settings.MaxAimDist then continue end

        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if onScreen then
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            if dist < minDist then
                minDist = dist
                closest = {
                    player = player,
                    character = char,
                    part = targetPart,
                    humanoid = targetHum,
                    rootPart = targetRoot,
                    screenPos = screenPos,
                    distance = dist,
                    worldDistance = worldDist
                }
            end
        end
    end
    return closest
end

--------------------------------------------------------------------------------
-- FEATURE SETUP FUNCTIONS
--------------------------------------------------------------------------------

-- AIMBOT
local function setupAimbot()
    safeDisconnect("Aimbot")
    if not Toggles.Aimbot then return end

    Connections.Aimbot = RunService.RenderStepped:Connect(function()
        if not Toggles.Aimbot then return end

        local bindKey = Settings.LockKeybind or "E"
        local ok, isDown = pcall(function()
            return UserInputService:IsKeyDown(Enum.KeyCode[bindKey])
        end)
        if not ok or not isDown then return end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then return end

        local target = getClosestTarget(Settings.AimbotFOV or 100, Toggles.TeamCheck, Settings.TargetBone)
        if not target then return end

        local mousePos = UserInputService:GetMouseLocation()
        local aimPos = Vector2.new(target.screenPos.X, target.screenPos.Y)
        local smooth = math.max((Settings.AimbotSmoothness or 5), 1)
        local accel = Settings.AimAcceleration or 1

        -- Prediction
        if Settings.AimbotPrediction and Settings.AimbotPrediction > 0 and target.rootPart then
            local targetVel = target.rootPart.Velocity
            local predMult = Settings.AimbotPrediction / 10
            local predictedPos
            if Settings.PredictionMode == "Quadratic" then
                predictedPos = target.part.Position + targetVel * predMult + Vector3.new(0, -Workspace.Gravity * predMult * predMult * 0.5, 0)
            else
                predictedPos = target.part.Position + targetVel * predMult
            end
            local predScreen = Camera:WorldToViewportPoint(predictedPos)
            if predScreen then
                aimPos = Vector2.new(predScreen.X, predScreen.Y)
            end
        end

        -- Random offset for anti-detection
        if Toggles.RandomAimOffset then
            aimPos = Vector2.new(
                aimPos.X + math.random(-3, 3),
                aimPos.Y + math.random(-3, 3)
            )
        end

        -- Move mouse
        local deltaX = (aimPos.X - mousePos.X) / smooth * accel
        local deltaY = (aimPos.Y - mousePos.Y) / smooth * accel

        -- Flick aim clamping
        if Toggles.FlickAim then
            local maxFlick = Settings.FlickSpeed or 5
            deltaX = math.clamp(deltaX, -maxFlick * 10, maxFlick * 10)
            deltaY = math.clamp(deltaY, -maxFlick * 10, maxFlick * 10)
        end

        pcall(function() mousemoverel(deltaX, deltaY) end)
    end)
end

-- TRIGGERBOT
local function setupTriggerbot()
    safeDisconnect("Triggerbot")
    if not Toggles.Triggerbot then return end

    Connections.Triggerbot = RunService.RenderStepped:Connect(function()
        if not Toggles.Triggerbot then return end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            if not Toggles.TriggerHoldMode then return end
        end

        local target = getClosestTarget(200, Toggles.TeamCheck, nil)
        if not target then return end

        local mouseTarget = Mouse.Target
        if mouseTarget and mouseTarget:IsDescendantOf(target.character) then
            task.wait((Settings.TriggerDelay or 50) / 1000)

            if Toggles.BurstMode then
                local count = Settings.BurstCount or 3
                for i = 1, count do
                    if not Toggles.Triggerbot then break end
                    pcall(function()
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        task.wait(0.03)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    end)
                    task.wait(0.05)
                end
            else
                pcall(function()
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end)
            end
        end
    end)
end

-- REACH
local function setupReach()
    safeDisconnect("Reach")
    if not Toggles.Reach then return end

    Connections.Reach = RunService.Stepped:Connect(function()
        if not Toggles.Reach then return end
        local char = getChar()
        if not char then return end
        local tool = getTool()
        if not tool then return end

        local handle = tool:FindFirstChild("Handle")
        if handle and handle:IsA("BasePart") then
            handle.Size = Vector3.new(Settings.ReachDistance or 10, handle.Size.Y, handle.Size.Z)
            handle.Massless = true
        end
    end)
end

-- KILL AURA
local function setupKillAura()
    safeDisconnect("KillAura")
    if not Toggles.KillAura then return end

    Connections.KillAura = RunService.Stepped:Connect(function()
        if not Toggles.KillAura then return end
        local hrp = getRoot()
        if not hrp then return end
        local tool = getTool()
        if not tool then return end

        local range = Settings.KillAuraRange or 10
        local targets = 0
        local maxTargets = Settings.KillAuraTargets or 3

        for _, player in ipairs(getPlayers()) do
            if player == LocalPlayer then continue end
            if targets >= maxTargets then break end
            if not isAlive(player) then continue end
            if Toggles.TeamCheck and player.Team and player.Team == LocalPlayer.Team then continue end

            local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP and (hrp.Position - targetHRP.Position).Magnitude <= range then
                pcall(function() tool:Activate() end)
                targets = targets + 1
            end
        end
    end)
end

-- HITBOX EXPANDER
local function setupHitboxExpander()
    safeDisconnect("HitboxExpander")
    if not Toggles.HitboxExpander then return end

    Connections.HitboxExpander = RunService.Stepped:Connect(function()
        if not Toggles.HitboxExpander then return end
        local size = Settings.HitboxExpander or 2

        for _, player in ipairs(getPlayers()) do
            if player == LocalPlayer then continue end
            if not isAlive(player) then continue end
            if Toggles.TeamCheck and player.Team and player.Team == LocalPlayer.Team then continue end

            local head = player.Character:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                head.Size = Vector3.new(size, size, size)
                head.Transparency = Toggles.HitboxVisible and 0.7 or 1
                head.CanCollide = false
                head.Material = Enum.Material.ForceField
            end
        end
    end)
end

-- ESP
local function setupESP()
    safeDisconnect("ESP")

    local anyESP = Toggles.BoxESP or Toggles.NameESP or Toggles.HealthESP or Toggles.DistanceESP or Toggles.WeaponESP or Toggles.VelocityESP
    if not anyESP then
        for player in pairs(ESPCache) do
            removeESP(player)
        end
        return
    end

    Connections.ESP = RunService.RenderStepped:Connect(function()
        for _, player in ipairs(getPlayers()) do
            if player == LocalPlayer then continue end

            if isAlive(player) then
                local hrp = getRoot()
                local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
                local dist = (hrp and targetHRP) and (hrp.Position - targetHRP.Position).Magnitude or 0
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
        end

        -- Clean disconnected
        for player in pairs(ESPCache) do
            if not player.Parent then
                removeESP(player)
            end
        end

        updateESP()
    end)
end

-- MOVEMENT CORE
local function setupMovementCore()
    safeDisconnect("MovementCore")

    Connections.MovementCore = RunService.Stepped:Connect(function()
        local hum = getHum()
        local hrp = getRoot()
        if not hum then return end

        -- WalkSpeed
        if Toggles.CustomSpeed then
            hum.WalkSpeed = Settings.WalkSpeed or 16
        end

        -- JumpPower
        if Toggles.CustomJump then
            hum.JumpPower = Settings.JumpPower or 50
            hum.UseJumpPower = true
        end

        -- Sprint
        if Toggles.Sprint and hrp then
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                hum.WalkSpeed = (Settings.WalkSpeed or 16) * (Settings.SprintMult or 1.5)
            end
        end

        -- Hip Height
        if Toggles.CustomHipHeight then
            hum.HipHeight = Settings.HipHeight or 0
        end

        -- Speed ramp
        if Toggles.SpeedRamp and hrp then
            local vel = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
            if vel > 1 then
                hum.WalkSpeed = math.min(hum.WalkSpeed + (Settings.RampSpeed or 2) * 0.1, 500)
            end
        end
    end)
end

-- BUNNY HOP
local function setupBhop()
    safeDisconnect("Bhop")
    if not Toggles.AutoBhop then return end

    Connections.Bhop = RunService.Stepped:Connect(function()
        if not Toggles.AutoBhop then return end
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

-- AIR MOVEMENT
local function setupAirMovement()
    safeDisconnect("AirMovement")

    local anyAir = Toggles.AirControl or Toggles.GlideMode or Toggles.HoverMode or Toggles.FloatMode
    if not anyAir then return end

    Connections.AirMovement = RunService.Stepped:Connect(function()
        local hum = getHum()
        local hrp = getRoot()
        if not hum or not hrp then return end
        if hum.FloorMaterial ~= Enum.Material.Air then return end

        local vel = hrp.Velocity

        if Toggles.AirControl then
            local moveDir = Vector3.zero
            local camLook = Camera.CFrame.LookVector
            local camRight = Camera.CFrame.RightVector
            local airSpeed = Settings.AirSpeed or 50

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camLook end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camLook end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camRight end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camRight end

            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit * airSpeed
                hrp.Velocity = Vector3.new(moveDir.X, vel.Y, moveDir.Z)
            end
        end

        if Toggles.GlideMode then
            local glideSpeed = Settings.GlideSpeed or 2
            hrp.Velocity = Vector3.new(vel.X, math.max(vel.Y, -glideSpeed), vel.Z)
        end

        if Toggles.HoverMode then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                hrp.Velocity = Vector3.new(vel.X, 15, vel.Z)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                hrp.Velocity = Vector3.new(vel.X, -15, vel.Z)
            else
                hrp.Velocity = Vector3.new(vel.X, 0, vel.Z)
            end
        end

        if Toggles.FloatMode then
            hrp.Velocity = Vector3.new(vel.X, math.max(vel.Y, -1), vel.Z)
        end
    end)
end

-- FLY
local function setupFly()
    safeDisconnect("Fly")

    if Toggles.Fly then
        Connections.Fly = RunService.RenderStepped:Connect(function()
            if not Toggles.Fly then return end
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

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camLook end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camLook end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camRight end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camRight end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir + Vector3.new(0, -1, 0) end

            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit
            end

            -- Fly acceleration
            local speed = Settings.FlySpeed or 50
            if Toggles.FlyAcceleration then
                local accel = Settings.FlyAcceleration or 1
                speed = speed * accel
            end

            FlyBody.bv.Velocity = moveDir * speed
            FlyBody.bg.CFrame = Camera.CFrame

            -- Hover lock
            if Toggles.HoverLock and moveDir.Magnitude == 0 then
                FlyBody.bv.Velocity = Vector3.zero
            end
        end)
    else
        if FlyBody then
            pcall(function() FlyBody.bv:Destroy() end)
            pcall(function() FlyBody.bg:Destroy() end)
            FlyBody = nil
            local hum = getHum()
            if hum then hum.PlatformStand = false end
        end
    end
end

-- NOCLIP
local function setupNoclip()
    safeDisconnect("Noclip")
    if not Toggles.Noclip then return end

    Connections.Noclip = RunService.Stepped:Connect(function()
        if not Toggles.Noclip then return end
        local char = getChar()
        if not char then return end

        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

-- INFINITE JUMP
local function setupInfiniteJump()
    safeDisconnect("InfJump")
    if not Toggles.InfJump then return end

    Connections.InfJump = UserInputService.JumpRequest:Connect(function()
        if not Toggles.InfJump then return end
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

-- MULTI JUMP
local function setupMultiJump()
    safeDisconnect("MultiJump")
    if not Toggles.MultiJumpEnabled then return end

    local jumpCt = 0
    Connections.MultiJump = UserInputService.JumpRequest:Connect(function()
        if not Toggles.MultiJumpEnabled then return end
        local hum = getHum()
        if not hum then return end

        if hum.FloorMaterial ~= Enum.Material.Air then
            jumpCt = 0
        end

        if jumpCt < (Settings.MultiJump or 1) then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            jumpCt = jumpCt + 1
        end
    end)
end

-- WALL WALK
local function setupWallWalk()
    safeDisconnect("WallWalk")
    if not Toggles.WallWalk then return end

    Connections.WallWalk = RunService.Stepped:Connect(function()
        if not Toggles.WallWalk then return end
        local hrp = getRoot()
        local hum = getHum()
        if not hrp or not hum then return end

        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {getChar()}
        params.FilterType = Enum.RaycastFilterType.Exclude

        local directions = {
            Camera.CFrame.RightVector * 5,
            -Camera.CFrame.RightVector * 5,
            Camera.CFrame.LookVector * 5
        }

        local hitWall = false
        for _, dir in ipairs(directions) do
            local result = Workspace:Raycast(hrp.Position, dir, params)
            if result then hitWall = true; break end
        end

        if hitWall then
            hum.PlatformStand = true
            local speed = Settings.WallClimbSpeed or 20
            local vx = UserInputService:IsKeyDown(Enum.KeyCode.A) and -speed or (UserInputService:IsKeyDown(Enum.KeyCode.D) and speed or 0)
            local vy = UserInputService:IsKeyDown(Enum.KeyCode.Space) and speed or (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -speed or 0)
            local vz = UserInputService:IsKeyDown(Enum.KeyCode.W) and -speed or (UserInputService:IsKeyDown(Enum.KeyCode.S) and speed or 0)
            hrp.Velocity = Vector3.new(vx, vy, vz)
        else
            hum.PlatformStand = false
        end
    end)
end

-- SLIDE
local function setupSlide()
    safeDisconnect("Slide")
    if not Toggles.SlideMovement then return end

    Connections.Slide = RunService.Stepped:Connect(function()
        if not Toggles.SlideMovement then return end
        local hum = getHum()
        local hrp = getRoot()
        if not hum or not hrp then return end

        if UserInputService:IsKeyDown(Enum.KeyCode.C) and hum.FloorMaterial ~= Enum.Material.Air then
            local speed = Settings.SlideSpeed or 50
            hrp.Velocity = Camera.CFrame.LookVector * speed
        end
    end)
end

-- GODMODE
local function setupGodmode()
    safeDisconnect("Godmode")
    if not Toggles.Godmode then return end

    Connections.Godmode = RunService.RenderStepped:Connect(function()
        if not Toggles.Godmode then return end
        local hum = getHum()
        if hum then
            hum.Health = hum.MaxHealth
        end
    end)
end

-- AUTO WALK
local function setupAutoWalk()
    safeDisconnect("AutoWalk")
    if not Toggles.AutoWalk then return end

    Connections.AutoWalk = RunService.RenderStepped:Connect(function()
        if not Toggles.AutoWalk then return end
        local hum = getHum()
        if hum then
            hum:Move(Camera.CFrame.LookVector, true)
        end
    end)
end

-- ANTI VOID
local function setupAntiVoid()
    safeDisconnect("AntiVoid")
    if not Toggles.AntiVoid then return end

    Connections.AntiVoid = RunService.Stepped:Connect(function()
        if not Toggles.AntiVoid then return end
        local hrp = getRoot()
        if hrp and hrp.Position.Y < (Settings.VoidHeight or -50) then
            hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
            hrp.Velocity = Vector3.zero
        end
    end)
end

-- FREECAM
local function setupFreecam()
    safeDisconnect("Freecam")

    if Toggles.Freecam then
        Connections.Freecam = RunService.RenderStepped:Connect(function()
            if not Toggles.Freecam then return end

            if not FreecamBody then
                local hrp = getRoot()
                if not hrp then return end
                Camera.CameraType = Enum.CameraType.Scriptable
                FreecamBody = {
                    position = hrp.Position,
                    rotation = Camera.CFrame - Camera.CFrame.Position
                }
            end

            local speed = Settings.FreecamSpeed or 50
            local moveDir = Vector3.zero

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir + Vector3.new(0, -1, 0) end

            if moveDir.Magnitude > 0 then
                FreecamBody.position = FreecamBody.position + moveDir.Unit * speed * 0.1
            end

            local rotSpeed = Settings.FreecamRot or 2
            local delta = UserInputService:GetMouseDelta()
            FreecamBody.rotation = FreecamBody.rotation * CFrame.Angles(-delta.Y * 0.001 * rotSpeed, -delta.X * 0.001 * rotSpeed, 0)

            Camera.CFrame = CFrame.new(FreecamBody.position) * FreecamBody.rotation
        end)
    else
        if FreecamBody then
            Camera.CameraType = Enum.CameraType.Custom
            FreecamBody = nil
        end
    end
end

-- FOLLOW PLAYER
local function setupFollowPlayer()
    safeDisconnect("FollowPlayer")
    if not Toggles.FollowPlayer or not Settings.TargetPlayer or Settings.TargetPlayer == "" then return end

    Connections.FollowPlayer = RunService.RenderStepped:Connect(function()
        if not Toggles.FollowPlayer then return end
        local target = Players:FindFirstChild(Settings.TargetPlayer)
        local hrp = getRoot()
        if not target or not isAlive(target) or not hrp then return end

        local targetPos = target.Character.HumanoidRootPart.Position
        local dist = (hrp.Position - targetPos).Magnitude
        local followDist = Settings.FollowDistance or 5

        if dist > followDist then
            local hum = getHum()
            if hum then
                hum:MoveTo(targetPos)
            end
        end
    end)
end

-- ORBIT PLAYER
local function setupOrbitPlayer()
    safeDisconnect("OrbitPlayer")
    if not Toggles.OrbitPlayer or not Settings.TargetPlayer or Settings.TargetPlayer == "" then return end

    Connections.OrbitPlayer = RunService.RenderStepped:Connect(function()
        if not Toggles.OrbitPlayer then return end
        local target = Players:FindFirstChild(Settings.TargetPlayer)
        local hrp = getRoot()
        if not target or not isAlive(target) or not hrp then return end

        local radius = Settings.OrbitRadius or 10
        local speed = Settings.OrbitSpeed or 1
        local height = Settings.OrbitHeight or 0
        OrbitingAngle = OrbitingAngle + 0.05 * speed
        local targetPos = target.Character.HumanoidRootPart.Position
        local offset = Vector3.new(math.cos(OrbitingAngle) * radius, height, math.sin(OrbitingAngle) * radius)
        hrp.CFrame = CFrame.new(targetPos + offset, targetPos)
    end)
end

-- FULLBRIGHT
local function setupFullbright()
    if not Toggles.Fullbright then return end
    pcall(function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = false
            end
        end
    end)
end

-- ANTI AFK
local function setupAntiAFK()
    safeDisconnect("AntiAFK")
    if not Toggles.AntiAFK then return end

    Connections.AntiAFK = LocalPlayer.Idled:Connect(function()
        pcall(function()
            local vu = game:GetService("VirtualUser")
            vu:Button2Down(Vector2.new(0, 0), Camera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0, 0), Camera.CFrame)
        end)
    end)
end

-- ANTI FALL DAMAGE
local function setupAntiFallDmg()
    safeDisconnect("AntiFallDmg")
    if not Toggles.AntiFallDmg then return end

    Connections.AntiFallDmg = RunService.Stepped:Connect(function()
        if not Toggles.AntiFallDmg then return end
        local hum = getHum()
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end)
end

-- ANTI KNOCKBACK
local function setupAntiKnockback()
    safeDisconnect("AntiKnockback")
    if not Toggles.AntiKnockback then return end

    Connections.AntiKnockback = RunService.Stepped:Connect(function()
        if not Toggles.AntiKnockback then return end
        local hrp = getRoot()
        if not hrp then return end
        local vel = hrp.Velocity
        local maxKB = Settings.KnockbackMult or 1
        if vel.Magnitude > 50 * maxKB then
            hrp.Velocity = vel.Unit * 50 * maxKB
        end
    end)
end

-- ANTI FLING
local function setupAntiFling()
    safeDisconnect("AntiFling")
    if not Toggles.AntiFling then return end

    Connections.AntiFling = RunService.Stepped:Connect(function()
        if not Toggles.AntiFling then return end
        local hrp = getRoot()
        if not hrp then return end
        if hrp.Velocity.Magnitude > (Settings.AntiFlingForce or 1000) then
            hrp.Velocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
        end
    end)
end

-- AUTO CLICKER
local function setupAutoClicker()
    safeDisconnect("AutoClicker")
    if not Toggles.AutoClicker then return end

    task.spawn(function()
        while Toggles.AutoClicker do
            pcall(function()
                local tool = getTool()
                if tool then
                    tool:Activate()
                end
            end)
            task.wait(Settings.ClickDelay or 0.1)
        end
    end)
end

-- AUTO FARM (Throttled)
local function setupAutoFarm()
    safeDisconnect("AutoFarm")
    if not Toggles.AutoFarm then return end

    task.spawn(function()
        while Toggles.AutoFarm do
            local hrp = getRoot()
            local hum = getHum()
            if not hrp or not hum then task.wait(1); continue end

            local nearest = nil
            local minDist = Settings.AutoFarmRange or 100

            local parts = getCachedParts(function(v)
                local name = v.Name:lower()
                return name:find("coin") or name:find("collect") or name:find("orb") or name:find("gem") or name:find("drop") or name:find("loot")
            end, "farmables", 3)

            for _, v in ipairs(parts) do
                local dist = (hrp.Position - v.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = v
                end
            end

            if nearest then
                hum:MoveTo(nearest.Position)
            end
            task.wait(0.5)
        end
    end)
end

-- LOOP TELEPORT
local function setupLoopTeleport()
    safeDisconnect("LoopTeleport")
    if not Toggles.LoopTeleport or not Settings.LoopTPTarget then return end

    task.spawn(function()
        while Toggles.LoopTeleport do
            local hrp = getRoot()
            local target = SavedPositions[Settings.LoopTPTarget]
            if hrp and target then
                hrp.CFrame = target
            end
            task.wait(Settings.LoopTPDelay or 1)
        end
    end)
end

-- WATER WALK
local function setupWaterWalk()
    safeDisconnect("WaterWalk")
    if not Toggles.WaterWalk then return end

    local platform = nil
    Connections.WaterWalk = RunService.Stepped:Connect(function()
        if not Toggles.WaterWalk then
            if platform then pcall(function() platform:Destroy() end) end
            return
        end
        local hrp = getRoot()
        if not hrp then return end

        if not platform or not platform.Parent then
            platform = Instance.new("Part")
            platform.Name = "CX_WaterWalk"
            platform.Anchored = true
            platform.CanCollide = true
            platform.Transparency = 1
            platform.Size = Vector3.new(6, 0.1, 6)
            platform.Parent = Workspace
        end

        local waterLevel = Settings.WaterLevel or 0
        if hrp.Position.Y < waterLevel + 3 and hrp.Position.Y > waterLevel - 10 then
            platform.Position = Vector3.new(hrp.Position.X, waterLevel, hrp.Position.Z)
        else
            platform.Position = Vector3.new(0, -9999, 0)
        end
    end)
end

--------------------------------------------------------------------------------
-- MASTER REFRESH (rebinds all active features)
--------------------------------------------------------------------------------
local function refreshAllFeatures()
    safeCall(setupAimbot)
    safeCall(setupTriggerbot)
    safeCall(setupReach)
    safeCall(setupKillAura)
    safeCall(setupHitboxExpander)
    safeCall(setupESP)
    safeCall(setupMovementCore)
    safeCall(setupBhop)
    safeCall(setupAirMovement)
    safeCall(setupFly)
    safeCall(setupNoclip)
    safeCall(setupInfiniteJump)
    safeCall(setupMultiJump)
    safeCall(setupWallWalk)
    safeCall(setupSlide)
    safeCall(setupGodmode)
    safeCall(setupAutoWalk)
    safeCall(setupAntiVoid)
    safeCall(setupFreecam)
    safeCall(setupFollowPlayer)
    safeCall(setupOrbitPlayer)
    safeCall(setupFullbright)
    safeCall(setupAntiAFK)
    safeCall(setupAntiFallDmg)
    safeCall(setupAntiKnockback)
    safeCall(setupAntiFling)
    safeCall(setupAutoClicker)
    safeCall(setupAutoFarm)
    safeCall(setupWaterWalk)
end

local function wrapToggle(fn)
    return function(v)
        if fn then fn(v) end
        task.defer(refreshAllFeatures)
    end
end

local function wrapSetting(key)
    return function(v)
        Settings[key] = v
    end
end

local function wrapToggleSetting(key)
    return function(v)
        Toggles[key] = v
    end
end

local function wrapToggleRefresh(key)
    return wrapToggle(function(v) Toggles[key] = v end)
end

--------------------------------------------------------------------------------
-- FEATURE COUNTER
--------------------------------------------------------------------------------
local FC = 0
local function countFeature()
    FC = FC + 1
end

--[[
===========================================================================
                             TAB 1: COMBAT
===========================================================================
]]
local CombatTab = Window:CreateTab("Combat", "crosshair")

-- ═══════════════════════ AIMBOT SYSTEM ═══════════════════════
CombatTab:CreateSection("Aimbot System")

Toggles.Aimbot = false
Toggles.TeamCheck = false
Toggles.VisibilityCheck = false
Toggles.RandomAimOffset = false
Toggles.DrawFOV = false
Toggles.StickyAim = false
Toggles.SnapAim = false
Toggles.FlickAim = false
Toggles.AimIndicator = false

CombatTab:CreateToggle({Name = "[AIMBOT] Enable Aimbot — Locks mouse to closest enemy", CurrentValue = false, Flag = "Aimbot", Callback = wrapToggleRefresh("Aimbot")}); countFeature()
CombatTab:CreateSlider({Name = "[AIMBOT] Smoothness — Lower = faster lock (1-50)", Range = {1, 50}, Increment = 0.5, CurrentValue = 5, Flag = "AimbotSmooth", Callback = wrapSetting("AimbotSmoothness")}); countFeature()
CombatTab:CreateInput({Name = "[AIMBOT] Smoothness Override — Type exact value", PlaceholderText = "5", RemoveTextAfterFocusLost = false, Flag = "AimbotSmoothInput", Callback = function(v) local n = tonumber(v); if n then Settings.AimbotSmoothness = n end end}); countFeature()
CombatTab:CreateSlider({Name = "[AIMBOT] FOV Radius — Pixel radius for target detection", Range = {10, 2000}, Increment = 10, CurrentValue = 100, Flag = "AimbotFOV", Callback = wrapSetting("AimbotFOV")}); countFeature()
CombatTab:CreateInput({Name = "[AIMBOT] FOV Override — Type any value", PlaceholderText = "100", RemoveTextAfterFocusLost = false, Flag = "AimbotFOVInput", Callback = function(v) local n = tonumber(v); if n then Settings.AimbotFOV = n end end}); countFeature()
CombatTab:CreateSlider({Name = "[AIMBOT] Prediction — Compensate for target movement", Range = {0, 20}, Increment = 0.1, CurrentValue = 0, Flag = "AimbotPred", Callback = wrapSetting("AimbotPrediction")}); countFeature()
CombatTab:CreateSlider({Name = "[AIMBOT] Acceleration — Aim speed multiplier", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 1, Flag = "AimAccel", Callback = wrapSetting("AimAcceleration")}); countFeature()
CombatTab:CreateSlider({Name = "[AIMBOT] Flick Speed — Max flick distance per frame", Range = {1, 20}, Increment = 1, CurrentValue = 5, Flag = "FlickSpeed", Callback = wrapSetting("FlickSpeed")}); countFeature()
CombatTab:CreateSlider({Name = "[AIMBOT] Max Distance — World studs limit", Range = {50, 5000}, Increment = 50, CurrentValue = 500, Flag = "MaxAimDist", Callback = wrapSetting("MaxAimDist")}); countFeature()
CombatTab:CreateDropdown({Name = "[AIMBOT] Target Bone — Which body part to aim at", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftHand", "RightHand", "Random", "Auto"}, CurrentOption = {"Head"}, Flag = "AimbotBone", Callback = function(v) Settings.TargetBone = v end}); countFeature()
CombatTab:CreateDropdown({Name = "[AIMBOT] Prediction Mode — Linear or Quadratic", Options = {"Linear", "Quadratic"}, CurrentOption = {"Linear"}, Flag = "PredMode", Callback = function(v) Settings.PredictionMode = v end}); countFeature()
CombatTab:CreateToggle({Name = "[AIMBOT] Team Check — Ignore teammates", CurrentValue = false, Flag = "TeamCheck", Callback = wrapToggleSetting("TeamCheck")}); countFeature()
CombatTab:CreateToggle({Name = "[AIMBOT] Visibility Check — Only aim at visible targets", CurrentValue = false, Flag = "VisCheck", Callback = wrapToggleSetting("VisibilityCheck")}); countFeature()
CombatTab:CreateToggle({Name = "[AIMBOT] Random Offset — Add jitter for anti-detection", CurrentValue = false, Flag = "RandOffset", Callback = wrapToggleSetting("RandomAimOffset")}); countFeature()
CombatTab:CreateToggle({Name = "[AIMBOT] Sticky Aim — Keep lock after losing sight", CurrentValue = false, Flag = "StickyAim", Callback = wrapToggleSetting("StickyAim")}); countFeature()
CombatTab:CreateToggle({Name = "[AIMBOT] Snap Aim — Instantly snap to target", CurrentValue = false, Flag = "SnapAim", Callback = wrapToggleSetting("SnapAim")}); countFeature()
CombatTab:CreateToggle({Name = "[AIMBOT] Flick Aim — Enable flick speed limit", CurrentValue = false, Flag = "FlickAim", Callback = wrapToggleSetting("FlickAim")}); countFeature()
CombatTab:CreateToggle({Name = "[AIMBOT] Draw FOV Circle — Show aim radius on screen", CurrentValue = false, Flag = "DrawFOV", Callback = wrapToggleSetting("DrawFOV")}); countFeature()
CombatTab:CreateToggle({Name = "[AIMBOT] Target Indicator — Highlight current target", CurrentValue = false, Flag = "AimIndicator", Callback = wrapToggleSetting("AimIndicator")}); countFeature()
CombatTab:CreateInput({Name = "[AIMBOT] Lock Keybind — Key to hold for aim", PlaceholderText = "E", RemoveTextAfterFocusLost = false, Flag = "LockKey", Callback = function(v) if v ~= "" then Settings.LockKeybind = v end end}); countFeature()

-- ═══════════════════════ TRIGGERBOT ═══════════════════════
CombatTab:CreateSection("Triggerbot")

Toggles.Triggerbot = false
Toggles.BurstMode = false
Toggles.TriggerHoldMode = false
Toggles.CrosshairOnlyTrigger = false

CombatTab:CreateToggle({Name = "[TRIGGER] Enable Triggerbot — Auto-fire when on target", CurrentValue = false, Flag = "Triggerbot", Callback = wrapToggleRefresh("Triggerbot")}); countFeature()
CombatTab:CreateSlider({Name = "[TRIGGER] Delay (ms) — Reaction time simulation", Range = {0, 1000}, Increment = 10, CurrentValue = 50, Flag = "TriggerDelay", Callback = wrapSetting("TriggerDelay")}); countFeature()
CombatTab:CreateInput({Name = "[TRIGGER] Delay Override — Exact ms value", PlaceholderText = "50", RemoveTextAfterFocusLost = false, Flag = "TriggerDelayInput", Callback = function(v) local n = tonumber(v); if n then Settings.TriggerDelay = n end end}); countFeature()
CombatTab:CreateToggle({Name = "[TRIGGER] Burst Mode — Fire multiple shots", CurrentValue = false, Flag = "BurstMode", Callback = wrapToggleSetting("BurstMode")}); countFeature()
CombatTab:CreateSlider({Name = "[TRIGGER] Burst Count — Shots per burst", Range = {2, 10}, Increment = 1, CurrentValue = 3, Flag = "BurstCount", Callback = wrapSetting("BurstCount")}); countFeature()
CombatTab:CreateToggle({Name = "[TRIGGER] Hold Mode — Active without right-click", CurrentValue = false, Flag = "TriggerHold", Callback = wrapToggleSetting("TriggerHoldMode")}); countFeature()
CombatTab:CreateToggle({Name = "[TRIGGER] Crosshair Only — Only fire when crosshair on target", CurrentValue = false, Flag = "CrosshairTrigger", Callback = wrapToggleSetting("CrosshairOnlyTrigger")}); countFeature()

-- ═══════════════════════ SILENT AIM ═══════════════════════
CombatTab:CreateSection("Silent Aim")

Toggles.SilentAim = false
Toggles.IgnoreDowned = false
Toggles.WallBang = false

CombatTab:CreateToggle({Name = "[SILENT] Enable Silent Aim — Hit without aiming directly", CurrentValue = false, Flag = "SilentAim", Callback = wrapToggleRefresh("SilentAim")}); countFeature()
CombatTab:CreateSlider({Name = "[SILENT] Hit Chance % — Probability of hitting", Range = {0, 100}, Increment = 1, CurrentValue = 100, Flag = "HitChance", Callback = wrapSetting("HitChance")}); countFeature()
CombatTab:CreateInput({Name = "[SILENT] Hit Chance Override", PlaceholderText = "100", RemoveTextAfterFocusLost = false, Flag = "HitChanceInput", Callback = function(v) local n = tonumber(v); if n then Settings.HitChance = math.clamp(n, 0, 100) end end}); countFeature()
CombatTab:CreateSlider({Name = "[SILENT] FOV — Detection radius", Range = {10, 2000}, Increment = 10, CurrentValue = 100, Flag = "SilentFOV", Callback = wrapSetting("SilentAimFOV")}); countFeature()
CombatTab:CreateDropdown({Name = "[SILENT] Bone Priority — Target bone preference", Options = {"Head", "Torso", "Limbs", "Random"}, CurrentOption = {"Head"}, Flag = "BonePriority", Callback = function(v) Settings.BonePriority = v end}); countFeature()
CombatTab:CreateToggle({Name = "[SILENT] Ignore Downed — Skip low-HP targets", CurrentValue = false, Flag = "IgnoreDowned", Callback = wrapToggleSetting("IgnoreDowned")}); countFeature()
CombatTab:CreateToggle({Name = "[SILENT] Wall Bang — Target through walls", CurrentValue = false, Flag = "WallBang", Callback = wrapToggleSetting("WallBang")}); countFeature()

-- ═══════════════════════ REACH & KILL AURA ═══════════════════════
CombatTab:CreateSection("Reach & Kill Aura")

Toggles.Reach = false
Toggles.ReachVisualize = false
Toggles.KillAura = false

CombatTab:CreateToggle({Name = "[REACH] Enable Reach — Extend melee range", CurrentValue = false, Flag = "Reach", Callback = wrapToggleRefresh("Reach")}); countFeature()
CombatTab:CreateSlider({Name = "[REACH] Distance — Reach extension in studs", Range = {5, 100}, Increment = 1, CurrentValue = 10, Flag = "ReachDist", Callback = wrapSetting("ReachDistance")}); countFeature()
CombatTab:CreateInput({Name = "[REACH] Distance Override", PlaceholderText = "10", RemoveTextAfterFocusLost = false, Flag = "ReachDistInput", Callback = function(v) local n = tonumber(v); if n then Settings.ReachDistance = n end end}); countFeature()
CombatTab:CreateToggle({Name = "[REACH] Visualize — Show reach area", CurrentValue = false, Flag = "ReachVis", Callback = wrapToggleSetting("ReachVisualize")}); countFeature()
CombatTab:CreateToggle({Name = "[AURA] Kill Aura — Auto-attack nearby enemies", CurrentValue = false, Flag = "KillAura", Callback = wrapToggleRefresh("KillAura")}); countFeature()
CombatTab:CreateSlider({Name = "[AURA] Range — Kill aura radius", Range = {5, 100}, Increment = 1, CurrentValue = 10, Flag = "AuraRange", Callback = wrapSetting("KillAuraRange")}); countFeature()
CombatTab:CreateInput({Name = "[AURA] Range Override", PlaceholderText = "10", RemoveTextAfterFocusLost = false, Flag = "AuraRangeInput", Callback = function(v) local n = tonumber(v); if n then Settings.KillAuraRange = n end end}); countFeature()
CombatTab:CreateSlider({Name = "[AURA] Attack Speed — Attacks per second", Range = {1, 20}, Increment = 1, CurrentValue = 5, Flag = "AuraSpeed", Callback = wrapSetting("KillAuraSpeed")}); countFeature()
CombatTab:CreateSlider({Name = "[AURA] Max Targets — Simultaneous targets", Range = {1, 20}, Increment = 1, CurrentValue = 3, Flag = "AuraTargets", Callback = wrapSetting("KillAuraTargets")}); countFeature()

-- ═══════════════════════ COMBAT ASSIST ═══════════════════════
CombatTab:CreateSection("Combat Assist")

Toggles.AutoBlock = false
Toggles.AutoParry = false
Toggles.ComboExtender = false
Toggles.AutoCombo = false

CombatTab:CreateToggle({Name = "[ASSIST] Auto Block — Block incoming attacks", CurrentValue = false, Flag = "AutoBlock", Callback = wrapToggleSetting("AutoBlock")}); countFeature()
CombatTab:CreateToggle({Name = "[ASSIST] Auto Parry — Perfect parry timing", CurrentValue = false, Flag = "AutoParry", Callback = wrapToggleSetting("AutoParry")}); countFeature()
CombatTab:CreateSlider({Name = "[ASSIST] Parry Timing — Seconds before impact", Range = {0.01, 1}, Increment = 0.01, CurrentValue = 0.1, Flag = "ParryTiming", Callback = wrapSetting("ParryTiming")}); countFeature()
CombatTab:CreateToggle({Name = "[ASSIST] Combo Extender — Keep combos going", CurrentValue = false, Flag = "ComboExt", Callback = wrapToggleSetting("ComboExtender")}); countFeature()
CombatTab:CreateToggle({Name = "[ASSIST] Auto Combo — Execute attack patterns", CurrentValue = false, Flag = "AutoCombo", Callback = wrapToggleSetting("AutoCombo")}); countFeature()

-- ═══════════════════════ WEAPON MODS ═══════════════════════
CombatTab:CreateSection("Weapon Modifications")

Toggles.NoRecoil = false
Toggles.NoSpread = false
Toggles.InstantReload = false
Toggles.InfAmmo = false
Toggles.AutoReload = false
Toggles.RapidFire = false
Toggles.AutoWeaponSwitch = false
Toggles.ScopeOverlay = false
Toggles.BulletTracer = false
Toggles.TrajectoryDisplay = false
Toggles.HitboxExpander = false
Toggles.HitboxVisible = false

CombatTab:CreateToggle({Name = "[WEAPON] No Recoil — Remove weapon recoil", CurrentValue = false, Flag = "NoRecoil", Callback = wrapToggleSetting("NoRecoil")}); countFeature()
CombatTab:CreateToggle({Name = "[WEAPON] No Spread — Remove bullet spread", CurrentValue = false, Flag = "NoSpread", Callback = wrapToggleSetting("NoSpread")}); countFeature()
CombatTab:CreateToggle({Name = "[WEAPON] Instant Reload — Skip reload animation", CurrentValue = false, Flag = "InstReload", Callback = wrapToggleSetting("InstantReload")}); countFeature()
CombatTab:CreateToggle({Name = "[WEAPON] Infinite Ammo — Never run out", CurrentValue = false, Flag = "InfAmmo", Callback = wrapToggleSetting("InfAmmo")}); countFeature()
CombatTab:CreateToggle({Name = "[WEAPON] Auto Reload — Reload when empty", CurrentValue = false, Flag = "AutoReload", Callback = wrapToggleSetting("AutoReload")}); countFeature()
CombatTab:CreateToggle({Name = "[WEAPON] Rapid Fire — Increase fire rate", CurrentValue = false, Flag = "RapidFire", Callback = wrapToggleSetting("RapidFire")}); countFeature()
CombatTab:CreateSlider({Name = "[WEAPON] Fire Rate Multiplier", Range = {1, 20}, Increment = 0.5, CurrentValue = 1, Flag = "FireRate", Callback = wrapSetting("FireRateMult")}); countFeature()
CombatTab:CreateSlider({Name = "[WEAPON] Bullet Speed Multiplier", Range = {1, 20}, Increment = 0.5, CurrentValue = 1, Flag = "BulletSpeed", Callback = wrapSetting("BulletSpeedMult")}); countFeature()
CombatTab:CreateSlider({Name = "[WEAPON] Damage Multiplier", Range = {1, 100}, Increment = 1, CurrentValue = 1, Flag = "DmgMult", Callback = wrapSetting("DamageMult")}); countFeature()
CombatTab:CreateToggle({Name = "[WEAPON] Auto Switch — Switch to best weapon", CurrentValue = false, Flag = "AutoWepSwitch", Callback = wrapToggleSetting("AutoWeaponSwitch")}); countFeature()
CombatTab:CreateToggle({Name = "[WEAPON] Scope Overlay — Add zoom scope", CurrentValue = false, Flag = "ScopeOverlay", Callback = wrapToggleSetting("ScopeOverlay")}); countFeature()
CombatTab:CreateSlider({Name = "[WEAPON] Scope Zoom Level", Range = {1, 10}, Increment = 0.5, CurrentValue = 2, Flag = "ScopeZoom", Callback = wrapSetting("ScopeZoom")}); countFeature()
CombatTab:CreateToggle({Name = "[WEAPON] Bullet Tracer — Show bullet paths", CurrentValue = false, Flag = "BulletTracer", Callback = wrapToggleSetting("BulletTracer")}); countFeature()
CombatTab:CreateSlider({Name = "[WEAPON] Tracer Length", Range = {10, 200}, Increment = 10, CurrentValue = 50, Flag = "TracerLen", Callback = wrapSetting("BulletTracerLen")}); countFeature()
CombatTab:CreateToggle({Name = "[WEAPON] Trajectory Display — Show bullet arc", CurrentValue = false, Flag = "TrajDisplay", Callback = wrapToggleSetting("TrajectoryDisplay")}); countFeature()

-- ═══════════════════════ HITBOX ═══════════════════════
CombatTab:CreateSection("Hitbox System")

CombatTab:CreateToggle({Name = "[HITBOX] Enable Hitbox Expander — Enlarge enemy heads", CurrentValue = false, Flag = "HitboxExp", Callback = wrapToggleRefresh("HitboxExpander")}); countFeature()
CombatTab:CreateSlider({Name = "[HITBOX] Size — Head hitbox size in studs", Range = {2, 100}, Increment = 1, CurrentValue = 5, Flag = "HitboxSize", Callback = wrapSetting("HitboxExpander")}); countFeature()
CombatTab:CreateInput({Name = "[HITBOX] Size Override — Type any value", PlaceholderText = "5", RemoveTextAfterFocusLost = false, Flag = "HitboxSizeInput", Callback = function(v) local n = tonumber(v); if n then Settings.HitboxExpander = n end end}); countFeature()
CombatTab:CreateToggle({Name = "[HITBOX] Visible — See expanded hitboxes", CurrentValue = false, Flag = "HitboxVis", Callback = wrapToggleSetting("HitboxVisible")}); countFeature()

-- ═══════════════════════ HIT LOG ═══════════════════════
CombatTab:CreateSection("Hit Logging")

Toggles.HitLogEnabled = false

CombatTab:CreateToggle({Name = "[LOG] Enable Hit Log — Track hits dealt", CurrentValue = false, Flag = "HitLog", Callback = wrapToggleSetting("HitLogEnabled")}); countFeature()
CombatTab:CreateSlider({Name = "[LOG] Max Entries — Log history length", Range = {10, 200}, Increment = 10, CurrentValue = 50, Flag = "HitLogMax", Callback = wrapSetting("HitLogMax")}); countFeature()
CombatTab:CreateButton({Name = "[LOG] Clear Hit Log", Callback = function() HitLog = {}; Notify("Hit Log", "Cleared", 2) end}); countFeature()

--[[
===========================================================================
                         TAB 2: MOVEMENT PRO
===========================================================================
]]
local MovementTab = Window:CreateTab("Movement Pro", "activity")

-- ═══════════════════════ SPEED SYSTEM ═══════════════════════
MovementTab:CreateSection("Speed System")

Toggles.CustomSpeed = false
Toggles.Sprint = false
Toggles.SpeedRamp = false
Toggles.MomentumBuilder = false
Toggles.VelocityLock = false
Toggles.SpeedCapBypass = false

MovementTab:CreateToggle({Name = "[SPEED] Enable Custom Speed — Override WalkSpeed", CurrentValue = false, Flag = "CustomSpeed", Callback = wrapToggleRefresh("CustomSpeed")}); countFeature()
MovementTab:CreateSlider({Name = "[SPEED] WalkSpeed — Base movement speed", Range = {16, 5000}, Increment = 1, CurrentValue = 16, Flag = "WalkSpeed", Callback = wrapSetting("WalkSpeed")}); countFeature()
MovementTab:CreateInput({Name = "[SPEED] WalkSpeed Override — Type any value (no limit)", PlaceholderText = "16", RemoveTextAfterFocusLost = false, Flag = "WalkSpeedInput", Callback = function(v) local n = tonumber(v); if n then Settings.WalkSpeed = n end end}); countFeature()
MovementTab:CreateToggle({Name = "[SPEED] Sprint — Hold Shift to sprint", CurrentValue = false, Flag = "Sprint", Callback = wrapToggleRefresh("Sprint")}); countFeature()
MovementTab:CreateSlider({Name = "[SPEED] Sprint Multiplier", Range = {1, 10}, Increment = 0.1, CurrentValue = 1.5, Flag = "SprintMult", Callback = wrapSetting("SprintMult")}); countFeature()
MovementTab:CreateInput({Name = "[SPEED] Sprint Mult Override", PlaceholderText = "1.5", RemoveTextAfterFocusLost = false, Flag = "SprintMultInput", Callback = function(v) local n = tonumber(v); if n then Settings.SprintMult = n end end}); countFeature()
MovementTab:CreateToggle({Name = "[SPEED] Speed Ramp — Accelerate while moving", CurrentValue = false, Flag = "SpeedRamp", Callback = wrapToggleRefresh("SpeedRamp")}); countFeature()
MovementTab:CreateSlider({Name = "[SPEED] Ramp Rate — Acceleration speed", Range = {0.5, 10}, Increment = 0.5, CurrentValue = 2, Flag = "RampSpeed", Callback = wrapSetting("RampSpeed")}); countFeature()
MovementTab:CreateToggle({Name = "[SPEED] Momentum Builder — Gain speed over time", CurrentValue = false, Flag = "Momentum", Callback = wrapToggleSetting("MomentumBuilder")}); countFeature()
MovementTab:CreateToggle({Name = "[SPEED] Velocity Lock — Lock current velocity", CurrentValue = false, Flag = "VelLock", Callback = wrapToggleSetting("VelocityLock")}); countFeature()
MovementTab:CreateToggle({Name = "[SPEED] Speed Cap Bypass — Remove speed limits", CurrentValue = false, Flag = "SpeedCapBypass", Callback = wrapToggleSetting("SpeedCapBypass")}); countFeature()
MovementTab:CreateSlider({Name = "[SPEED] Acceleration", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "Accel", Callback = wrapSetting("Acceleration")}); countFeature()
MovementTab:CreateSlider({Name = "[SPEED] Deceleration", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "Decel", Callback = wrapSetting("Deceleration")}); countFeature()

-- ═══════════════════════ JUMP SYSTEM ═══════════════════════
MovementTab:CreateSection("Jump System")

Toggles.CustomJump = false
Toggles.InfJump = false
Toggles.MultiJumpEnabled = false
Toggles.CoyoteTime = false
Toggles.WallJump = false
Toggles.LongJump = false
Toggles.RocketJump = false
Toggles.JumpDelayRem = false
Toggles.MoonJump = false

MovementTab:CreateToggle({Name = "[JUMP] Custom Jump Power — Override JumpPower", CurrentValue = false, Flag = "CustomJump", Callback = wrapToggleRefresh("CustomJump")}); countFeature()
MovementTab:CreateSlider({Name = "[JUMP] Jump Power — Jump height force", Range = {50, 2000}, Increment = 10, CurrentValue = 50, Flag = "JumpPower", Callback = wrapSetting("JumpPower")}); countFeature()
MovementTab:CreateInput({Name = "[JUMP] Jump Power Override", PlaceholderText = "50", RemoveTextAfterFocusLost = false, Flag = "JumpPowerInput", Callback = function(v) local n = tonumber(v); if n then Settings.JumpPower = n end end}); countFeature()
MovementTab:CreateToggle({Name = "[JUMP] Infinite Jump — Jump in mid-air", CurrentValue = false, Flag = "InfJump", Callback = wrapToggleRefresh("InfJump")}); countFeature()
MovementTab:CreateToggle({Name = "[JUMP] Multi Jump — Limited extra jumps", CurrentValue = false, Flag = "MultiJumpOn", Callback = wrapToggleRefresh("MultiJumpEnabled")}); countFeature()
MovementTab:CreateSlider({Name = "[JUMP] Extra Jumps — Number of air jumps", Range = {1, 100}, Increment = 1, CurrentValue = 1, Flag = "MultiJump", Callback = wrapSetting("MultiJump")}); countFeature()
MovementTab:CreateToggle({Name = "[JUMP] Coyote Time — Jump briefly after ledge", CurrentValue = false, Flag = "CoyoteTime", Callback = wrapToggleSetting("CoyoteTime")}); countFeature()
MovementTab:CreateSlider({Name = "[JUMP] Coyote Frames — Grace period frames", Range = {1, 20}, Increment = 1, CurrentValue = 5, Flag = "CoyoteFrames", Callback = wrapSetting("CoyoteFrames")}); countFeature()
MovementTab:CreateToggle({Name = "[JUMP] Wall Jump — Jump off walls", CurrentValue = false, Flag = "WallJump", Callback = wrapToggleSetting("WallJump")}); countFeature()
MovementTab:CreateToggle({Name = "[JUMP] Long Jump — Extend horizontal distance", CurrentValue = false, Flag = "LongJump", Callback = wrapToggleSetting("LongJump")}); countFeature()
MovementTab:CreateSlider({Name = "[JUMP] Long Jump Multiplier", Range = {1, 10}, Increment = 0.5, CurrentValue = 2, Flag = "LongJumpMult", Callback = wrapSetting("LongJumpMult")}); countFeature()
MovementTab:CreateToggle({Name = "[JUMP] Rocket Jump — Explosive upward force", CurrentValue = false, Flag = "RocketJump", Callback = wrapToggleSetting("RocketJump")}); countFeature()
MovementTab:CreateSlider({Name = "[JUMP] Rocket Force", Range = {50, 500}, Increment = 10, CurrentValue = 100, Flag = "RocketForce", Callback = wrapSetting("RocketJumpForce")}); countFeature()
MovementTab:CreateToggle({Name = "[JUMP] Jump Delay Remover — Remove jump cooldown", CurrentValue = false, Flag = "JumpDelRem", Callback = wrapToggleSetting("JumpDelayRem")}); countFeature()
MovementTab:CreateToggle({Name = "[JUMP] Moon Jump — Hold Space to rise", CurrentValue = false, Flag = "MoonJump", Callback = wrapToggleSetting("MoonJump")}); countFeature()
MovementTab:CreateSlider({Name = "[JUMP] Moon Force — Upward force strength", Range = {10, 500}, Increment = 10, CurrentValue = 100, Flag = "MoonForce", Callback = wrapSetting("MoonJumpForce")}); countFeature()

-- ═══════════════════════ BUNNY HOP ═══════════════════════
MovementTab:CreateSection("Bunny Hop")

Toggles.AutoBhop = false

MovementTab:CreateToggle({Name = "[BHOP] Auto Bunny Hop — Auto jump while moving", CurrentValue = false, Flag = "AutoBhop", Callback = wrapToggleRefresh("AutoBhop")}); countFeature()
MovementTab:CreateSlider({Name = "[BHOP] Strafe Boost — Air strafe speed boost", Range = {1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "StrafeBoost", Callback = wrapSetting("StrafeBoost")}); countFeature()

-- ═══════════════════════ AIR MOVEMENT ═══════════════════════
MovementTab:CreateSection("Air Movement")

Toggles.AirControl = false
Toggles.GlideMode = false
Toggles.HoverMode = false
Toggles.FloatMode = false

MovementTab:CreateToggle({Name = "[AIR] Air Control — WASD movement in air", CurrentValue = false, Flag = "AirControl", Callback = wrapToggleRefresh("AirControl")}); countFeature()
MovementTab:CreateSlider({Name = "[AIR] Air Speed — Movement speed in air", Range = {10, 500}, Increment = 10, CurrentValue = 50, Flag = "AirSpeed", Callback = wrapSetting("AirSpeed")}); countFeature()
MovementTab:CreateInput({Name = "[AIR] Air Speed Override", PlaceholderText = "50", RemoveTextAfterFocusLost = false, Flag = "AirSpeedInput", Callback = function(v) local n = tonumber(v); if n then Settings.AirSpeed = n end end}); countFeature()
MovementTab:CreateToggle({Name = "[AIR] Glide Mode — Slow fall rate", CurrentValue = false, Flag = "GlideMode", Callback = wrapToggleRefresh("GlideMode")}); countFeature()
MovementTab:CreateSlider({Name = "[AIR] Glide Speed — Fall rate in studs/s", Range = {0.5, 20}, Increment = 0.5, CurrentValue = 2, Flag = "GlideSpeed", Callback = wrapSetting("GlideSpeed")}); countFeature()
MovementTab:CreateToggle({Name = "[AIR] Hover Mode — Space/Ctrl to rise/lower", CurrentValue = false, Flag = "HoverMode", Callback = wrapToggleRefresh("HoverMode")}); countFeature()
MovementTab:CreateSlider({Name = "[AIR] Hover Height — Target hover altitude", Range = {10, 500}, Increment = 10, CurrentValue = 50, Flag = "HoverHeight", Callback = wrapSetting("HoverHeight")}); countFeature()
MovementTab:CreateToggle({Name = "[AIR] Float Mode — Near-zero gravity fall", CurrentValue = false, Flag = "FloatMode", Callback = wrapToggleRefresh("FloatMode")}); countFeature()

-- ═══════════════════════ FLY SYSTEM ═══════════════════════
MovementTab:CreateSection("Fly System")

Toggles.Fly = false
Toggles.FlyAcceleration = false
Toggles.HoverLock = false
Toggles.AutoAltitude = false
Toggles.FlyDrift = false

MovementTab:CreateToggle({Name = "[FLY] Enable Fly — WASD + Space/Shift flight", CurrentValue = false, Flag = "Fly", Callback = wrapToggleRefresh("Fly")}); countFeature()
MovementTab:CreateSlider({Name = "[FLY] Speed — Flight speed", Range = {10, 5000}, Increment = 10, CurrentValue = 50, Flag = "FlySpeed", Callback = wrapSetting("FlySpeed")}); countFeature()
MovementTab:CreateInput({Name = "[FLY] Speed Override — Type any value (no limit)", PlaceholderText = "50", RemoveTextAfterFocusLost = false, Flag = "FlySpeedInput", Callback = function(v) local n = tonumber(v); if n then Settings.FlySpeed = n end end}); countFeature()
MovementTab:CreateToggle({Name = "[FLY] Acceleration — Speed ramp during flight", CurrentValue = false, Flag = "FlyAccel", Callback = wrapToggleSetting("FlyAcceleration")}); countFeature()
MovementTab:CreateSlider({Name = "[FLY] Acceleration Rate", Range = {0.5, 5}, Increment = 0.1, CurrentValue = 1, Flag = "FlyAccelRate", Callback = wrapSetting("FlyAcceleration")}); countFeature()
MovementTab:CreateToggle({Name = "[FLY] Hover Lock — Stop mid-air when idle", CurrentValue = false, Flag = "HoverLock", Callback = wrapToggleSetting("HoverLock")}); countFeature()
MovementTab:CreateToggle({Name = "[FLY] Auto Altitude — Maintain set height", CurrentValue = false, Flag = "AutoAlt", Callback = wrapToggleSetting("AutoAltitude")}); countFeature()
MovementTab:CreateSlider({Name = "[FLY] Altitude — Auto altitude target", Range = {10, 1000}, Increment = 10, CurrentValue = 100, Flag = "FlyAlt", Callback = wrapSetting("FlyAltitude")}); countFeature()
MovementTab:CreateToggle({Name = "[FLY] Drift — Momentum-based flight", CurrentValue = false, Flag = "FlyDrift", Callback = wrapToggleSetting("FlyDrift")}); countFeature()

-- ═══════════════════════ WALL & SURFACE ═══════════════════════
MovementTab:CreateSection("Wall & Surface Movement")

Toggles.WallWalk = false
Toggles.SlideMovement = false

MovementTab:CreateToggle({Name = "[WALL] Wall Walk — Climb any wall", CurrentValue = false, Flag = "WallWalk", Callback = wrapToggleRefresh("WallWalk")}); countFeature()
MovementTab:CreateSlider({Name = "[WALL] Climb Speed — Wall movement speed", Range = {5, 100}, Increment = 5, CurrentValue = 20, Flag = "WallClimbSpeed", Callback = wrapSetting("WallClimbSpeed")}); countFeature()
MovementTab:CreateToggle({Name = "[SLIDE] Slide Movement — Press C to slide", CurrentValue = false, Flag = "SlideMove", Callback = wrapToggleRefresh("SlideMovement")}); countFeature()
MovementTab:CreateSlider({Name = "[SLIDE] Slide Speed", Range = {20, 200}, Increment = 10, CurrentValue = 50, Flag = "SlideSpeed", Callback = wrapSetting("SlideSpeed")}); countFeature()
MovementTab:CreateSlider({Name = "[SLIDE] Slide Friction", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.5, Flag = "SlideFriction", Callback = wrapSetting("SlideFriction")}); countFeature()

-- ═══════════════════════ DASH SYSTEM ═══════════════════════
MovementTab:CreateSection("Dash System")

Toggles.OmniDash = false
Toggles.Blink = false
Toggles.PhaseShift = false

MovementTab:CreateSlider({Name = "[DASH] Distance — Dash range in studs", Range = {10, 1000}, Increment = 10, CurrentValue = 50, Flag = "DashDist", Callback = wrapSetting("DashDistance")}); countFeature()
MovementTab:CreateInput({Name = "[DASH] Distance Override", PlaceholderText = "50", RemoveTextAfterFocusLost = false, Flag = "DashDistInput", Callback = function(v) local n = tonumber(v); if n then Settings.DashDistance = n end end}); countFeature()
MovementTab:CreateSlider({Name = "[DASH] Cooldown — Seconds between dashes", Range = {0, 10}, Increment = 0.5, CurrentValue = 1, Flag = "DashCD", Callback = wrapSetting("DashCooldown")}); countFeature()
MovementTab:CreateSlider({Name = "[DASH] Speed — Dash velocity", Range = {50, 500}, Increment = 10, CurrentValue = 100, Flag = "DashSpeed", Callback = wrapSetting("DashSpeed")}); countFeature()
MovementTab:CreateToggle({Name = "[DASH] Omni Directional — Dash in any direction", CurrentValue = false, Flag = "OmniDash", Callback = wrapToggleSetting("OmniDash")}); countFeature()
MovementTab:CreateToggle({Name = "[DASH] Blink — Short-range teleport dash", CurrentValue = false, Flag = "Blink", Callback = wrapToggleSetting("Blink")}); countFeature()
MovementTab:CreateSlider({Name = "[DASH] Blink Distance", Range = {5, 100}, Increment = 5, CurrentValue = 30, Flag = "BlinkDist", Callback = wrapSetting("BlinkDistance")}); countFeature()
MovementTab:CreateToggle({Name = "[DASH] Phase Shift — Noclip dash through walls", CurrentValue = false, Flag = "PhaseShift", Callback = wrapToggleSetting("PhaseShift")}); countFeature()
MovementTab:CreateSlider({Name = "[DASH] Phase Distance", Range = {10, 200}, Increment = 10, CurrentValue = 50, Flag = "PhaseDist", Callback = wrapSetting("PhaseDistance")}); countFeature()

-- ═══════════════════════ PHYSICS MODS ═══════════════════════
MovementTab:CreateSection("Physics & Safety")

Toggles.AntiFallDmg = false
Toggles.AntiKnockback = false
Toggles.IcePhysics = false
Toggles.PlatformLock = false
Toggles.Noclip = false
Toggles.AutoWalk = false
Toggles.MoveCorrection = false
Toggles.TerminalVelOverride = false
Toggles.CustomHipHeight = false

MovementTab:CreateToggle({Name = "[PHYS] Anti Fall Damage — Prevent fall death", CurrentValue = false, Flag = "AntiFall", Callback = wrapToggleRefresh("AntiFallDmg")}); countFeature()
MovementTab:CreateToggle({Name = "[PHYS] Anti Knockback — Reduce knockback", CurrentValue = false, Flag = "AntiKB", Callback = wrapToggleRefresh("AntiKnockback")}); countFeature()
MovementTab:CreateSlider({Name = "[PHYS] Knockback Multiplier", Range = {0, 10}, Increment = 0.1, CurrentValue = 1, Flag = "KBMult", Callback = wrapSetting("KnockbackMult")}); countFeature()
MovementTab:CreateToggle({Name = "[PHYS] Ice Physics — Slippery movement", CurrentValue = false, Flag = "IcePhys", Callback = wrapToggleSetting("IcePhysics")}); countFeature()
MovementTab:CreateSlider({Name = "[PHYS] Friction — Surface friction", Range = {0, 2}, Increment = 0.1, CurrentValue = 1, Flag = "Friction", Callback = wrapSetting("Friction")}); countFeature()
MovementTab:CreateToggle({Name = "[PHYS] Platform Lock — Stay on moving platforms", CurrentValue = false, Flag = "PlatLock", Callback = wrapToggleSetting("PlatformLock")}); countFeature()
MovementTab:CreateSlider({Name = "[PHYS] Step Height — Stair climb height", Range = {2, 100}, Increment = 1, CurrentValue = 2, Flag = "StepHeight", Callback = wrapSetting("StepHeight")}); countFeature()
MovementTab:CreateToggle({Name = "[PHYS] Noclip — Walk through walls", CurrentValue = false, Flag = "Noclip", Callback = wrapToggleRefresh("Noclip")}); countFeature()
MovementTab:CreateToggle({Name = "[PHYS] Auto Walk — Walk forward automatically", CurrentValue = false, Flag = "AutoWalk", Callback = wrapToggleRefresh("AutoWalk")}); countFeature()
MovementTab:CreateToggle({Name = "[PHYS] Terminal Velocity Override", CurrentValue = false, Flag = "TermVelOvr", Callback = wrapToggleSetting("TerminalVelOverride")}); countFeature()
MovementTab:CreateSlider({Name = "[PHYS] Terminal Velocity Value", Range = {0, 1000}, Increment = 10, CurrentValue = 196, Flag = "TermVel", Callback = wrapSetting("TerminalVelocity")}); countFeature()
MovementTab:CreateToggle({Name = "[PHYS] Custom Hip Height", CurrentValue = false, Flag = "CustomHipH", Callback = wrapToggleRefresh("CustomHipHeight")}); countFeature()
MovementTab:CreateSlider({Name = "[PHYS] Hip Height", Range = {0, 50}, Increment = 1, CurrentValue = 0, Flag = "HipHeight", Callback = wrapSetting("HipHeight")}); countFeature()
MovementTab:CreateToggle({Name = "[PHYS] Movement Correction", CurrentValue = false, Flag = "MoveCorr", Callback = wrapToggleSetting("MoveCorrection")}); countFeature()

--[[
===========================================================================
                        TAB 3: VISUAL PRO
===========================================================================
]]
local VisualsTab = Window:CreateTab("Visual Pro", "eye")

-- ═══════════════════════ ESP SYSTEM ═══════════════════════
VisualsTab:CreateSection("ESP — Player Detection")

Toggles.BoxESP = false
Toggles.NameESP = false
Toggles.HealthESP = false
Toggles.DistanceESP = false
Toggles.WeaponESP = false
Toggles.VelocityESP = false
Toggles.TeamColorESP = false
Toggles.RainbowESP = false
Toggles.TracerESP = false
Toggles.SkeletonESP = false
Toggles.HeadDotESP = false

VisualsTab:CreateToggle({Name = "[ESP] Box Highlight — Glow around players", CurrentValue = false, Flag = "BoxESP", Callback = wrapToggle(function(v) Toggles.BoxESP = v; setupESP() end)}); countFeature()
VisualsTab:CreateToggle({Name = "[ESP] Name Tags — Show player names", CurrentValue = false, Flag = "NameESP", Callback = wrapToggle(function(v) Toggles.NameESP = v; setupESP() end)}); countFeature()
VisualsTab:CreateToggle({Name = "[ESP] Health Bars — Show HP values", CurrentValue = false, Flag = "HealthESP", Callback = wrapToggle(function(v) Toggles.HealthESP = v; setupESP() end)}); countFeature()
VisualsTab:CreateToggle({Name = "[ESP] Distance — Show meters away", CurrentValue = false, Flag = "DistESP", Callback = wrapToggle(function(v) Toggles.DistanceESP = v; setupESP() end)}); countFeature()
VisualsTab:CreateToggle({Name = "[ESP] Weapon Display — Show equipped tool", CurrentValue = false, Flag = "WeaponESP", Callback = wrapToggle(function(v) Toggles.WeaponESP = v; setupESP() end)}); countFeature()
VisualsTab:CreateToggle({Name = "[ESP] Velocity — Show movement speed", CurrentValue = false, Flag = "VelocityESP", Callback = wrapToggle(function(v) Toggles.VelocityESP = v; setupESP() end)}); countFeature()
VisualsTab:CreateToggle({Name = "[ESP] Team Colors — Color by team", CurrentValue = false, Flag = "TeamColors", Callback = wrapToggleSetting("TeamColorESP")}); countFeature()
VisualsTab:CreateToggle({Name = "[ESP] Rainbow Mode — Cycling colors", CurrentValue = false, Flag = "RainbowESP", Callback = wrapToggleSetting("RainbowESP")}); countFeature()
VisualsTab:CreateToggle({Name = "[ESP] Tracers — Lines to players", CurrentValue = false, Flag = "TracerESP", Callback = wrapToggleSetting("TracerESP")}); countFeature()
VisualsTab:CreateToggle({Name = "[ESP] Skeleton — Bone structure overlay", CurrentValue = false, Flag = "SkelESP", Callback = wrapToggleSetting("SkeletonESP")}); countFeature()
VisualsTab:CreateToggle({Name = "[ESP] Head Dots — Dot on player heads", CurrentValue = false, Flag = "HeadDotESP", Callback = wrapToggleSetting("HeadDotESP")}); countFeature()
VisualsTab:CreateSlider({Name = "[ESP] Fill Transparency", Range = {0, 1}, Increment = 0.05, CurrentValue = 0.5, Flag = "ESPTrans", Callback = wrapSetting("ESPTransparency")}); countFeature()
VisualsTab:CreateSlider({Name = "[ESP] Max Distance", Range = {100, 50000}, Increment = 100, CurrentValue = 5000, Flag = "ESPMaxDist", Callback = wrapSetting("ESPMaxDist")}); countFeature()
VisualsTab:CreateInput({Name = "[ESP] Max Distance Override", PlaceholderText = "5000", RemoveTextAfterFocusLost = false, Flag = "ESPMaxDistInput", Callback = function(v) local n = tonumber(v); if n then Settings.ESPMaxDist = n end end}); countFeature()
VisualsTab:CreateDropdown({Name = "[ESP] Tracer Origin — Line start point", Options = {"Bottom", "Center", "Top", "Mouse"}, CurrentOption = {"Bottom"}, Flag = "TracerOrigin", Callback = function(v) Settings.TracerOrigin = v end}); countFeature()
VisualsTab:CreateSlider({Name = "[ESP] Tracer Thickness", Range = {1, 5}, Increment = 0.5, CurrentValue = 1, Flag = "TracerThick", Callback = wrapSetting("TracerThickness")}); countFeature()
VisualsTab:CreateDropdown({Name = "[ESP] BBox Style — Box style", Options = {"Corner", "Full", "3D"}, CurrentOption = {"Corner"}, Flag = "BBoxStyle", Callback = function(v) Settings.BBoxStyle = v end}); countFeature()

-- ═══════════════════════ CHAMS ═══════════════════════
VisualsTab:CreateSection("Chams System")

Toggles.ChamsEnabled = false
Toggles.ChamsWallOnly = false

VisualsTab:CreateToggle({Name = "[CHAMS] Enable Chams — Colored player overlay", CurrentValue = false, Flag = "ChamsOn", Callback = wrapToggleSetting("ChamsEnabled")}); countFeature()
VisualsTab:CreateToggle({Name = "[CHAMS] Through Walls Only — Only show when occluded", CurrentValue = false, Flag = "ChamsWall", Callback = wrapToggleSetting("ChamsWallOnly")}); countFeature()
VisualsTab:CreateSlider({Name = "[CHAMS] Transparency", Range = {0, 1}, Increment = 0.05, CurrentValue = 0.3, Flag = "ChamsTrans", Callback = wrapSetting("ChamsTransparency")}); countFeature()

-- ═══════════════════════ ITEM ESP ═══════════════════════
VisualsTab:CreateSection("Item & Object ESP")

Toggles.ItemESP = false
Toggles.ToolESP = false
Toggles.NPCHighlight = false
Toggles.PartHighlight = false

VisualsTab:CreateToggle({Name = "[ITEM] Item ESP — Highlight collectibles", CurrentValue = false, Flag = "ItemESP", Callback = wrapToggleSetting("ItemESP")}); countFeature()
VisualsTab:CreateSlider({Name = "[ITEM] Detection Range", Range = {50, 2000}, Increment = 50, CurrentValue = 200, Flag = "ItemRange", Callback = wrapSetting("ItemESPRange")}); countFeature()
VisualsTab:CreateToggle({Name = "[ITEM] Tool ESP — Highlight dropped tools", CurrentValue = false, Flag = "ToolESP", Callback = wrapToggleSetting("ToolESP")}); countFeature()
VisualsTab:CreateToggle({Name = "[ITEM] NPC Highlight — Highlight non-players", CurrentValue = false, Flag = "NPCHigh", Callback = wrapToggleSetting("NPCHighlight")}); countFeature()
VisualsTab:CreateToggle({Name = "[ITEM] Part Highlight — Highlight interactable parts", CurrentValue = false, Flag = "PartHigh", Callback = wrapToggleSetting("PartHighlight")}); countFeature()

-- ═══════════════════════ CAMERA SYSTEM ═══════════════════════
VisualsTab:CreateSection("Camera System")

Toggles.FOVUnlock = false
Toggles.ThirdPerson = false
Toggles.CamShakeRemoval = false
Toggles.Freecam = false
Toggles.SpectateMode = false
Toggles.OrbitCamera = false
Toggles.TopDownView = false
Toggles.CinematicMode = false

VisualsTab:CreateSlider({Name = "[CAM] Custom FOV — Field of view", Range = {10, 120}, Increment = 1, CurrentValue = 70, Flag = "CustomFOV", Callback = function(v) Settings.CustomFOV = v; Camera.FieldOfView = v end}); countFeature()
VisualsTab:CreateInput({Name = "[CAM] FOV Override", PlaceholderText = "70", RemoveTextAfterFocusLost = false, Flag = "FOVInput", Callback = function(v) local n = tonumber(v); if n then Settings.CustomFOV = n; Camera.FieldOfView = n end end}); countFeature()
VisualsTab:CreateToggle({Name = "[CAM] FOV Unlock — Remove FOV limits", CurrentValue = false, Flag = "FOVUnlock", Callback = wrapToggleSetting("FOVUnlock")}); countFeature()
VisualsTab:CreateSlider({Name = "[CAM] Zoom Speed", Range = {1, 20}, Increment = 0.5, CurrentValue = 1, Flag = "ZoomSpeed", Callback = wrapSetting("ZoomSpeed")}); countFeature()
VisualsTab:CreateToggle({Name = "[CAM] Third Person Lock", CurrentValue = false, Flag = "ThirdPerson", Callback = function(v) Toggles.ThirdPerson = v; LocalPlayer.CameraMode = v and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson end}); countFeature()
VisualsTab:CreateSlider({Name = "[CAM] Camera Smoothing", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "CamSmooth", Callback = wrapSetting("CamSmooth")}); countFeature()
VisualsTab:CreateToggle({Name = "[CAM] Remove Camera Shake", CurrentValue = false, Flag = "CamShake", Callback = wrapToggleSetting("CamShakeRemoval")}); countFeature()
VisualsTab:CreateToggle({Name = "[CAM] Freecam — Detached camera flight", CurrentValue = false, Flag = "Freecam", Callback = wrapToggleRefresh("Freecam")}); countFeature()
VisualsTab:CreateSlider({Name = "[CAM] Freecam Speed", Range = {10, 500}, Increment = 10, CurrentValue = 50, Flag = "FreecamSpeed", Callback = wrapSetting("FreecamSpeed")}); countFeature()
VisualsTab:CreateSlider({Name = "[CAM] Freecam Rotation Speed", Range = {0.5, 10}, Increment = 0.5, CurrentValue = 2, Flag = "FreecamRot", Callback = wrapSetting("FreecamRot")}); countFeature()
VisualsTab:CreateToggle({Name = "[CAM] Spectate Mode — Watch another player", CurrentValue = false, Flag = "Spectate", Callback = wrapToggleSetting("SpectateMode")}); countFeature()
VisualsTab:CreateInput({Name = "[CAM] Spectate Target — Player username", PlaceholderText = "Username", RemoveTextAfterFocusLost = false, Flag = "SpectateTarget", Callback = function(v) Settings.SpectateTarget = v end}); countFeature()
VisualsTab:CreateToggle({Name = "[CAM] Orbit Camera — Camera orbits character", CurrentValue = false, Flag = "OrbitCam", Callback = wrapToggleSetting("OrbitCamera")}); countFeature()
VisualsTab:CreateSlider({Name = "[CAM] Orbit Radius", Range = {5, 50}, Increment = 1, CurrentValue = 15, Flag = "OrbitCamRad", Callback = wrapSetting("OrbitCamRadius")}); countFeature()
VisualsTab:CreateSlider({Name = "[CAM] Orbit Speed", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 1, Flag = "OrbitCamSpeed", Callback = wrapSetting("OrbitCamSpeed")}); countFeature()
VisualsTab:CreateToggle({Name = "[CAM] Top Down View — Bird's eye camera", CurrentValue = false, Flag = "TopDown", Callback = wrapToggleSetting("TopDownView")}); countFeature()
VisualsTab:CreateToggle({Name = "[CAM] Cinematic Mode — Smooth camera paths", CurrentValue = false, Flag = "CineMode", Callback = wrapToggleSetting("CinematicMode")}); countFeature()
VisualsTab:CreateSlider({Name = "[CAM] Cinematic Speed", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 1, Flag = "CineSpeed", Callback = wrapSetting("CineSpeed")}); countFeature()

-- ═══════════════════════ CROSSHAIR ═══════════════════════
VisualsTab:CreateSection("Crosshair System")

Toggles.Crosshair = false

VisualsTab:CreateToggle({Name = "[CROSS] Enable Crosshair — Custom crosshair overlay", CurrentValue = false, Flag = "Crosshair", Callback = wrapToggleSetting("Crosshair")}); countFeature()
VisualsTab:CreateDropdown({Name = "[CROSS] Style — Crosshair shape", Options = {"Cross", "Dot", "Circle", "T-Shape"}, CurrentOption = {"Cross"}, Flag = "CrossStyle", Callback = function(v) Settings.CrosshairStyle = v end}); countFeature()
VisualsTab:CreateSlider({Name = "[CROSS] Size", Range = {2, 50}, Increment = 1, CurrentValue = 10, Flag = "CrossSize", Callback = wrapSetting("CrosshairSize")}); countFeature()
VisualsTab:CreateSlider({Name = "[CROSS] Thickness", Range = {1, 10}, Increment = 0.5, CurrentValue = 2, Flag = "CrossThick", Callback = wrapSetting("CrosshairThickness")}); countFeature()
VisualsTab:CreateSlider({Name = "[CROSS] Gap", Range = {0, 20}, Increment = 1, CurrentValue = 3, Flag = "CrossGap", Callback = wrapSetting("CrosshairGap")}); countFeature()

-- ═══════════════════════ ENVIRONMENT ═══════════════════════
VisualsTab:CreateSection("Environment Visuals")

Toggles.Fullbright = false
Toggles.NightMode = false
Toggles.RemFog = false
Toggles.XRayMode = false
Toggles.WireframeMode = false
Toggles.RemoveParticles = false

VisualsTab:CreateToggle({Name = "[ENV] Fullbright — Remove all shadows", CurrentValue = false, Flag = "Fullbright", Callback = function(v) Toggles.Fullbright = v; if v then setupFullbright() end end}); countFeature()
VisualsTab:CreateToggle({Name = "[ENV] Night Mode — Dark environment", CurrentValue = false, Flag = "NightMode", Callback = function(v) Toggles.NightMode = v; if v then Lighting.Brightness = 0.3; Lighting.ClockTime = 0 else Lighting.Brightness = 1; Lighting.ClockTime = 12 end end}); countFeature()
VisualsTab:CreateToggle({Name = "[ENV] Remove Fog — Clear visibility", CurrentValue = false, Flag = "RemFog", Callback = function(v) Toggles.RemFog = v; Lighting.FogEnd = v and 100000 or 1000 end}); countFeature()
VisualsTab:CreateSlider({Name = "[ENV] Time of Day", Range = {0, 24}, Increment = 0.5, CurrentValue = 12, Flag = "TimeOfDay", Callback = function(v) Settings.TimeChange = v; Lighting.ClockTime = v end}); countFeature()
VisualsTab:CreateSlider({Name = "[ENV] World Brightness", Range = {0, 10}, Increment = 0.5, CurrentValue = 1, Flag = "WorldBright", Callback = function(v) Settings.WorldBright = v; Lighting.Brightness = v end}); countFeature()
VisualsTab:CreateSlider({Name = "[ENV] Shadow Intensity", Range = {0, 1}, Increment = 0.1, CurrentValue = 1, Flag = "ShadowInt", Callback = function(v) Settings.ShadowInt = v; pcall(function() Lighting.ShadowSoftness = v end) end}); countFeature()
VisualsTab:CreateDropdown({Name = "[ENV] Skybox Preset", Options = {"Default", "Galaxy", "Vaporwave", "Red", "Blue", "Green", "Sunset", "Clear"}, CurrentOption = {"Default"}, Flag = "Skybox", Callback = function(v) Settings.Skybox = v end}); countFeature()
VisualsTab:CreateToggle({Name = "[ENV] X-Ray Mode — See through walls", CurrentValue = false, Flag = "XRay", Callback = wrapToggleSetting("XRayMode")}); countFeature()
VisualsTab:CreateSlider({Name = "[ENV] X-Ray Transparency", Range = {0.1, 0.9}, Increment = 0.1, CurrentValue = 0.7, Flag = "XRayTrans", Callback = wrapSetting("XRayTransparency")}); countFeature()
VisualsTab:CreateToggle({Name = "[ENV] Remove Particles — Disable effects", CurrentValue = false, Flag = "RemParticles", Callback = wrapToggleSetting("RemoveParticles")}); countFeature()

--[[
===========================================================================
                      TAB 4: TELEPORT SYSTEM
===========================================================================
]]
local TeleportTab = Window:CreateTab("Teleport System", "map-pin")

-- ═══════════════════════ POSITION MANAGEMENT ═══════════════════════
TeleportTab:CreateSection("Position Management")

TeleportTab:CreateButton({Name = "[SAVE] Save Current Position — Auto-named by time", Callback = function()
    local hrp = getRoot()
    if hrp then
        local name = "Pos_" .. os.date("%H%M%S")
        SavedPositions[name] = hrp.CFrame
        table.insert(TeleportHistory, {name = name, cframe = hrp.CFrame, time = os.time()})
        Notify("Position Saved", name .. " (" .. tostring(math.floor(hrp.Position.X)) .. ", " .. tostring(math.floor(hrp.Position.Y)) .. ", " .. tostring(math.floor(hrp.Position.Z)) .. ")", 3)
    end
end}); countFeature()

TeleportTab:CreateInput({Name = "[SAVE] Save Named Position — Custom name", PlaceholderText = "Enter position name", RemoveTextAfterFocusLost = false, Flag = "SaveNamed", Callback = function(v)
    local hrp = getRoot()
    if hrp and v ~= "" then
        SavedPositions[v] = hrp.CFrame
        table.insert(TeleportHistory, {name = v, cframe = hrp.CFrame, time = os.time()})
        Notify("Saved", v, 3)
    end
end}); countFeature()

TeleportTab:CreateInput({Name = "[SAVE] Waypoint Name — Name for current coords", PlaceholderText = "Waypoint name", RemoveTextAfterFocusLost = false, Flag = "WaypointName", Callback = function(v) Settings.WaypointName = v end}); countFeature()

TeleportTab:CreateButton({Name = "[SAVE] Save Waypoint — Save using waypoint name", Callback = function()
    local hrp = getRoot()
    local name = Settings.WaypointName
    if hrp and name and name ~= "" then
        SavedPositions[name] = hrp.CFrame
        Notify("Waypoint Saved", name, 3)
    end
end}); countFeature()

TeleportTab:CreateButton({Name = "[LIST] List All Saved Positions", Callback = function()
    local list = ""
    local count = 0
    for name, cf in pairs(SavedPositions) do
        count = count + 1
        list = list .. name .. " (" .. math.floor(cf.X) .. "," .. math.floor(cf.Y) .. "," .. math.floor(cf.Z) .. ")\n"
        if count >= 20 then list = list .. "... and more"; break end
    end
    Notify("Saved Positions", list ~= "" and list or "None saved", 8)
end}); countFeature()

TeleportTab:CreateInput({Name = "[DELETE] Delete Position — Enter name to remove", PlaceholderText = "Position name", RemoveTextAfterFocusLost = false, Flag = "DeletePos", Callback = function(v)
    if SavedPositions[v] then
        SavedPositions[v] = nil
        Notify("Deleted", v, 2)
    else
        Notify("Not Found", v, 2)
    end
end}); countFeature()

TeleportTab:CreateInput({Name = "[SEARCH] Search Positions — Find by name", PlaceholderText = "Search term", RemoveTextAfterFocusLost = false, Flag = "SearchPos", Callback = function(v)
    local results = ""
    for name in pairs(SavedPositions) do
        if name:lower():find(v:lower()) then
            results = results .. name .. "\n"
        end
    end
    Notify("Search Results", results ~= "" and results or "No matches", 5)
end}); countFeature()

-- ═══════════════════════ TELEPORT MODES ═══════════════════════
TeleportTab:CreateSection("Teleport Modes")

Toggles.TweenTP = false
Toggles.SafeTP = false

TeleportTab:CreateButton({Name = "[TP] Teleport to Spawn", Callback = function()
    local hrp = getRoot()
    if hrp and SavedPositions["Spawn"] then
        hrp.CFrame = SavedPositions["Spawn"]
    end
end}); countFeature()

TeleportTab:CreateInput({Name = "[TP] Teleport to Saved — Enter position name", PlaceholderText = "Position name", RemoveTextAfterFocusLost = false, Flag = "TPToSaved", Callback = function(v)
    local hrp = getRoot()
    if hrp and SavedPositions[v] then
        if Toggles.TweenTP then
            local tweenInfo = TweenInfo.new((hrp.Position - SavedPositions[v].Position).Magnitude / (Settings.TweenSpeed or 50), Enum.EasingStyle.Linear)
            TweenService:Create(hrp, tweenInfo, {CFrame = SavedPositions[v]}):Play()
        else
            task.wait(Settings.TeleportDelay or 0)
            hrp.CFrame = SavedPositions[v]
        end
        Notify("Teleported", v, 2)
    end
end}); countFeature()

TeleportTab:CreateSlider({Name = "[TP] Teleport Delay — Seconds before TP", Range = {0, 10}, Increment = 0.5, CurrentValue = 0, Flag = "TPDelay", Callback = wrapSetting("TeleportDelay")}); countFeature()
TeleportTab:CreateToggle({Name = "[TP] Smooth Tween TP — Animated teleport", CurrentValue = false, Flag = "TweenTP", Callback = wrapToggleSetting("TweenTP")}); countFeature()
TeleportTab:CreateSlider({Name = "[TP] Tween Speed — Studs per second", Range = {10, 500}, Increment = 10, CurrentValue = 50, Flag = "TweenSpeed", Callback = wrapSetting("TweenSpeed")}); countFeature()
TeleportTab:CreateInput({Name = "[TP] Tween Speed Override", PlaceholderText = "50", RemoveTextAfterFocusLost = false, Flag = "TweenSpeedInput", Callback = function(v) local n = tonumber(v); if n then Settings.TweenSpeed = n end end}); countFeature()
TeleportTab:CreateToggle({Name = "[TP] Safe TP — Validate landing zone", CurrentValue = false, Flag = "SafeTP", Callback = wrapToggleSetting("SafeTP")}); countFeature()
TeleportTab:CreateSlider({Name = "[TP] Safe Height Offset — Studs above ground", Range = {0, 50}, Increment = 1, CurrentValue = 5, Flag = "SafeTPHeight", Callback = wrapSetting("SafeTPHeight")}); countFeature()

-- ═══════════════════════ COORDINATE TELEPORT ═══════════════════════
TeleportTab:CreateSection("Coordinate Teleport")

TeleportTab:CreateInput({Name = "[COORD] X Coordinate", PlaceholderText = "0", RemoveTextAfterFocusLost = false, Flag = "CoordX", Callback = function(v) Settings.CoordX = tonumber(v) or 0 end}); countFeature()
TeleportTab:CreateInput({Name = "[COORD] Y Coordinate", PlaceholderText = "0", RemoveTextAfterFocusLost = false, Flag = "CoordY", Callback = function(v) Settings.CoordY = tonumber(v) or 0 end}); countFeature()
TeleportTab:CreateInput({Name = "[COORD] Z Coordinate", PlaceholderText = "0", RemoveTextAfterFocusLost = false, Flag = "CoordZ", Callback = function(v) Settings.CoordZ = tonumber(v) or 0 end}); countFeature()
TeleportTab:CreateButton({Name = "[COORD] Teleport to Coordinates", Callback = function()
    local hrp = getRoot()
    if hrp then
        local target = CFrame.new(Settings.CoordX or 0, Settings.CoordY or 0, Settings.CoordZ or 0)
        if Toggles.TweenTP then
            local dist = (hrp.Position - target.Position).Magnitude
            local tweenInfo = TweenInfo.new(dist / (Settings.TweenSpeed or 50), Enum.EasingStyle.Linear)
            TweenService:Create(hrp, tweenInfo, {CFrame = target}):Play()
        else
            task.wait(Settings.TeleportDelay or 0)
            hrp.CFrame = target
        end
        Notify("Teleported", "XYZ: " .. Settings.CoordX .. ", " .. Settings.CoordY .. ", " .. Settings.CoordZ, 2)
    end
end}); countFeature()

TeleportTab:CreateButton({Name = "[COORD] Copy Current Position — To clipboard", Callback = function()
    local hrp = getRoot()
    if hrp then
        local pos = math.floor(hrp.Position.X) .. ", " .. math.floor(hrp.Position.Y) .. ", " .. math.floor(hrp.Position.Z)
        pcall(function() setclipboard(pos) end)
        Notify("Copied", pos, 2)
    end
end}); countFeature()

-- ═══════════════════════ LOOP & RANDOM ═══════════════════════
TeleportTab:CreateSection("Loop & Random Teleport")

Toggles.LoopTeleport = false
Settings.LoopTPTarget = nil

TeleportTab:CreateToggle({Name = "[LOOP] Loop Teleport — Continuously TP to position", CurrentValue = false, Flag = "LoopTP", Callback = function(v) Toggles.LoopTeleport = v; if v then setupLoopTeleport() end end}); countFeature()
TeleportTab:CreateSlider({Name = "[LOOP] Loop Delay — Seconds between TPs", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "LoopTPDelay", Callback = wrapSetting("LoopTPDelay")}); countFeature()
TeleportTab:CreateInput({Name = "[LOOP] Loop Target — Position name to loop to", PlaceholderText = "Position name", RemoveTextAfterFocusLost = false, Flag = "LoopTPTarget", Callback = function(v) Settings.LoopTPTarget = v end}); countFeature()

TeleportTab:CreateButton({Name = "[RANDOM] Random Teleport — TP to random location", Callback = function()
    local hrp = getRoot()
    if hrp then
        local radius = Settings.RandomTPRadius or 100
        local height = Settings.RandomTPHeight or 10
        local offsetX = math.random(-radius, radius)
        local offsetZ = math.random(-radius, radius)
        hrp.CFrame = CFrame.new(hrp.Position.X + offsetX, hrp.Position.Y + height, hrp.Position.Z + offsetZ)
        Notify("Random TP", "Offset: " .. offsetX .. ", " .. offsetZ, 2)
    end
end}); countFeature()

TeleportTab:CreateSlider({Name = "[RANDOM] Radius — Max random distance", Range = {10, 5000}, Increment = 10, CurrentValue = 100, Flag = "RandTPRad", Callback = wrapSetting("RandomTPRadius")}); countFeature()
TeleportTab:CreateInput({Name = "[RANDOM] Radius Override", PlaceholderText = "100", RemoveTextAfterFocusLost = false, Flag = "RandTPRadInput", Callback = function(v) local n = tonumber(v); if n then Settings.RandomTPRadius = n end end}); countFeature()
TeleportTab:CreateSlider({Name = "[RANDOM] Height Offset", Range = {0, 100}, Increment = 5, CurrentValue = 10, Flag = "RandTPHeight", Callback = wrapSetting("RandomTPHeight")}); countFeature()

-- ═══════════════════════ PLAYER TELEPORT ═══════════════════════
TeleportTab:CreateSection("Player Teleport")

Toggles.FollowPlayer = false
Toggles.OrbitPlayer = false

TeleportTab:CreateInput({Name = "[PLAYER] Target Player — Username", PlaceholderText = "Username", RemoveTextAfterFocusLost = false, Flag = "TPPlayer", Callback = function(v) Settings.TargetPlayer = v end}); countFeature()

TeleportTab:CreateButton({Name = "[PLAYER] Teleport to Player", Callback = function()
    local target = Players:FindFirstChild(Settings.TargetPlayer or "")
    local hrp = getRoot()
    if target and isAlive(target) and hrp then
        task.wait(Settings.TeleportDelay or 0)
        if Toggles.TweenTP then
            local targetCF = target.Character.HumanoidRootPart.CFrame
            local dist = (hrp.Position - targetCF.Position).Magnitude
            TweenService:Create(hrp, TweenInfo.new(dist / (Settings.TweenSpeed or 50), Enum.EasingStyle.Linear), {CFrame = targetCF}):Play()
        else
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
        end
        Notify("Teleported", "To " .. Settings.TargetPlayer, 2)
    end
end}); countFeature()

TeleportTab:CreateToggle({Name = "[PLAYER] Follow Player — Continuously follow", CurrentValue = false, Flag = "FollowPlayer", Callback = wrapToggleRefresh("FollowPlayer")}); countFeature()
TeleportTab:CreateSlider({Name = "[PLAYER] Follow Distance", Range = {2, 30}, Increment = 1, CurrentValue = 5, Flag = "FollowDist", Callback = wrapSetting("FollowDistance")}); countFeature()

TeleportTab:CreateToggle({Name = "[PLAYER] Orbit Player — Circle around target", CurrentValue = false, Flag = "OrbitPlayer", Callback = wrapToggleRefresh("OrbitPlayer")}); countFeature()
TeleportTab:CreateSlider({Name = "[PLAYER] Orbit Radius", Range = {3, 50}, Increment = 1, CurrentValue = 10, Flag = "OrbitRad", Callback = wrapSetting("OrbitRadius")}); countFeature()
TeleportTab:CreateSlider({Name = "[PLAYER] Orbit Speed", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 1, Flag = "OrbitSpeed", Callback = wrapSetting("OrbitSpeed")}); countFeature()
TeleportTab:CreateSlider({Name = "[PLAYER] Orbit Height — Vertical offset", Range = {-20, 50}, Increment = 1, CurrentValue = 0, Flag = "OrbitHeight", Callback = wrapSetting("OrbitHeight")}); countFeature()

-- ═══════════════════════ HISTORY & SAFETY ═══════════════════════
TeleportTab:CreateSection("History & Safety")

Toggles.AntiVoidTP = false

TeleportTab:CreateButton({Name = "[HIST] Show Teleport History — Last 20 positions", Callback = function()
    local hist = ""
    local count = math.min(#TeleportHistory, 20)
    for i = #TeleportHistory, math.max(1, #TeleportHistory - 19), -1 do
        local entry = TeleportHistory[i]
        hist = hist .. entry.name .. "\n"
    end
    Notify("TP History", hist ~= "" and hist or "No history", 8)
end}); countFeature()

TeleportTab:CreateButton({Name = "[HIST] Undo Last Teleport — Go to previous position", Callback = function()
    if #TeleportHistory >= 2 then
        local prev = TeleportHistory[#TeleportHistory - 1]
        local hrp = getRoot()
        if hrp and prev then
            hrp.CFrame = prev.cframe
            Notify("Undo TP", "Returned to " .. prev.name, 2)
        end
    end
end}); countFeature()

TeleportTab:CreateButton({Name = "[HIST] Clear History", Callback = function() TeleportHistory = {}; Notify("History", "Cleared", 2) end}); countFeature()

TeleportTab:CreateToggle({Name = "[SAFE] Anti-Void Recovery — TP up if falling", CurrentValue = false, Flag = "AntiVoidTP", Callback = wrapToggleRefresh("AntiVoidTP")}); countFeature()

TeleportTab:CreateButton({Name = "[PATH] Pathfind to Player — Navigate with obstacles", Callback = function()
    local target = Players:FindFirstChild(Settings.TargetPlayer or "")
    local hrp = getRoot()
    local hum = getHum()
    if target and isAlive(target) and hrp and hum then
        pcall(function()
            local path = PathfindingService:CreatePath({
                AgentRadius = 2,
                AgentHeight = 5,
                AgentCanJump = true,
            })
            path:ComputeAsync(hrp.Position, target.Character.HumanoidRootPart.Position)
            if path.Status == Enum.PathStatus.Success then
                local waypoints = path:GetWaypoints()
                for _, wp in ipairs(waypoints) do
                    hum:MoveTo(wp.Position)
                    if wp.Action == Enum.PathWaypointAction.Jump then
                        hum.Jump = true
                    end
                    hum.MoveToFinished:Wait()
                end
                Notify("Pathfind", "Arrived at " .. target.Name, 2)
            else
                Notify("Pathfind", "No path found", 2)
            end
        end)
    end
end}); countFeature()

TeleportTab:CreateSlider({Name = "[PATH] Path Timeout — Seconds before giving up", Range = {5, 60}, Increment = 5, CurrentValue = 10, Flag = "PathTimeout", Callback = wrapSetting("PathTimeout")}); countFeature()

--[[
===========================================================================
                       TAB 5: PLAYER MODS
===========================================================================
]]
local PlayerTab = Window:CreateTab("Player Mods", "user")

-- ═══════════════════════ CHARACTER ═══════════════════════
PlayerTab:CreateSection("Character Modifications")

Toggles.Godmode = false
Toggles.ForceSit = false
Toggles.AntiRagdoll = false
Toggles.DisableAnims = false
Toggles.Invisible = false
Toggles.ForceField = false
Toggles.CustomScale = false
Toggles.CustomHeadScale = false
Toggles.CustomTransparency = false

PlayerTab:CreateToggle({Name = "[CHAR] Godmode — Infinite health", CurrentValue = false, Flag = "Godmode", Callback = wrapToggleRefresh("Godmode")}); countFeature()
PlayerTab:CreateSlider({Name = "[CHAR] Heal Speed — HP per second", Range = {1, 500}, Increment = 1, CurrentValue = 1, Flag = "HealSpeed", Callback = wrapSetting("HealSpeed")}); countFeature()
PlayerTab:CreateSlider({Name = "[CHAR] Max Health", Range = {100, 1000000}, Increment = 100, CurrentValue = 100, Flag = "MaxHP", Callback = wrapSetting("MaxHealth")}); countFeature()
PlayerTab:CreateInput({Name = "[CHAR] Max Health Override", PlaceholderText = "100", RemoveTextAfterFocusLost = false, Flag = "MaxHPInput", Callback = function(v) local n = tonumber(v); if n then Settings.MaxHealth = n end end}); countFeature()
PlayerTab:CreateToggle({Name = "[CHAR] Force Sit — Lock in sitting pose", CurrentValue = false, Flag = "ForceSit", Callback = function(v) Toggles.ForceSit = v; local h = getHum(); if h then h.Sit = v end end}); countFeature()
PlayerTab:CreateToggle({Name = "[CHAR] Anti Ragdoll — Prevent ragdoll state", CurrentValue = false, Flag = "AntiRag", Callback = wrapToggleSetting("AntiRagdoll")}); countFeature()
PlayerTab:CreateToggle({Name = "[CHAR] Disable Animations — Remove all anims", CurrentValue = false, Flag = "DisAnim", Callback = wrapToggleSetting("DisableAnims")}); countFeature()
PlayerTab:CreateSlider({Name = "[CHAR] Animation Speed", Range = {0, 10}, Increment = 0.1, CurrentValue = 1, Flag = "AnimSpeed", Callback = wrapSetting("AnimSpeed")}); countFeature()
PlayerTab:CreateToggle({Name = "[CHAR] Invisible — Transparency to max", CurrentValue = false, Flag = "Invis", Callback = wrapToggleSetting("Invisible")}); countFeature()
PlayerTab:CreateToggle({Name = "[CHAR] Force Field — Spawn protection bubble", CurrentValue = false, Flag = "ForceField", Callback = function(v)
    Toggles.ForceField = v
    local char = getChar()
    if char then
        if v then
            if not char:FindFirstChildOfClass("ForceField") then
                Instance.new("ForceField", char)
            end
        else
            local ff = char:FindFirstChildOfClass("ForceField")
            if ff then ff:Destroy() end
        end
    end
end}); countFeature()

-- ═══════════════════════ BODY MODS ═══════════════════════
PlayerTab:CreateSection("Body Modifications")

PlayerTab:CreateToggle({Name = "[BODY] Custom Scale — Override character size", CurrentValue = false, Flag = "CustomScale", Callback = wrapToggleSetting("CustomScale")}); countFeature()
PlayerTab:CreateSlider({Name = "[BODY] Character Scale", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "CharScale", Callback = wrapSetting("CharScale")}); countFeature()
PlayerTab:CreateInput({Name = "[BODY] Scale Override", PlaceholderText = "1", RemoveTextAfterFocusLost = false, Flag = "CharScaleInput", Callback = function(v) local n = tonumber(v); if n then Settings.CharScale = n end end}); countFeature()
PlayerTab:CreateToggle({Name = "[BODY] Custom Head Scale", CurrentValue = false, Flag = "CustomHead", Callback = wrapToggleSetting("CustomHeadScale")}); countFeature()
PlayerTab:CreateSlider({Name = "[BODY] Head Scale — Big/small head", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "HeadScale", Callback = wrapSetting("HeadScale")}); countFeature()
PlayerTab:CreateToggle({Name = "[BODY] Custom Transparency", CurrentValue = false, Flag = "CustomTrans", Callback = wrapToggleSetting("CustomTransparency")}); countFeature()
PlayerTab:CreateSlider({Name = "[BODY] Body Transparency", Range = {0, 1}, Increment = 0.05, CurrentValue = 0, Flag = "BodyTrans", Callback = wrapSetting("BodyTransparency")}); countFeature()

-- ═══════════════════════ MOVEMENT MODS ═══════════════════════
PlayerTab:CreateSection("Movement Modifications")

Toggles.CustomSwimSpeed = false
Toggles.CustomCrawlSpeed = false

PlayerTab:CreateToggle({Name = "[MOVE] Custom Swim Speed", CurrentValue = false, Flag = "CustomSwim", Callback = wrapToggleSetting("CustomSwimSpeed")}); countFeature()
PlayerTab:CreateSlider({Name = "[MOVE] Swim Speed", Range = {10, 500}, Increment = 10, CurrentValue = 50, Flag = "SwimSpeed", Callback = wrapSetting("SwimSpeed")}); countFeature()
PlayerTab:CreateToggle({Name = "[MOVE] Custom Crawl Speed", CurrentValue = false, Flag = "CustomCrawl", Callback = wrapToggleSetting("CustomCrawlSpeed")}); countFeature()
PlayerTab:CreateSlider({Name = "[MOVE] Crawl Speed", Range = {5, 100}, Increment = 5, CurrentValue = 10, Flag = "CrawlSpeed", Callback = wrapSetting("CrawlSpeed")}); countFeature()

-- ═══════════════════════ IDENTITY ═══════════════════════
PlayerTab:CreateSection("Identity Modifications")

Toggles.NameSpoofVis = false
Toggles.TeamSpoofVis = false

PlayerTab:CreateToggle({Name = "[ID] Name Display Override — Fake name tag", CurrentValue = false, Flag = "NameSpoof", Callback = wrapToggleSetting("NameSpoofVis")}); countFeature()
PlayerTab:CreateInput({Name = "[ID] Display Name — Custom name to show", PlaceholderText = "Custom name", RemoveTextAfterFocusLost = false, Flag = "DisplayName", Callback = function(v) Settings.DisplayName = v end}); countFeature()
PlayerTab:CreateToggle({Name = "[ID] Team Visual Override", CurrentValue = false, Flag = "TeamSpoof", Callback = wrapToggleSetting("TeamSpoofVis")}); countFeature()

-- ═══════════════════════ PROTECTION ═══════════════════════
PlayerTab:CreateSection("Protection Systems")

Toggles.AntiFling = false
Toggles.AntiTeleportOthers = false
Toggles.AntiFreeze = false
Toggles.AntiVoid = false
Toggles.DamageLog = false

PlayerTab:CreateToggle({Name = "[PROT] Anti Fling — Prevent fling exploits", CurrentValue = false, Flag = "AntiFling", Callback = wrapToggleRefresh("AntiFling")}); countFeature()
PlayerTab:CreateSlider({Name = "[PROT] Anti Fling Threshold — Max velocity", Range = {100, 10000}, Increment = 100, CurrentValue = 1000, Flag = "AntiFlingForce", Callback = wrapSetting("AntiFlingForce")}); countFeature()
PlayerTab:CreateToggle({Name = "[PROT] Anti TP Others — Block forced TPs", CurrentValue = false, Flag = "AntiTPOthers", Callback = wrapToggleSetting("AntiTeleportOthers")}); countFeature()
PlayerTab:CreateToggle({Name = "[PROT] Anti Freeze — Prevent character freeze", CurrentValue = false, Flag = "AntiFreeze", Callback = wrapToggleSetting("AntiFreeze")}); countFeature()
PlayerTab:CreateToggle({Name = "[PROT] Anti Void — Recover from falling", CurrentValue = false, Flag = "AntiVoid", Callback = wrapToggleRefresh("AntiVoid")}); countFeature()
PlayerTab:CreateSlider({Name = "[PROT] Void Height — Y threshold", Range = {-1000, 0}, Increment = 10, CurrentValue = -50, Flag = "VoidHeight", Callback = wrapSetting("VoidHeight")}); countFeature()
PlayerTab:CreateInput({Name = "[PROT] Void Height Override", PlaceholderText = "-50", RemoveTextAfterFocusLost = false, Flag = "VoidHeightInput", Callback = function(v) local n = tonumber(v); if n then Settings.VoidHeight = n end end}); countFeature()
PlayerTab:CreateToggle({Name = "[PROT] Damage Log — Track incoming damage", CurrentValue = false, Flag = "DamageLog", Callback = wrapToggleSetting("DamageLog")}); countFeature()
PlayerTab:CreateSlider({Name = "[PROT] Damage Log Max Entries", Range = {10, 200}, Increment = 10, CurrentValue = 50, Flag = "DmgLogMax", Callback = wrapSetting("DamageLogMax")}); countFeature()

-- ═══════════════════════ ANIMATION MODS ═══════════════════════
PlayerTab:CreateSection("Animation Overrides")

Toggles.CustomWalkAnim = false
Toggles.CustomIdleAnim = false
Toggles.CustomEmoteSpeed = false

PlayerTab:CreateToggle({Name = "[ANIM] Custom Walk Animation", CurrentValue = false, Flag = "CustomWalk", Callback = wrapToggleSetting("CustomWalkAnim")}); countFeature()
PlayerTab:CreateInput({Name = "[ANIM] Walk Anim ID — rbxassetid number", PlaceholderText = "Animation ID", RemoveTextAfterFocusLost = false, Flag = "WalkAnimId", Callback = function(v) Settings.WalkAnimId = v end}); countFeature()
PlayerTab:CreateToggle({Name = "[ANIM] Custom Idle Animation", CurrentValue = false, Flag = "CustomIdle", Callback = wrapToggleSetting("CustomIdleAnim")}); countFeature()
PlayerTab:CreateInput({Name = "[ANIM] Idle Anim ID", PlaceholderText = "Animation ID", RemoveTextAfterFocusLost = false, Flag = "IdleAnimId", Callback = function(v) Settings.IdleAnimId = v end}); countFeature()
PlayerTab:CreateToggle({Name = "[ANIM] Custom Emote Speed", CurrentValue = false, Flag = "EmoteSpeedOn", Callback = wrapToggleSetting("CustomEmoteSpeed")}); countFeature()
PlayerTab:CreateSlider({Name = "[ANIM] Emote Speed Multiplier", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "EmoteSpeed", Callback = wrapSetting("EmoteSpeed")}); countFeature()

-- ═══════════════════════ RESPAWN ═══════════════════════
PlayerTab:CreateSection("Respawn Control")

Toggles.RespawnOver = false
Toggles.InstaRespawn = false
Toggles.FakeLag = false
Toggles.FakeAFK = false

PlayerTab:CreateToggle({Name = "[RESP] Respawn Override — Custom respawn behavior", CurrentValue = false, Flag = "RespOver", Callback = wrapToggleSetting("RespawnOver")}); countFeature()
PlayerTab:CreateToggle({Name = "[RESP] Instant Respawn — Skip respawn timer", CurrentValue = false, Flag = "InstaResp", Callback = wrapToggleSetting("InstaRespawn")}); countFeature()
PlayerTab:CreateToggle({Name = "[MISC] Fake Lag — Simulate high ping", CurrentValue = false, Flag = "FakeLag", Callback = wrapToggleSetting("FakeLag")}); countFeature()
PlayerTab:CreateToggle({Name = "[MISC] Fake AFK — Appear idle", CurrentValue = false, Flag = "FakeAFK", Callback = wrapToggleSetting("FakeAFK")}); countFeature()

--[[
===========================================================================
                          TAB 6: WORLD
===========================================================================
]]
local WorldTab = Window:CreateTab("World", "globe")

-- ═══════════════════════ PHYSICS ═══════════════════════
WorldTab:CreateSection("World Physics")

WorldTab:CreateSlider({Name = "[PHYS] Gravity — World gravity force", Range = {0, 2000}, Increment = 10, CurrentValue = 196, Flag = "Gravity", Callback = function(v) Settings.Gravity = v; Workspace.Gravity = v end}); countFeature()
WorldTab:CreateInput({Name = "[PHYS] Gravity Override", PlaceholderText = "196", RemoveTextAfterFocusLost = false, Flag = "GravityInput", Callback = function(v) local n = tonumber(v); if n then Settings.Gravity = n; Workspace.Gravity = n end end}); countFeature()
WorldTab:CreateSlider({Name = "[PHYS] Physics Time Scale — Game speed", Range = {0, 5}, Increment = 0.1, CurrentValue = 1, Flag = "PhysTime", Callback = wrapSetting("PhysTimeScale")}); countFeature()
WorldTab:CreateSlider({Name = "[PHYS] Air Density — Drag resistance", Range = {0, 5}, Increment = 0.1, CurrentValue = 1, Flag = "AirDensity", Callback = wrapSetting("AirDensity")}); countFeature()
WorldTab:CreateSlider({Name = "[PHYS] Elasticity — Bounce factor", Range = {0, 2}, Increment = 0.1, CurrentValue = 0.5, Flag = "Elasticity", Callback = wrapSetting("Elasticity")}); countFeature()

-- ═══════════════════════ PART MODS ═══════════════════════
WorldTab:CreateSection("Part Modifications")

Toggles.RemCol = false
Toggles.BreakParts = false
Toggles.SpawnPlats = false
Toggles.AutoBridge = false
Toggles.DelMap = false
Toggles.ObjFreeze = false
Toggles.ObjHighlight = false
Toggles.RemTex = false
Toggles.AnchorAll = false
Toggles.MassOverride = false
Toggles.TransScanner = false

WorldTab:CreateToggle({Name = "[PART] Remove Collisions — Walk through parts", CurrentValue = false, Flag = "RemCol", Callback = wrapToggleSetting("RemCol")}); countFeature()
WorldTab:CreateToggle({Name = "[PART] Break Parts — Unanchor nearby parts", CurrentValue = false, Flag = "BreakParts", Callback = wrapToggleSetting("BreakParts")}); countFeature()
WorldTab:CreateToggle({Name = "[PART] Spawn Platforms — Create floating platforms", CurrentValue = false, Flag = "SpawnPlats", Callback = wrapToggleSetting("SpawnPlats")}); countFeature()
WorldTab:CreateToggle({Name = "[PART] Auto Bridge — Build path ahead", CurrentValue = false, Flag = "AutoBridge", Callback = wrapToggleSetting("AutoBridge")}); countFeature()
WorldTab:CreateToggle({Name = "[PART] Delete Map — Remove all parts", CurrentValue = false, Flag = "DelMap", Callback = function(v) Toggles.DelMap = v
    if v then
        Notify("Warning", "This will remove visible map parts!", 3)
    end
end}); countFeature()
WorldTab:CreateToggle({Name = "[PART] Freeze Objects — Anchor all parts", CurrentValue = false, Flag = "FreezeObj", Callback = wrapToggleSetting("ObjFreeze")}); countFeature()
WorldTab:CreateToggle({Name = "[PART] Object Highlighting — Highlight interactables", CurrentValue = false, Flag = "ObjHigh", Callback = wrapToggleSetting("ObjHighlight")}); countFeature()
WorldTab:CreateToggle({Name = "[PART] Remove Textures — Strip materials", CurrentValue = false, Flag = "RemTex", Callback = wrapToggleSetting("RemTex")}); countFeature()
WorldTab:CreateToggle({Name = "[PART] Anchor All — Lock everything", CurrentValue = false, Flag = "AnchorAll", Callback = wrapToggleSetting("AnchorAll")}); countFeature()
WorldTab:CreateToggle({Name = "[PART] Mass Override — Set all mass to 0", CurrentValue = false, Flag = "MassOvr", Callback = wrapToggleSetting("MassOverride")}); countFeature()
WorldTab:CreateToggle({Name = "[PART] Transparency Scanner — Find hidden parts", CurrentValue = false, Flag = "TransScan", Callback = wrapToggleSetting("TransScanner")}); countFeature()

-- ═══════════════════════ WATER & TERRAIN ═══════════════════════
WorldTab:CreateSection("Terrain & Water")

Toggles.WaterWalk = false
Toggles.LavaImmune = false
Toggles.TerrainRemove = false
Toggles.TerrainColorOvr = false

WorldTab:CreateToggle({Name = "[WATER] Water Walk — Walk on water surface", CurrentValue = false, Flag = "WaterWalk", Callback = wrapToggleRefresh("WaterWalk")}); countFeature()
WorldTab:CreateSlider({Name = "[WATER] Water Level — Y position of water platform", Range = {-100, 200}, Increment = 5, CurrentValue = 0, Flag = "WaterLevel", Callback = wrapSetting("WaterLevel")}); countFeature()
WorldTab:CreateToggle({Name = "[WATER] Lava Immunity — Ignore lava damage", CurrentValue = false, Flag = "LavaImm", Callback = wrapToggleSetting("LavaImmune")}); countFeature()
WorldTab:CreateToggle({Name = "[TERRAIN] Remove Terrain Decoration", CurrentValue = false, Flag = "TerrainRem", Callback = function(v) Toggles.TerrainRemove = v; pcall(function() sethiddenproperty(Workspace.Terrain, "Decoration", not v) end) end}); countFeature()
WorldTab:CreateToggle({Name = "[TERRAIN] Override Terrain Color", CurrentValue = false, Flag = "TerrainColor", Callback = wrapToggleSetting("TerrainColorOvr")}); countFeature()

-- ═══════════════════════ LIGHTING PRO ═══════════════════════
WorldTab:CreateSection("Advanced Lighting")

WorldTab:CreateSlider({Name = "[LIGHT] Ambient R", Range = {0, 255}, Increment = 5, CurrentValue = 128, Flag = "AmbR", Callback = function(v) Settings.AmbientR = v; pcall(function() Lighting.Ambient = Color3.fromRGB(v, Settings.AmbientG, Settings.AmbientB) end) end}); countFeature()
WorldTab:CreateSlider({Name = "[LIGHT] Ambient G", Range = {0, 255}, Increment = 5, CurrentValue = 128, Flag = "AmbG", Callback = function(v) Settings.AmbientG = v; pcall(function() Lighting.Ambient = Color3.fromRGB(Settings.AmbientR, v, Settings.AmbientB) end) end}); countFeature()
WorldTab:CreateSlider({Name = "[LIGHT] Ambient B", Range = {0, 255}, Increment = 5, CurrentValue = 128, Flag = "AmbB", Callback = function(v) Settings.AmbientB = v; pcall(function() Lighting.Ambient = Color3.fromRGB(Settings.AmbientR, Settings.AmbientG, v) end) end}); countFeature()
WorldTab:CreateSlider({Name = "[LIGHT] Outdoor Ambient R", Range = {0, 255}, Increment = 5, CurrentValue = 128, Flag = "OutAmbR", Callback = function(v) Settings.OutdoorAmbR = v end}); countFeature()
WorldTab:CreateSlider({Name = "[LIGHT] Outdoor Ambient G", Range = {0, 255}, Increment = 5, CurrentValue = 128, Flag = "OutAmbG", Callback = function(v) Settings.OutdoorAmbG = v end}); countFeature()
WorldTab:CreateSlider({Name = "[LIGHT] Outdoor Ambient B", Range = {0, 255}, Increment = 5, CurrentValue = 128, Flag = "OutAmbB", Callback = function(v) Settings.OutdoorAmbB = v end}); countFeature()
WorldTab:CreateSlider({Name = "[LIGHT] Exposure", Range = {-5, 5}, Increment = 0.1, CurrentValue = 0, Flag = "Exposure", Callback = wrapSetting("Exposure")}); countFeature()
WorldTab:CreateSlider({Name = "[LIGHT] Color Temperature", Range = {1000, 10000}, Increment = 100, CurrentValue = 6500, Flag = "ColorTemp", Callback = wrapSetting("ColorTemp")}); countFeature()
WorldTab:CreateSlider({Name = "[LIGHT] Fog Start", Range = {0, 10000}, Increment = 100, CurrentValue = 0, Flag = "FogStart", Callback = function(v) Settings.FogStart = v; Lighting.FogStart = v end}); countFeature()
WorldTab:CreateSlider({Name = "[LIGHT] Fog End", Range = {100, 100000}, Increment = 100, CurrentValue = 100000, Flag = "FogEnd", Callback = function(v) Settings.FogEnd = v; Lighting.FogEnd = v end}); countFeature()

-- ═══════════════════════ SOUND MODS ═══════════════════════
WorldTab:CreateSection("Sound Modifications")

Toggles.MuteSounds = false
Toggles.CustomAmbient = false

WorldTab:CreateSlider({Name = "[SOUND] Global Volume", Range = {0, 10}, Increment = 0.5, CurrentValue = 1, Flag = "GlobalVol", Callback = function(v) Settings.GlobalVolume = v; SoundService.AmbientReverb = Enum.ReverbType.NoReverb end}); countFeature()
WorldTab:CreateToggle({Name = "[SOUND] Mute All Sounds", CurrentValue = false, Flag = "MuteSounds", Callback = wrapToggleSetting("MuteSounds")}); countFeature()
WorldTab:CreateToggle({Name = "[SOUND] Custom Ambient Sound", CurrentValue = false, Flag = "CustomAmbient", Callback = wrapToggleSetting("CustomAmbient")}); countFeature()
WorldTab:CreateInput({Name = "[SOUND] Ambient Sound ID", PlaceholderText = "Sound asset ID", RemoveTextAfterFocusLost = false, Flag = "AmbientSound", Callback = function(v) Settings.AmbientSoundId = v end}); countFeature()

-- ═══════════════════════ WIND ═══════════════════════
WorldTab:CreateSection("Wind & Forces")

WorldTab:CreateSlider({Name = "[WIND] Wind Force X", Range = {-100, 100}, Increment = 5, CurrentValue = 0, Flag = "WindX", Callback = wrapSetting("WindForceX")}); countFeature()
WorldTab:CreateSlider({Name = "[WIND] Wind Force Y", Range = {-100, 100}, Increment = 5, CurrentValue = 0, Flag = "WindY", Callback = wrapSetting("WindForceY")}); countFeature()
WorldTab:CreateSlider({Name = "[WIND] Wind Force Z", Range = {-100, 100}, Increment = 5, CurrentValue = 0, Flag = "WindZ", Callback = wrapSetting("WindForceZ")}); countFeature()

--[[
===========================================================================
                         TAB 7: UTILITY
===========================================================================
]]
local UtilityTab = Window:CreateTab("Utility", "tool")

-- ═══════════════════════ QUALITY OF LIFE ═══════════════════════
UtilityTab:CreateSection("Quality of Life")

Toggles.AntiAFK = false
Toggles.FPSBoost = false
Toggles.LowGFX = false
Toggles.PingDisp = false
Toggles.FPSCounter = false

UtilityTab:CreateToggle({Name = "[QOL] Anti AFK — Prevent idle kick", CurrentValue = true, Flag = "AntiAFK", Callback = wrapToggleRefresh("AntiAFK")}); countFeature()
UtilityTab:CreateToggle({Name = "[QOL] FPS Boost — Disable visual effects", CurrentValue = false, Flag = "FPSBoost", Callback = wrapToggleSetting("FPSBoost")}); countFeature()
UtilityTab:CreateToggle({Name = "[QOL] Low Graphics Mode — Minimum rendering", CurrentValue = false, Flag = "LowGFX", Callback = wrapToggleSetting("LowGFX")}); countFeature()
UtilityTab:CreateToggle({Name = "[QOL] Show Ping — Display latency", CurrentValue = false, Flag = "ShowPing", Callback = wrapToggleSetting("PingDisp")}); countFeature()
UtilityTab:CreateToggle({Name = "[QOL] FPS Counter — Display frame rate", CurrentValue = false, Flag = "FPSCounter", Callback = wrapToggleSetting("FPSCounter")}); countFeature()
UtilityTab:CreateSlider({Name = "[QOL] Notification Duration — Seconds to show", Range = {1, 15}, Increment = 1, CurrentValue = 3, Flag = "NotifDur", Callback = wrapSetting("NotifDuration")}); countFeature()

-- ═══════════════════════ AUTO CLICKER ═══════════════════════
UtilityTab:CreateSection("Auto Clicker & Tools")

Toggles.AutoClicker = false

UtilityTab:CreateToggle({Name = "[CLICK] Auto Clicker — Activate tool repeatedly", CurrentValue = false, Flag = "AutoClicker", Callback = function(v) Toggles.AutoClicker = v; if v then setupAutoClicker() end end}); countFeature()
UtilityTab:CreateSlider({Name = "[CLICK] Click Delay — Seconds between clicks", Range = {0.01, 2}, Increment = 0.01, CurrentValue = 0.1, Flag = "ClickDelay", Callback = wrapSetting("ClickDelay")}); countFeature()
UtilityTab:CreateInput({Name = "[CLICK] Delay Override", PlaceholderText = "0.1", RemoveTextAfterFocusLost = false, Flag = "ClickDelayInput", Callback = function(v) local n = tonumber(v); if n then Settings.ClickDelay = n end end}); countFeature()

-- ═══════════════════════ AUTO FARM ═══════════════════════
UtilityTab:CreateSection("Auto Farm")

Toggles.AutoFarm = false

UtilityTab:CreateToggle({Name = "[FARM] Auto Farm — Collect nearby items", CurrentValue = false, Flag = "AutoFarm", Callback = function(v) Toggles.AutoFarm = v; if v then setupAutoFarm() end end}); countFeature()
UtilityTab:CreateSlider({Name = "[FARM] Collection Range", Range = {10, 2000}, Increment = 10, CurrentValue = 100, Flag = "FarmRange", Callback = wrapSetting("AutoFarmRange")}); countFeature()
UtilityTab:CreateInput({Name = "[FARM] Range Override", PlaceholderText = "100", RemoveTextAfterFocusLost = false, Flag = "FarmRangeInput", Callback = function(v) local n = tonumber(v); if n then Settings.AutoFarmRange = n end end}); countFeature()

-- ═══════════════════════ CHAT SYSTEM ═══════════════════════
UtilityTab:CreateSection("Chat System")

Toggles.AutoChatSpam = false
Toggles.AutoReply = false
Toggles.ChatLogger = false
Toggles.WhisperMode = false

UtilityTab:CreateToggle({Name = "[CHAT] Auto Chat Spam — Send messages on loop", CurrentValue = false, Flag = "AutoSpam", Callback = wrapToggleSetting("AutoChatSpam")}); countFeature()
UtilityTab:CreateInput({Name = "[CHAT] Spam Message", PlaceholderText = "Message to spam", RemoveTextAfterFocusLost = false, Flag = "SpamText", Callback = function(v) Settings.SpamText = v end}); countFeature()
UtilityTab:CreateSlider({Name = "[CHAT] Spam Delay — Seconds between messages", Range = {1, 30}, Increment = 1, CurrentValue = 5, Flag = "SpamDelay", Callback = wrapSetting("SpamDelay")}); countFeature()
UtilityTab:CreateToggle({Name = "[CHAT] Auto Reply — Auto respond to messages", CurrentValue = false, Flag = "AutoReply", Callback = wrapToggleSetting("AutoReply")}); countFeature()
UtilityTab:CreateInput({Name = "[CHAT] Reply Text", PlaceholderText = "Auto reply text", RemoveTextAfterFocusLost = false, Flag = "ReplyText", Callback = function(v) Settings.ReplyText = v end}); countFeature()
UtilityTab:CreateToggle({Name = "[CHAT] Chat Logger — Log all messages", CurrentValue = false, Flag = "ChatLog", Callback = wrapToggleSetting("ChatLogger")}); countFeature()
UtilityTab:CreateToggle({Name = "[CHAT] Whisper Mode — Only show whispers", CurrentValue = false, Flag = "WhisperMode", Callback = wrapToggleSetting("WhisperMode")}); countFeature()

-- ═══════════════════════ SERVER TOOLS ═══════════════════════
UtilityTab:CreateSection("Server Tools")

UtilityTab:CreateButton({Name = "[SERVER] Rejoin Server — Reconnect to same server", Callback = function()
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end}); countFeature()

UtilityTab:CreateButton({Name = "[SERVER] Server Hop — Join different server", Callback = function()
    pcall(function()
        local servers = {}
        local data = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
        for _, v in ipairs(data.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, v.id)
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(#servers)], LocalPlayer)
        else
            Notify("Server Hop", "No available servers", 3)
        end
    end)
end}); countFeature()

UtilityTab:CreateButton({Name = "[SERVER] Show Player List — All players + info", Callback = function()
    local list = ""
    for _, p in ipairs(getPlayers()) do
        list = list .. p.Name .. " (ID: " .. p.UserId .. ")\n"
    end
    Notify("Players (" .. #getPlayers() .. ")", list, 10)
end}); countFeature()

UtilityTab:CreateButton({Name = "[SERVER] Show Game Info", Callback = function()
    Notify("Game Info", "PlaceId: " .. game.PlaceId .. "\nJobId: " .. game.JobId .. "\nPlayers: " .. #getPlayers() .. "/" .. Players.MaxPlayers, 8)
end}); countFeature()

-- ═══════════════════════ CLIPBOARD & MISC ═══════════════════════
UtilityTab:CreateSection("Clipboard & Misc Tools")

UtilityTab:CreateButton({Name = "[CLIP] Copy Position — XYZ to clipboard", Callback = function()
    local hrp = getRoot()
    if hrp then
        local pos = tostring(math.floor(hrp.Position.X)) .. ", " .. tostring(math.floor(hrp.Position.Y)) .. ", " .. tostring(math.floor(hrp.Position.Z))
        pcall(function() setclipboard(pos) end)
        Notify("Copied", pos, 2)
    end
end}); countFeature()

UtilityTab:CreateButton({Name = "[CLIP] Copy CFrame — Full CFrame to clipboard", Callback = function()
    local hrp = getRoot()
    if hrp then
        pcall(function() setclipboard(tostring(hrp.CFrame)) end)
        Notify("Copied", "CFrame copied", 2)
    end
end}); countFeature()

UtilityTab:CreateButton({Name = "[MEM] Memory Cleaner — Force garbage collection", Callback = function()
    pcall(function() collectgarbage("collect") end)
    Notify("Cleaned", "Memory garbage collected", 2)
end}); countFeature()

UtilityTab:CreateSlider({Name = "[MEM] Auto Clean Interval — Seconds", Range = {10, 300}, Increment = 10, CurrentValue = 60, Flag = "MemCleanInt", Callback = wrapSetting("MemCleanInterval")}); countFeature()

UtilityTab:CreateButton({Name = "[INFO] Show Memory Usage", Callback = function()
    local mem = math.floor(collectgarbage("count"))
    Notify("Memory", mem .. " KB used", 3)
end}); countFeature()

UtilityTab:CreateButton({Name = "[INFO] Show Network Stats", Callback = function()
    pcall(function()
        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        Notify("Network", "Ping: " .. math.floor(ping) .. "ms", 3)
    end)
end}); countFeature()

UtilityTab:CreateButton({Name = "[INST] Instance Counter — Count workspace children", Callback = function()
    local count = 0
    pcall(function()
        for _ in ipairs(Workspace:GetDescendants()) do
            count = count + 1
        end
    end)
    Notify("Instances", count .. " objects in Workspace", 3)
end}); countFeature()

--[[
===========================================================================
                       TAB 8: AUTOMATION
===========================================================================
]]
local AutomationTab = Window:CreateTab("Automation", "cpu")

-- ═══════════════════════ SMART FARM ═══════════════════════
AutomationTab:CreateSection("Smart Farm System")

Toggles.AutoFarmPath = false
Toggles.AutoCollect = false
Toggles.AutoInteract = false
Toggles.SmartTarget = false
Toggles.LootFilterOn = false

AutomationTab:CreateToggle({Name = "[FARM] Auto Farm Pathfinding — Navigate to collectibles", CurrentValue = false, Flag = "AutoFarmPath", Callback = wrapToggleSetting("AutoFarmPath")}); countFeature()
AutomationTab:CreateToggle({Name = "[FARM] Auto Collect — Pick up nearby items", CurrentValue = false, Flag = "AutoCollect", Callback = wrapToggleSetting("AutoCollect")}); countFeature()
AutomationTab:CreateToggle({Name = "[FARM] Auto Interact — Press prompts automatically", CurrentValue = false, Flag = "AutoInteract", Callback = wrapToggleSetting("AutoInteract")}); countFeature()
AutomationTab:CreateToggle({Name = "[FARM] Smart Targeting — Prioritize valuable targets", CurrentValue = false, Flag = "SmartTarget", Callback = wrapToggleSetting("SmartTarget")}); countFeature()
AutomationTab:CreateSlider({Name = "[FARM] Detection Radius", Range = {10, 2000}, Increment = 10, CurrentValue = 50, Flag = "EnemyRad", Callback = wrapSetting("EnemyDetRad")}); countFeature()
AutomationTab:CreateInput({Name = "[FARM] Detection Radius Override", PlaceholderText = "50", RemoveTextAfterFocusLost = false, Flag = "EnemyRadInput", Callback = function(v) local n = tonumber(v); if n then Settings.EnemyDetRad = n end end}); countFeature()
AutomationTab:CreateDropdown({Name = "[FARM] Farm Priority — Target selection mode", Options = {"Nearest", "Farthest", "Highest Value", "Lowest HP", "Random"}, CurrentOption = {"Nearest"}, Flag = "FarmPriority", Callback = function(v) Settings.FarmPriority = v end}); countFeature()
AutomationTab:CreateToggle({Name = "[FARM] Loot Filter — Only collect specific items", CurrentValue = false, Flag = "LootFilter", Callback = wrapToggleSetting("LootFilterOn")}); countFeature()
AutomationTab:CreateDropdown({Name = "[FARM] Loot Filter Mode", Options = {"All", "Coins Only", "Gems Only", "Weapons Only", "Custom"}, CurrentOption = {"All"}, Flag = "LootFilterMode", Callback = function(v) Settings.LootFilter = v end}); countFeature()

-- ═══════════════════════ AUTO COMBAT ═══════════════════════
AutomationTab:CreateSection("Auto Combat")

Toggles.AutoAttack = false
Toggles.SkillRotation = false
Toggles.PositioningAI = false
Toggles.AutoDodge = false

AutomationTab:CreateToggle({Name = "[COMBAT] Auto Attack — Attack nearest enemy", CurrentValue = false, Flag = "AutoAttack", Callback = wrapToggleSetting("AutoAttack")}); countFeature()
AutomationTab:CreateDropdown({Name = "[COMBAT] Attack Pattern", Options = {"Single", "AoE", "Burst", "Sustained"}, CurrentOption = {"Single"}, Flag = "AttackPattern", Callback = function(v) Settings.AttackPattern = v end}); countFeature()
AutomationTab:CreateToggle({Name = "[COMBAT] Skill Rotation — Use abilities in order", CurrentValue = false, Flag = "SkillRot", Callback = wrapToggleSetting("SkillRotation")}); countFeature()
AutomationTab:CreateSlider({Name = "[COMBAT] Skill Delay — Seconds between skills", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 0.5, Flag = "SkillDelay", Callback = wrapSetting("SkillDelay")}); countFeature()
AutomationTab:CreateToggle({Name = "[COMBAT] Positioning AI — Stay at optimal range", CurrentValue = false, Flag = "PosAI", Callback = wrapToggleSetting("PositioningAI")}); countFeature()
AutomationTab:CreateSlider({Name = "[COMBAT] Position Update Rate", Range = {0.05, 1}, Increment = 0.05, CurrentValue = 0.1, Flag = "PosRate", Callback = wrapSetting("PositionUpdateRate")}); countFeature()
AutomationTab:CreateToggle({Name = "[COMBAT] Auto Dodge — Evade incoming attacks", CurrentValue = false, Flag = "AutoDodge", Callback = wrapToggleSetting("AutoDodge")}); countFeature()

-- ═══════════════════════ ECONOMY ═══════════════════════
AutomationTab:CreateSection("Economy Automation")

Toggles.AutoSell = false
Toggles.AutoQuest = false
Toggles.AutoUpgrade = false
Toggles.AutoEquip = false
Toggles.AutoTrade = false
Toggles.InventoryManager = false

AutomationTab:CreateToggle({Name = "[ECON] Auto Sell — Sell items at sell point", CurrentValue = false, Flag = "AutoSell", Callback = wrapToggleSetting("AutoSell")}); countFeature()
AutomationTab:CreateToggle({Name = "[ECON] Auto Quest — Accept and complete quests", CurrentValue = false, Flag = "AutoQuest", Callback = wrapToggleSetting("AutoQuest")}); countFeature()
AutomationTab:CreateToggle({Name = "[ECON] Auto Upgrade — Upgrade equipment", CurrentValue = false, Flag = "AutoUpgrade", Callback = wrapToggleSetting("AutoUpgrade")}); countFeature()
AutomationTab:CreateToggle({Name = "[ECON] Auto Equip Best — Equip strongest items", CurrentValue = false, Flag = "AutoEquip", Callback = wrapToggleSetting("AutoEquip")}); countFeature()
AutomationTab:CreateToggle({Name = "[ECON] Auto Trade — Accept profitable trades", CurrentValue = false, Flag = "AutoTrade", Callback = wrapToggleSetting("AutoTrade")}); countFeature()
AutomationTab:CreateSlider({Name = "[ECON] Trade Min Value — Minimum value to accept", Range = {0, 10000}, Increment = 100, CurrentValue = 0, Flag = "TradeMinVal", Callback = wrapSetting("TradeMinValue")}); countFeature()
AutomationTab:CreateToggle({Name = "[ECON] Inventory Manager — Auto-organize items", CurrentValue = false, Flag = "InvManager", Callback = wrapToggleSetting("InventoryManager")}); countFeature()

-- ═══════════════════════ SOCIAL ═══════════════════════
AutomationTab:CreateSection("Social Automation")

Toggles.AutoFriend = false
Toggles.AutoParty = false
Toggles.AutoFollowSocial = false
Toggles.AIMovement = false

AutomationTab:CreateToggle({Name = "[SOCIAL] Auto Friend — Send friend requests", CurrentValue = false, Flag = "AutoFriend", Callback = wrapToggleSetting("AutoFriend")}); countFeature()
AutomationTab:CreateToggle({Name = "[SOCIAL] Auto Party — Join/create party", CurrentValue = false, Flag = "AutoParty", Callback = wrapToggleSetting("AutoParty")}); countFeature()
AutomationTab:CreateToggle({Name = "[SOCIAL] Auto Follow — Follow nearest player", CurrentValue = false, Flag = "AutoFollowSoc", Callback = wrapToggleSetting("AutoFollowSocial")}); countFeature()
AutomationTab:CreateToggle({Name = "[SOCIAL] AI Movement — Smart pathing behavior", CurrentValue = false, Flag = "AIMove", Callback = wrapToggleSetting("AIMovement")}); countFeature()

--[[
===========================================================================
                     TAB 9: EXPERIMENTAL
===========================================================================
]]
local ExperimentalTab = Window:CreateTab("Experimental", "flask-conical")

-- ═══════════════════════ PHYSICS OVERRIDE ═══════════════════════
ExperimentalTab:CreateSection("Physics Overrides")

Toggles.ZeroGravity = false
Toggles.ReverseGravity = false
Toggles.StickyMode = false
Toggles.MoonGravity = false
Toggles.CustomGravAxis = false

ExperimentalTab:CreateToggle({Name = "[PHYS] Zero Gravity — Weightless mode", CurrentValue = false, Flag = "ZeroG", Callback = function(v) Toggles.ZeroGravity = v; if v then Workspace.Gravity = 0 else Workspace.Gravity = Settings.Gravity end end}); countFeature()
ExperimentalTab:CreateToggle({Name = "[PHYS] Reverse Gravity — Fall upward", CurrentValue = false, Flag = "ReverseG", Callback = function(v) Toggles.ReverseGravity = v; if v then Workspace.Gravity = -196 else Workspace.Gravity = Settings.Gravity end end}); countFeature()
ExperimentalTab:CreateToggle({Name = "[PHYS] Sticky Mode — Walk on ceilings", CurrentValue = false, Flag = "StickyMode", Callback = wrapToggleSetting("StickyMode")}); countFeature()
ExperimentalTab:CreateToggle({Name = "[PHYS] Moon Gravity — Low gravity", CurrentValue = false, Flag = "MoonG", Callback = function(v) Toggles.MoonGravity = v; if v then Workspace.Gravity = 30 else Workspace.Gravity = Settings.Gravity end end}); countFeature()
ExperimentalTab:CreateToggle({Name = "[PHYS] Per-Axis Gravity — Custom XYZ gravity", CurrentValue = false, Flag = "CustomGravAxis", Callback = wrapToggleSetting("CustomGravAxis")}); countFeature()
ExperimentalTab:CreateSlider({Name = "[PHYS] Gravity X Axis", Range = {-200, 200}, Increment = 10, CurrentValue = 0, Flag = "GravX", Callback = wrapSetting("GravityX")}); countFeature()
ExperimentalTab:CreateSlider({Name = "[PHYS] Gravity Y Axis", Range = {-500, 500}, Increment = 10, CurrentValue = -196, Flag = "GravY", Callback = wrapSetting("GravityY")}); countFeature()
ExperimentalTab:CreateSlider({Name = "[PHYS] Gravity Z Axis", Range = {-200, 200}, Increment = 10, CurrentValue = 0, Flag = "GravZ", Callback = wrapSetting("GravityZ")}); countFeature()

-- ═══════════════════════ NETWORK ═══════════════════════
ExperimentalTab:CreateSection("Network Experiments")

Toggles.LagSwitch = false
Toggles.PacketDisplay = false
Toggles.NetworkThrottle = false

ExperimentalTab:CreateToggle({Name = "[NET] Lag Switch — Simulate high latency (local only)", CurrentValue = false, Flag = "LagSwitch", Callback = wrapToggleSetting("LagSwitch")}); countFeature()
ExperimentalTab:CreateSlider({Name = "[NET] Lag Duration — Seconds of simulated lag", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 1, Flag = "LagDur", Callback = wrapSetting("LagSwitchDuration")}); countFeature()
ExperimentalTab:CreateToggle({Name = "[NET] Packet Display — Show network activity", CurrentValue = false, Flag = "PacketDisp", Callback = wrapToggleSetting("PacketDisplay")}); countFeature()
ExperimentalTab:CreateToggle({Name = "[NET] Network Throttle — Limit outgoing data", CurrentValue = false, Flag = "NetThrottle", Callback = wrapToggleSetting("NetworkThrottle")}); countFeature()

-- ═══════════════════════ CHARACTER EXPERIMENTS ═══════════════════════
ExperimentalTab:CreateSection("Character Experiments")

Toggles.GhostMode = false
Toggles.TimeFreeze = false
Toggles.SpeedManipulation = false
Toggles.CloneCharacter = false
Toggles.RagdollSelf = false
Toggles.TinyMode = false
Toggles.GiantMode = false
Toggles.SpinMode = false
Toggles.HeadlessMode = false

ExperimentalTab:CreateToggle({Name = "[CHAR] Ghost Mode — Semi-transparent + noclip", CurrentValue = false, Flag = "GhostMode", Callback = function(v)
    Toggles.GhostMode = v
    local char = getChar()
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = v and 0.7 or 0
                part.CanCollide = not v
            end
        end
    end
end}); countFeature()

ExperimentalTab:CreateToggle({Name = "[CHAR] Time Freeze (Local) — Freeze local character", CurrentValue = false, Flag = "TimeFreeze", Callback = function(v)
    Toggles.TimeFreeze = v
    local hrp = getRoot()
    if hrp then
        hrp.Anchored = v
    end
end}); countFeature()

ExperimentalTab:CreateToggle({Name = "[CHAR] Speed Manipulation — Fast/slow motion", CurrentValue = false, Flag = "SpeedManip", Callback = wrapToggleSetting("SpeedManipulation")}); countFeature()
ExperimentalTab:CreateToggle({Name = "[CHAR] Clone Character — Duplicate your avatar", CurrentValue = false, Flag = "CloneChar", Callback = function(v)
    Toggles.CloneCharacter = v
    if v then
        local char = getChar()
        if char then
            pcall(function()
                local clone = char:Clone()
                clone.Name = "CX_Clone"
                for _, part in ipairs(clone:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                local hum = clone:FindFirstChildOfClass("Humanoid")
                if hum then hum:Destroy() end
                clone.Parent = Workspace
            end)
        end
    else
        pcall(function()
            local clone = Workspace:FindFirstChild("CX_Clone")
            if clone then clone:Destroy() end
        end)
    end
end}); countFeature()

ExperimentalTab:CreateToggle({Name = "[CHAR] Ragdoll Self — Go limp", CurrentValue = false, Flag = "RagdollSelf", Callback = function(v)
    Toggles.RagdollSelf = v
    local hum = getHum()
    if hum then
        hum.PlatformStand = v
    end
end}); countFeature()

ExperimentalTab:CreateToggle({Name = "[CHAR] Tiny Mode — Shrink character", CurrentValue = false, Flag = "TinyMode", Callback = function(v)
    Toggles.TinyMode = v
    local char = getChar()
    if char then
        pcall(function()
            local hd = char:FindFirstChild("Humanoid") and char.Humanoid
            if hd then
                local bodyScale = hd:FindFirstChild("BodyHeightScale")
                if bodyScale then bodyScale.Value = v and 0.3 or 1 end
                local bodyWidth = hd:FindFirstChild("BodyWidthScale")
                if bodyWidth then bodyWidth.Value = v and 0.3 or 1 end
                local bodyDepth = hd:FindFirstChild("BodyDepthScale")
                if bodyDepth then bodyDepth.Value = v and 0.3 or 1 end
                local headScale = hd:FindFirstChild("HeadScale")
                if headScale then headScale.Value = v and 0.3 or 1 end
            end
        end)
    end
end}); countFeature()

ExperimentalTab:CreateToggle({Name = "[CHAR] Giant Mode — Enlarge character", CurrentValue = false, Flag = "GiantMode", Callback = function(v)
    Toggles.GiantMode = v
    local char = getChar()
    if char then
        pcall(function()
            local hd = char:FindFirstChild("Humanoid") and char.Humanoid
            if hd then
                local bodyScale = hd:FindFirstChild("BodyHeightScale")
                if bodyScale then bodyScale.Value = v and 5 or 1 end
                local bodyWidth = hd:FindFirstChild("BodyWidthScale")
                if bodyWidth then bodyWidth.Value = v and 5 or 1 end
                local bodyDepth = hd:FindFirstChild("BodyDepthScale")
                if bodyDepth then bodyDepth.Value = v and 5 or 1 end
                local headScale = hd:FindFirstChild("HeadScale")
                if headScale then headScale.Value = v and 3 or 1 end
            end
        end)
    end
end}); countFeature()

ExperimentalTab:CreateToggle({Name = "[CHAR] Spin Mode — Constant rotation", CurrentValue = false, Flag = "SpinMode", Callback = wrapToggleSetting("SpinMode")}); countFeature()
ExperimentalTab:CreateToggle({Name = "[CHAR] Headless Mode — Remove head visually", CurrentValue = false, Flag = "HeadlessMode", Callback = function(v)
    Toggles.HeadlessMode = v
    local head = getHead()
    if head then
        head.Transparency = v and 1 or 0
        local face = head:FindFirstChild("face") or head:FindFirstChildOfClass("Decal")
        if face then face.Transparency = v and 1 or 0 end
    end
end}); countFeature()

-- ═══════════════════════ RENDER EXPERIMENTS ═══════════════════════
ExperimentalTab:CreateSection("Render Experiments")

Toggles.MatrixMode = false
Toggles.NegativeColors = false
Toggles.DesatMode = false
Toggles.HighContrast = false
Toggles.NeonMode = false
Toggles.FlatShading = false

ExperimentalTab:CreateToggle({Name = "[RENDER] Matrix Mode — Green-tinted world", CurrentValue = false, Flag = "MatrixMode", Callback = function(v)
    Toggles.MatrixMode = v
    pcall(function()
        local cc = Lighting:FindFirstChild("CX_ColorCorrection")
        if not cc then
            cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "CX_ColorCorrection"
            cc.Parent = Lighting
        end
        if v then
            cc.TintColor = Color3.fromRGB(0, 255, 0)
            cc.Saturation = -0.8
            cc.Enabled = true
        else
            cc.Enabled = false
        end
    end)
end}); countFeature()

ExperimentalTab:CreateToggle({Name = "[RENDER] Negative Colors — Invert all colors", CurrentValue = false, Flag = "NegativeColors", Callback = function(v)
    Toggles.NegativeColors = v
    pcall(function()
        local cc = Lighting:FindFirstChild("CX_Negative") or Instance.new("ColorCorrectionEffect")
        cc.Name = "CX_Negative"
        cc.Parent = Lighting
        cc.TintColor = v and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 255, 255)
        cc.Contrast = v and -2 or 0
        cc.Enabled = v
    end)
end}); countFeature()

ExperimentalTab:CreateToggle({Name = "[RENDER] Desaturated — Black and white mode", CurrentValue = false, Flag = "DesatMode", Callback = function(v)
    Toggles.DesatMode = v
    pcall(function()
        local cc = Lighting:FindFirstChild("CX_Desat") or Instance.new("ColorCorrectionEffect")
        cc.Name = "CX_Desat"
        cc.Parent = Lighting
        cc.Saturation = v and -1 or 0
        cc.Enabled = v
    end)
end}); countFeature()

ExperimentalTab:CreateToggle({Name = "[RENDER] High Contrast — Enhanced contrast", CurrentValue = false, Flag = "HighContrast", Callback = function(v)
    Toggles.HighContrast = v
    pcall(function()
        local cc = Lighting:FindFirstChild("CX_HiContrast") or Instance.new("ColorCorrectionEffect")
        cc.Name = "CX_HiContrast"
        cc.Parent = Lighting
        cc.Contrast = v and 1.5 or 0
        cc.Enabled = v
    end)
end}); countFeature()

ExperimentalTab:CreateToggle({Name = "[RENDER] Neon Mode — Glow everything", CurrentValue = false, Flag = "NeonMode", Callback = function(v)
    Toggles.NeonMode = v
    pcall(function()
        local bloom = Lighting:FindFirstChild("CX_Bloom") or Instance.new("BloomEffect")
        bloom.Name = "CX_Bloom"
        bloom.Parent = Lighting
        bloom.Intensity = v and 3 or 0
        bloom.Size = v and 56 or 24
        bloom.Threshold = v and 0.1 or 0.95
        bloom.Enabled = v
    end)
end}); countFeature()

ExperimentalTab:CreateToggle({Name = "[RENDER] Flat Shading — Remove lighting detail", CurrentValue = false, Flag = "FlatShading", Callback = function(v)
    Toggles.FlatShading = v
    pcall(function()
        Lighting.GlobalShadows = not v
        Lighting.Brightness = v and 5 or 1
    end)
end}); countFeature()

-- ═══════════════════════ MISC EXPERIMENTAL ═══════════════════════
ExperimentalTab:CreateSection("Miscellaneous")

Toggles.ScreenShake = false
Toggles.DrunkMode = false
Toggles.EarthquakeMode = false
Toggles.MirrorMode = false

ExperimentalTab:CreateToggle({Name = "[MISC] Screen Shake — Camera vibration", CurrentValue = false, Flag = "ScreenShake", Callback = wrapToggleSetting("ScreenShake")}); countFeature()
ExperimentalTab:CreateToggle({Name = "[MISC] Drunk Mode — Wobbly camera", CurrentValue = false, Flag = "DrunkMode", Callback = wrapToggleSetting("DrunkMode")}); countFeature()
ExperimentalTab:CreateToggle({Name = "[MISC] Earthquake Mode — Ground shake simulation", CurrentValue = false, Flag = "EarthquakeMode", Callback = wrapToggleSetting("EarthquakeMode")}); countFeature()
ExperimentalTab:CreateToggle({Name = "[MISC] Mirror Mode — Invert controls", CurrentValue = false, Flag = "MirrorMode", Callback = wrapToggleSetting("MirrorMode")}); countFeature()

ExperimentalTab:CreateButton({Name = "[MISC] Reset All Settings — Restore defaults", Callback = function()
    for k in pairs(Toggles) do
        Toggles[k] = false
    end
    Settings.WalkSpeed = 16
    Settings.JumpPower = 50
    Settings.FlySpeed = 50
    Settings.Gravity = 196
    Workspace.Gravity = 196
    refreshAllFeatures()
    Notify("Reset", "All settings restored to defaults", 3)
end}); countFeature()

ExperimentalTab:CreateButton({Name = "[MISC] Destroy Script — Clean shutdown", Callback = function()
    cleanupAll()
    for player in pairs(ESPCache) do
        removeESP(player)
    end
    if FlyBody then
        pcall(function() FlyBody.bv:Destroy() end)
        pcall(function() FlyBody.bg:Destroy() end)
        FlyBody = nil
    end
    if FreecamBody then
        Camera.CameraType = Enum.CameraType.Custom
        FreecamBody = nil
    end
    -- Clean up experiment effects
    pcall(function()
        for _, v in ipairs(Lighting:GetChildren()) do
            if v.Name:sub(1, 3) == "CX_" then v:Destroy() end
        end
    end)
    pcall(function()
        local ww = Workspace:FindFirstChild("CX_WaterWalk")
        if ww then ww:Destroy() end
    end)
    pcall(function()
        local clone = Workspace:FindFirstChild("CX_Clone")
        if clone then clone:Destroy() end
    end)
    Rayfield:Destroy()
    Notify("CypherX", "Script destroyed. Goodbye!", 3)
end}); countFeature()

--[[
===========================================================================
                       DRAWING SETUP
===========================================================================
]]
if Drawing then
    pcall(function()
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Visible = false
        FOVCircle.Thickness = 2
        FOVCircle.Color = Color3.fromRGB(255, 255, 255)
        FOVCircle.Filled = false
        FOVCircle.Transparency = 1
    end)
end

--[[
===========================================================================
                     MAIN RENDER LOOP
===========================================================================
]]
RunService.RenderStepped:Connect(function()
    -- FOV Circle
    if FOVCircle then
        FOVCircle.Visible = Toggles.DrawFOV or false
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Radius = Settings.AimbotFOV or 100
    end

    -- ESP adornee updates
    for player, esp in pairs(ESPCache) do
        if esp.highlight and player.Character then
            esp.highlight.Adornee = player.Character
        end
        if esp.billboard and player.Character then
            esp.billboard.Adornee = player.Character
        end
    end

    -- Rainbow ESP
    if Toggles.RainbowESP then
        local hue = tick() % 5 / 5
        local color = Color3.fromHSV(hue, 1, 1)
        for _, esp in pairs(ESPCache) do
            if esp.highlight then
                esp.highlight.FillColor = color
                esp.highlight.OutlineColor = color
            end
        end
    end

    -- Spin mode
    if Toggles.SpinMode then
        local hrp = getRoot()
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0)
        end
    end

    -- Moon Jump (hold space = rise)
    if Toggles.MoonJump then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            local hrp = getRoot()
            if hrp then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, Settings.MoonJumpForce or 100, hrp.Velocity.Z)
            end
        end
    end

    -- Screen shake effect
    if Toggles.ScreenShake then
        local offset = CFrame.new(
            math.random(-10, 10) / 100,
            math.random(-10, 10) / 100,
            math.random(-10, 10) / 100
        )
        Camera.CFrame = Camera.CFrame * offset
    end

    -- Drunk mode
    if Toggles.DrunkMode then
        local sway = CFrame.Angles(
            math.sin(tick() * 2) * 0.02,
            math.cos(tick() * 1.5) * 0.02,
            math.sin(tick() * 3) * 0.01
        )
        Camera.CFrame = Camera.CFrame * sway
    end
end)

-- Heartbeat loop for less frequent operations
local lastAutoCleanTime = 0
RunService.Heartbeat:Connect(function()
    local now = tick()

    -- Auto memory clean
    if (now - lastAutoCleanTime) >= (Settings.MemCleanInterval or 60) then
        pcall(function() collectgarbage("collect") end)
        lastAutoCleanTime = now
    end

    -- Chat spam
    if Toggles.AutoChatSpam and Settings.SpamText ~= "" then
        pcall(function()
            local channels = game:GetService("TextChatService"):FindFirstChild("TextChannels")
            if channels then
                local general = channels:FindFirstChild("RBXGeneral")
                if general then
                    general:SendAsync(Settings.SpamText)
                end
            end
        end)
        task.wait(Settings.SpamDelay or 5)
    end

    -- Per-axis gravity
    if Toggles.CustomGravAxis then
        local hrp = getRoot()
        if hrp then
            local gx = Settings.GravityX or 0
            local gz = Settings.GravityZ or 0
            if gx ~= 0 or gz ~= 0 then
                hrp.Velocity = hrp.Velocity + Vector3.new(gx * 0.01, 0, gz * 0.01)
            end
        end
    end
end)

--[[
===========================================================================
                   CHARACTER RESPAWN HANDLER
===========================================================================
]]
LocalPlayer.CharacterAdded:Connect(function(char)
    -- Wait for character to fully load
    local hum = char:WaitForChild("Humanoid", 10)
    local hrp = char:WaitForChild("HumanoidRootPart", 10)
    if not hum or not hrp then return end

    -- Small delay for stability
    task.wait(0.5)

    -- Clear fly body reference (old character)
    FlyBody = nil
    FreecamBody = nil

    -- Rebind all active features
    task.spawn(function()
        refreshAllFeatures()
    end)
end)

--[[
===========================================================================
                     PLAYER CLEANUP HANDLER
===========================================================================
]]
Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

--[[
===========================================================================
                       INITIALIZATION
===========================================================================
]]

-- Initialize all features
refreshAllFeatures()

-- Load saved configuration
pcall(function()
    Rayfield:LoadConfiguration()
end)

-- Feature count
Notify("CypherX Hub V4", FC .. " Features Loaded Successfully!", 5)

-- Teleport cleanup
LocalPlayer.OnTeleport:Connect(function()
    cleanupAll()
    for player in pairs(ESPCache) do
        removeESP(player)
    end
    if FlyBody then
        pcall(function() FlyBody.bv:Destroy() end)
        pcall(function() FlyBody.bg:Destroy() end)
        FlyBody = nil
    end
    if FreecamBody then
        Camera.CameraType = Enum.CameraType.Custom
        FreecamBody = nil
    end
    pcall(function()
        for _, v in ipairs(Lighting:GetChildren()) do
            if v.Name:sub(1, 3) == "CX_" then v:Destroy() end
        end
    end)
    pcall(function()
        local ww = Workspace:FindFirstChild("CX_WaterWalk")
        if ww then ww:Destroy() end
    end)
end)
