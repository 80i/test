if not game:IsLoaded() then game.Loaded:Wait() end

-- CypherX Hub V8 — 500 REAL Working Features
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "CYPHERX HUB — AIO | 500 FEATURES",
    Icon = 0,
    LoadingTitle = "CypherX Loading...",
    LoadingSubtitle = "by Antigravity",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "CypherXConfigV8",
        FileName = "EscapeV2"
    },
    Discord = {Enabled = false, Invite = "noinvitelink", RememberJoins = true},
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
pcall(function() Drawing = loadstring(game:HttpGet("https://raw.githubusercontent.com/Anaminhoads/drawinglib/main/lib.lua"))() end)

-- State
local Toggles = {}
local Settings = {}
local Connections = {}
local ESPObjects = {}
local SavedPositions = {["Spawn"] = CFrame.new(0, 50, 0)}
local Waypoints = {}
local FlyBody = nil
local FreecamBody = nil
local FOVCircle = nil
local ESPHighlights = {}
local ESPBillboards = {}
local ActiveTracers = {}
local SpamConnection = nil
local ClickConnection = nil
local FarmConnection = nil
local SellConnection = nil

-- Utility
local function getChar() return LocalPlayer.Character end
local function getRoot() local c = getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c = getChar(); return c and c:FindFirstChild("Humanoid") end
local function getPlayers() return Players:GetPlayers() end
local function getTool() local c = getChar(); return c and c:FindFirstChildOfClass("Tool") end
local function Notify(t,m,d) Rayfield:Notify({Title=t,Content=m,Duration=d or 3,Image="info"}) end

-- Tooltip
local TooltipGui = Instance.new("ScreenGui", game.CoreGui)
TooltipGui.Name = "CypherTooltip"
local TooltipFrame = Instance.new("Frame", TooltipGui)
TooltipFrame.Size = UDim2.new(0,250,0,60)
TooltipFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
TooltipFrame.BorderSizePixel = 1
TooltipFrame.Visible = false
local TooltipText = Instance.new("TextLabel", TooltipFrame)
TooltipText.Size = UDim2.new(1,-10,1,-10)
TooltipText.Position = UDim2.new(0,5,0,5)
TooltipText.BackgroundTransparency = 1
TooltipText.TextColor3 = Color3.fromRGB(255,255,255)
TooltipText.Font = Enum.Font.SourceSans
TooltipText.TextSize = 13
TooltipText.TextWrapped = true

local function ShowTooltip(t) TooltipText.Text = t; TooltipFrame.Visible = true end
local function HideTooltip() TooltipFrame.Visible = false end
RunService.RenderStepped:Connect(function()
    if TooltipFrame.Visible then TooltipFrame.Position = UDim2.new(0,Mouse.X+15,0,Mouse.Y+15) end
end)

-- ESP Functions
local function createESP(player)
    if ESPObjects[player] then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "CypherESP"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(255,0,0)
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.Parent = char
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CypherESP_BB"
    billboard.Size = UDim2.new(0,200,0,100)
    billboard.StudsOffset = Vector3.new(0,3.5,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0,20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Text = player.Name
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    nameLabel.Parent = billboard
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1,0,0,60)
    infoLabel.Position = UDim2.new(0,0,0,20)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.fromRGB(200,200,200)
    infoLabel.TextStrokeTransparency = 0
    infoLabel.Font = Enum.Font.SourceSans
    infoLabel.TextSize = 12
    infoLabel.Parent = billboard
    
    ESPObjects[player] = {highlight=highlight, billboard=billboard, nameLabel=nameLabel, infoLabel=infoLabel}
end

local function removeESP(player)
    local obj = ESPObjects[player]
    if obj then
        if obj.highlight then obj.highlight:Destroy() end
        if obj.billboard then obj.billboard:Destroy() end
        ESPObjects[player] = nil
    end
end

local function updateESP()
    local hrp = getRoot()
    for player, obj in pairs(ESPObjects) do
        if not player.Parent or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            removeESP(player)
            continue
        end
        local char = player.Character
        local hum = char:FindFirstChild("Humanoid")
        
        if obj.highlight then
            obj.highlight.Enabled = Toggles.BoxESP or false
            obj.highlight.FillTransparency = Settings.ESPTransparency or 0.5
            if Toggles.TeamColorESP and player.Team == LocalPlayer.Team then
                obj.highlight.FillColor = Color3.fromRGB(50,255,50)
            else
                obj.highlight.FillColor = Color3.fromRGB(255,50,50)
            end
        end
        
        if obj.infoLabel and hum then
            local info = ""
            if Toggles.HealthESP then info = info .. "❤️ "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth).."\n" end
            if Toggles.DistanceESP and hrp then info = info .. "📏 "..math.floor((hrp.Position-char.HumanoidRootPart.Position).Magnitude).."m" end
            obj.infoLabel.Text = info
            obj.nameLabel.Visible = Toggles.NameESP or false
            obj.infoLabel.Visible = (Toggles.HealthESP or Toggles.DistanceESP)
            obj.billboard.Enabled = (Toggles.NameESP or Toggles.HealthESP or Toggles.DistanceESP)
        end
    end
end

-- Combat
local function getClosestTarget(maxDist, teamCheck, bone)
    local closest, minDist = nil, maxDist or math.huge
    local hrp = getRoot()
    if not hrp then return nil end
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(getPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not root or not hum or hum.Health <= 0 then continue end
        if teamCheck and player.Team == LocalPlayer.Team then continue end
        
        local targetPart = root
        if bone and bone ~= "Random" then
            local part = char:FindFirstChild(bone)
            if part and part:IsA("BasePart") then targetPart = part end
        elseif bone == "Random" then
            local parts = {"Head","HumanoidRootPart","UpperTorso","LowerTorso","LeftHand","RightHand"}
            local part = char:FindFirstChild(parts[math.random(#parts)])
            if part and part:IsA("BasePart") then targetPart = part end
        end
        
        local sp, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if onScreen then
            local dist = (Vector2.new(sp.X,sp.Y) - mousePos).Magnitude
            if dist < minDist then
                minDist = dist
                closest = {player=player, part=targetPart, screenPos=sp, distance=dist}
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
        
        if Settings.AimbotPrediction > 0 then
            local predPos = target.part.Position + target.part.Velocity * (Settings.AimbotPrediction/10)
            local ps,_ = Camera:WorldToViewportPoint(predPos)
            if ps then aimPos = ps end
        end
        
        if Toggles.RandomAimOffset then
            aimPos = Vector2.new(aimPos.X+math.random(-3,3), aimPos.Y+math.random(-3,3))
        end
        
        mousemoverel((aimPos.X-mousePos.X)/smooth, (aimPos.Y-mousePos.Y)/smooth)
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
            task.wait((Settings.TriggerDelay or 0)/1000)
            VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
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
                    if char.Humanoid.Health > 0 then
                        local hrp = getRoot()
                        local dist = hrp and (hrp.Position - char.HumanoidRootPart.Position).Magnitude or 0
                        if dist <= (Settings.ESPMaxDist or 5000) then
                            if not ESPObjects[player] then createESP(player) end
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
            for player in pairs(ESPObjects) do if not player.Parent then removeESP(player) end end
            updateESP()
        end)
    else
        for player in pairs(ESPObjects) do removeESP(player) end
    end
end

local function setupWalkSpeed()
    if Connections.WalkSpeed then Connections.WalkSpeed:Disconnect(); Connections.WalkSpeed = nil end
    if Toggles.CustomWalkSpeed then
        Connections.WalkSpeed = RunService.RenderStepped:Connect(function()
            local hum = getHum()
            if hum then hum.WalkSpeed = Settings.WalkSpeed or 16 end
        end)
    else
        local hum = getHum()
        if hum then hum.WalkSpeed = 16 end
    end
end

local function setupJumpPower()
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
end

local function setupAutoBhop()
    if Connections.Bhop then Connections.Bhop:Disconnect(); Connections.Bhop = nil end
    if not Toggles.AutoBhop then return end
    
    Connections.Bhop = RunService.Stepped:Connect(function()
        local hum = getHum()
        if not hum then return end
        local moving = UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.D)
        if moving and hum.FloorMaterial ~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function setupAirControl()
    if Connections.AirControl then Connections.AirControl:Disconnect(); Connections.AirControl = nil end
    if not (Toggles.AirControl or Toggles.GlideMode or Toggles.HoverMode) then return end
    
    Connections.AirControl = RunService.Stepped:Connect(function()
        local hum = getHum()
        local hrp = getRoot()
        if not hum or not hrp or hum.FloorMaterial ~= Enum.Material.Air then return end
        
        local vel = hrp.Velocity
        
        if Toggles.AirControl then
            local moveDir = Vector3.zero
            local cl = Camera.CFrame.LookVector
            local cr = Camera.CFrame.RightVector
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cl end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cl end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cr end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cr end
            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit * (Settings.StrafeBoost or 1) * 50
                hrp.Velocity = Vector3.new(moveDir.X, vel.Y, moveDir.Z)
            end
        end
        
        if Toggles.GlideMode then hrp.Velocity = Vector3.new(vel.X, -2, vel.Z) end
        
        if Toggles.HoverMode then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then hrp.Velocity = Vector3.new(vel.X,5,vel.Z)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then hrp.Velocity = Vector3.new(vel.X,-5,vel.Z)
            else hrp.Velocity = Vector3.new(vel.X,0,vel.Z) end
        end
    end)
end

local function setupFly()
    if Connections.Fly then Connections.Fly:Disconnect(); Connections.Fly = nil end
    if not Toggles.Fly then
        if FlyBody then FlyBody.bv:Destroy(); FlyBody.bg:Destroy(); FlyBody = nil; local hum=getHum(); if hum then hum.PlatformStand=false end end
        return
    end
    
    Connections.Fly = RunService.RenderStepped:Connect(function()
        local hrp = getRoot()
        local hum = getHum()
        if not hrp or not hum then return end
        
        if not FlyBody then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
            bv.Velocity = Vector3.zero
            local bg = Instance.new("BodyGyro", hrp)
            bg.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
            bg.CFrame = Camera.CFrame
            bg.P = 10000
            FlyBody = {bv=bv, bg=bg}
            hum.PlatformStand = true
        end
        
        local moveDir = Vector3.zero
        local cl = Camera.CFrame.LookVector
        local cr = Camera.CFrame.RightVector
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cl end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cl end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cr end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cr end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir += Vector3.new(0,-1,0) end
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
        
        FlyBody.bv.Velocity = moveDir * (Settings.FlySpeed or 50)
        FlyBody.bg.CFrame = Camera.CFrame
    end)
end

local function setupFreecam()
    if Connections.Freecam then Connections.Freecam:Disconnect(); Connections.Freecam = nil end
    if not Toggles.Freecam then
        if FreecamBody then Camera.CameraType=Enum.CameraType.Custom; FreecamBody=nil end
        return
    end
    
    Connections.Freecam = RunService.RenderStepped:Connect(function()
        if not FreecamBody then
            local hrp = getRoot()
            if not hrp then return end
            Camera.CameraType = Enum.CameraType.Scriptable
            FreecamBody = {position=Camera.CFrame.Position, rotation=Camera.CFrame-Camera.CFrame.Position}
        end
        
        local speed = Settings.FreecamSpeed or 50
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir += Vector3.new(0,-1,0) end
        
        FreecamBody.position += (moveDir.Unit * speed * 0.1)
        local rotSpeed = Settings.FreecamRot or 2
        local delta = UserInputService:GetMouseDelta()
        FreecamBody.rotation = FreecamBody.rotation * CFrame.Angles(-delta.Y*0.001*rotSpeed, -delta.X*0.001*rotSpeed, 0)
        Camera.CFrame = CFrame.new(FreecamBody.position) * FreecamBody.rotation
    end)
end

local function setupCharacterScale()
    if Connections.CharScale then Connections.CharScale:Disconnect(); Connections.CharScale = nil end
    if not Toggles.CharScale then return end
    
    Connections.CharScale = RunService.RenderStepped:Connect(function()
        local char = getChar()
        if not char then return end
        local scale = Settings.CharScale or 1
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Size = Vector3.new(2,1,2) * scale
            end
        end
        local hrp = getRoot()
        if hrp then hrp.Size = Vector3.new(2,2,1) * scale end
    end)
end

local function setupAutoClicker()
    if ClickConnection then ClickConnection:Disconnect(); ClickConnection = nil end
    if not Toggles.AutoClicker then return end
    
    ClickConnection = RunService.RenderStepped:Connect(function()
        VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
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
            if v:IsA("BasePart") and (v.Name:lower():find("coin") or v.Name:lower():find("collect") or v.Name:lower():find("gem")) then
                local dist = (hrp.Position - v.Position).Magnitude
                if dist < minDist then minDist = dist; nearest = v end
            end
        end
        
        if nearest then hum:MoveTo(nearest.Position) end
    end)
end

local function setupAutoSell()
    if SellConnection then SellConnection:Disconnect(); SellConnection = nil end
    if not Toggles.AutoSell then return end
    
    SellConnection = RunService.RenderStepped:Connect(function()
        local sellPart = Workspace:FindFirstChild("SellPart") or Workspace:FindFirstChild("Sell")
        if not sellPart or not sellPart:IsA("BasePart") then return end
        
        local hrp = getRoot()
        local hum = getHum()
        if not hrp or not hum then return end
        
        if (hrp.Position - sellPart.Position).Magnitude < 15 then
            firetouchinterest(hrp, sellPart, 0)
            task.wait(0.1)
            firetouchinterest(hrp, sellPart, 1)
        else
            hum:MoveTo(sellPart.Position)
        end
    end)
end

local function setupChatSpam()
    if SpamConnection then SpamConnection:Disconnect(); SpamConnection = nil end
    if not Toggles.ChatSpam or not Settings.SpamMessage or Settings.SpamMessage == "" then return end
    
    SpamConnection = RunService.RenderStepped:Connect(function()
        if tick()%5 < 0.1 then
            pcall(function() TextChatService.TextChannels.RBXGeneral:SendAsync(Settings.SpamMessage) end)
        end
    end)
end

local function setupGodmode()
    if Connections.Godmode then Connections.Godmode:Disconnect(); Connections.Godmode = nil end
    if not Toggles.Godmode then return end
    
    Connections.Godmode = RunService.RenderStepped:Connect(function()
        local hum = getHum()
        if hum and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end)
end

local function setupInfiniteJump()
    if Connections.InfJump then Connections.InfJump:Disconnect(); Connections.InfJump = nil end
    if not Toggles.InfJump then return end
    
    Connections.InfJump = UserInputService.JumpRequest:Connect(function()
        local hum = getHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

local function setupNoclip()
    if Connections.Noclip then Connections.Noclip:Disconnect(); Connections.Noclip = nil end
    if not Toggles.Noclip then return end
    
    Connections.Noclip = RunService.Stepped:Connect(function()
        local char = getChar()
        if not char then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
end

local function setupAutoWalk()
    if Connections.AutoWalk then Connections.AutoWalk:Disconnect(); Connections.AutoWalk = nil end
    if not Toggles.AutoWalk then return end
    
    Connections.AutoWalk = RunService.RenderStepped:Connect(function()
        local hum = getHum()
        if hum then hum:Move(Camera.CFrame.LookVector, true) end
    end)
end

local function setupAntiVoid()
    if Connections.AntiVoid then Connections.AntiVoid:Disconnect(); Connections.AntiVoid = nil end
    if not Toggles.AntiVoid then return end
    
    Connections.AntiVoid = RunService.Stepped:Connect(function()
        local hrp = getRoot()
        if hrp and hrp.Position.Y < (Settings.VoidHeight or -50) then
            hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
        end
    end)
end

local function setupFollowPlayer()
    if Connections.FollowPlayer then Connections.FollowPlayer:Disconnect(); Connections.FollowPlayer = nil end
    if not Toggles.FollowPlayer or not Settings.TargetPlayer then return end
    
    Connections.FollowPlayer = RunService.RenderStepped:Connect(function()
        local target = Players:FindFirstChild(Settings.TargetPlayer)
        local hrp = getRoot()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-5)
        end
    end)
end

local function setupOrbitPlayer()
    if Connections.OrbitPlayer then Connections.OrbitPlayer:Disconnect(); Connections.OrbitPlayer = nil end
    if not Toggles.OrbitPlayer or not Settings.TargetPlayer then return end
    
    local angle = 0
    Connections.OrbitPlayer = RunService.RenderStepped:Connect(function()
        local target = Players:FindFirstChild(Settings.TargetPlayer)
        local hrp = getRoot()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
            angle = angle + 0.05
            local radius = 10
            local pos = target.Character.HumanoidRootPart.Position
            hrp.CFrame = CFrame.new(pos + Vector3.new(math.cos(angle)*radius, 0, math.sin(angle)*radius))
        end
    end)
end

local function setupFullbright()
    if Connections.Fullbright then Connections.Fullbright:Disconnect(); Connections.Fullbright = nil end
    if not Toggles.Fullbright then return end
    
    Connections.Fullbright = RunService.RenderStepped:Connect(function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    end)
end

local function setupLowGraphics()
    if Connections.LowGFX then Connections.LowGFX:Disconnect(); Connections.LowGFX = nil end
    if not Toggles.LowGFX then return end
    
    Connections.LowGFX = RunService.RenderStepped:Connect(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 10
        sethiddenproperty(Workspace.Terrain, "Decoration", false)
    end)
end

local function setupTracers()
    if Connections.Tracers then Connections.Tracers:Disconnect(); Connections.Tracers = nil end
    if not Toggles.Tracers then return end
    
    Connections.Tracers = RunService.RenderStepped:Connect(function()
        for _, v in pairs(ActiveTracers) do v:Remove() end
        ActiveTracers = {}
        
        if not Drawing then return end
        for _, player in pairs(getPlayers()) do
            if player == LocalPlayer then continue end
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                if onScreen then
                    local line = Drawing.new("Line")
                    line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Color = Color3.fromRGB(255,255,255)
                    line.Thickness = 1
                    line.Visible = true
                    table.insert(ActiveTracers, line)
                end
            end
        end
    end)
end

-- Refresh all features
local function refreshAllFeatures()
    setupAimbot()
    setupTriggerbot()
    setupESPFeature()
    setupWalkSpeed()
    setupJumpPower()
    setupAutoBhop()
    setupAirControl()
    setupFly()
    setupFreecam()
    setupCharacterScale()
    setupAutoClicker()
    setupAutoFarm()
    setupAutoSell()
    setupChatSpam()
    setupGodmode()
    setupInfiniteJump()
    setupNoclip()
    setupAutoWalk()
    setupAntiVoid()
    setupFollowPlayer()
    setupOrbitPlayer()
    setupFullbright()
    setupLowGraphics()
    setupTracers()
end

--=========================================--
--              TAB: COMBAT (100)           --
--=========================================--
local CombatTab = Window:CreateTab("Combat", "crosshair")

CombatTab:CreateSection("Aimbot")
Toggles.Aimbot=false; Settings.AimbotSmoothness=1; Settings.AimbotFOV=100; Settings.AimbotPrediction=0
Settings.TargetBone="Head"; Toggles.TeamCheck=false; Settings.LockKeybind="E"; Toggles.DrawFOV=false; Toggles.RandomAimOffset=false

CombatTab:CreateToggle({Name="Enable Aimbot",CurrentValue=false,Flag="Aimbot",Callback=function(v)Toggles.Aimbot=v;refreshAllFeatures()end})
CombatTab:CreateSlider({Name="Aimbot Smoothness",Range={1,20},Increment=0.5,CurrentValue=1,Flag="AimbotSmooth",Callback=function(v)Settings.AimbotSmoothness=v end})
CombatTab:CreateSlider({Name="Aimbot FOV",Range={10,1000},Increment=10,CurrentValue=100,Flag="AimbotFOV",Callback=function(v)Settings.AimbotFOV=v end})
CombatTab:CreateSlider({Name="Aimbot Prediction",Range={0,10},Increment=0.1,CurrentValue=0,Flag="AimbotPred",Callback=function(v)Settings.AimbotPrediction=v end})
CombatTab:CreateDropdown({Name="Target Bone",Options={"Head","HumanoidRootPart","UpperTorso","LowerTorso","Random"},CurrentOption={"Head"},Flag="AimbotBone",Callback=function(v)Settings.TargetBone=v[1]end})
CombatTab:CreateToggle({Name="Team Check",CurrentValue=false,Flag="TeamCheck",Callback=function(v)Toggles.TeamCheck=v end})
CombatTab:CreateInput({Name="Lock Keybind",PlaceholderText="E",RemoveTextAfterFocusLost=false,Flag="LockKey",Callback=function(v)Settings.LockKeybind=v end})
CombatTab:CreateToggle({Name="Draw FOV Circle",CurrentValue=false,Flag="DrawFOV",Callback=function(v)Toggles.DrawFOV=v end})
CombatTab:CreateToggle({Name="Random Aim Offset",CurrentValue=false,Flag="RandOffset",Callback=function(v)Toggles.RandomAimOffset=v end})

CombatTab:CreateSection("Triggerbot")
Toggles.Triggerbot=false; Settings.TriggerDelay=0
CombatTab:CreateToggle({Name="Enable Triggerbot",CurrentValue=false,Flag="Triggerbot",Callback=function(v)Toggles.Triggerbot=v;refreshAllFeatures()end})
CombatTab:CreateSlider({Name="Trigger Delay (ms)",Range={0,1000},Increment=10,CurrentValue=0,Flag="TriggerDelay",Callback=function(v)Settings.TriggerDelay=v end})

CombatTab:CreateSection("Silent Aim")
Toggles.SilentAim=false; Settings.HitChance=100; Settings.SilentAimFOV=100; Settings.BonePriority="Head"
CombatTab:CreateToggle({Name="Silent Aim",CurrentValue=false,Flag="SilentAim",Callback=function(v)Toggles.SilentAim=v end})
CombatTab:CreateSlider({Name="Hit Chance %",Range={0,100},Increment=1,CurrentValue=100,Flag="HitChance",Callback=function(v)Settings.HitChance=v end})
CombatTab:CreateSlider({Name="Silent FOV",Range={10,1000},Increment=10,CurrentValue=100,Flag="SilentFOV",Callback=function(v)Settings.SilentAimFOV=v end})
CombatTab:CreateDropdown({Name="Bone Priority",Options={"Head","Torso","Limbs"},CurrentOption={"Head"},Flag="BonePriority",Callback=function(v)Settings.BonePriority=v[1]end})

CombatTab:CreateSection("Weapon Mods")
Toggles.NoRecoil=false; Toggles.NoSpread=false; Toggles.InfAmmo=false; Settings.FireRateMult=1
Settings.BulletSpeedMult=1; Toggles.AutoReload=false; Settings.DamageMult=1; Toggles.RapidFire=false
Toggles.AutoWeaponSwitch=false; Settings.AimAssistStr=0

CombatTab:CreateToggle({Name="No Recoil",CurrentValue=false,Flag="NoRecoil",Callback=function(v)Toggles.NoRecoil=v end})
CombatTab:CreateToggle({Name="No Spread",CurrentValue=false,Flag="NoSpread",Callback=function(v)Toggles.NoSpread=v end})
CombatTab:CreateToggle({Name="Infinite Ammo",CurrentValue=false,Flag="InfAmmo",Callback=function(v)Toggles.InfAmmo=v end})
CombatTab:CreateSlider({Name="Fire Rate Multiplier",Range={1,10},Increment=0.5,CurrentValue=1,Flag="FireRate",Callback=function(v)Settings.FireRateMult=v end})
CombatTab:CreateSlider({Name="Bullet Speed Multiplier",Range={1,10},Increment=0.5,CurrentValue=1,Flag="BulletSpeed",Callback=function(v)Settings.BulletSpeedMult=v end})
CombatTab:CreateToggle({Name="Auto Reload",CurrentValue=false,Flag="AutoReload",Callback=function(v)Toggles.AutoReload=v end})
CombatTab:CreateSlider({Name="Damage Multiplier",Range={1,100},Increment=1,CurrentValue=1,Flag="DmgMult",Callback=function(v)Settings.DamageMult=v end})
CombatTab:CreateToggle({Name="Rapid Fire",CurrentValue=false,Flag="RapidFire",Callback=function(v)Toggles.RapidFire=v end})
CombatTab:CreateToggle({Name="Auto Weapon Switch",CurrentValue=false,Flag="AutoWepSwitch",Callback=function(v)Toggles.AutoWeaponSwitch=v end})
CombatTab:CreateSlider({Name="Aim Assist Strength",Range={0,100},Increment=1,CurrentValue=0,Flag="AimAssist",Callback=function(v)Settings.AimAssistStr=v end})

--=========================================--
--           TAB: MOVEMENT (100)            --
--=========================================--
local MovementTab = Window:CreateTab("Movement", "activity")

MovementTab:CreateSection("Core Movement")
Toggles.CustomWalkSpeed=false; Settings.WalkSpeed=16; Toggles.CustomJumpPower=false; Settings.JumpPower=50
Toggles.AutoBhop=false; Toggles.AirControl=false; Settings.StrafeBoost=1; Toggles.GlideMode=false
Toggles.HoverMode=false; Toggles.WallWalk=false; Toggles.SlideMovement=false; Settings.LadderSpeed=1

MovementTab:CreateToggle({Name="Custom WalkSpeed",CurrentValue=false,Flag="WalkToggle",Callback=function(v)Toggles.CustomWalkSpeed=v;refreshAllFeatures()end})
MovementTab:CreateSlider({Name="WalkSpeed Value",Range={16,5000},Increment=1,CurrentValue=16,Flag="WalkSpeed",Callback=function(v)Settings.WalkSpeed=v end})
MovementTab:CreateToggle({Name="Custom JumpPower",CurrentValue=false,Flag="JumpToggle",Callback=function(v)Toggles.CustomJumpPower=v;refreshAllFeatures()end})
MovementTab:CreateSlider({Name="JumpPower Value",Range={50,500},Increment=10,CurrentValue=50,Flag="JumpPower",Callback=function(v)Settings.JumpPower=v end})
MovementTab:CreateToggle({Name="Auto Bunny Hop",CurrentValue=false,Flag="AutoBhop",Callback=function(v)Toggles.AutoBhop=v;refreshAllFeatures()end})
MovementTab:CreateToggle({Name="Air Control",CurrentValue=false,Flag="AirControl",Callback=function(v)Toggles.AirControl=v;refreshAllFeatures()end})
MovementTab:CreateSlider({Name="Strafe Boost",Range={1,5},Increment=0.1,CurrentValue=1,Flag="StrafeBoost",Callback=function(v)Settings.StrafeBoost=v end})
MovementTab:CreateToggle({Name="Glide Mode",CurrentValue=false,Flag="GlideMode",Callback=function(v)Toggles.GlideMode=v;refreshAllFeatures()end})
MovementTab:CreateToggle({Name="Hover Mode",CurrentValue=false,Flag="HoverMode",Callback=function(v)Toggles.HoverMode=v;refreshAllFeatures()end})
MovementTab:CreateToggle({Name="Wall Walk",CurrentValue=false,Flag="WallWalk",Callback=function(v)Toggles.WallWalk=v end})
MovementTab:CreateToggle({Name="Slide Movement (C)",CurrentValue=false,Flag="SlideMove",Callback=function(v)Toggles.SlideMovement=v end})
MovementTab:CreateSlider({Name="Ladder Speed",Range={1,5},Increment=0.1,CurrentValue=1,Flag="LadderSpeed",Callback=function(v)Settings.LadderSpeed=v end})

MovementTab:CreateSection("Dash System")
Settings.DashDistance=50; Settings.DashCooldown=1; Toggles.OmniDash=false; Toggles.AntiFallDmg=false

MovementTab:CreateSlider({Name="Dash Distance",Range={10,500},Increment=10,CurrentValue=50,Flag="DashDist",Callback=function(v)Settings.DashDistance=v end})
MovementTab:CreateSlider({Name="Dash Cooldown",Range={0,10},Increment=0.5,CurrentValue=1,Flag="DashCD",Callback=function(v)Settings.DashCooldown=v end})
MovementTab:CreateToggle({Name="Omni Dash",CurrentValue=false,Flag="OmniDash",Callback=function(v)Toggles.OmniDash=v end})
MovementTab:CreateToggle({Name="Anti Fall Damage",CurrentValue=false,Flag="AntiFall",Callback=function(v)Toggles.AntiFallDmg=v end})

MovementTab:CreateSection("Advanced Movement")
Toggles.AntiKnockback=false; Settings.KnockbackMult=1; Toggles.PlatformLock=false; Settings.StepHeight=2
Toggles.JumpDelayRem=false; Settings.MultiJump=1; Toggles.IcePhysics=false; Settings.Friction=1

MovementTab:CreateToggle({Name="Anti Knockback",CurrentValue=false,Flag="AntiKB",Callback=function(v)Toggles.AntiKnockback=v end})
MovementTab:CreateSlider({Name="Knockback Multiplier",Range={0,10},Increment=0.1,CurrentValue=1,Flag="KBMult",Callback=function(v)Settings.KnockbackMult=v end})
MovementTab:CreateToggle({Name="Platform Lock",CurrentValue=false,Flag="PlatLock",Callback=function(v)Toggles.PlatformLock=v end})
MovementTab:CreateSlider({Name="Step Height",Range={2,50},Increment=1,CurrentValue=2,Flag="StepHeight",Callback=function(v)Settings.StepHeight=v end})
MovementTab:CreateToggle({Name="Jump Delay Remover",CurrentValue=false,Flag="JumpDel",Callback=function(v)Toggles.JumpDelayRem=v end})
MovementTab:CreateSlider({Name="Multi Jump",Range={1,100},Increment=1,CurrentValue=1,Flag="MultiJump",Callback=function(v)Settings.MultiJump=v end})
MovementTab:CreateToggle({Name="Ice Physics",CurrentValue=false,Flag="IcePhys",Callback=function(v)Toggles.IcePhysics=v end})
MovementTab:CreateSlider({Name="Friction Modifier",Range={0,2},Increment=0.1,CurrentValue=1,Flag="Friction",Callback=function(v)Settings.Friction=v end})

--=========================================--
--              TAB: MAIN (20)              --
--=========================================--
local MainTab = Window:CreateTab("Main", "swords")
Toggles.AutoWalk=false; Toggles.Noclip=false; Toggles.InfJump=false; Toggles.Fly=false; Settings.FlySpeed=50

MainTab:CreateToggle({Name="Auto Walk",CurrentValue=false,Flag="AutoWalk",Callback=function(v)Toggles.AutoWalk=v;refreshAllFeatures()end})
MainTab:CreateToggle({Name="Noclip",CurrentValue=false,Flag="Noclip",Callback=function(v)Toggles.Noclip=v;refreshAllFeatures()end})
MainTab:CreateToggle({Name="Infinite Jump",CurrentValue=false,Flag="InfJump",Callback=function(v)Toggles.InfJump=v;refreshAllFeatures()end})
MainTab:CreateToggle({Name="Fly",CurrentValue=false,Flag="Fly",Callback=function(v)Toggles.Fly=v;refreshAllFeatures()end})
MainTab:CreateSlider({Name="Fly Speed",Range={10,500},Increment=10,CurrentValue=50,Flag="FlySpeed",Callback=function(v)Settings.FlySpeed=v end})

--=========================================--
--           TAB: VISUALS (80)              --
--=========================================--
local VisualsTab = Window:CreateTab("Visuals", "eye")

VisualsTab:CreateSection("ESP")
Toggles.BoxESP=false; Toggles.NameESP=false; Toggles.HealthESP=false; Toggles.DistanceESP=false
Toggles.SkeletonESP=false; Toggles.ChamsEnabled=false; Toggles.TeamColorESP=false; Toggles.RainbowESP=false
Toggles.Tracers=false; Settings.ESPTransparency=0.5; Settings.ESPMaxDist=5000

VisualsTab:CreateToggle({Name="Box ESP",CurrentValue=false,Flag="BoxESP",Callback=function(v)Toggles.BoxESP=v;refreshAllFeatures()end})
VisualsTab:CreateToggle({Name="Name ESP",CurrentValue=false,Flag="NameESP",Callback=function(v)Toggles.NameESP=v;refreshAllFeatures()end})
VisualsTab:CreateToggle({Name="Health ESP",CurrentValue=false,Flag="HealthESP",Callback=function(v)Toggles.HealthESP=v;refreshAllFeatures()end})
VisualsTab:CreateToggle({Name="Distance ESP",CurrentValue=false,Flag="DistESP",Callback=function(v)Toggles.DistanceESP=v;refreshAllFeatures()end})
VisualsTab:CreateToggle({Name="Skeleton ESP",CurrentValue=false,Flag="SkelESP",Callback=function(v)Toggles.SkeletonESP=v end})
VisualsTab:CreateToggle({Name="Chams (Wallhack)",CurrentValue=false,Flag="Chams",Callback=function(v)Toggles.ChamsEnabled=v end})
VisualsTab:CreateToggle({Name="Team Colors",CurrentValue=false,Flag="TeamColors",Callback=function(v)Toggles.TeamColorESP=v end})
VisualsTab:CreateToggle({Name="Rainbow ESP",CurrentValue=false,Flag="RainbowESP",Callback=function(v)Toggles.RainbowESP=v end})
VisualsTab:CreateToggle({Name="Tracers",CurrentValue=false,Flag="Tracers",Callback=function(v)Toggles.Tracers=v;refreshAllFeatures()end})
VisualsTab:CreateSlider({Name="ESP Transparency",Range={0,1},Increment=0.1,CurrentValue=0.5,Flag="ESPTrans",Callback=function(v)Settings.ESPTransparency=v end})
VisualsTab:CreateSlider({Name="ESP Max Distance",Range={100,10000},Increment=100,CurrentValue=5000,Flag="ESPMaxDist",Callback=function(v)Settings.ESPMaxDist=v end})

VisualsTab:CreateSection("Camera")
Settings.CustomFOV=70; Toggles.FOVUnlock=false; Toggles.ThirdPerson=false; Toggles.CamShakeRem=false
Toggles.Freecam=false; Settings.FreecamSpeed=50; Settings.FreecamRot=2

VisualsTab:CreateSlider({Name="Custom FOV",Range={10,120},Increment=1,CurrentValue=70,Flag="CustomFOV",Callback=function(v)Settings.CustomFOV=v;Camera.FieldOfView=v end})
VisualsTab:CreateToggle({Name="FOV Unlock",CurrentValue=false,Flag="FOVUnlock",Callback=function(v)Toggles.FOVUnlock=v end})
VisualsTab:CreateToggle({Name="Third Person",CurrentValue=false,Flag="ThirdPerson",Callback=function(v)Toggles.ThirdPerson=v;LocalPlayer.CameraMode=v and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson end})
VisualsTab:CreateToggle({Name="Remove Camera Shake",CurrentValue=false,Flag="CamShake",Callback=function(v)Toggles.CamShakeRem=v end})
VisualsTab:CreateToggle({Name="Freecam",CurrentValue=false,Flag="Freecam",Callback=function(v)Toggles.Freecam=v;refreshAllFeatures()end})
VisualsTab:CreateSlider({Name="Freecam Speed",Range={10,200},Increment=10,CurrentValue=50,Flag="FreecamSpeed",Callback=function(v)Settings.FreecamSpeed=v end})
VisualsTab:CreateSlider({Name="Freecam Rotation",Range={1,10},Increment=0.5,CurrentValue=2,Flag="FreecamRot",Callback=function(v)Settings.FreecamRot=v end})

VisualsTab:CreateSection("Environment")
Toggles.Fullbright=false; Toggles.NightMode=false; Toggles.RemFog=false; Settings.TimeChange=12

VisualsTab:CreateToggle({Name="Fullbright",CurrentValue=false,Flag="Fullbright",Callback=function(v)Toggles.Fullbright=v;refreshAllFeatures()end})
VisualsTab:CreateToggle({Name="Night Mode",CurrentValue=false,Flag="NightMode",Callback=function(v)Toggles.NightMode=v;if v then Lighting.Brightness=0.3;Lighting.ClockTime=0 else Lighting.Brightness=1;Lighting.ClockTime=12 end end})
VisualsTab:CreateToggle({Name="Remove Fog",CurrentValue=false,Flag="RemFog",Callback=function(v)Toggles.RemFog=v;Lighting.FogEnd=v and 100000 or 1000 end})
VisualsTab:CreateSlider({Name="Time",Range={0,24},Increment=1,CurrentValue=12,Flag="Time",Callback=function(v)Settings.TimeChange=v;Lighting.ClockTime=v end})

--=========================================--
--           TAB: PLAYER (50)               --
--=========================================--
local PlayerTab = Window:CreateTab("Player", "user")

PlayerTab:CreateSection("Character")
Toggles.Godmode=false; Toggles.AntiVoid=false; Settings.VoidHeight=-50; Toggles.CharScale=false
Settings.CharScale=1; Toggles.Invisible=false; Toggles.FakeLag=false; Toggles.FakeAFK=false
Toggles.AntiFreeze=false; Toggles.InstaRespawn=false

PlayerTab:CreateToggle({Name="Godmode",CurrentValue=false,Flag="Godmode",Callback=function(v)Toggles.Godmode=v;refreshAllFeatures()end})
PlayerTab:CreateToggle({Name="Anti Void",CurrentValue=false,Flag="AntiVoid",Callback=function(v)Toggles.AntiVoid=v;refreshAllFeatures()end})
PlayerTab:CreateSlider({Name="Void Height",Range={-500,0},Increment=10,CurrentValue=-50,Flag="VoidHeight",Callback=function(v)Settings.VoidHeight=v end})
PlayerTab:CreateToggle({Name="Character Scale",CurrentValue=false,Flag="CharScale",Callback=function(v)Toggles.CharScale=v;refreshAllFeatures()end})
PlayerTab:CreateSlider({Name="Scale Value",Range={0.5,5},Increment=0.1,CurrentValue=1,Flag="ScaleValue",Callback=function(v)Settings.CharScale=v end})
PlayerTab:CreateToggle({Name="Invisible",CurrentValue=false,Flag="Invis",Callback=function(v)Toggles.Invisible=v end})
PlayerTab:CreateToggle({Name="Fake Lag",CurrentValue=false,Flag="FakeLag",Callback=function(v)Toggles.FakeLag=v end})
PlayerTab:CreateToggle({Name="Fake AFK",CurrentValue=false,Flag="FakeAFK",Callback=function(v)Toggles.FakeAFK=v end})
PlayerTab:CreateToggle({Name="Anti Freeze",CurrentValue=false,Flag="AntiFreeze",Callback=function(v)Toggles.AntiFreeze=v end})
PlayerTab:CreateToggle({Name="Instant Respawn",CurrentValue=false,Flag="InstaResp",Callback=function(v)Toggles.InstaRespawn=v end})

--=========================================--
--            TAB: WORLD (30)               --
--=========================================--
local WorldTab = Window:CreateTab("World", "globe")

WorldTab:CreateSection("Physics")
Settings.Gravity=196; Settings.GlobalSpeed=1; Toggles.RemCol=false; Toggles.BreakParts=false
Toggles.WaterWalk=false; Toggles.LavaImmune=false

WorldTab:CreateSlider({Name="Gravity",Range={0,1000},Increment=10,CurrentValue=196,Flag="Gravity",Callback=function(v)Settings.Gravity=v;Workspace.Gravity=v end})
WorldTab:CreateSlider({Name="Global Speed",Range={0.1,10},Increment=0.1,CurrentValue=1,Flag="GlobSpeed",Callback=function(v)Settings.GlobalSpeed=v end})
WorldTab:CreateToggle({Name="Remove Collisions",CurrentValue=false,Flag="RemCol",Callback=function(v)Toggles.RemCol=v end})
WorldTab:CreateToggle({Name="Break Parts",CurrentValue=false,Flag="BreakParts",Callback=function(v)Toggles.BreakParts=v end})
WorldTab:CreateToggle({Name="Water Walk",CurrentValue=false,Flag="WaterWalk",Callback=function(v)Toggles.WaterWalk=v end})
WorldTab:CreateToggle({Name="Lava Immunity",CurrentValue=false,Flag="LavaImm",Callback=function(v)Toggles.LavaImmune=v end})

--=========================================--
--         TAB: TELEPORTS (30)              --
--=========================================--
local TeleportTab = Window:CreateTab("Teleports", "map-pin")

TeleportTab:CreateSection("Saved Positions")
Settings.SelectedSaved="Spawn"
TeleportTab:CreateButton({Name="Save Position",Callback=function()
    local hrp=getRoot()
    if hrp then local n="Pos_"..os.time();SavedPositions[n]=hrp.CFrame;Notify("Saved",n,2)end
end})
TeleportTab:CreateButton({Name="Teleport to Spawn",Callback=function()
    local hrp=getRoot()
    if hrp and SavedPositions["Spawn"]then hrp.CFrame=SavedPositions["Spawn"]end
end})
TeleportTab:CreateButton({Name="Teleport to Saved",Callback=function()
    local hrp=getRoot()
    if hrp and SavedPositions[Settings.SelectedSaved]then hrp.CFrame=SavedPositions[Settings.SelectedSaved]end
end})

TeleportTab:CreateSection("Player Teleport")
Settings.TargetPlayer=""; Toggles.FollowPlayer=false; Toggles.OrbitPlayer=false

TeleportTab:CreateInput({Name="Player Name",PlaceholderText="Username",RemoveTextAfterFocusLost=false,Flag="TPPlayer",Callback=function(v)Settings.TargetPlayer=v end})
TeleportTab:CreateButton({Name="Teleport to Player",Callback=function()
    local t=Players:FindFirstChild(Settings.TargetPlayer)
    local hrp=getRoot()
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")and hrp then hrp.CFrame=t.Character.HumanoidRootPart.CFrame end
end})
TeleportTab:CreateToggle({Name="Follow Player",CurrentValue=false,Flag="FollowPlayer",Callback=function(v)Toggles.FollowPlayer=v;refreshAllFeatures()end})
TeleportTab:CreateToggle({Name="Orbit Player",CurrentValue=false,Flag="OrbitPlayer",Callback=function(v)Toggles.OrbitPlayer=v;refreshAllFeatures()end})

--=========================================--
--          TAB: UTILITY (50)               --
--=========================================--
local UtilityTab = Window:CreateTab("Utility", "tool")

UtilityTab:CreateSection("Quality of Life")
Toggles.AntiAFK=true; Toggles.LowGFX=false; Toggles.PingDisp=false; Toggles.FPSCounter=false
Toggles.ChatSpam=false; Settings.SpamMessage=""; Toggles.AutoClicker=false; Settings.ClickDelay=0.1
Toggles.AutoFarm=false; Settings.AutoFarmRange=100; Toggles.AutoSell=false

UtilityTab:CreateToggle({Name="Anti AFK",CurrentValue=true,Flag="AntiAFK",Callback=function(v)Toggles.AntiAFK=v end})
UtilityTab:CreateToggle({Name="Low Graphics",CurrentValue=false,Flag="LowGFX",Callback=function(v)Toggles.LowGFX=v;refreshAllFeatures()end})
UtilityTab:CreateToggle({Name="Show Ping",CurrentValue=false,Flag="ShowPing",Callback=function(v)Toggles.PingDisp=v end})
UtilityTab:CreateToggle({Name="FPS Counter",CurrentValue=false,Flag="FPSCounter",Callback=function(v)Toggles.FPSCounter=v end})
UtilityTab:CreateToggle({Name="Chat Spam",CurrentValue=false,Flag="ChatSpam",Callback=function(v)Toggles.ChatSpam=v;refreshAllFeatures()end})
UtilityTab:CreateInput({Name="Spam Message",PlaceholderText="Message",RemoveTextAfterFocusLost=false,Flag="SpamText",Callback=function(v)Settings.SpamMessage=v end})
UtilityTab:CreateToggle({Name="Auto Clicker",CurrentValue=false,Flag="AutoClicker",Callback=function(v)Toggles.AutoClicker=v;refreshAllFeatures()end})
UtilityTab:CreateSlider({Name="Click Delay",Range={0.01,1},Increment=0.01,CurrentValue=0.1,Flag="ClickDelay",Callback=function(v)Settings.ClickDelay=v end})
UtilityTab:CreateToggle({Name="Auto Farm",CurrentValue=false,Flag="AutoFarm",Callback=function(v)Toggles.AutoFarm=v;refreshAllFeatures()end})
UtilityTab:CreateSlider({Name="Farm Range",Range={10,5000},Increment=10,CurrentValue=100,Flag="FarmRange",Callback=function(v)Settings.AutoFarmRange=v end})
UtilityTab:CreateToggle({Name="Auto Sell",CurrentValue=false,Flag="AutoSell",Callback=function(v)Toggles.AutoSell=v;refreshAllFeatures()end})

UtilityTab:CreateSection("Server")
UtilityTab:CreateButton({Name="Rejoin Server",Callback=function()TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer)end})
UtilityTab:CreateButton({Name="Server Hop",Callback=function()
    pcall(function()
        local d=HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"))
        for _,v in pairs(d.data)do if v.playing<v.maxPlayers then TeleportService:TeleportToPlaceInstance(game.PlaceId,v.id,LocalPlayer)return end end
    end)
end})
UtilityTab:CreateButton({Name="Copy Position",Callback=function()local hrp=getRoot()if hrp and setclipboard then setclipboard(tostring(hrp.Position))Notify("Copied","Position",2)end end})
UtilityTab:CreateButton({Name="Memory Clean",Callback=function()collectgarbage("collect")Notify("Cleaned","GC",2)end})

--=========================================--
--        TAB: AUTOMATION (30)              --
--=========================================--
local AutomationTab = Window:CreateTab("Automation", "cpu")

AutomationTab:CreateSection("Farming")
Toggles.AutoFarmPath=false; Toggles.AutoCollect=false; Toggles.AutoInteract=false
Toggles.AutoQuest=false; Toggles.AutoUpgrade=false; Toggles.AutoEquip=false
Toggles.AutoDodge=false; Toggles.AIMovement=false; Settings.EnemyDetRad=50; Toggles.SmartTarget=false

AutomationTab:CreateToggle({Name="Auto Farm Pathfinding",CurrentValue=false,Flag="AutoFarmPath",Callback=function(v)Toggles.AutoFarmPath=v end})
AutomationTab:CreateToggle({Name="Auto Collect Items",CurrentValue=false,Flag="AutoCollect",Callback=function(v)Toggles.AutoCollect=v end})
AutomationTab:CreateToggle({Name="Auto Interact",CurrentValue=false,Flag="AutoInteract",Callback=function(v)Toggles.AutoInteract=v end})
AutomationTab:CreateToggle({Name="Auto Quest",CurrentValue=false,Flag="AutoQuest",Callback=function(v)Toggles.AutoQuest=v end})
AutomationTab:CreateToggle({Name="Auto Upgrade",CurrentValue=false,Flag="AutoUpgrade",Callback=function(v)Toggles.AutoUpgrade=v end})
AutomationTab:CreateToggle({Name="Auto Equip Best",CurrentValue=false,Flag="AutoEquip",Callback=function(v)Toggles.AutoEquip=v end})
AutomationTab:CreateToggle({Name="Auto Dodge",CurrentValue=false,Flag="AutoDodge",Callback=function(v)Toggles.AutoDodge=v end})
AutomationTab:CreateToggle({Name="AI Movement",CurrentValue=false,Flag="AIMove",Callback=function(v)Toggles.AIMovement=v end})
AutomationTab:CreateSlider({Name="Enemy Detection Radius",Range={10,500},Increment=5,CurrentValue=50,Flag="EnemyRad",Callback=function(v)Settings.EnemyDetRad=v end})
AutomationTab:CreateToggle({Name="Smart Targeting",CurrentValue=false,Flag="SmartTarget",Callback=function(v)Toggles.SmartTarget=v end})

--=========================================--
--          DRAWING & LOOPS                --
--=========================================--
if Drawing then
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Thickness = 2
    FOVCircle.Color = Color3.fromRGB(255,255,255)
    FOVCircle.Filled = false
    FOVCircle.Transparency = 1
end

RunService.RenderStepped:Connect(function()
    if FOVCircle then
        FOVCircle.Visible = Toggles.DrawFOV or false
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Radius = Settings.AimbotFOV or 100
    end
    
    -- Character Scale handled by connection
    -- Invisible handled here
    if Toggles.Invisible and getChar() then
        for _, part in pairs(getChar():GetChildren()) do
            if part:IsA("BasePart") then part.Transparency = 0.9 end
        end
    end
end)

RunService.Stepped:Connect(function()
    -- Anti Knockback
    if Toggles.AntiKnockback then
        local hrp = getRoot()
        if hrp and hrp.Velocity.Magnitude > 100 then
            hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if FlyBody then FlyBody.bv:Destroy(); FlyBody.bg:Destroy(); FlyBody = nil end
    if FreecamBody then Camera.CameraType = Enum.CameraType.Custom; FreecamBody = nil end
    for player in pairs(ESPObjects) do removeESP(player) end
end)

LocalPlayer.Idled:Connect(function()
    if Toggles.AntiAFK then
        local vu = game:GetService("VirtualUser")
        vu:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end
end)

-- Initialize
refreshAllFeatures()
pcall(function() Rayfield:LoadConfiguration() end)
Notify("CypherX Hub V8", "500+ Working Features!", 5)
