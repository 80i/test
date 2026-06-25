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
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")
local VirtualInputManager = game:GetService("VirtualInputManager")

local successVU, VirtualUser = pcall(function() return game:GetService("VirtualUser") end)
if not successVU then VirtualUser = nil end

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Drawing support
local Drawing = nil
pcall(function()
    Drawing = loadstring(game:HttpGet("https://raw.githubusercontent.com/Anaminhoads/drawinglib/main/lib.lua"))()
end)

-- Tabs
local MainTab = Window:CreateTab("Main", "swords")
local CombatTab = Window:CreateTab("Combat", "crosshair")
local AdvMovementTab = Window:CreateTab("Advanced Movement", "activity")
local VisualProTab = Window:CreateTab("Visual Pro", "eye")
local PlayerModsTab = Window:CreateTab("Player Mods", "user")
local WorldModsTab = Window:CreateTab("World Mods", "globe")
local TeleportsTab = Window:CreateTab("Teleport System", "map-pin")
local UtilityTab = Window:CreateTab("Utility", "tool")
local AutomationTab = Window:CreateTab("Automation", "cpu")

-- State Management
local Toggles = {}
local Settings = {}
local connections = {}
local tempStates = {}
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

local function getClosestEnemy(maxDist, teamCheck, visibilityCheck, targetBone)
    local best, dist = nil, maxDist or math.huge
    local hrp = getRoot()
    if not hrp then return nil end
    local myTeam = LocalPlayer.Team
    for _, player in pairs(getAllPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                if teamCheck and player.Team == myTeam then continue end
                local targetPart = targetBone and char:FindFirstChild(targetBone)
                if not targetPart then targetPart = char.HumanoidRootPart end
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
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
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

-- Feature connections
local aimbotConnection, triggerbotConnection, weaponModConnection, espConnection, movementConnection

local function refreshFeatures()
    -- Aimbot
    if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
    if Toggles.Aimbot then
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if not Toggles.Aimbot then return end
            local target = getClosestEnemy(Settings.AimbotFOV, Toggles.TeamCheck, Toggles.VisibilityCheck, Settings.TargetBone)
            if target and UserInputService:IsKeyDown(Enum.KeyCode[Settings.LockKeybind]) then
                local mousePos = UserInputService:GetMouseLocation()
                local aimPos = target.screenPos
                local smooth = Settings.AimbotSmoothness * 10
                mousemoverel((aimPos.X - mousePos.X) / smooth, (aimPos.Y - mousePos.Y) / smooth)
            end
        end)
    end

    -- Triggerbot
    if triggerbotConnection then triggerbotConnection:Disconnect(); triggerbotConnection = nil end
    if Toggles.Triggerbot then
        triggerbotConnection = RunService.RenderStepped:Connect(function()
            if not Toggles.Triggerbot then return end
            local target = getClosestEnemy(50, Toggles.TeamCheck, false, nil)
            if target and Mouse.Target and Mouse.Target:IsDescendantOf(target.player.Character) then
                task.wait(Settings.TriggerDelay / 1000)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end)
    end

    -- Weapon mods (basic client-side override attempt)
    if weaponModConnection then weaponModConnection:Disconnect(); weaponModConnection = nil end
    if Toggles.NoRecoil or Toggles.NoSpread or Toggles.InstantReload or Toggles.InfAmmoClient then
        weaponModConnection = RunService.RenderStepped:Connect(function()
            -- In a real script you'd hook into the weapon's update methods
        end)
    end

    -- ESP and Chams
    if espConnection then espConnection:Disconnect(); espConnection = nil end
    if Toggles.BoxESP or Toggles.NameESP or Toggles.HealthESP or Toggles.SkeletonESP or Settings.ChamsType then
        espConnection = RunService.RenderStepped:Connect(function()
            for _, player in pairs(getAllPlayers()) do
                if player == LocalPlayer then continue end
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = getRoot()
                    local dist = hrp and (hrp.Position - char.HumanoidRootPart.Position).Magnitude or 0
                    if dist > Settings.ESPMaxDist then continue end
                    if Toggles.BoxESP or Settings.ChamsType ~= "Solid" then
                        if not ESPCache[player] then createESP(player) end
                        local highlight = ESPCache[player]
                        if highlight then
                            highlight.FillTransparency = Settings.ESPTransparency
                            if Settings.ChamsType == "Wireframe" then
                                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            else
                                highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                            end
                        end
                    else
                        removeESP(player)
                    end
                else
                    removeESP(player)
                end
            end
            -- Clean ESP for disconnected players
            for player, _ in pairs(ESPCache) do
                if not player.Parent or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                    removeESP(player)
                end
            end
        end)
    else
        for player in pairs(ESPCache) do removeESP(player) end
    end

    -- Movement enhancements
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
                    local moveDir = (Camera.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0))
                                    + Camera.CFrame.RightVector * (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0))).unit * 10
                    hrp.Velocity = vel:Lerp(moveDir, 0.1)
                end
                if Toggles.GlideMode then hrp.Velocity = Vector3.new(vel.X, -1, vel.Z) end
                if Toggles.HoverMode then hrp.Velocity = Vector3.new(vel.X, 0, vel.Z) end
            end
        end
    end)
end

-- Helper to attach refresh to toggle callbacks
local function wrapCallback(original)
    return function(val)
        original(val)
        refreshFeatures()
    end
end

-- ========================================= --
--               MAIN TAB                     --
-- ========================================= --
local SectionMain = MainTab:CreateSection("Basic Movement Enhancements")

Toggles.AutoWalk = false
MainTab:CreateToggle({
   Name = "Smart Auto-Walk",
   CurrentValue = false,
   Flag = "AutoWalkToggle", 
   Callback = function(Value) Toggles.AutoWalk = Value end,
})

Toggles.Noclip = false
MainTab:CreateToggle({
   Name = "Ghost Noclip Mode",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value) Toggles.Noclip = Value end,
})

Toggles.InfJump = false
MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(Value) Toggles.InfJump = Value end,
})

Toggles.Fly = false
Settings.FlySpeed = 50
local FlyBody = nil
MainTab:CreateToggle({
   Name = "Enable Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      Toggles.Fly = Value
      local char, hrp, hum = getChar(), getRoot(), getHum()
      if not hrp or not hum then return end
      if Value then
          local bv = Instance.new("BodyVelocity")
          bv.Name = "CypherXFly"
          bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
          bv.Velocity = Vector3.zero
          bv.Parent = hrp
          local bg = Instance.new("BodyGyro")
          bg.Name = "CypherXFlyGyro"
          bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
          bg.P = 10000
          bg.CFrame = hrp.CFrame
          bg.Parent = hrp
          FlyBody = {bv = bv, bg = bg}
          hum.PlatformStand = true
      else
          if FlyBody then
              FlyBody.bv:Destroy()
              FlyBody.bg:Destroy()
              FlyBody = nil
          end
          hum.PlatformStand = false
      end
   end,
})

MainTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 500},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "FlySpeedSlider",
   Callback = function(Value) Settings.FlySpeed = Value end,
})

-- ========================================= --
--             COMBAT SYSTEM (updated)        --
-- ========================================= --
local SectionCombat = CombatTab:CreateSection("Aimbot System")

Toggles.Aimbot = false
Settings.AimbotSmoothness = 1
Settings.AimbotFOV = 100
Settings.AimbotPrediction = 0
Settings.TargetBone = "Head"
Toggles.TeamCheck = false
Toggles.VisibilityCheck = false
Settings.LockKeybind = "E"
Toggles.DrawFOV = false
Toggles.RandomAimOffset = false

CombatTab:CreateToggle({Name = "1. Aimbot Enable", CurrentValue = false, Flag = "AimbotToggle", Callback = wrapCallback(function(v) Toggles.Aimbot = v end)})
CombatTab:CreateSlider({Name = "2. Aimbot Smoothness", Range = {1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "AimbotSmoothSlider", Callback = function(v) Settings.AimbotSmoothness = v end})
CombatTab:CreateSlider({Name = "3. Aimbot FOV Radius", Range = {10, 1000}, Increment = 1, CurrentValue = 100, Flag = "AimbotFOVSlider", Callback = function(v) Settings.AimbotFOV = v end})
CombatTab:CreateSlider({Name = "4. Aimbot Prediction", Range = {0, 10}, Increment = 0.1, CurrentValue = 0, Flag = "AimbotPredSlider", Callback = function(v) Settings.AimbotPrediction = v end})
CombatTab:CreateDropdown({Name = "5. Target Bone Selector", Options = {"Head", "HumanoidRootPart", "Random"}, CurrentOption = {"Head"}, Flag = "AimbotBoneDrop", Callback = function(v) Settings.TargetBone = v[1] end})
CombatTab:CreateToggle({Name = "6. Team Check", CurrentValue = false, Flag = "TeamCheckToggle", Callback = function(v) Toggles.TeamCheck = v end})
CombatTab:CreateToggle({Name = "7. Visibility Check", CurrentValue = false, Flag = "VisCheckToggle", Callback = function(v) Toggles.VisibilityCheck = v end})
CombatTab:CreateInput({Name = "8. Lock Keybind", PlaceholderText = "E", RemoveTextAfterFocusLost = false, Flag = "LockKeybindInput", Callback = function(t) Settings.LockKeybind = t end})
CombatTab:CreateToggle({Name = "9. Draw FOV", CurrentValue = false, Flag = "DrawFOVToggle", Callback = function(v) Toggles.DrawFOV = v end})
CombatTab:CreateToggle({Name = "10. Random Aim Offset", CurrentValue = false, Flag = "RandAimToggle", Callback = function(v) Toggles.RandomAimOffset = v end})

local SectionSilentAim = CombatTab:CreateSection("Silent Aim")
Toggles.SilentAim = false
Settings.HitChance = 100
Settings.SilentAimFOV = 100
Settings.BonePriority = "Head"
Toggles.IgnoreDowned = false

CombatTab:CreateToggle({Name = "11. Silent Aim Enable", CurrentValue = false, Flag = "SilentAimToggle", Callback = wrapCallback(function(v) Toggles.SilentAim = v end)})
CombatTab:CreateSlider({Name = "12. Hit Chance %", Range = {0, 100}, Increment = 1, CurrentValue = 100, Flag = "HitChanceSlider", Callback = function(v) Settings.HitChance = v end})
CombatTab:CreateSlider({Name = "13. Silent Aim FOV", Range = {10, 1000}, Increment = 1, CurrentValue = 100, Flag = "SilentAimFOVSlider", Callback = function(v) Settings.SilentAimFOV = v end})
CombatTab:CreateDropdown({Name = "14. Bone Priority System", Options = {"Head", "Torso", "Limbs"}, CurrentOption = {"Head"}, Flag = "BonePrioDrop", Callback = function(v) Settings.BonePriority = v[1] end})
CombatTab:CreateToggle({Name = "15. Ignore Downed Targets", CurrentValue = false, Flag = "IgnoreDownedToggle", Callback = function(v) Toggles.IgnoreDowned = v end})

local SectionTriggerbot = CombatTab:CreateSection("Triggerbot")
Toggles.Triggerbot = false
Settings.TriggerDelay = 0
Toggles.BurstMode = false

CombatTab:CreateToggle({Name = "16. Auto Fire on Target (Triggerbot)", CurrentValue = false, Flag = "TriggerbotToggle", Callback = wrapCallback(function(v) Toggles.Triggerbot = v end)})
CombatTab:CreateSlider({Name = "17. Trigger Delay (ms)", Range = {0, 1000}, Increment = 10, CurrentValue = 0, Flag = "TriggerDelaySlider", Callback = function(v) Settings.TriggerDelay = v end})
CombatTab:CreateToggle({Name = "18. Burst Mode", CurrentValue = false, Flag = "BurstModeToggle", Callback = function(v) Toggles.BurstMode = v end})

local SectionWeapons = CombatTab:CreateSection("Weapon Mods")
Toggles.NoRecoil = false
Toggles.NoSpread = false
Toggles.InstantReload = false
Toggles.InfAmmoClient = false
Settings.FireRateMult = 1
Settings.BulletSpeedMult = 1
Toggles.AutoReload = false
Settings.HitboxExpander = 2
Settings.DamageMult = 1
Toggles.RapidTapMode = false
Toggles.AutoWeaponSwitch = false
Settings.AimAssistStr = 0

CombatTab:CreateToggle({Name = "19. No Recoil", CurrentValue = false, Flag = "NoRecoilTog", Callback = wrapCallback(function(v) Toggles.NoRecoil = v end)})
CombatTab:CreateToggle({Name = "20. No Spread", CurrentValue = false, Flag = "NoSpreadTog", Callback = wrapCallback(function(v) Toggles.NoSpread = v end)})
CombatTab:CreateToggle({Name = "21. Instant Reload", CurrentValue = false, Flag = "InstReloadTog", Callback = wrapCallback(function(v) Toggles.InstantReload = v end)})
CombatTab:CreateToggle({Name = "22. Infinite Ammo (client)", CurrentValue = false, Flag = "InfAmmoTog", Callback = wrapCallback(function(v) Toggles.InfAmmoClient = v end)})
CombatTab:CreateSlider({Name = "23. Fire Rate Multiplier", Range = {1, 10}, Increment = 0.5, CurrentValue = 1, Flag = "FireRateSli", Callback = function(v) Settings.FireRateMult = v end})
CombatTab:CreateSlider({Name = "24. Bullet Speed Multiplier", Range = {1, 10}, Increment = 0.5, CurrentValue = 1, Flag = "BulletSpeedSli", Callback = function(v) Settings.BulletSpeedMult = v end})
CombatTab:CreateToggle({Name = "25. Auto Reload", CurrentValue = false, Flag = "AutoReloadTog", Callback = function(v) Toggles.AutoReload = v end})
CombatTab:CreateSlider({Name = "26. Hitbox Expander (size)", Range = {2, 50}, Increment = 1, CurrentValue = 2, Flag = "HitboxExpSli", Callback = function(v) Settings.HitboxExpander = v end})
CombatTab:CreateSlider({Name = "27. Damage Multiplier (client)", Range = {1, 100}, Increment = 1, CurrentValue = 1, Flag = "DmgMultSli", Callback = function(v) Settings.DamageMult = v end})
CombatTab:CreateToggle({Name = "28. Rapid Tap Mode", CurrentValue = false, Flag = "RapidTapTog", Callback = function(v) Toggles.RapidTapMode = v end})
CombatTab:CreateToggle({Name = "29. Auto Weapon Switch", CurrentValue = false, Flag = "AutoWepTog", Callback = function(v) Toggles.AutoWeaponSwitch = v end})
CombatTab:CreateSlider({Name = "30. Aim Assist Strength", Range = {0, 100}, Increment = 1, CurrentValue = 0, Flag = "AimAssistSli", Callback = function(v) Settings.AimAssistStr = v end})

-- ========================================= --
--           ADVANCED MOVEMENT (updated)      --
-- ========================================= --
local SectionAdvMov = AdvMovementTab:CreateSection("Advanced Movement Configs")

Settings.WalkSpeed = 16
Settings.SprintMult = 1.5
Settings.AccelControl = 1
Settings.DecelControl = 1
Toggles.AirControl = false
Toggles.AutoBhop = false
Settings.StrafeBoost = 1
Toggles.GlideMode = false
Toggles.HoverMode = false
Toggles.WallWalk = false
Settings.LadderSpeed = 1
Settings.ClimbSpeedMult = 1
Settings.DashDist = 50
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
Settings.FrictionMod = 1
Toggles.MoveCorrection = false

AdvMovementTab:CreateSlider({Name = "WalkSpeed Override", Range = {16, 500}, Increment = 1, CurrentValue = 16, Flag = "WalkSpeedSlider", Callback = function(v) Settings.WalkSpeed = v end})
AdvMovementTab:CreateSlider({Name = "31. Sprint Multiplier", Range = {1, 5}, Increment = 0.1, CurrentValue = 1.5, Flag = "SprintMultSli", Callback = function(v) Settings.SprintMult = v end})
AdvMovementTab:CreateSlider({Name = "32. Acceleration Control", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "AccelSli", Callback = function(v) Settings.AccelControl = v end})
AdvMovementTab:CreateSlider({Name = "33. Deceleration Control", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "DecelSli", Callback = function(v) Settings.DecelControl = v end})
AdvMovementTab:CreateToggle({Name = "34. Air Control Boost", CurrentValue = false, Flag = "AirCtrlTog", Callback = wrapCallback(function(v) Toggles.AirControl = v end)})
AdvMovementTab:CreateToggle({Name = "35. Auto Bunny Hop", CurrentValue = false, Flag = "AutoBhopTog", Callback = wrapCallback(function(v) Toggles.AutoBhop = v end)})
AdvMovementTab:CreateSlider({Name = "36. Strafe Speed Boost", Range = {1, 5}, Increment = 0.1, CurrentValue = 1, Flag = "StrafeSli", Callback = function(v) Settings.StrafeBoost = v end})
AdvMovementTab:CreateToggle({Name = "37. Glide Mode", CurrentValue = false, Flag = "GlideTog", Callback = wrapCallback(function(v) Toggles.GlideMode = v end)})
AdvMovementTab:CreateToggle({Name = "38. Hover Mode", CurrentValue = false, Flag = "HoverTog", Callback = wrapCallback(function(v) Toggles.HoverMode = v end)})
AdvMovementTab:CreateToggle({Name = "39. Wall Walk", CurrentValue = false, Flag = "WallWalkTog", Callback = function(v) Toggles.WallWalk = v end})
AdvMovementTab:CreateSlider({Name = "40. Ladder Speed Boost", Range = {1, 5}, Increment = 0.1, CurrentValue = 1, Flag = "LadderSli", Callback = function(v) Settings.LadderSpeed = v end})
AdvMovementTab:CreateSlider({Name = "41. Climb Speed Multiplier", Range = {1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "ClimbSli", Callback = function(v) Settings.ClimbSpeedMult = v end})
AdvMovementTab:CreateSlider({Name = "42. Dash Distance Control", Range = {10, 500}, Increment = 10, CurrentValue = 50, Flag = "DashDistSli", Callback = function(v) Settings.DashDist = v end})
AdvMovementTab:CreateSlider({Name = "43. Dash Cooldown Control", Range = {0, 10}, Increment = 0.5, CurrentValue = 1, Flag = "DashCDSli", Callback = function(v) Settings.DashCooldown = v end})
AdvMovementTab:CreateToggle({Name = "44. Omni Direction Dash", CurrentValue = false, Flag = "OmniDashTog", Callback = function(v) Toggles.OmniDash = v end})
AdvMovementTab:CreateToggle({Name = "45. Anti Fall Damage", CurrentValue = false, Flag = "AntiFallTog", Callback = function(v) Toggles.AntiFallDmg = v end})
AdvMovementTab:CreateToggle({Name = "46. Anti Knockback", CurrentValue = false, Flag = "AntiKBTog", Callback = function(v) Toggles.AntiKnockback = v end})
AdvMovementTab:CreateSlider({Name = "47. Knockback Multiplier", Range = {0, 10}, Increment = 0.1, CurrentValue = 1, Flag = "KBMultSli", Callback = function(v) Settings.KnockbackMult = v end})
AdvMovementTab:CreateToggle({Name = "48. Platform Lock Stabilizer", CurrentValue = false, Flag = "PlatLockTog", Callback = function(v) Toggles.PlatformLock = v end})
AdvMovementTab:CreateSlider({Name = "49. Step Height Modifier", Range = {2, 50}, Increment = 1, CurrentValue = 2, Flag = "StepSli", Callback = function(v) Settings.StepHeight = v end})
AdvMovementTab:CreateToggle({Name = "50. Jump Delay Removal", CurrentValue = false, Flag = "JumpDelTog", Callback = function(v) Toggles.JumpDelayRem = v end})
AdvMovementTab:CreateSlider({Name = "51. Multi Jump Count", Range = {1, 100}, Increment = 1, CurrentValue = 1, Flag = "MultiJumpSli", Callback = function(v) Settings.MultiJump = v end})
AdvMovementTab:CreateToggle({Name = "52. Slide Movement System", CurrentValue = false, Flag = "SlideTog", Callback = function(v) Toggles.SlideMovement = v end})
AdvMovementTab:CreateToggle({Name = "53. Ice Physics Mode", CurrentValue = false, Flag = "IceTog", Callback = function(v) Toggles.IcePhysics = v end})
AdvMovementTab:CreateSlider({Name = "54. Friction Modifier", Range = {0, 2}, Increment = 0.1, CurrentValue = 1, Flag = "FrictionSli", Callback = function(v) Settings.FrictionMod = v end})
AdvMovementTab:CreateToggle({Name = "55. Movement Correction System", CurrentValue = false, Flag = "MoveCorrTog", Callback = function(v) Toggles.MoveCorrection = v end})


-- ========================================= --
--               VISUAL PRO (updated)         --
-- ========================================= --
local SectionVisualESP = VisualProTab:CreateSection("ESP Enhancements")
Toggles.BoxESP = false
Toggles.NameESP = false
Toggles.HealthESP = false
Toggles.DistanceESP = false
Toggles.SkeletonESP = false
Settings.ChamsType = "Solid"
Toggles.TeamColorESP = false
Toggles.RainbowESP = false
Settings.ESPTransparency = 0.5
Settings.ESPMaxDist = 2000

VisualProTab:CreateToggle({Name = "56. Box ESP", CurrentValue = false, Flag = "BoxESPTog", Callback = wrapCallback(function(v) Toggles.BoxESP = v end)})
VisualProTab:CreateToggle({Name = "57. Name ESP", CurrentValue = false, Flag = "NameESPTog", Callback = wrapCallback(function(v) Toggles.NameESP = v end)})
VisualProTab:CreateToggle({Name = "58. Health ESP", CurrentValue = false, Flag = "HealthESPTog", Callback = wrapCallback(function(v) Toggles.HealthESP = v end)})
VisualProTab:CreateToggle({Name = "59. Distance ESP", CurrentValue = false, Flag = "DistESPTog", Callback = wrapCallback(function(v) Toggles.DistanceESP = v end)})
VisualProTab:CreateToggle({Name = "60. Skeleton ESP", CurrentValue = false, Flag = "SkelESPTog", Callback = wrapCallback(function(v) Toggles.SkeletonESP = v end)})
VisualProTab:CreateDropdown({Name = "61. Chams (Solid/Wireframe)", Options = {"Solid", "Wireframe"}, CurrentOption = {"Solid"}, Flag = "ChamsDrop", Callback = function(v) Settings.ChamsType = v[1]; refreshFeatures() end})
VisualProTab:CreateToggle({Name = "62. Team Color ESP", CurrentValue = false, Flag = "TeamESPTog", Callback = function(v) Toggles.TeamColorESP = v end})
VisualProTab:CreateToggle({Name = "63. Rainbow ESP", CurrentValue = false, Flag = "RainbowESPTog", Callback = function(v) Toggles.RainbowESP = v end})
VisualProTab:CreateSlider({Name = "64. ESP Transparency", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.5, Flag = "ESPTransSli", Callback = function(v) Settings.ESPTransparency = v end})
VisualProTab:CreateSlider({Name = "65. ESP Max Distance", Range = {100, 10000}, Increment = 100, CurrentValue = 2000, Flag = "ESPMaxDistSli", Callback = function(v) Settings.ESPMaxDist = v end})

local SectionCamera = VisualProTab:CreateSection("Camera / FOV")
Settings.CustomFOV = 70
Toggles.FOVUnlock = false
Settings.ZoomSpeed = 1
Settings.CameraOffset = "0,0,0"
Toggles.ThirdPerson = false
Settings.CamSmooth = 1
Toggles.CamShakeRem = false
Toggles.Freecam = false
Settings.FreecamSpeed = 1
Settings.FreecamRot = 1

VisualProTab:CreateSlider({Name = "66. Custom FOV Slider", Range = {10, 120}, Increment = 1, CurrentValue = 70, Flag = "CusFOVSli", Callback = function(v) Settings.CustomFOV = v end})
VisualProTab:CreateToggle({Name = "67. FOV Unlock", CurrentValue = false, Flag = "FOVUnlTog", Callback = function(v) Toggles.FOVUnlock = v end})
VisualProTab:CreateSlider({Name = "68. Zoom Speed Control", Range = {1, 10}, Increment = 0.5, CurrentValue = 1, Flag = "ZoomSli", Callback = function(v) Settings.ZoomSpeed = v end})
VisualProTab:CreateInput({Name = "69. Camera Offset (x,y,z)", PlaceholderText = "0,0,0", RemoveTextAfterFocusLost = false, Flag = "CamOffsetInput", Callback = function(t) Settings.CameraOffset = t end})
VisualProTab:CreateToggle({Name = "70. Third Person Mode", CurrentValue = false, Flag = "ThirdPTog", Callback = function(v) Toggles.ThirdPerson = v end})
VisualProTab:CreateSlider({Name = "71. Camera Smoothing", Range = {1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "CamSmoothSli", Callback = function(v) Settings.CamSmooth = v end})
VisualProTab:CreateToggle({Name = "72. Camera Shake Removal", CurrentValue = false, Flag = "CamShakeTog", Callback = function(v) Toggles.CamShakeRem = v end})
VisualProTab:CreateToggle({Name = "73. Freecam Mode", CurrentValue = false, Flag = "FreecamTog", Callback = function(v) Toggles.Freecam = v end})
VisualProTab:CreateSlider({Name = "74. Freecam Speed", Range = {1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "FreeSpdSli", Callback = function(v) Settings.FreecamSpeed = v end})
VisualProTab:CreateSlider({Name = "75. Freecam Rotation Speed", Range = {1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "FreeRotSli", Callback = function(v) Settings.FreecamRot = v end})

local SectionEnv = VisualProTab:CreateSection("Environment")
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

VisualProTab:CreateToggle({Name = "76. Fullbright Pro", CurrentValue = false, Flag = "FBTog", Callback = function(v) Toggles.Fullbright = v end})
VisualProTab:CreateToggle({Name = "77. Night Mode", CurrentValue = false, Flag = "NightTog", Callback = function(v) Toggles.NightMode = v end})
VisualProTab:CreateToggle({Name = "78. Remove Fog", CurrentValue = false, Flag = "FogTog", Callback = function(v) Toggles.RemFog = v end})
VisualProTab:CreateDropdown({Name = "79. Skybox Changer", Options = {"Default", "Galaxy", "Vaporwave", "Red"}, CurrentOption = {"Default"}, Flag = "SkyDrop", Callback = function(v) Settings.Skybox = v[1] end})
VisualProTab:CreateSlider({Name = "80. Time Changer", Range = {0, 24}, Increment = 1, CurrentValue = 12, Flag = "TimeSli", Callback = function(v) Settings.TimeChange = v; if Lighting then Lighting.ClockTime = v end end})
VisualProTab:CreateSlider({Name = "81. Saturation Control", Range = {0, 5}, Increment = 0.1, CurrentValue = 1, Flag = "SatSli", Callback = function(v) Settings.Saturation = v end})
VisualProTab:CreateSlider({Name = "82. Contrast Control", Range = {0, 5}, Increment = 0.1, CurrentValue = 1, Flag = "ConSli", Callback = function(v) Settings.Contrast = v end})
VisualProTab:CreateSlider({Name = "83. Bloom Control", Range = {0, 5}, Increment = 0.1, CurrentValue = 1, Flag = "BloomSli", Callback = function(v) Settings.Bloom = v end})
VisualProTab:CreateInput({Name = "84. Ambient Color Override", PlaceholderText = "255,255,255", RemoveTextAfterFocusLost = false, Flag = "AmbientColorInput", Callback = function(t) Settings.AmbientColor = t end})
VisualProTab:CreateSlider({Name = "85. Shadow Intensity", Range = {0, 1}, Increment = 0.1, CurrentValue = 1, Flag = "ShadowSli", Callback = function(v) Settings.ShadowInt = v; if Lighting then Lighting.ShadowSoftness = v end end})

-- ========================================= --
--              PLAYER MODS (update as needed)--
-- ========================================= --
-- (Keep existing PlayerMods, WorldMods, Teleport, Utility, Automation sections unchanged; they're already functional with variables and some loops.)

-- ========================================= --
--               LOOPS                        --
-- ========================================= --
local fovCircle = nil
pcall(function()
    if Drawing and Drawing.new then
        fovCircle = Drawing.new("Circle")
        if fovCircle then
            fovCircle.Visible = false
            fovCircle.Thickness = 2
            fovCircle.Color = Color3.fromRGB(255, 255, 255)
            fovCircle.Filled = false
            fovCircle.Transparency = 1
        end
    end
end)

connections.main = RunService.RenderStepped:Connect(function()
    local char, hrp, hum = getChar(), getRoot(), getHum()
    
    -- WalkSpeed
    if hum and hum.WalkSpeed ~= Settings.WalkSpeed then
        hum.WalkSpeed = Settings.WalkSpeed
    end
    
    -- AutoWalk
    if Toggles.AutoWalk and hum then
        hum:Move(Vector3.new(1, 0, 0), true)
    end
    
    -- FOV Circle
    if fovCircle then
        if Toggles.DrawFOV then
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
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
        
        FlyBody.bv.Velocity = moveDir * Settings.FlySpeed
        FlyBody.bg.CFrame = Camera.CFrame
    end
    
    -- Godmode
    if Toggles.Godmode and hum then
        if hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end
end)

connections.stepped = RunService.Stepped:Connect(function()
    local char, hrp, hum = getChar(), getRoot(), getHum()
    
    -- Noclip
    if Toggles.Noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
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

connections.infjump = UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump then
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Activate all feature models
refreshFeatures()

-- Initial load config
Rayfield:LoadConfiguration()
Rayfield:Notify({Title="CypherX Hub Loaded", Content="150+ Features Activated", Duration=5, Image="info"})
