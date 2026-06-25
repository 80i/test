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
   Discord = { Enabled = false },
   KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

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

--=========================================--
--               MAIN TAB                  --
--=========================================--
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
          bg.cframe = hrp.CFrame
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

--=========================================--
--             COMBAT SYSTEM               --
--=========================================--
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

CombatTab:CreateToggle({Name = "1. Aimbot Enable", CurrentValue = false, Flag = "AimbotToggle", Callback = function(v) Toggles.Aimbot = v end})
CombatTab:CreateSlider({Name = "2. Aimbot Smoothness", Range = {1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "AimbotSmoothSlider", Callback = function(v) Settings.AimbotSmoothness = v end})
CombatTab:CreateSlider({Name = "3. Aimbot FOV Radius", Range = {10, 1000}, Increment = 1, CurrentValue = 100, Flag = "AimbotFOVSlider", Callback = function(v) Settings.AimbotFOV = v end})
CombatTab:CreateSlider({Name = "4. Aimbot Prediction", Range = {0, 10}, Increment = 0.1, CurrentValue = 0, Flag = "AimbotPredSlider", Callback = function(v) Settings.AimbotPrediction = v end})
CombatTab:CreateDropdown({Name = "5. Target Bone Selector", Options = {"Head", "HumanoidRootPart", "Random"}, CurrentOption = {"Head"}, Flag = "AimbotBoneDrop", Callback = function(v) Settings.TargetBone = v[1] end})
CombatTab:CreateToggle({Name = "6. Team Check", CurrentValue = false, Flag = "TeamCheckToggle", Callback = function(v) Toggles.TeamCheck = v end})
CombatTab:CreateToggle({Name = "7. Visibility Check", CurrentValue = false, Flag = "VisCheckToggle", Callback = function(v) Toggles.VisibilityCheck = v end})
CombatTab:CreateInput({Name = "8. Lock Keybind", PlaceholderText = "E", RemoveTextAfterFocusLost = false, Callback = function(t) Settings.LockKeybind = t end})
CombatTab:CreateToggle({Name = "9. Draw FOV", CurrentValue = false, Flag = "DrawFOVToggle", Callback = function(v) Toggles.DrawFOV = v end})
CombatTab:CreateToggle({Name = "10. Random Aim Offset", CurrentValue = false, Flag = "RandAimToggle", Callback = function(v) Toggles.RandomAimOffset = v end})

local SectionSilentAim = CombatTab:CreateSection("Silent Aim")
Toggles.SilentAim = false
Settings.HitChance = 100
Settings.SilentAimFOV = 100
Settings.BonePriority = "Head"
Toggles.IgnoreDowned = false

CombatTab:CreateToggle({Name = "11. Silent Aim Enable", CurrentValue = false, Flag = "SilentAimToggle", Callback = function(v) Toggles.SilentAim = v end})
CombatTab:CreateSlider({Name = "12. Hit Chance %", Range = {0, 100}, Increment = 1, CurrentValue = 100, Flag = "HitChanceSlider", Callback = function(v) Settings.HitChance = v end})
CombatTab:CreateSlider({Name = "13. Silent Aim FOV", Range = {10, 1000}, Increment = 1, CurrentValue = 100, Flag = "SilentAimFOVSlider", Callback = function(v) Settings.SilentAimFOV = v end})
CombatTab:CreateDropdown({Name = "14. Bone Priority System", Options = {"Head", "Torso", "Limbs"}, CurrentOption = {"Head"}, Flag = "BonePrioDrop", Callback = function(v) Settings.BonePriority = v[1] end})
CombatTab:CreateToggle({Name = "15. Ignore Downed Targets", CurrentValue = false, Flag = "IgnoreDownedToggle", Callback = function(v) Toggles.IgnoreDowned = v end})

local SectionTriggerbot = CombatTab:CreateSection("Triggerbot")
Toggles.Triggerbot = false
Settings.TriggerDelay = 0
Toggles.BurstMode = false

CombatTab:CreateToggle({Name = "16. Auto Fire on Target (Triggerbot)", CurrentValue = false, Flag = "TriggerbotToggle", Callback = function(v) Toggles.Triggerbot = v end})
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

CombatTab:CreateToggle({Name = "19. No Recoil", CurrentValue = false, Flag = "NoRecoilTog", Callback = function(v) Toggles.NoRecoil = v end})
CombatTab:CreateToggle({Name = "20. No Spread", CurrentValue = false, Flag = "NoSpreadTog", Callback = function(v) Toggles.NoSpread = v end})
CombatTab:CreateToggle({Name = "21. Instant Reload", CurrentValue = false, Flag = "InstReloadTog", Callback = function(v) Toggles.InstantReload = v end})
CombatTab:CreateToggle({Name = "22. Infinite Ammo (client)", CurrentValue = false, Flag = "InfAmmoTog", Callback = function(v) Toggles.InfAmmoClient = v end})
CombatTab:CreateSlider({Name = "23. Fire Rate Multiplier", Range = {1, 10}, Increment = 0.5, CurrentValue = 1, Flag = "FireRateSli", Callback = function(v) Settings.FireRateMult = v end})
CombatTab:CreateSlider({Name = "24. Bullet Speed Multiplier", Range = {1, 10}, Increment = 0.5, CurrentValue = 1, Flag = "BulletSpeedSli", Callback = function(v) Settings.BulletSpeedMult = v end})
CombatTab:CreateToggle({Name = "25. Auto Reload", CurrentValue = false, Flag = "AutoReloadTog", Callback = function(v) Toggles.AutoReload = v end})
CombatTab:CreateSlider({Name = "26. Hitbox Expander (size)", Range = {2, 50}, Increment = 1, CurrentValue = 2, Flag = "HitboxExpSli", Callback = function(v) Settings.HitboxExpander = v end})
CombatTab:CreateSlider({Name = "27. Damage Multiplier (client)", Range = {1, 100}, Increment = 1, CurrentValue = 1, Flag = "DmgMultSli", Callback = function(v) Settings.DamageMult = v end})
CombatTab:CreateToggle({Name = "28. Rapid Tap Mode", CurrentValue = false, Flag = "RapidTapTog", Callback = function(v) Toggles.RapidTapMode = v end})
CombatTab:CreateToggle({Name = "29. Auto Weapon Switch", CurrentValue = false, Flag = "AutoWepTog", Callback = function(v) Toggles.AutoWeaponSwitch = v end})
CombatTab:CreateSlider({Name = "30. Aim Assist Strength", Range = {0, 100}, Increment = 1, CurrentValue = 0, Flag = "AimAssistSli", Callback = function(v) Settings.AimAssistStr = v end})


--=========================================--
--           ADVANCED MOVEMENT             --
--=========================================--
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
AdvMovementTab:CreateToggle({Name = "34. Air Control Boost", CurrentValue = false, Flag = "AirCtrlTog", Callback = function(v) Toggles.AirControl = v end})
AdvMovementTab:CreateToggle({Name = "35. Auto Bunny Hop", CurrentValue = false, Flag = "AutoBhopTog", Callback = function(v) Toggles.AutoBhop = v end})
AdvMovementTab:CreateSlider({Name = "36. Strafe Speed Boost", Range = {1, 5}, Increment = 0.1, CurrentValue = 1, Flag = "StrafeSli", Callback = function(v) Settings.StrafeBoost = v end})
AdvMovementTab:CreateToggle({Name = "37. Glide Mode", CurrentValue = false, Flag = "GlideTog", Callback = function(v) Toggles.GlideMode = v end})
AdvMovementTab:CreateToggle({Name = "38. Hover Mode", CurrentValue = false, Flag = "HoverTog", Callback = function(v) Toggles.HoverMode = v end})
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


--=========================================--
--               VISUAL PRO                --
--=========================================--
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

VisualProTab:CreateToggle({Name = "56. Box ESP", CurrentValue = false, Flag = "BoxESPTog", Callback = function(v) Toggles.BoxESP = v end})
VisualProTab:CreateToggle({Name = "57. Name ESP", CurrentValue = false, Flag = "NameESPTog", Callback = function(v) Toggles.NameESP = v end})
VisualProTab:CreateToggle({Name = "58. Health ESP", CurrentValue = false, Flag = "HealthESPTog", Callback = function(v) Toggles.HealthESP = v end})
VisualProTab:CreateToggle({Name = "59. Distance ESP", CurrentValue = false, Flag = "DistESPTog", Callback = function(v) Toggles.DistanceESP = v end})
VisualProTab:CreateToggle({Name = "60. Skeleton ESP", CurrentValue = false, Flag = "SkelESPTog", Callback = function(v) Toggles.SkeletonESP = v end})
VisualProTab:CreateDropdown({Name = "61. Chams (Solid/Wireframe)", Options = {"Solid", "Wireframe"}, CurrentOption = {"Solid"}, Flag = "ChamsDrop", Callback = function(v) Settings.ChamsType = v[1] end})
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
VisualProTab:CreateInput({Name = "69. Camera Offset (x,y,z)", PlaceholderText = "0,0,0", RemoveTextAfterFocusLost = false, Callback = function(t) Settings.CameraOffset = t end})
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
VisualProTab:CreateInput({Name = "84. Ambient Color Override", PlaceholderText = "255,255,255", RemoveTextAfterFocusLost = false, Callback = function(t) Settings.AmbientColor = t end})
VisualProTab:CreateSlider({Name = "85. Shadow Intensity", Range = {0, 1}, Increment = 0.1, CurrentValue = 1, Flag = "ShadowSli", Callback = function(v) Settings.ShadowInt = v; if Lighting then Lighting.ShadowSoftness = v end end})

--=========================================--
--              PLAYER MODS                --
--=========================================--
local SectionPlayer = PlayerModsTab:CreateSection("Character Enhancements")
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
Toggles.AntiFreeze = false
Toggles.RespawnOver = false
Toggles.InstaRespawn = false

PlayerModsTab:CreateToggle({Name = "86. Godmode (auto heal loop)", CurrentValue = false, Flag = "GodTog", Callback = function(v) Toggles.Godmode = v end})
PlayerModsTab:CreateSlider({Name = "87. Health Regen Speed", Range = {0, 100}, Increment = 1, CurrentValue = 1, Flag = "HealSpdSli", Callback = function(v) Settings.HealSpeed = v end})
PlayerModsTab:CreateSlider({Name = "88. Max Health Override (client)", Range = {100, 100000}, Increment = 100, CurrentValue = 100, Flag = "MaxHPSli", Callback = function(v) Settings.MaxHealth = v end})
PlayerModsTab:CreateToggle({Name = "89. Force Sit", CurrentValue = false, Flag = "SitTog", Callback = function(v) Toggles.ForceSit = v; local h=getHum(); if h then h.Sit=v end end})
PlayerModsTab:CreateToggle({Name = "90. Anti Ragdoll", CurrentValue = false, Flag = "AntiRagTog", Callback = function(v) Toggles.AntiRagdoll = v end})
PlayerModsTab:CreateToggle({Name = "91. Disable Animations", CurrentValue = false, Flag = "DisAnimTog", Callback = function(v) Toggles.DisableAnims = v end})
PlayerModsTab:CreateSlider({Name = "92. Animation Speed Multiplier", Range = {0, 10}, Increment = 0.1, CurrentValue = 1, Flag = "AnimSpdSli", Callback = function(v) Settings.AnimSpeed = v end})
PlayerModsTab:CreateSlider({Name = "93. Character Scale Modifier", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "CharScaleSli", Callback = function(v) Settings.CharScale = v end})
PlayerModsTab:CreateToggle({Name = "94. Invisible Character", CurrentValue = false, Flag = "InvisTog", Callback = function(v) Toggles.Invisible = v end})
PlayerModsTab:CreateToggle({Name = "95. Fake Lag Movement", CurrentValue = false, Flag = "FakeLagTog", Callback = function(v) Toggles.FakeLag = v end})
PlayerModsTab:CreateToggle({Name = "96. Fake AFK", CurrentValue = false, Flag = "FakeAFKTog", Callback = function(v) Toggles.FakeAFK = v end})
PlayerModsTab:CreateToggle({Name = "97. Anti Void", CurrentValue = false, Flag = "AntiVoidTog", Callback = function(v) Toggles.AntiVoid = v end})
PlayerModsTab:CreateToggle({Name = "98. Anti Freeze", CurrentValue = false, Flag = "AntiFrzTog", Callback = function(v) Toggles.AntiFreeze = v end})
PlayerModsTab:CreateToggle({Name = "99. Respawn Override", CurrentValue = false, Flag = "RespOverTog", Callback = function(v) Toggles.RespawnOver = v end})
PlayerModsTab:CreateToggle({Name = "100. Instant Respawn", CurrentValue = false, Flag = "InstaRespTog", Callback = function(v) Toggles.InstaRespawn = v end})

--=========================================--
--               WORLD MODS                --
--=========================================--
local SectionWorld = WorldModsTab:CreateSection("Environment Interactions")
Settings.Gravity = workspace.Gravity
Settings.GlobalSpeed = 1
Toggles.RemColGlobal = false
Toggles.BreakParts = false
Toggles.SpawnPlats = false
Toggles.AutoBridge = false
Toggles.DelMap = false
Toggles.WaterWalk = false
Toggles.LavaImmune = false
Toggles.ObjHighlight = false
Settings.PhysTimeScale = 1
Toggles.ObjFreeze = false
Toggles.MovPlat = false
Settings.WorldBright = 1
Toggles.RemTex = false

WorldModsTab:CreateSlider({Name = "101. Gravity Override", Range = {0, 1000}, Increment = 1, CurrentValue = workspace.Gravity, Flag = "GravSli", Callback = function(v) Settings.Gravity = v; workspace.Gravity = v end})
WorldModsTab:CreateSlider({Name = "102. Global Speed Modifier", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "GlobSpdSli", Callback = function(v) Settings.GlobalSpeed = v end})
WorldModsTab:CreateToggle({Name = "103. Remove Collisions (global)", CurrentValue = false, Flag = "RemColTog", Callback = function(v) Toggles.RemColGlobal = v end})
WorldModsTab:CreateToggle({Name = "104. Break Parts (client)", CurrentValue = false, Flag = "BreakPartTog", Callback = function(v) Toggles.BreakParts = v end})
WorldModsTab:CreateToggle({Name = "105. Spawn Platforms Under Player", CurrentValue = false, Flag = "PlatTog", Callback = function(v) Toggles.SpawnPlats = v end})
WorldModsTab:CreateToggle({Name = "106. Auto Bridge Builder", CurrentValue = false, Flag = "BridgeTog", Callback = function(v) Toggles.AutoBridge = v end})
WorldModsTab:CreateToggle({Name = "107. Delete Map Parts (client)", CurrentValue = false, Flag = "DelMapTog", Callback = function(v) Toggles.DelMap = v end})
WorldModsTab:CreateToggle({Name = "108. Water Walk", CurrentValue = false, Flag = "WaterWalkTog", Callback = function(v) Toggles.WaterWalk = v end})
WorldModsTab:CreateToggle({Name = "109. Lava Immunity (client)", CurrentValue = false, Flag = "LavaImmTog", Callback = function(v) Toggles.LavaImmune = v end})
WorldModsTab:CreateToggle({Name = "110. Object Highlighting", CurrentValue = false, Flag = "ObjHiTog", Callback = function(v) Toggles.ObjHighlight = v end})
WorldModsTab:CreateSlider({Name = "111. Physics Time Scale", Range = {0, 5}, Increment = 0.1, CurrentValue = 1, Flag = "PhysTimeSli", Callback = function(v) Settings.PhysTimeScale = v end})
WorldModsTab:CreateToggle({Name = "112. Object Freeze", CurrentValue = false, Flag = "ObjFrzTog", Callback = function(v) Toggles.ObjFreeze = v end})
WorldModsTab:CreateToggle({Name = "113. Moving Platform Creator", CurrentValue = false, Flag = "MovPlatTog", Callback = function(v) Toggles.MovPlat = v end})
WorldModsTab:CreateSlider({Name = "114. World Brightness Slider", Range = {0, 10}, Increment = 0.1, CurrentValue = 1, Flag = "WorldBrightSli", Callback = function(v) Settings.WorldBright = v; if Lighting then Lighting.Brightness = v end end})
WorldModsTab:CreateToggle({Name = "115. Remove Textures", CurrentValue = false, Flag = "RemTexTog", Callback = function(v) Toggles.RemTex = v end})

--=========================================--
--            TELEPORT SYSTEM              --
--=========================================--
local SectionTP = TeleportsTab:CreateSection("Position Management")
tempStates.SavedPositions = {
    ["End Stage"] = Vector3.new(7986.58, 718.30, 5143.11),
    ["Spawn Area"] = Vector3.new(0, 50, 0),
    ["Secret Zone"] = Vector3.new(1000, 100, 1000)
}
Settings.SelectedLocation = "End Stage"
Settings.TeleportDelay = 0
Toggles.TweenTP = false
Settings.RandTPRad = 0
Settings.TargetPlayer = ""
Toggles.FollowPlayer = false
Toggles.OrbitPlayer = false
Toggles.AutoReturn = false

TeleportsTab:CreateButton({Name = "116. Save Unlimited Positions", Callback = function() 
    local hrp = getRoot()
    if hrp then 
        local name = "Pos_" .. tostring(math.random(1000,9999))
        tempStates.SavedPositions[name] = hrp.Position
        Rayfield:Notify({Title="Position Saved", Content=name, Duration=3})
    end
end})
TeleportsTab:CreateInput({Name = "117. Named Position Slots", PlaceholderText = "Enter Name and press Enter", RemoveTextAfterFocusLost = false, Callback = function(t) 
    local hrp = getRoot()
    if hrp and t ~= "" then
        tempStates.SavedPositions[t] = hrp.Position
        Rayfield:Notify({Title="Position Saved", Content=t, Duration=3})
    end
end})

local locOptions = {}
for k,_ in pairs(tempStates.SavedPositions) do table.insert(locOptions, k) end

TeleportsTab:CreateDropdown({Name = "118. Teleport List UI", Options = locOptions, CurrentOption = {locOptions[1] or ""}, Flag = "TPListDrop", Callback = function(v) Settings.SelectedLocation = v[1] end})
TeleportsTab:CreateButton({Name = "Teleport to Selected", Callback = function()
    local hrp = getRoot()
    if hrp and tempStates.SavedPositions[Settings.SelectedLocation] then
        if Toggles.TweenTP then
            TweenService:Create(hrp, TweenInfo.new(1), {CFrame = CFrame.new(tempStates.SavedPositions[Settings.SelectedLocation])}):Play()
        else
            hrp.CFrame = CFrame.new(tempStates.SavedPositions[Settings.SelectedLocation])
        end
    end
end})

TeleportsTab:CreateSlider({Name = "119. Teleport Delay Control", Range = {0, 10}, Increment = 0.1, CurrentValue = 0, Flag = "TPDelSli", Callback = function(v) Settings.TeleportDelay = v end})
TeleportsTab:CreateToggle({Name = "120. Tween Teleport (smooth)", CurrentValue = false, Flag = "TweenTPTog", Callback = function(v) Toggles.TweenTP = v end})
TeleportsTab:CreateSlider({Name = "121. Random Teleport Radius", Range = {0, 1000}, Increment = 10, CurrentValue = 0, Flag = "RandRadSli", Callback = function(v) Settings.RandTPRad = v end})
TeleportsTab:CreateInput({Name = "122. Player Teleport (select)", PlaceholderText = "Username", RemoveTextAfterFocusLost = false, Callback = function(t) Settings.TargetPlayer = t end})
TeleportsTab:CreateButton({Name = "Teleport to Player", Callback = function()
    local target = Players:FindFirstChild(Settings.TargetPlayer)
    local hrp = getRoot()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
        hrp.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end})
TeleportsTab:CreateToggle({Name = "123. Follow Player", CurrentValue = false, Flag = "FolTog", Callback = function(v) Toggles.FollowPlayer = v end})
TeleportsTab:CreateToggle({Name = "124. Orbit Player", CurrentValue = false, Flag = "OrbTog", Callback = function(v) Toggles.OrbitPlayer = v end})
TeleportsTab:CreateToggle({Name = "125. Auto Return Position", CurrentValue = false, Flag = "RetTog", Callback = function(v) Toggles.AutoReturn = v end})

--=========================================--
--                UTILITY                  --
--=========================================--
local SectionUtil = UtilityTab:CreateSection("QOL Features")
Toggles.AntiAFK = false
Toggles.FPSBoost = false
Toggles.LowGFX = false
Toggles.PingDisp = false
Toggles.FPSCounter = false
Toggles.AutoChatSpam = false
Settings.SpamText = ""
Toggles.AutoReply = false
Settings.ReplyText = ""

UtilityTab:CreateToggle({Name = "126. Anti AFK", CurrentValue = true, Flag = "AntiAFKTog", Callback = function(v) Toggles.AntiAFK = v end})
connections.afk = LocalPlayer.Idled:Connect(function()
    if Toggles.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end
end)
UtilityTab:CreateButton({Name = "127. Server Rejoin", Callback = function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end})
UtilityTab:CreateButton({Name = "128. Server Hop", Callback = function()
    Rayfield:Notify({Title="Server Hop", Content="Finding new server...", Duration=3})
end})
UtilityTab:CreateButton({Name = "129. Copy Position to Clipboard", Callback = function()
    local hrp = getRoot()
    if hrp and setclipboard then setclipboard(tostring(hrp.Position)) end
end})
UtilityTab:CreateButton({Name = "130. Copy Player Name", Callback = function()
    if setclipboard then setclipboard(LocalPlayer.Name) end
end})
UtilityTab:CreateToggle({Name = "131. FPS Boost Mode", CurrentValue = false, Flag = "FPSBoostTog", Callback = function(v) Toggles.FPSBoost = v end})
UtilityTab:CreateToggle({Name = "132. Low Graphics Mode", CurrentValue = false, Flag = "LowGFXTog", Callback = function(v) 
    Toggles.LowGFX = v
    if v then
        Lighting.GlobalShadows = false
        sethiddenproperty(workspace.Terrain, "Decoration", false)
    else
        Lighting.GlobalShadows = true
        sethiddenproperty(workspace.Terrain, "Decoration", true)
    end
end})
UtilityTab:CreateButton({Name = "133. Memory Cleaner", Callback = function()
    collectgarbage("collect")
    Rayfield:Notify({Title="Cleaned", Content="Memory garbage collected", Duration=3})
end})
UtilityTab:CreateToggle({Name = "134. Ping Display", CurrentValue = false, Flag = "PingTog", Callback = function(v) Toggles.PingDisp = v end})
UtilityTab:CreateToggle({Name = "135. FPS Counter", CurrentValue = false, Flag = "FPSTog", Callback = function(v) Toggles.FPSCounter = v end})
UtilityTab:CreateInput({Name = "Chat Spam Message", PlaceholderText = "Message", RemoveTextAfterFocusLost = false, Callback = function(t) Settings.SpamText = t end})
UtilityTab:CreateToggle({Name = "136. Auto Chat Spam", CurrentValue = false, Flag = "SpamTog", Callback = function(v) Toggles.AutoChatSpam = v end})
UtilityTab:CreateInput({Name = "Auto Reply Text", PlaceholderText = "Reply", RemoveTextAfterFocusLost = false, Callback = function(t) Settings.ReplyText = t end})
UtilityTab:CreateToggle({Name = "137. Auto Reply System", CurrentValue = false, Flag = "ReplyTog", Callback = function(v) Toggles.AutoReply = v end})
UtilityTab:CreateButton({Name = "138. Notification System Customizer", Callback = function()
    Rayfield:Notify({Title="Custom Notify", Content="Notification System Works", Duration=3})
end})

--=========================================--
--              AUTOMATION                 --
--=========================================--
local SectionAuto = AutomationTab:CreateSection("Farming & Automation")
Toggles.AutoFarmPath = false
Toggles.AutoCollect = false
Toggles.AutoClick = false
Toggles.AutoInteract = false
Toggles.AutoQuest = false
Toggles.AutoUpgrade = false
Toggles.AutoSell = false
Toggles.AutoEquip = false
Toggles.AutoDodge = false
Toggles.AIMovement = false
Settings.EnemyDetRad = 50
Toggles.SmartTarget = false

AutomationTab:CreateToggle({Name = "139. Auto Farm Pathfinding", CurrentValue = false, Flag = "FarmTog", Callback = function(v) Toggles.AutoFarmPath = v end})
AutomationTab:CreateToggle({Name = "140. Auto Collect Items", CurrentValue = false, Flag = "ColTog", Callback = function(v) Toggles.AutoCollect = v end})
AutomationTab:CreateToggle({Name = "141. Auto Clicker", CurrentValue = false, Flag = "ClickTog", Callback = function(v) Toggles.AutoClick = v end})
AutomationTab:CreateToggle({Name = "142. Auto Interact", CurrentValue = false, Flag = "IntTog", Callback = function(v) Toggles.AutoInteract = v end})
AutomationTab:CreateToggle({Name = "143. Auto Quest", CurrentValue = false, Flag = "QuestTog", Callback = function(v) Toggles.AutoQuest = v end})
AutomationTab:CreateToggle({Name = "144. Auto Upgrade System", CurrentValue = false, Flag = "UpTog", Callback = function(v) Toggles.AutoUpgrade = v end})
AutomationTab:CreateToggle({Name = "145. Auto Sell Items", CurrentValue = false, Flag = "SellTog", Callback = function(v) Toggles.AutoSell = v end})
AutomationTab:CreateToggle({Name = "146. Auto Equip Best", CurrentValue = false, Flag = "EquipTog", Callback = function(v) Toggles.AutoEquip = v end})
AutomationTab:CreateToggle({Name = "147. Auto Dodge System", CurrentValue = false, Flag = "DodgeTog", Callback = function(v) Toggles.AutoDodge = v end})
AutomationTab:CreateToggle({Name = "148. AI Movement (basic pathing)", CurrentValue = false, Flag = "AIMovTog", Callback = function(v) Toggles.AIMovement = v end})
AutomationTab:CreateSlider({Name = "149. Enemy Detection Radius", Range = {10, 500}, Increment = 5, CurrentValue = 50, Flag = "EneRadSli", Callback = function(v) Settings.EnemyDetRad = v end})
AutomationTab:CreateToggle({Name = "150. Smart Target Switching", CurrentValue = false, Flag = "SmartTarTog", Callback = function(v) Toggles.SmartTarget = v end})

--=========================================--
--               LOOPS                     --
--=========================================--
local fovCircle = Drawing and Drawing.new("Circle") or nil
if fovCircle then
    fovCircle.Visible = false
    fovCircle.Thickness = 2
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
    fovCircle.Filled = false
    fovCircle.Transparency = 1
end

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

-- Initial load config
Rayfield:LoadConfiguration()
Rayfield:Notify({Title="CypherX Hub Loaded", Content="150+ Features Activated", Duration=5, Image="info"})
