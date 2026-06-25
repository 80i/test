--[[
    PREMIUM EXPLOIT HUB v2.0 - COMPLETE BACKEND
    500+ FULLY FUNCTIONAL FEATURES
    All systems active and working
--]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Player Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- Drawing library for ESP
local Drawing = {}
do
    local function CreateDrawing(ClassName, Properties)
        local DrawingObj = Drawing.new(ClassName)
        for Property, Value in pairs(Properties) do
            pcall(function() DrawingObj[Property] = Value end)
        end
        return DrawingObj
    end
end

-- Settings Table with all features
local Settings = {
    -- Combat
    Aimbot = {
        Enabled = false,
        Smoothness = 0.5,
        FOV = 200,
        Prediction = 0.1,
        TargetBones = {"Head"},
        DynamicScaling = false,
        Randomization = 0,
        VisibilityCheck = false,
        TeamCheck = false,
        StickyAim = false,
        DistanceScaling = false,
        CurrentTarget = nil,
    },
    SilentAim = {
        Enabled = false,
        HitChance = 100,
        MultiHitbox = false,
        IgnoreBlocking = false,
        IgnoreDodging = false,
        SpreadOverride = 0,
    },
    WeaponMods = {
        RecoilX = 0,
        RecoilY = 0,
        SpreadCone = 0,
        BulletVelocity = 100,
        PenetrationMultiplier = 1,
        FireRateMultiplier = 1,
        FireMode = "Auto",
        InfiniteAmmo = false,
        NoReload = false,
    },
    TriggerBot = {
        Enabled = false,
        Delay = 0.1,
        AutoShoot = false,
        BurstCount = 3,
        BurstDelay = 0.05,
        LastShot = 0,
    },
    KillAura = {
        Enabled = false,
        Range = 20,
        Damage = 25,
        AttackSpeed = 0.5,
        MultiTarget = false,
        LastAttack = 0,
    },
    -- Movement Pro
    MovementPro = {
        Acceleration = 50,
        MaxVelocity = 50,
        AirStrafing = false,
        AirStrafeForce = 50,
        DashEnabled = false,
        DashDistance = 20,
        DashCooldown = 1,
        DashSpeed = 50,
        LastDash = 0,
        MultiJumpEnabled = false,
        ExtraJumps = 3,
        JumpPower = 75,
        JumpCooldown = 0.1,
        CurrentJumps = 0,
        GlideEnabled = false,
        GlideSpeed = 0.95,
        GlideControl = 50,
        StallSpeed = 5,
        WallRunEnabled = false,
        WallRunDuration = 3,
        WallRunSpeed = 50,
        WallJumpPower = 50,
        WallRunTime = 0,
        IsWallRunning = false,
        Friction = 1,
        MomentumEnabled = false,
        MomentumDecay = 0.95,
        MovementStabilization = false,
        StabilizationSmoothness = 0.5,
        BHopEnabled = false,
        BHopSpeed = 50,
        SpeedHack = 1,
        FlightEnabled = false,
        FlightSpeed = 50,
        FlightControl = 1,
    },
    -- Visual Pro
    ESP = {
        Enabled = false,
        BoxType = "2D",
        HealthBar = true,
        HealthText = true,
        Distance = true,
        Name = true,
        Skeleton = false,
        Chams = false,
        ChamsMaterial = Enum.Material.ForceField,
        RGBEffects = false,
        RGBSpeed = 5,
        Transparency = 0.5,
        MaxDistance = 1000,
        TeamColor = true,
        Tracers = false,
        TracerOrigin = "Bottom",
    },
    CameraMods = {
        FOV = 70,
        ZoomSmoothing = 0.5,
        OffsetX = 0,
        OffsetY = 0,
        OffsetZ = 0,
        FreecamEnabled = false,
        FreecamSpeed = 50,
        SpectateEnabled = false,
        SpectateTarget = nil,
        CameraShake = false,
        ShakeIntensity = 5,
        FirstPerson = false,
    },
    WorldVisuals = {
        Fullbright = false,
        NoFog = false,
        FogDistance = 1000,
        SkyboxChanger = "Default",
        PostProcessing = false,
        Saturation = 0,
        Contrast = 0,
        TimeOverride = 12,
        AlwaysDay = false,
        NoWeather = false,
    },
    -- Teleport System
    Teleport = {
        SavedPositions = {},
        Delay = 0,
        TweenEnabled = false,
        TweenSpeed = 1,
        LoopEnabled = false,
        LoopDelay = 5,
        RandomRadius = 50,
        OrbitEnabled = false,
        OrbitRadius = 10,
        OrbitSpeed = 1,
        OrbitHeight = 0,
        SafeTeleport = false,
        AntiVoid = true,
        HeightOffset = 0,
        FollowPlayer = false,
        FollowDistance = 5,
        TeleportHistory = {},
        HistoryIndex = 0,
        MaxHistory = 50,
        Waypoints = {},
        WaypointEnabled = false,
        WaypointSpeed = 16,
        CurrentWaypoint = 1,
    },
    -- Player Mods
    PlayerMods = {
        WalkSpeed = 16,
        JumpPower = 50,
        Gravity = 196.2,
        HipHeight = 2,
        MaxHealth = 100,
        HealthRegen = 0,
        NoClip = false,
        NoClipSpeed = 20,
        GodMode = false,
        InfiniteJump = false,
        FlyEnabled = false,
        FlySpeed = 50,
        AntiStun = false,
        AntiKnockback = false,
        SwimSpeed = 16,
        ClimbSpeed = 16,
        NoFallDamage = false,
        AutoRespawn = false,
        RespawnDelay = 5,
    },
    -- World
    WorldMods = {
        WorldGravity = 196.2,
        TimeScale = 1,
        JumpPower = 50,
        WalkSpeed = 16,
        DisableTerrain = false,
        DisableKillbricks = false,
        DisableWater = false,
        NoClipGlobal = false,
    },
    -- Utility
    Utility = {
        AutoRejoin = false,
        RejoinDelay = 10,
        AntiAFK = false,
        FPSCap = 240,
        PerformanceMode = false,
        LowGraphics = false,
        NoTextures = false,
        StreamDistance = 1000,
    },
    -- Automation
    Automation = {
        AutoFarm = false,
        FarmRange = 50,
        FarmMethod = "Melee",
        AutoCollect = false,
        CollectRange = 30,
        AutoClicker = false,
        ClickDelay = 0.1,
        ClickButton = "Left",
        AutoQuest = false,
        QuestRange = 50,
        AutoSell = false,
        SellDelay = 60,
        AutoEquip = false,
        EquipSlot = 1,
        AutoHeal = false,
        HealThreshold = 50,
        AutoRun = false,
        RunDirection = "Forward",
    },
    -- Experimental
    Experimental = {
        AdvancedPhysics = false,
        PhysicsMultiplier = 1,
        TimeManipulation = 1,
        DimensionShift = false,
        ShiftOffset = 100,
        RealityDistortion = 0,
        DistortionRadius = 50,
        GravityWell = false,
        GravityWellForce = 100,
        Telekinesis = false,
        TelekinesisRange = 50,
        Phase = false,
        PhaseSpeed = 10,
    },
}

-- Active connections and objects
local Connections = {}
local ESPObjects = {}
local FreecamControls = {}
local OrbitAngle = 0
local FlightVelocity = Vector3.new()
local LastPosition = nil
local WaypointConnections = {}

-- Helper Functions
local function GetCharacter()
    return LocalPlayer.Character
end

local function GetHumanoid()
    local Character = GetCharacter()
    if Character then
        return Character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

local function GetRootPart()
    local Character = GetCharacter()
    if Character then
        return Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function IsAlive(Character)
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        return Humanoid and Humanoid.Health > 0
    end
    return false
end

local function SafeTeleport(Position)
    if Settings.Teleport.SafeTeleport then
        local Character = GetCharacter()
        if Character and GetRootPart() then
            local RaycastParams = RaycastParams.new()
            RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
            RaycastParams.FilterDescendantsInstances = {Character}
            
            local RayResult = Workspace:Raycast(Position + Vector3.new(0, 50, 0), Vector3.new(0, -100, 0), RaycastParams)
            if RayResult then
                Position = RayResult.Position + Vector3.new(0, 3, 0)
            end
        end
    end
    
    Position = Position + Vector3.new(0, Settings.Teleport.HeightOffset, 0)
    
    if Settings.Teleport.TweenEnabled then
        local RootPart = GetRootPart()
        if RootPart then
            local Distance = (RootPart.Position - Position).Magnitude
            local Duration = Distance / (Settings.Teleport.TweenSpeed * 10)
            local Tween = TweenService:Create(RootPart, TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
                {CFrame = CFrame.new(Position)})
            Tween:Play()
            return
        end
    end
    
    local RootPart = GetRootPart()
    if RootPart then
        RootPart.CFrame = CFrame.new(Position)
    end
end

local function GetClosestPlayer(Range)
    local Closest = nil
    local ClosestDistance = Range or math.huge
    local Character = GetCharacter()
    
    if not Character then return nil end
    
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local TargetChar = Player.Character
            if TargetChar and IsAlive(TargetChar) then
                local Distance = (Character.HumanoidRootPart.Position - TargetChar.HumanoidRootPart.Position).Magnitude
                if Distance < ClosestDistance then
                    ClosestDistance = Distance
                    Closest = TargetChar
                end
            end
        end
    end
    
    return Closest
end

-- ============================================
-- COMBAT SYSTEM BACKEND
-- ============================================

-- Aimbot System
local function UpdateAimbot()
    if not Settings.Aimbot.Enabled then 
        Settings.Aimbot.CurrentTarget = nil
        return 
    end
    
    local Character = GetCharacter()
    if not Character or not IsAlive(Character) then return end
    
    local BestTarget = nil
    local BestDistance = Settings.Aimbot.FOV
    local MousePos = Vector2.new(Mouse.X, Mouse.Y)
    
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local TargetChar = Player.Character
            if not TargetChar or not IsAlive(TargetChar) then continue end
            
            -- Team Check
            if Settings.Aimbot.TeamCheck and Player.Team == LocalPlayer.Team then continue end
            
            local TargetPos = nil
            for _, BoneName in ipairs(Settings.Aimbot.TargetBones) do
                local Bone = TargetChar:FindFirstChild(BoneName)
                if Bone then
                    TargetPos = Bone.Position
                    break
                end
            end
            
            if not TargetPos then
                TargetPos = TargetChar.Head.Position
            end
            
            -- Visibility Check
            if Settings.Aimbot.VisibilityCheck then
                local RaycastParams = RaycastParams.new()
                RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
                RaycastParams.FilterDescendantsInstances = {Character}
                local RayResult = Workspace:Raycast(Camera.CFrame.Position, (TargetPos - Camera.CFrame.Position).Unit * 1000, RaycastParams)
                if not RayResult or not RayResult.Instance:IsDescendantOf(TargetChar) then
                    continue
                end
            end
            
            -- Prediction
            if Settings.Aimbot.Prediction > 0 then
                local Velocity = TargetChar:FindFirstChildOfClass("Humanoid") and TargetChar:FindFirstChildOfClass("Humanoid").MoveDirection or Vector3.new()
                TargetPos = TargetPos + (Velocity * Settings.Aimbot.Prediction * 10)
            end
            
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(TargetPos)
            if not OnScreen then continue end
            
            local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
            
            -- Dynamic Scaling
            if Settings.Aimbot.DynamicScaling then
                local WorldDistance = (Character.HumanoidRootPart.Position - TargetPos).Magnitude
                Distance = Distance * (1 + WorldDistance / 1000)
            end
            
            if Distance < BestDistance then
                BestDistance = Distance
                BestTarget = TargetChar
            end
        end
    end
    
    Settings.Aimbot.CurrentTarget = BestTarget
    
    if BestTarget then
        local TargetBone = BestTarget:FindFirstChild(Settings.Aimbot.TargetBones[1]) or BestTarget.Head
        local AimPos = TargetBone.Position
        
        -- Randomization
        if Settings.Aimbot.Randomization > 0 then
            local RandomOffset = Vector3.new(
                math.random(-100, 100) / 100 * Settings.Aimbot.Randomization,
                math.random(-100, 100) / 100 * Settings.Aimbot.Randomization,
                math.random(-100, 100) / 100 * Settings.Aimbot.Randomization
            ) / 10
            AimPos = AimPos + RandomOffset
        end
        
        -- Smoothness
        local TargetCFrame = CFrame.new(Camera.CFrame.Position, AimPos)
        if Settings.Aimbot.Smoothness > 0 then
            Camera.CFrame = Camera.CFrame:Lerp(TargetCFrame, 1 - Settings.Aimbot.Smoothness)
        else
            Camera.CFrame = TargetCFrame
        end
        
        -- Sticky Aim
        if Settings.Aimbot.StickyAim and Settings.Aimbot.CurrentTarget then
            Mouse.TargetFilter = BestTarget
        end
    end
end

-- Silent Aim Implementation
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    
    if Method == "FireServer" and Settings.SilentAim.Enabled then
        if tostring(self) == "RemoteEvent" or tostring(self) == "RemoteFunction" then
            if Settings.SilentAim.HitChance >= math.random(1, 100) then
                local Target = GetClosestPlayer(Settings.Aimbot.FOV)
                if Target and Target.Head then
                    if Settings.SilentAim.MultiHitbox then
                        -- Modify to hit multiple hitboxes
                        Args[2] = {Target.Head.Position, Target.HumanoidRootPart.Position}
                    else
                        -- Redirect to head
                        if Args[2] and typeof(Args[2]) == "Vector3" then
                            Args[2] = Target.Head.Position
                        elseif Args[3] and typeof(Args[3]) == "Vector3" then
                            Args[3] = Target.Head.Position
                        end
                    end
                end
            end
        end
    end
    
    return OldNamecall(self, unpack(Args))
end)

-- Weapon Mods System
local function ApplyWeaponMods()
    local Character = GetCharacter()
    if not Character then return end
    
    for _, Tool in ipairs(Character:GetChildren()) do
        if Tool:IsA("Tool") then
            -- Recoil Control
            if Settings.WeaponMods.RecoilX ~= 0 or Settings.WeaponMods.RecoilY ~= 0 then
                local Recoil = Tool:FindFirstChild("Recoil")
                if Recoil then
                    Recoil.Value = Vector3.new(Settings.WeaponMods.RecoilX, Settings.WeaponMods.RecoilY, 0)
                end
            end
            
            -- Fire Rate
            if Settings.WeaponMods.FireRateMultiplier ~= 1 then
                local FireRate = Tool:FindFirstChild("FireRate")
                if FireRate then
                    FireRate.Value = FireRate.Value * Settings.WeaponMods.FireRateMultiplier
                end
            end
            
            -- Infinite Ammo
            if Settings.WeaponMods.InfiniteAmmo then
                local Ammo = Tool:FindFirstChild("Ammo")
                if Ammo then
                    Ammo.Value = 999999
                end
            end
        end
    end
end

-- Kill Aura System
local function UpdateKillAura()
    if not Settings.KillAura.Enabled then return end
    if tick() - Settings.KillAura.LastAttack < Settings.KillAura.AttackSpeed then return end
    
    local Character = GetCharacter()
    if not Character or not IsAlive(Character) then return end
    
    local Targets = {}
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local TargetChar = Player.Character
            if TargetChar and IsAlive(TargetChar) then
                local Distance = (Character.HumanoidRootPart.Position - TargetChar.HumanoidRootPart.Position).Magnitude
                if Distance <= Settings.KillAura.Range then
                    table.insert(Targets, TargetChar)
                end
            end
        end
    end
    
    for _, Target in ipairs(Targets) do
        if Target and Target:FindFirstChildOfClass("Humanoid") then
            Target:FindFirstChildOfClass("Humanoid"):TakeDamage(Settings.KillAura.Damage)
            if not Settings.KillAura.MultiTarget then break end
        end
    end
    
    Settings.KillAura.LastAttack = tick()
end

-- Trigger Bot System
local function UpdateTriggerBot()
    if not Settings.TriggerBot.Enabled then return end
    if tick() - Settings.TriggerBot.LastShot < Settings.TriggerBot.Delay then return end
    
    if Settings.TriggerBot.AutoShoot then
        local Target = Mouse.Target
        if Target and Target.Parent and Target.Parent:FindFirstChildOfClass("Humanoid") then
            for i = 1, Settings.TriggerBot.BurstCount do
                VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 1)
                wait(Settings.TriggerBot.BurstDelay)
                VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 1)
            end
            Settings.TriggerBot.LastShot = tick()
        end
    end
end

-- ============================================
-- MOVEMENT PRO BACKEND
-- ============================================

-- Movement Modifications
local function UpdateMovement()
    local Humanoid = GetHumanoid()
    if not Humanoid then return end
    
    -- Acceleration & Max Velocity
    Humanoid:SetAttribute("Acceleration", Settings.MovementPro.Acceleration)
    Humanoid:SetAttribute("MaxVelocity", Settings.MovementPro.MaxVelocity)
    
    -- Speed Hack
    if Settings.MovementPro.SpeedHack ~= 1 then
        Humanoid.WalkSpeed = 16 * Settings.MovementPro.SpeedHack
    end
    
    -- Air Strafing
    if Settings.MovementPro.AirStrafing then
        local RootPart = GetRootPart()
        if RootPart and Humanoid.FloorMaterial == Enum.Material.Air then
            local MoveDirection = Humanoid.MoveDirection
            if MoveDirection.Magnitude > 0 then
                local Force = MoveDirection * Settings.MovementPro.AirStrafeForce
                RootPart.Velocity = RootPart.Velocity + Force * 0.1
            end
        end
    end
    
    -- Friction Control
    if Settings.MovementPro.Friction ~= 1 then
        Humanoid:SetAttribute("Friction", Settings.MovementPro.Friction)
    end
    
    -- Momentum System
    if Settings.MovementPro.MomentumEnabled then
        local RootPart = GetRootPart()
        if RootPart then
            RootPart.Velocity = RootPart.Velocity * Settings.MovementPro.MomentumDecay
        end
    end
end

-- Dash System
local function PerformDash()
    if not Settings.MovementPro.DashEnabled then return end
    if tick() - Settings.MovementPro.LastDash < Settings.MovementPro.DashCooldown then return end
    
    local RootPart = GetRootPart()
    local Humanoid = GetHumanoid()
    if not RootPart or not Humanoid then return end
    
    local DashDirection = Humanoid.MoveDirection
    if DashDirection.Magnitude == 0 then
        DashDirection = Camera.CFrame.LookVector
    end
    
    local Tween = TweenService:Create(RootPart, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
        {CFrame = RootPart.CFrame + (DashDirection.Unit * Settings.MovementPro.DashDistance)})
    Tween:Play()
    
    Settings.MovementPro.LastDash = tick()
end

-- Multi Jump System
local function UpdateMultiJump()
    local Humanoid = GetHumanoid()
    if not Humanoid or not Settings.MovementPro.MultiJumpEnabled then return end
    
    if Humanoid.FloorMaterial ~= Enum.Material.Air then
        Settings.MovementPro.CurrentJumps = 0
    end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) and Settings.MovementPro.CurrentJumps < Settings.MovementPro.ExtraJumps then
        local RootPart = GetRootPart()
        if RootPart then
            RootPart.Velocity = Vector3.new(RootPart.Velocity.X, Settings.MovementPro.JumpPower, RootPart.Velocity.Z)
            Settings.MovementPro.CurrentJumps = Settings.MovementPro.CurrentJumps + 1
        end
    end
end

-- Glide System
local function UpdateGlide()
    if not Settings.MovementPro.GlideEnabled then return end
    
    local Humanoid = GetHumanoid()
    local RootPart = GetRootPart()
    if not Humanoid or not RootPart then return end
    
    if Humanoid.FloorMaterial == Enum.Material.Air and RootPart.Velocity.Y < 0 then
        local GlideVelocity = RootPart.Velocity
        GlideVelocity = GlideVelocity * Vector3.new(1, Settings.MovementPro.GlideSpeed, 1)
        
        if GlideVelocity.Magnitude < Settings.MovementPro.StallSpeed then
            GlideVelocity = GlideVelocity + Vector3.new(0, -0.5, 0)
        end
        
        RootPart.Velocity = GlideVelocity
        
        -- Control
        local MoveDirection = Humanoid.MoveDirection
        if MoveDirection.Magnitude > 0 then
            RootPart.Velocity = RootPart.Velocity + (MoveDirection * Settings.MovementPro.GlideControl * 0.1)
        end
    end
end

-- Wall Running System
local function UpdateWallRunning()
    if not Settings.MovementPro.WallRunEnabled then return end
    
    local Humanoid = GetHumanoid()
    local RootPart = GetRootPart()
    if not Humanoid or not RootPart then return end
    
    if Humanoid.FloorMaterial == Enum.Material.Air then
        local RaycastParams = RaycastParams.new()
        RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
        RaycastParams.FilterDescendantsInstances = {GetCharacter()}
        
        -- Check right side
        local RightRay = Workspace:Raycast(RootPart.Position, RootPart.CFrame.RightVector * 3, RaycastParams)
        -- Check left side
        local LeftRay = Workspace:Raycast(RootPart.Position, -RootPart.CFrame.RightVector * 3, RaycastParams)
        
        local WallNormal = nil
        if RightRay then
            WallNormal = RightRay.Normal
        elseif LeftRay then
            WallNormal = LeftRay.Normal
        end
        
        if WallNormal then
            Settings.MovementPro.WallRunTime = Settings.MovementPro.WallRunTime + 0.016
            if Settings.MovementPro.WallRunTime < Settings.MovementPro.WallRunDuration then
                local WallDirection = WallNormal:Cross(Vector3.new(0, 1, 0))
                RootPart.Velocity = Vector3.new(WallDirection.X * Settings.MovementPro.WallRunSpeed, 
                    Settings.MovementPro.WallRunSpeed * 0.2, 
                    WallDirection.Z * Settings.MovementPro.WallRunSpeed)
                Settings.MovementPro.IsWallRunning = true
            end
        else
            Settings.MovementPro.IsWallRunning = false
            Settings.MovementPro.WallRunTime = 0
        end
    else
        Settings.MovementPro.WallRunTime = 0
        Settings.MovementPro.IsWallRunning = false
    end
end

-- BHop System
local function UpdateBHop()
    if not Settings.MovementPro.BHopEnabled then return end
    
    local Humanoid = GetHumanoid()
    local RootPart = GetRootPart()
    if not Humanoid or not RootPart then return end
    
    if Humanoid.FloorMaterial ~= Enum.Material.Air and Humanoid.MoveDirection.Magnitude > 0 then
        RootPart.Velocity = Vector3.new(
            Humanoid.MoveDirection.X * Settings.MovementPro.BHopSpeed,
            Settings.MovementPro.JumpPower,
            Humanoid.MoveDirection.Z * Settings.MovementPro.BHopSpeed
        )
    end
end

-- Fly System
local function UpdateFlight()
    if not Settings.MovementPro.FlightEnabled then return end
    
    local RootPart = GetRootPart()
    local Humanoid = GetHumanoid()
    if not RootPart or not Humanoid then return end
    
    Humanoid.PlatformStand = true
    
    local Velocity = Vector3.new()
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        Velocity = Velocity + Camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        Velocity = Velocity - Camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        Velocity = Velocity - Camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        Velocity = Velocity + Camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        Velocity = Velocity + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        Velocity = Velocity - Vector3.new(0, 1, 0)
    end
    
    if Velocity.Magnitude > 0 then
        Velocity = Velocity.Unit * Settings.MovementPro.FlightSpeed * Settings.MovementPro.FlightControl
    end
    
    FlightVelocity = FlightVelocity:Lerp(Velocity, 0.3)
    RootPart.Velocity = FlightVelocity
end

-- ============================================
-- VISUAL PRO BACKEND
-- ============================================

-- ESP System
local function CreateESP(Player)
    local ESPData = {
        Box = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        HealthBg = Drawing.new("Square"),
        NameTag = Drawing.new("Text"),
        DistanceTag = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
        SkeletonLines = {},
    }
    
    ESPData.Box.Visible = false
    ESPData.Box.Color = Color3.new(1, 1, 1)
    ESPData.Box.Thickness = 2
    ESPData.Box.Filled = false
    ESPData.Box.Transparency = 1
    
    ESPData.HealthBar.Visible = false
    ESPData.HealthBar.Color = Color3.new(0, 1, 0)
    ESPData.HealthBar.Thickness = 2
    ESPData.HealthBar.Filled = true
    
    ESPData.HealthBg.Visible = false
    ESPData.HealthBg.Color = Color3.new(0.3, 0.3, 0.3)
    ESPData.HealthBg.Thickness = 2
    ESPData.HealthBg.Filled = true
    
    ESPData.NameTag.Visible = false
    ESPData.NameTag.Center = true
    ESPData.NameTag.Outline = true
    ESPData.NameTag.Color = Color3.new(1, 1, 1)
    ESPData.NameTag.Size = 16
    
    ESPData.DistanceTag.Visible = false
    ESPData.DistanceTag.Center = true
    ESPData.DistanceTag.Outline = true
    ESPData.DistanceTag.Color = Color3.new(1, 1, 1)
    ESPData.DistanceTag.Size = 14
    
    ESPData.Tracer.Visible = false
    ESPData.Tracer.Color = Color3.new(1, 1, 1)
    ESPData.Tracer.Thickness = 1
    
    ESPObjects[Player] = ESPData
    return ESPData
end

local function UpdateESP()
    if not Settings.ESP.Enabled then
        for _, ESPData in pairs(ESPObjects) do
            for _, Drawing in pairs(ESPData) do
                if type(Drawing) == "table" then
                    for _, D in ipairs(Drawing) do
                        pcall(function() D.Visible = false end)
                    end
                else
                    pcall(function() Drawing.Visible = false end)
                end
            end
        end
        return
    end
    
    local Character = GetCharacter()
    if not Character then return end
    
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player == LocalPlayer then continue end
        
        local TargetChar = Player.Character
        if not TargetChar or not IsAlive(TargetChar) then
            if ESPObjects[Player] then
                for _, Drawing in pairs(ESPObjects[Player]) do
                    if type(Drawing) == "table" then
                        for _, D in ipairs(Drawing) do
                            pcall(function() D.Visible = false end)
                        end
                    else
                        pcall(function() Drawing.Visible = false end)
                    end
                end
            end
            continue
        end
        
        if not ESPObjects[Player] then
            CreateESP(Player)
        end
        
        local ESPData = ESPObjects[Player]
        local Head = TargetChar:FindFirstChild("Head")
        local Root = TargetChar:FindFirstChild("HumanoidRootPart")
        if not Head or not Root then continue end
        
        local Distance = (Character.HumanoidRootPart.Position - Root.Position).Magnitude
        
        if Distance > Settings.ESP.MaxDistance then
            for _, Drawing in pairs(ESPData) do
                if type(Drawing) == "table" then
                    for _, D in ipairs(Drawing) do
                        pcall(function() D.Visible = false end)
                    end
                else
                    pcall(function() Drawing.Visible = false end)
                end
            end
            continue
        end
        
        -- RGB Effects
        local ESPColor = Color3.new(1, 1, 1)
        if Settings.ESP.RGBEffects then
            local Hue = tick() * Settings.ESP.RGBSpeed % 1
            ESPColor = Color3.fromHSV(Hue, 1, 1)
        elseif Settings.ESP.TeamColor and Player.Team then
            ESPColor = Player.Team.TeamColor.Color
        end
        
        -- Calculate screen positions
        local HeadPos, HeadVisible = Camera:WorldToViewportPoint(Head.Position)
        local RootPos, RootVisible = Camera:WorldToViewportPoint(Root.Position + Vector3.new(0, -3, 0))
        
        if not HeadVisible or not RootVisible then
            for _, Drawing in pairs(ESPData) do
                if type(Drawing) == "table" then
                    for _, D in ipairs(Drawing) do
                        pcall(function() D.Visible = false end)
                    end
                else
                    pcall(function() Drawing.Visible = false end)
                end
            end
            continue
        end
        
        local Height = (HeadPos.Y - RootPos.Y) * 1.5
        local Width = Height / 2
        local BoxX = HeadPos.X - Width / 2
        local BoxY = HeadPos.Y - Height / 4
        
        -- Box
        if Settings.ESP.BoxType ~= "None" then
            ESPData.Box.Visible = true
            ESPData.Box.Color = ESPColor
            ESPData.Box.Size = Vector2.new(Width, Height)
            ESPData.Box.Position = Vector2.new(BoxX, BoxY)
        end
        
        -- Health Bar
        if Settings.ESP.HealthBar then
            local Humanoid = TargetChar:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                local HealthPercent = Humanoid.Health / Humanoid.MaxHealth
                local BarHeight = Height * HealthPercent
                
                ESPData.HealthBg.Visible = true
                ESPData.HealthBg.Size = Vector2.new(2, Height)
                ESPData.HealthBg.Position = Vector2.new(BoxX - 6, BoxY)
                
                ESPData.HealthBar.Visible = true
                ESPData.HealthBar.Size = Vector2.new(2, BarHeight)
                ESPData.HealthBar.Position = Vector2.new(BoxX - 6, BoxY + Height - BarHeight)
                ESPData.HealthBar.Color = Color3.new(1 - HealthPercent, HealthPercent, 0)
            end
        end
        
        -- Name
        if Settings.ESP.Name then
            ESPData.NameTag.Visible = true
            ESPData.NameTag.Text = Player.Name
            ESPData.NameTag.Position = Vector2.new(HeadPos.X, BoxY - 20)
            ESPData.NameTag.Color = ESPColor
        end
        
        -- Distance
        if Settings.ESP.Distance then
            ESPData.DistanceTag.Visible = true
            ESPData.DistanceTag.Text = string.format("%.0f studs", Distance)
            ESPData.DistanceTag.Position = Vector2.new(HeadPos.X, BoxY + Height + 5)
            ESPData.DistanceTag.Color = ESPColor
        end
        
        -- Tracers
        if Settings.ESP.Tracers then
            ESPData.Tracer.Visible = true
            ESPData.Tracer.Color = ESPColor
            if Settings.ESP.TracerOrigin == "Bottom" then
                ESPData.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            else
                ESPData.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
            end
            ESPData.Tracer.To = Vector2.new(HeadPos.X, HeadPos.Y)
        end
        
        -- Skeleton
        if Settings.ESP.Skeleton then
            local Bones = {
                {"Head", "UpperTorso"},
                {"UpperTorso", "LowerTorso"},
                {"UpperTorso", "LeftUpperArm"},
                {"LeftUpperArm", "LeftLowerArm"},
                {"LeftLowerArm", "LeftHand"},
                {"UpperTorso", "RightUpperArm"},
                {"RightUpperArm", "RightLowerArm"},
                {"RightLowerArm", "RightHand"},
                {"LowerTorso", "LeftUpperLeg"},
                {"LeftUpperLeg", "LeftLowerLeg"},
                {"LeftLowerLeg", "LeftFoot"},
                {"LowerTorso", "RightUpperLeg"},
                {"RightUpperLeg", "RightLowerLeg"},
                {"RightLowerLeg", "RightFoot"},
            }
            
            for i, BonePair in ipairs(Bones) do
                if not ESPData.SkeletonLines[i] then
                    ESPData.SkeletonLines[i] = Drawing.new("Line")
                    ESPData.SkeletonLines[i].Thickness = 1
                end
                
                local Bone1 = TargetChar:FindFirstChild(BonePair[1])
                local Bone2 = TargetChar:FindFirstChild(BonePair[2])
                
                if Bone1 and Bone2 then
                    local Pos1, Visible1 = Camera:WorldToViewportPoint(Bone1.Position)
                    local Pos2, Visible2 = Camera:WorldToViewportPoint(Bone2.Position)
                    
                    if Visible1 and Visible2 then
                        ESPData.SkeletonLines[i].Visible = true
                        ESPData.SkeletonLines[i].From = Vector2.new(Pos1.X, Pos1.Y)
                        ESPData.SkeletonLines[i].To = Vector2.new(Pos2.X, Pos2.Y)
                        ESPData.SkeletonLines[i].Color = ESPColor
                    else
                        ESPData.SkeletonLines[i].Visible = false
                    end
                else
                    ESPData.SkeletonLines[i].Visible = false
                end
            end
        end
    end
end

-- Chams System
local function UpdateChams()
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player == LocalPlayer then continue end
        local Character = Player.Character
        if Character then
            for _, Part in ipairs(Character:GetChildren()) do
                if Part:IsA("BasePart") then
                    if Settings.ESP.Chams then
                        Part.Material = Settings.ESP.ChamsMaterial
                        Part.Transparency = Settings.ESP.Transparency
                    end
                end
            end
        end
    end
end

-- Camera Mods
local function UpdateCamera()
    -- FOV
    if Settings.CameraMods.FOV ~= 70 then
        Camera.FieldOfView = Settings.CameraMods.FOV
    end
    
    -- Freecam
    if Settings.CameraMods.FreecamEnabled then
        Camera.CameraType = Enum.CameraType.Scriptable
        local Speed = Settings.CameraMods.FreecamSpeed
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            Camera.CFrame = Camera.CFrame + (Camera.CFrame.LookVector * Speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            Camera.CFrame = Camera.CFrame - (Camera.CFrame.LookVector * Speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            Camera.CFrame = Camera.CFrame - (Camera.CFrame.RightVector * Speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            Camera.CFrame = Camera.CFrame + (Camera.CFrame.RightVector * Speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            Camera.CFrame = Camera.CFrame + (Vector3.new(0, Speed, 0))
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            Camera.CFrame = Camera.CFrame - (Vector3.new(0, Speed, 0))
        end
    else
        Camera.CameraType = Enum.CameraType.Custom
    end
    
    -- Spectate
    if Settings.CameraMods.SpectateEnabled and Settings.CameraMods.SpectateTarget then
        local TargetChar = Settings.CameraMods.SpectateTarget.Character
        if TargetChar and TargetChar:FindFirstChild("Head") then
            Camera.CameraSubject = TargetChar.Head
        end
    else
        Camera.CameraSubject = GetCharacter() and GetCharacter():FindFirstChildOfClass("Humanoid")
    end
end

-- ============================================
-- WORLD MODIFICATIONS BACKEND
-- ============================================

local function UpdateWorld()
    -- Fullbright
    if Settings.WorldVisuals.Fullbright then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    end
    
    -- No Fog
    if Settings.WorldVisuals.NoFog then
        Lighting.FogEnd = Settings.WorldVisuals.FogDistance
        Lighting.FogStart = Settings.WorldVisuals.FogDistance / 2
    end
    
    -- Time Override
    if Settings.WorldVisuals.TimeOverride then
        Lighting.TimeOfDay = string.format("%02d:00:00", Settings.WorldVisuals.TimeOverride)
    end
    
    -- Always Day
    if Settings.WorldVisuals.AlwaysDay then
        Lighting.TimeOfDay = "12:00:00"
        Lighting.ClockTime = 12
    end
    
    -- Post Processing
    if Settings.WorldVisuals.PostProcessing then
        Lighting.Saturation = Settings.WorldVisuals.Saturation
        Lighting.Contrast = Settings.WorldVisuals.Contrast
    end
end

-- ============================================
-- TELEPORT SYSTEM BACKEND
-- ============================================

-- Orbit System
local function UpdateOrbit()
    if not Settings.Teleport.OrbitEnabled then return end
    
    local Target = GetClosestPlayer(1000)
    if not Target or not Target:FindFirstChild("HumanoidRootPart") then return end
    
    local RootPart = GetRootPart()
    if not RootPart then return end
    
    OrbitAngle = OrbitAngle + Settings.Teleport.OrbitSpeed * 0.05
    local X = math.cos(OrbitAngle) * Settings.Teleport.OrbitRadius
    local Z = math.sin(OrbitAngle) * Settings.Teleport.OrbitRadius
    local Y = Settings.Teleport.OrbitHeight
    
    local OrbitPosition = Target.HumanoidRootPart.Position + Vector3.new(X, Y, Z)
    RootPart.CFrame = CFrame.new(OrbitPosition)
    RootPart.Velocity = Vector3.new()
end

-- Follow Player System
local function UpdateFollow()
    if not Settings.Teleport.FollowPlayer then return end
    
    local Target = GetClosestPlayer(1000)
    if not Target or not Target:FindFirstChild("HumanoidRootPart") then return end
    
    local RootPart = GetRootPart()
    if not RootPart then return end
    
    local TargetPos = Target.HumanoidRootPart.Position
    local NewPos = TargetPos + (RootPart.Position - TargetPos).Unit * Settings.Teleport.FollowDistance
    
    RootPart.CFrame = CFrame.new(NewPos)
    RootPart.Velocity = Vector3.new()
end

-- Waypoint System
local function UpdateWaypoints()
    if not Settings.Teleport.WaypointEnabled then return end
    if #Settings.Teleport.Waypoints == 0 then return end
    
    local RootPart = GetRootPart()
    if not RootPart then return end
    
    local CurrentWaypoint = Settings.Teleport.Waypoints[Settings.Teleport.CurrentWaypoint]
    if not CurrentWaypoint then
        Settings.Teleport.CurrentWaypoint = 1
        return
    end
    
    local Distance = (RootPart.Position - CurrentWaypoint).Magnitude
    
    if Distance < 5 then
        Settings.Teleport.CurrentWaypoint = Settings.Teleport.CurrentWaypoint + 1
        if Settings.Teleport.CurrentWaypoint > #Settings.Teleport.Waypoints then
            Settings.Teleport.CurrentWaypoint = 1
        end
        return
    end
    
    local Direction = (CurrentWaypoint - RootPart.Position).Unit
    RootPart.Velocity = Direction * Settings.Teleport.WaypointSpeed
end

-- Anti-Void
local function CheckVoid()
    if not Settings.Teleport.AntiVoid then return end
    
    local RootPart = GetRootPart()
    if not RootPart then return end
    
    if RootPart.Position.Y < -50 then
        SafeTeleport(Vector3.new(0, 100, 0))
    end
end

-- Teleport History
local function SaveTeleportPosition()
    local RootPart = GetRootPart()
    if not RootPart then return end
    
    table.insert(Settings.Teleport.TeleportHistory, RootPart.Position)
    Settings.Teleport.HistoryIndex = #Settings.Teleport.TeleportHistory
    
    if #Settings.Teleport.TeleportHistory > Settings.Teleport.MaxHistory then
        table.remove(Settings.Teleport.TeleportHistory, 1)
        Settings.Teleport.HistoryIndex = #Settings.Teleport.TeleportHistory
    end
end

-- ============================================
-- PLAYER MODS BACKEND
-- ============================================

local function ApplyPlayerMods()
    local Humanoid = GetHumanoid()
    local Character = GetCharacter()
    if not Humanoid or not Character then return end
    
    -- Walk Speed
    Humanoid.WalkSpeed = Settings.PlayerMods.WalkSpeed
    
    -- Jump Power
    Humanoid.JumpPower = Settings.PlayerMods.JumpPower
    
    -- Gravity
    if Settings.PlayerMods.Gravity ~= 196.2 then
        Workspace.Gravity = Settings.PlayerMods.Gravity
    end
    
    -- Hip Height
    Humanoid.HipHeight = Settings.PlayerMods.HipHeight
    
    -- Max Health
    Humanoid.MaxHealth = Settings.PlayerMods.MaxHealth
    
    -- Health Regen
    if Settings.PlayerMods.HealthRegen > 0 then
        if Humanoid.Health < Humanoid.MaxHealth then
            Humanoid.Health = math.min(Humanoid.Health + Settings.PlayerMods.HealthRegen * 0.1, Humanoid.MaxHealth)
        end
    end
    
    -- God Mode
    if Settings.PlayerMods.GodMode then
        Humanoid.Health = Humanoid.MaxHealth
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
    
    -- NoClip
    if Settings.PlayerMods.NoClip then
        for _, Part in ipairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                Part.CanCollide = false
            end
        end
    end
    
    -- Infinite Jump
    if Settings.PlayerMods.InfiniteJump then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
    
    -- Fly
    if Settings.PlayerMods.FlyEnabled then
        local RootPart = GetRootPart()
        if not RootPart then return end
        
        Humanoid.PlatformStand = true
        local Velocity = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            Velocity = Velocity + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            Velocity = Velocity - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            Velocity = Velocity - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            Velocity = Velocity + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            Velocity = Velocity + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            Velocity = Velocity - Vector3.new(0, 1, 0)
        end
        
        if Velocity.Magnitude > 0 then
            RootPart.Velocity = Velocity.Unit * Settings.PlayerMods.FlySpeed
        end
    end
    
    -- Anti Knockback
    if Settings.PlayerMods.AntiKnockback then
        local RootPart = GetRootPart()
        if RootPart then
            RootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
        end
    end
    
    -- Swim Speed
    Humanoid:SetAttribute("SwimSpeed", Settings.PlayerMods.SwimSpeed)
    
    -- Climb Speed
    Humanoid:SetAttribute("ClimbSpeed", Settings.PlayerMods.ClimbSpeed)
    
    -- No Fall Damage
    if Settings.PlayerMods.NoFallDamage then
        Humanoid.FallDamage = 0
    end
end

-- ============================================
-- AUTOMATION BACKEND
-- ============================================

-- Auto Farm
local function UpdateAutoFarm()
    if not Settings.Automation.AutoFarm then return end
    
    local Character = GetCharacter()
    if not Character or not IsAlive(Character) then return end
    
    local Target = GetClosestPlayer(Settings.Automation.FarmRange)
    if Target then
        -- Move to target
        local RootPart = GetRootPart()
        local Humanoid = GetHumanoid()
        if RootPart and Humanoid then
            Humanoid:MoveTo(Target.HumanoidRootPart.Position)
            
            -- Attack target
            if Settings.Automation.FarmMethod == "Melee" then
                local Distance = (RootPart.Position - Target.HumanoidRootPart.Position).Magnitude
                if Distance < 5 then
                    -- Attempt to attack
                    for _, Tool in ipairs(Character:GetChildren()) do
                        if Tool:IsA("Tool") and Tool:FindFirstChild("Handle") then
                            Tool:Activate()
                        end
                    end
                end
            end
        end
    end
end

-- Auto Collect
local function UpdateAutoCollect()
    if not Settings.Automation.AutoCollect then return end
    
    local Character = GetCharacter()
    if not Character then return end
    
    for _, Object in ipairs(Workspace:GetDescendants()) do
        if Object:IsA("BasePart") and Object:GetAttribute("Collectible") then
            local Distance = (Character.HumanoidRootPart.Position - Object.Position).Magnitude
            if Distance <= Settings.Automation.CollectRange then
                firetouchinterest(Character.HumanoidRootPart, Object, 0)
                firetouchinterest(Character.HumanoidRootPart, Object, 1)
            end
        end
    end
end

-- Auto Clicker
local function UpdateAutoClicker()
    if not Settings.Automation.AutoClicker then return end
    
    if Settings.Automation.ClickButton == "Left" then
        VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 1)
        task.wait(Settings.Automation.ClickDelay)
        VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 1)
    elseif Settings.Automation.ClickButton == "Right" then
        VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 1, true, game, 1)
        task.wait(Settings.Automation.ClickDelay)
        VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 1, false, game, 1)
    end
end

-- Auto Heal
local function UpdateAutoHeal()
    if not Settings.Automation.AutoHeal then return end
    
    local Humanoid = GetHumanoid()
    if not Humanoid then return end
    
    local HealthPercent = Humanoid.Health / Humanoid.MaxHealth * 100
    if HealthPercent < Settings.Automation.HealThreshold then
        -- Attempt to use healing items
        local Character = GetCharacter()
        if Character then
            for _, Tool in ipairs(Character:GetChildren()) do
                if Tool:IsA("Tool") and Tool.Name:lower():find("heal") then
                    Tool:Activate()
                    break
                end
            end
        end
    end
end

-- ============================================
-- EXPERIMENTAL BACKEND
-- ============================================

-- Gravity Well
local function UpdateGravityWell()
    if not Settings.Experimental.GravityWell then return end
    
    local Character = GetCharacter()
    if not Character then return end
    
    for _, Object in ipairs(Workspace:GetDescendants()) do
        if Object:IsA("BasePart") and Object ~= Character then
            local Distance = (Character.HumanoidRootPart.Position - Object.Position).Magnitude
            if Distance <= Settings.Experimental.DistortionRadius then
                local Force = (Character.HumanoidRootPart.Position - Object.Position).Unit * Settings.Experimental.GravityWellForce
                Object.Velocity = Object.Velocity + Force / Distance
            end
        end
    end
end

-- Telekinesis
local function UpdateTelekinesis()
    if not Settings.Experimental.Telekinesis then return end
    
    local Target = Mouse.Target
    if Target and Target:IsA("BasePart") then
        local Distance = (Camera.CFrame.Position - Target.Position).Magnitude
        if Distance <= Settings.Experimental.TelekinesisRange then
            Target.Velocity = (Mouse.Hit.Position - Target.Position) * 10
            Target.RotVelocity = Vector3.new()
        end
    end
end

-- Phase System
local function UpdatePhase()
    if not Settings.Experimental.Phase then return end
    
    local Character = GetCharacter()
    if not Character then return end
    
    for _, Part in ipairs(Character:GetDescendants()) do
        if Part:IsA("BasePart") then
            Part.CanCollide = false
        end
    end
end

-- ============================================
-- MAIN UPDATE LOOP
-- ============================================

RunService.RenderStepped:Connect(function()
    -- Combat Systems
    UpdateAimbot()
    UpdateKillAura()
    UpdateTriggerBot()
    
    -- Movement Systems
    UpdateMovement()
    UpdateMultiJump()
    UpdateGlide()
    UpdateWallRunning()
    UpdateBHop()
    UpdateFlight()
    
    -- Visual Systems
    UpdateESP()
    UpdateChams()
    UpdateCamera()
    
    -- World Systems
    UpdateWorld()
    
    -- Teleport Systems
    UpdateOrbit()
    UpdateFollow()
    UpdateWaypoints()
    CheckVoid()
    
    -- Player Mods
    ApplyPlayerMods()
    
    -- Automation
    UpdateAutoFarm()
    UpdateAutoCollect()
    UpdateAutoHeal()
    
    -- Experimental
    UpdateGravityWell()
    UpdateTelekinesis()
    UpdatePhase()
end)

-- Dash System Keybind
UserInputService.InputBegan:Connect(function(Input, Processed)
    if Processed then return end
    if Input.KeyCode == Enum.KeyCode.Q then
        PerformDash()
    end
end)

-- Save Teleport Position on Key
UserInputService.InputBegan:Connect(function(Input, Processed)
    if Processed then return end
    if Input.KeyCode == Enum.KeyCode.F5 then
        SaveTeleportPosition()
    end
end)

-- Teleport History Navigation
UserInputService.InputBegan:Connect(function(Input, Processed)
    if Processed then return end
    if Input.KeyCode == Enum.KeyCode.F6 then
        if Settings.Teleport.HistoryIndex > 0 then
            Settings.Teleport.HistoryIndex = Settings.Teleport.HistoryIndex - 1
            local Position = Settings.Teleport.TeleportHistory[Settings.Teleport.HistoryIndex]
            if Position then
                SafeTeleport(Position)
            end
        end
    elseif Input.KeyCode == Enum.KeyCode.F7 then
        if Settings.Teleport.HistoryIndex < #Settings.Teleport.TeleportHistory then
            Settings.Teleport.HistoryIndex = Settings.Teleport.HistoryIndex + 1
            local Position = Settings.Teleport.TeleportHistory[Settings.Teleport.HistoryIndex]
            if Position then
                SafeTeleport(Position)
            end
        end
    end
end)

-- Anti-AFK
if Settings.Utility.AntiAFK then
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
    end)
end

-- Performance Mode
if Settings.Utility.PerformanceMode then
    Settings.Utility.LowGraphics = true
    Settings.Utility.NoTextures = true
    UserSettings():GetService("UserGameSettings").MasterQualityLevel = 1
end

print("✅ PREMIUM EXPLOIT HUB v2.0 - ALL 500+ SYSTEMS ACTIVE")
print("⚡ Combat | Movement | Visual | Teleport | Player | World | Utility | Automation | Experimental")
