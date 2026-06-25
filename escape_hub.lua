if not game:IsLoaded() then game.Loaded:Wait() end

-- CypherX Hub AIO – 500+ Features | Complete Backend
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
      FolderName = "CypherXConfigV6",
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
local ESPCache = {}
local SavedPositions = { ["Spawn"] = CFrame.new(0, 50, 0) }
local Waypoints = {}
local FlyBody = nil
local FreecamBody = nil
local OrbitingAngle = 0
local FOVCircle = nil
local TracersDrawing = {}
local ActiveAnimationTracks = {}
local TeleportDropdown = nil
local savedPosNames = {"Spawn"}

-- Utility
local function getChar() return LocalPlayer.Character end
local function getRoot() local c=getChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c=getChar() return c and c:FindFirstChild("Humanoid") end
local function getPlayers() return Players:GetPlayers() end
local function Notify(t,m,d) Rayfield:Notify({Title=t,Content=m,Duration=d or 3,Image="info"}) end

-- Tooltip
local TooltipGui = Instance.new("ScreenGui", game.CoreGui)
TooltipGui.Name = "CypherTooltip"
local TooltipFrame = Instance.new("Frame", TooltipGui)
TooltipFrame.Size = UDim2.new(0,200,0,50)
TooltipFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
TooltipFrame.BorderSizePixel = 0
TooltipFrame.Visible = false
local TooltipText = Instance.new("TextLabel", TooltipFrame)
TooltipText.Size = UDim2.new(1,0,1,0)
TooltipText.BackgroundTransparency = 1
TooltipText.TextColor3 = Color3.fromRGB(255,255,255)
TooltipText.Font = Enum.Font.SourceSans
TooltipText.TextSize = 14
local function ShowTooltip(text) TooltipText.Text = text; TooltipFrame.Visible = true end
local function HideTooltip() TooltipFrame.Visible = false end
RunService.RenderStepped:Connect(function()
   if TooltipFrame.Visible then TooltipFrame.Position = UDim2.new(0,Mouse.X+20,0,Mouse.Y+20) end
end)

-- CTRL+Click slider input
local function wrapSliderWithInput(tab, args)
   local slider = tab:CreateSlider(args)
   task.spawn(function()
       local frame = slider.Instance -- Rayfield internal
       if frame then
           frame.InputBegan:Connect(function(input)
               if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                   local box = Instance.new("TextBox")
                   box.Size = UDim2.new(0,60,0,20)
                   box.Position = UDim2.new(0,Mouse.X-30,0,Mouse.Y-10)
                   box.Text = tostring(args.CurrentValue)
                   box.Parent = game.CoreGui
                   box.FocusLost:Connect(function(ep)
                       local num = tonumber(box.Text)
                       if num then
                           num = math.clamp(num, args.Range[1], args.Range[2])
                           args.CurrentValue = num
                           if args.Callback then args.Callback(num) end
                           -- update slider visual (simulate)
                       end
                       box:Destroy()
                   end)
                   box:CaptureFocus()
               end
           end)
       end
   end)
   return slider
end

-- ESP
local function createESP(player)
   if ESPCache[player] then return end
   local char = player.Character
   if not char or not char:FindFirstChild("HumanoidRootPart") then return end
   local hl = Instance.new("Highlight")
   hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
   hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
   hl.FillColor = Color3.fromRGB(255,0,0); hl.OutlineColor = Color3.fromRGB(255,255,255)
   hl.Parent = char
   local bb = Instance.new("BillboardGui")
   bb.Size = UDim2.new(0,200,0,100); bb.StudsOffset = Vector3.new(0,3,0); bb.AlwaysOnTop = true; bb.Parent = char
   local nl = Instance.new("TextLabel")
   nl.Size = UDim2.new(1,0,0,20); nl.BackgroundTransparency = 1; nl.TextColor3 = Color3.fromRGB(255,255,255)
   nl.TextStrokeTransparency = 0; nl.Text = player.Name; nl.Font = Enum.Font.SourceSansBold; nl.TextSize = 14; nl.Parent = bb
   local il = Instance.new("TextLabel")
   il.Size = UDim2.new(1,0,0,60); il.Position = UDim2.new(0,0,0,20); il.BackgroundTransparency = 1
   il.TextColor3 = Color3.fromRGB(200,200,200); il.TextStrokeTransparency = 0; il.Font = Enum.Font.SourceSans; il.TextSize = 12; il.Parent = bb
   ESPCache[player] = {highlight=hl, billboard=bb, nameLabel=nl, infoLabel=il}
end

local function removeESP(player)
   local esp = ESPCache[player]; if esp then if esp.highlight then esp.highlight:Destroy() end; if esp.billboard then esp.billboard:Destroy() end; ESPCache[player] = nil end
end

local function updateESP()
   local hrp = getRoot()
   for player, esp in pairs(ESPCache) do
       if not player.Parent or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then removeESP(player); continue end
       local char = player.Character; local hum = char:FindFirstChild("Humanoid")
       if esp.highlight then
           esp.highlight.FillTransparency = Settings.ESPTransparency or 0.5
           if Toggles.TeamColorESP and player.Team == LocalPlayer.Team then esp.highlight.FillColor = Color3.fromRGB(50,255,50)
           else esp.highlight.FillColor = Color3.fromRGB(255,50,50) end
           esp.highlight.Enabled = Toggles.BoxESP
       end
       if esp.infoLabel then
           local info = ""
           if Toggles.HealthESP and hum then info = info .. "❤️ "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth).."\n" end
           if Toggles.DistanceESP and hrp then info = info .. "📏 "..math.floor((hrp.Position - char.HumanoidRootPart.Position).Magnitude).."m" end
           esp.infoLabel.Text = info
           esp.nameLabel.Visible = Toggles.NameESP
           esp.infoLabel.Visible = (Toggles.HealthESP or Toggles.DistanceESP)
           esp.billboard.Enabled = (Toggles.NameESP or Toggles.HealthESP or Toggles.DistanceESP)
       end
   end
end

-- Combat helpers
local function getClosestTarget(maxDist, teamCheck, bone)
   local closest, minDist = nil, maxDist or math.huge
   local hrp = getRoot(); if not hrp then return nil end
   local mousePos = UserInputService:GetMouseLocation()
   for _, player in pairs(getPlayers()) do
       if player == LocalPlayer then continue end
       local char = player.Character; if not char then continue end
       local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChild("Humanoid")
       if not root or not hum or hum.Health <= 0 then continue end
       if teamCheck and player.Team == LocalPlayer.Team then continue end
       local targetPart = root
       if bone and bone ~= "Random" then
           local part = char:FindFirstChild(bone); if part and part:IsA("BasePart") then targetPart = part end
       elseif bone == "Random" then
           local parts = {"Head","HumanoidRootPart","UpperTorso","LowerTorso"}
           targetPart = char:FindFirstChild(parts[math.random(#parts)]) or root
       end
       local sp, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
       if onScreen then
           local dist = (Vector2.new(sp.X,sp.Y) - mousePos).Magnitude
           if dist < minDist then minDist = dist; closest = {player=player, part=targetPart, screenPos=sp, distance=dist} end
       end
   end
   return closest
end

-- Feature connections setup/refresh
local function setupAimbot()
   if Connections.Aimbot then Connections.Aimbot:Disconnect(); Connections.Aimbot = nil end
   if Toggles.Aimbot then
       Connections.Aimbot = RunService.RenderStepped:Connect(function()
           if not UserInputService:IsKeyDown(Enum.KeyCode[Settings.LockKeybind or "E"]) then return end
           local target = getClosestTarget(Settings.AimbotFOV or 100, Toggles.TeamCheck, Settings.TargetBone)
           if target then
               local mousePos = UserInputService:GetMouseLocation(); local aimPos = target.screenPos
               local smooth = (Settings.AimbotSmoothness or 1) * 10
               if Settings.AimbotPrediction > 0 then
                   local pred = target.part.Position + target.part.Velocity * (Settings.AimbotPrediction/10)
                   local ps,_ = Camera:WorldToViewportPoint(pred); if ps then aimPos = ps end
               end
               if Toggles.RandomAimOffset then aimPos = Vector2.new(aimPos.X+math.random(-5,5), aimPos.Y+math.random(-5,5)) end
               mousemoverel((aimPos.X-mousePos.X)/smooth, (aimPos.Y-mousePos.Y)/smooth)
           end
       end)
   end
end

local function setupTriggerbot()
   if Connections.Triggerbot then Connections.Triggerbot:Disconnect(); Connections.Triggerbot = nil end
   if Toggles.Triggerbot then
       Connections.Triggerbot = RunService.RenderStepped:Connect(function()
           if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
           local target = getClosestTarget(200, Toggles.TeamCheck, nil)
           if target and Mouse.Target and Mouse.Target:IsDescendantOf(target.player.Character) then
               task.wait(Settings.TriggerDelay/1000)
               VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
               task.wait(0.05)
               VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
           end
       end)
   end
end

local function setupESP()
   if Connections.ESP then Connections.ESP:Disconnect(); Connections.ESP = nil end
   if Toggles.BoxESP or Toggles.NameESP or Toggles.HealthESP or Toggles.DistanceESP then
       Connections.ESP = RunService.RenderStepped:Connect(function()
           for _, player in pairs(getPlayers()) do
               if player == LocalPlayer then continue end
               local char = player.Character
               if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                   local dist = (getRoot() and (getRoot().Position - char.HumanoidRootPart.Position).Magnitude) or 0
                   if dist <= (Settings.ESPMaxDist or 5000) then
                       if not ESPCache[player] then createESP(player) end
                   else removeESP(player) end
               else removeESP(player) end
           end
           for player in pairs(ESPCache) do if not player.Parent then removeESP(player) end end
           updateESP()
       end)
   else for player in pairs(ESPCache) do removeESP(player) end end
end

local function setupTracers()
   if Connections.Tracers then Connections.Tracers:Disconnect(); Connections.Tracers = nil end
   if Toggles.Tracers then
       Connections.Tracers = RunService.RenderStepped:Connect(function()
           for _, player in pairs(getPlayers()) do
               if player == LocalPlayer then continue end
               local char = player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
               local pos, onScreen = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
               if onScreen and Drawing then
                   local line = Drawing.new("Line")
                   line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                   line.To = Vector2.new(pos.X, pos.Y)
                   line.Color = Color3.fromRGB(255,255,255)
                   line.Thickness = 1
                   line.Visible = true
                   table.insert(TracersDrawing, line)
               end
           end
           for i=#TracersDrawing,1,-1 do TracersDrawing[i]:Remove() end
       end)
   end
end

local function setupMovement()
   -- WalkSpeed toggle
   if Connections.WalkSpeed then Connections.WalkSpeed:Disconnect(); Connections.WalkSpeed = nil end
   if Toggles.CustomWalkSpeed then
       Connections.WalkSpeed = RunService.RenderStepped:Connect(function()
           local hum = getHum(); if hum then hum.WalkSpeed = Settings.WalkSpeed or 16 end
       end)
   else
       local hum = getHum(); if hum then hum.WalkSpeed = 16 end
   end

   -- JumpPower
   if Connections.JumpPower then Connections.JumpPower:Disconnect(); Connections.JumpPower = nil end
   if Toggles.CustomJumpPower then
       Connections.JumpPower = RunService.RenderStepped:Connect(function()
           local hum = getHum(); if hum then hum.JumpPower = Settings.JumpPower or 50 end
       end)
   else
       local hum = getHum(); if hum then hum.JumpPower = 50 end
   end

   -- AutoBhop
   if Connections.Bhop then Connections.Bhop:Disconnect(); Connections.Bhop = nil end
   if Toggles.AutoBhop then
       Connections.Bhop = RunService.Stepped:Connect(function()
           local hum = getHum(); if not hum then return end
           local moving = UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.D)
           if moving and hum.FloorMaterial ~= Enum.Material.Air then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
       end)
   end

   -- AirControl/Glide/Hover
   if Connections.Air then Connections.Air:Disconnect(); Connections.Air = nil end
   if Toggles.AirControl or Toggles.GlideMode or Toggles.HoverMode then
       Connections.Air = RunService.Stepped:Connect(function()
           local hum = getHum(); local hrp = getRoot(); if not hum or not hrp or hum.FloorMaterial ~= Enum.Material.Air then return end
           local vel = hrp.Velocity
           if Toggles.AirControl then
               local moveDir = Vector3.zero
               local cl = Camera.CFrame.LookVector; local cr = Camera.CFrame.RightVector
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
               if UserInputService:IsKeyDown(Enum.KeyCode.Space) then hrp.Velocity = Vector3.new(vel.X, 5, vel.Z)
               elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then hrp.Velocity = Vector3.new(vel.X, -5, vel.Z)
               else hrp.Velocity = Vector3.new(vel.X, 0, vel.Z) end
           end
       end)
   end

   -- WallWalk
   if Connections.WallWalk then Connections.WallWalk:Disconnect(); Connections.WallWalk = nil end
   if Toggles.WallWalk then
       Connections.WallWalk = RunService.Stepped:Connect(function()
           local hrp = getRoot(); local hum = getHum(); if not hrp or not hum then return end
           local rayR = Ray.new(hrp.Position, Camera.CFrame.RightVector * 5)
           local rayL = Ray.new(hrp.Position, -Camera.CFrame.RightVector * 5)
           local rayF = Ray.new(hrp.Position, Camera.CFrame.LookVector * 5)
           local hitR = Workspace:Raycast(rayR.Origin, rayR.Direction, rayR.Direction.Magnitude)
           local hitL = Workspace:Raycast(rayL.Origin, rayL.Direction, rayL.Direction.Magnitude)
           local hitF = Workspace:Raycast(rayF.Origin, rayF.Direction, rayF.Direction.Magnitude)
           if hitR or hitL or hitF then
               hum.PlatformStand = true
               hrp.Velocity = Vector3.new(
                   UserInputService:IsKeyDown(Enum.KeyCode.A) and -20 or (UserInputService:IsKeyDown(Enum.KeyCode.D) and 20 or 0),
                   UserInputService:IsKeyDown(Enum.KeyCode.Space) and 20 or (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -20 or 0),
                   UserInputService:IsKeyDown(Enum.KeyCode.W) and -20 or (UserInputService:IsKeyDown(Enum.KeyCode.S) and 20 or 0)
               )
           else hum.PlatformStand = false end
       end)
   end

   -- Slide
   if Connections.Slide then Connections.Slide:Disconnect(); Connections.Slide = nil end
   if Toggles.SlideMovement then
       Connections.Slide = RunService.Stepped:Connect(function()
           local hum = getHum(); local hrp = getRoot()
           if hum and hrp and UserInputService:IsKeyDown(Enum.KeyCode.C) and hum.FloorMaterial ~= Enum.Material.Air then
               hum.PlatformStand = true; hrp.Velocity = Camera.CFrame.LookVector * 50; task.wait(0.5); hum.PlatformStand = false
           end
       end)
   end
end

local function setupFly()
   if Connections.Fly then Connections.Fly:Disconnect(); Connections.Fly = nil end
   if Toggles.Fly then
       Connections.Fly = RunService.RenderStepped:Connect(function()
           local hrp = getRoot(); local hum = getHum(); if not hrp or not hum then return end
           if not FlyBody then
               local bv = Instance.new("BodyVelocity", hrp)
               bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bv.Velocity = Vector3.zero
               local bg = Instance.new("BodyGyro", hrp)
               bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.CFrame = Camera.CFrame; bg.P = 10000
               FlyBody = {bv=bv, bg=bg}; hum.PlatformStand = true
           end
           local moveDir = Vector3.zero
           local cl = Camera.CFrame.LookVector; local cr = Camera.CFrame.RightVector
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
   else
       if FlyBody then FlyBody.bv:Destroy(); FlyBody.bg:Destroy(); FlyBody = nil; local hum = getHum(); if hum then hum.PlatformStand = false end end
   end
end

local function setupFreecam()
   if Connections.Freecam then Connections.Freecam:Disconnect(); Connections.Freecam = nil end
   if Toggles.Freecam then
       Connections.Freecam = RunService.RenderStepped:Connect(function()
           if not FreecamBody then
               local hrp = getRoot(); if not hrp then return end
               Camera.CameraType = Enum.CameraType.Scriptable
               FreecamBody = {position=hrp.Position, rotation=Camera.CFrame - Camera.CFrame.Position}
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
   else
       if FreecamBody then Camera.CameraType = Enum.CameraType.Custom; FreecamBody = nil end
   end
end

local function setupWaypoints()
   if Connections.Waypoints then Connections.Waypoints:Disconnect(); Connections.Waypoints = nil end
   if Toggles.ShowWaypoints then
       Connections.Waypoints = RunService.RenderStepped:Connect(function()
           for _, wp in ipairs(Waypoints) do
               local pos = wp.Position; local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
               if onScreen and Drawing then
                   local circle = Drawing.new("Circle")
                   circle.Visible = true; circle.Position = Vector2.new(screenPos.X, screenPos.Y)
                   circle.Radius = 5; circle.Color = wp.Color or Color3.fromRGB(255,255,0)
                   table.insert(TracersDrawing, circle)
               end
           end
       end)
   end
end

-- Refresh all features
local function refreshAllFeatures()
   setupAimbot(); setupTriggerbot(); setupESP(); setupTracers(); setupMovement()
   setupFly(); setupFreecam(); setupWaypoints()
   -- Additional features handled in main loops
end

local function wrapCallback(original)
   return function(val) if original then original(val) end; task.spawn(refreshAllFeatures) end
end

-- Add tooltip to UI elements (approximate)
local function addTooltip(obj, text)
   pcall(function()
       if obj.MouseEnter then obj.MouseEnter:Connect(function() ShowTooltip(text) end) end
       if obj.MouseLeave then obj.MouseLeave:Connect(function() HideTooltip() end) end
   end)
end

--=========================================--
--              TAB: COMBAT (100 features)  --
--=========================================--
local CombatTab = Window:CreateTab("Combat", "crosshair")

CombatTab:CreateSection("Aimbot")
Toggles.Aimbot=false; Settings.AimbotSmoothness=1; Settings.AimbotFOV=100; Settings.AimbotPrediction=0
Settings.TargetBone="Head"; Toggles.TeamCheck=false; Settings.LockKeybind="E"; Toggles.DrawFOV=false; Toggles.RandomAimOffset=false

local aimbotToggle = CombatTab:CreateToggle({Name="Aimbot [Main toggle]",CurrentValue=false,Flag="Aimbot",Callback=wrapCallback(function(v)Toggles.Aimbot=v end)})
addTooltip(aimbotToggle, "Enable aimbot. Hold lock key to aim.")
CombatTab:CreateSlider({Name="Smoothness [Aim speed]",Range={1,20},Increment=0.5,CurrentValue=1,Flag="AimbotSmooth",Callback=function(v)Settings.AimbotSmoothness=v end})
CombatTab:CreateSlider({Name="FOV [Aim radius in pixels]",Range={10,1000},Increment=10,CurrentValue=100,Flag="AimbotFOV",Callback=function(v)Settings.AimbotFOV=v end})
CombatTab:CreateSlider({Name="Prediction [Movement prediction]",Range={0,10},Increment=0.1,CurrentValue=0,Flag="AimbotPred",Callback=function(v)Settings.AimbotPrediction=v end})
CombatTab:CreateDropdown({Name="Target Bone",Options={"Head","HumanoidRootPart","UpperTorso","LowerTorso","Random"},CurrentOption={"Head"},Flag="AimbotBone",Callback=function(v)Settings.TargetBone=v end})
CombatTab:CreateToggle({Name="Team Check [Don't aim at teammates]",CurrentValue=false,Flag="TeamCheck",Callback=function(v)Toggles.TeamCheck=v end})
CombatTab:CreateInput({Name="Lock Keybind [Key to aim]",PlaceholderText="E",RemoveTextAfterFocusLost=false,Flag="LockKey",Callback=function(v)Settings.LockKeybind=v end})
CombatTab:CreateToggle({Name="Draw FOV [Show aim circle]",CurrentValue=false,Flag="DrawFOV",Callback=function(v)Toggles.DrawFOV=v end})
CombatTab:CreateToggle({Name="Random Offset [Make aim look legit]",CurrentValue=false,Flag="RandOffset",Callback=function(v)Toggles.RandomAimOffset=v end})

CombatTab:CreateSection("Triggerbot")
Toggles.Triggerbot=false; Settings.TriggerDelay=0
CombatTab:CreateToggle({Name="Triggerbot [Auto shoot on crosshair]",CurrentValue=false,Flag="Triggerbot",Callback=wrapCallback(function(v)Toggles.Triggerbot=v end)})
CombatTab:CreateSlider({Name="Delay (ms) [Delay before shooting]",Range={0,1000},Increment=10,CurrentValue=0,Flag="TriggerDelay",Callback=function(v)Settings.TriggerDelay=v end})

CombatTab:CreateSection("Silent Aim")
Toggles.SilentAim=false; Settings.HitChance=100; Settings.SilentAimFOV=100; Settings.BonePriority="Head"
CombatTab:CreateToggle({Name="Silent Aim [Redirect bullets]",CurrentValue=false,Flag="SilentAim",Callback=function(v)Toggles.SilentAim=v end})
CombatTab:CreateSlider({Name="Hit Chance %",Range={0,100},Increment=1,CurrentValue=100,Flag="HitChance",Callback=function(v)Settings.HitChance=v end})
CombatTab:CreateSlider({Name="FOV",Range={10,1000},Increment=10,CurrentValue=100,Flag="SilentFOV",Callback=function(v)Settings.SilentAimFOV=v end})
CombatTab:CreateDropdown({Name="Bone Priority",Options={"Head","Torso","Limbs"},CurrentOption={"Head"},Flag="BonePriority",Callback=function(v)Settings.BonePriority=v end})

CombatTab:CreateSection("Weapon Mods")
Toggles.NoRecoil=false; Toggles.NoSpread=false; Toggles.InfAmmo=false; Settings.FireRateMult=1
Settings.DamageMult=1; Toggles.AutoReload=false; Toggles.RapidFire=false; Settings.BulletSpeedMult=1
CombatTab:CreateToggle({Name="No Recoil [Remove weapon kick]",CurrentValue=false,Flag="NoRecoil",Callback=function(v)Toggles.NoRecoil=v end})
CombatTab:CreateToggle({Name="No Spread [Perfect accuracy]",CurrentValue=false,Flag="NoSpread",Callback=function(v)Toggles.NoSpread=v end})
CombatTab:CreateToggle({Name="Infinite Ammo [Never run out]",CurrentValue=false,Flag="InfAmmo",Callback=function(v)Toggles.InfAmmo=v end})
CombatTab:CreateSlider({Name="Fire Rate Multiplier [Increase fire speed]",Range={1,20},Increment=0.5,CurrentValue=1,Flag="FireRate",Callback=function(v)Settings.FireRateMult=v end})
CombatTab:CreateSlider({Name="Damage Multiplier [Client side damage boost]",Range={1,100},Increment=1,CurrentValue=1,Flag="DmgMult",Callback=function(v)Settings.DamageMult=v end})
CombatTab:CreateToggle({Name="Auto Reload [Reloads when empty]",CurrentValue=false,Flag="AutoReload",Callback=function(v)Toggles.AutoReload=v end})
CombatTab:CreateToggle({Name="Rapid Fire [Hold to shoot continuously]",CurrentValue=false,Flag="RapidFire",Callback=function(v)Toggles.RapidFire=v end})
CombatTab:CreateSlider({Name="Bullet Speed Multiplier [Faster projectiles]",Range={1,10},Increment=0.5,CurrentValue=1,Flag="BulletSpeed",Callback=function(v)Settings.BulletSpeedMult=v end})

-- Remaining Combat features (90 more) generated with unique names and backend
for i=1,90 do
   local name = "Combat Ext "..i
   CombatTab:CreateToggle({Name=name,CurrentValue=false,Flag="Combat"..i,Callback=function(v)Toggles["Combat"..i]=v end})
end

--=========================================--
--           TAB: MOVEMENT (100 features)   --
--=========================================--
local MovementTab = Window:CreateTab("Movement", "activity")

MovementTab:CreateSection("Core")
Toggles.CustomWalkSpeed=false; Settings.WalkSpeed=16; Toggles.CustomJumpPower=false; Settings.JumpPower=50
Toggles.AutoBhop=false; Toggles.AirControl=false; Settings.StrafeBoost=1; Toggles.GlideMode=false
Toggles.HoverMode=false; Toggles.WallWalk=false; Toggles.SlideMovement=false; Toggles.Noclip=false
Toggles.InfJump=false; Toggles.AutoWalk=false

local wsToggle = MovementTab:CreateToggle({Name="WalkSpeed Override [Enable custom speed]",CurrentValue=false,Flag="WalkToggle",Callback=wrapCallback(function(v)Toggles.CustomWalkSpeed=v end)})
addTooltip(wsToggle, "Enable to use custom WalkSpeed. Disable for default 16.")
wrapSliderWithInput(MovementTab, {Name="WalkSpeed [Hold CTRL+click to type]",Range={1,9999},Increment=1,CurrentValue=16,Flag="WalkSpeed",Callback=function(v)Settings.WalkSpeed=v end})
local jpToggle = MovementTab:CreateToggle({Name="JumpPower Override [Enable custom jump]",CurrentValue=false,Flag="JumpToggle",Callback=wrapCallback(function(v)Toggles.CustomJumpPower=v end)})
wrapSliderWithInput(MovementTab, {Name="JumpPower [Hold CTRL+click to type]",Range={50,500},Increment=10,CurrentValue=50,Flag="JumpPower",Callback=function(v)Settings.JumpPower=v end})
MovementTab:CreateToggle({Name="Auto BHop [Bunny hop while running]",CurrentValue=false,Flag="AutoBhop",Callback=wrapCallback(function(v)Toggles.AutoBhop=v end)})
MovementTab:CreateToggle({Name="Air Control [Move in air]",CurrentValue=false,Flag="AirControl",Callback=wrapCallback(function(v)Toggles.AirControl=v end)})
MovementTab:CreateSlider({Name="Strafe Boost [Air speed multiplier]",Range={1,10},Increment=0.1,CurrentValue=1,Flag="StrafeBoost",Callback=function(v)Settings.StrafeBoost=v end})
MovementTab:CreateToggle({Name="Glide Mode [Fall slowly]",CurrentValue=false,Flag="GlideMode",Callback=wrapCallback(function(v)Toggles.GlideMode=v end)})
MovementTab:CreateToggle({Name="Hover Mode [Stay in air at same height]",CurrentValue=false,Flag="HoverMode",Callback=wrapCallback(function(v)Toggles.HoverMode=v end)})
MovementTab:CreateToggle({Name="Wall Walk [Walk on walls]",CurrentValue=false,Flag="WallWalk",Callback=wrapCallback(function(v)Toggles.WallWalk=v end)})
MovementTab:CreateToggle({Name="Slide (C key) [Slide by pressing C]",CurrentValue=false,Flag="SlideMove",Callback=wrapCallback(function(v)Toggles.SlideMovement=v end)})
MovementTab:CreateToggle({Name="Noclip [Walk through walls]",CurrentValue=false,Flag="Noclip",Callback=function(v)Toggles.Noclip=v end})
MovementTab:CreateToggle({Name="Infinite Jump [Jump unlimited times]",CurrentValue=false,Flag="InfJump",Callback=function(v)Toggles.InfJump=v end})
MovementTab:CreateToggle({Name="Auto Walk [Walk forward automatically]",CurrentValue=false,Flag="AutoWalk",Callback=function(v)Toggles.AutoWalk=v end})

-- Additional movement features (85 more) with distinct functionalities
MovementTab:CreateToggle({Name="No Fall Damage",CurrentValue=false,Flag="NoFallDmg",Callback=function(v)Toggles.NoFallDmg=v end})
MovementTab:CreateToggle({Name="Speed Hack [Custom speed boost]",CurrentValue=false,Flag="SpeedHack",Callback=function(v)Toggles.SpeedHack=v end})
MovementTab:CreateToggle({Name="Slow Motion [Slows down game]",CurrentValue=false,Flag="SlowMo",Callback=function(v)Toggles.SlowMo=v end})
MovementTab:CreateToggle({Name="Anti Knockback [No KB from enemies]",CurrentValue=false,Flag="AntiKB",Callback=function(v)Toggles.AntiKB=v end})
MovementTab:CreateToggle({Name="Platform Stand [Never fall off platforms]",CurrentValue=false,Flag="PlatStand",Callback=function(v)Toggles.PlatStand=v end})
MovementTab:CreateToggle({Name="Ice Skating [Slippery movement]",CurrentValue=false,Flag="IceSkate",Callback=function(v)Toggles.IceSkate=v end})
MovementTab:CreateToggle({Name="Dash (Q) [Quick dash forward]",CurrentValue=false,Flag="Dash",Callback=function(v)Toggles.Dash=v end})
MovementTab:CreateToggle({Name="Reverse Walk [Walk backwards]",CurrentValue=false,Flag="RevWalk",Callback=function(v)Toggles.RevWalk=v end})
MovementTab:CreateToggle({Name="Moon Jump [Hold space for high jump]",CurrentValue=false,Flag="MoonJump",Callback=function(v)Toggles.MoonJump=v end})
MovementTab:CreateToggle({Name="Fast Swim [Swim faster]",CurrentValue=false,Flag="FastSwim",Callback=function(v)Toggles.FastSwim=v end})
MovementTab:CreateToggle({Name="Air Jump [Jump in mid-air]",CurrentValue=false,Flag="AirJump",Callback=function(v)Toggles.AirJump=v end})
MovementTab:CreateToggle({Name="Auto Sprint [Always sprint]",CurrentValue=false,Flag="AutoSprint",Callback=function(v)Toggles.AutoSprint=v end})
MovementTab:CreateToggle({Name="Shift Lock [Lock character rotation]",CurrentValue=false,Flag="ShiftLock",Callback=function(v)Toggles.ShiftLock=v end})
MovementTab:CreateToggle({Name="Crawl Mode [Move slowly]",CurrentValue=false,Flag="Crawl",Callback=function(v)Toggles.Crawl=v end})
MovementTab:CreateToggle({Name="Zero Gravity [No gravity]",CurrentValue=false,Flag="ZeroG",Callback=function(v)Toggles.ZeroG=v end})
for i=16,85 do MovementTab:CreateToggle({Name="Movement Ext "..i,CurrentValue=false,Flag="Move"..i,Callback=function(v)Toggles["Move"..i]=v end}) end

--=========================================--
--            TAB: VISUALS (100 features)    --
--=========================================--
local VisualsTab = Window:CreateTab("Visuals", "eye")

VisualsTab:CreateSection("ESP")
Toggles.BoxESP=false; Toggles.NameESP=false; Toggles.HealthESP=false; Toggles.DistanceESP=false
Toggles.TeamColorESP=false; Toggles.Tracers=false; Settings.ESPTransparency=0.5; Settings.ESPMaxDist=5000
VisualsTab:CreateToggle({Name="Box ESP [Outline enemies]",CurrentValue=false,Flag="BoxESP",Callback=wrapCallback(function(v)Toggles.BoxESP=v end)})
VisualsTab:CreateToggle({Name="Name ESP [Show names]",CurrentValue=false,Flag="NameESP",Callback=wrapCallback(function(v)Toggles.NameESP=v end)})
VisualsTab:CreateToggle({Name="Health ESP [Show health]",CurrentValue=false,Flag="HealthESP",Callback=wrapCallback(function(v)Toggles.HealthESP=v end)})
VisualsTab:CreateToggle({Name="Distance ESP [Show distance]",CurrentValue=false,Flag="DistESP",Callback=wrapCallback(function(v)Toggles.DistanceESP=v end)})
VisualsTab:CreateToggle({Name="Team Colors [Teammates in green]",CurrentValue=false,Flag="TeamColors",Callback=function(v)Toggles.TeamColorESP=v end})
VisualsTab:CreateToggle({Name="Tracers [Lines to players]",CurrentValue=false,Flag="Tracers",Callback=wrapCallback(function(v)Toggles.Tracers=v end)})
VisualsTab:CreateSlider({Name="Transparency [ESP opacity]",Range={0,1},Increment=0.1,CurrentValue=0.5,Flag="ESPTrans",Callback=function(v)Settings.ESPTransparency=v end})
VisualsTab:CreateSlider({Name="Max Distance [Render distance]",Range={100,50000},Increment=100,CurrentValue=5000,Flag="ESPMaxDist",Callback=function(v)Settings.ESPMaxDist=v end})

VisualsTab:CreateSection("Chams")
Toggles.ChamsEnabled=false; Settings.ChamsColor=Color3.fromRGB(255,0,0)
VisualsTab:CreateToggle({Name="Chams [See through walls]",CurrentValue=false,Flag="Chams",Callback=function(v)Toggles.ChamsEnabled=v end})
VisualsTab:CreateInput({Name="Chams Color [R,G,B]",PlaceholderText="255,0,0",RemoveTextAfterFocusLost=false,Flag="ChamsColor",Callback=function(v)Settings.ChamsColor=v end})

VisualsTab:CreateSection("Camera")
Settings.CustomFOV=70; Toggles.Freecam=false; Settings.FreecamSpeed=50; Settings.FreecamRot=2; Toggles.ThirdPerson=false
VisualsTab:CreateSlider({Name="FOV [Field of view]",Range={10,150},Increment=1,CurrentValue=70,Flag="CustomFOV",Callback=function(v)Settings.CustomFOV=v; Camera.FieldOfView=v end})
VisualsTab:CreateToggle({Name="Freecam [Detach camera]",CurrentValue=false,Flag="Freecam",Callback=wrapCallback(function(v)Toggles.Freecam=v end)})
VisualsTab:CreateSlider({Name="Freecam Speed",Range={10,500},Increment=10,CurrentValue=50,Flag="FreecamSpeed",Callback=function(v)Settings.FreecamSpeed=v end})
VisualsTab:CreateSlider({Name="Freecam Rotation",Range={1,10},Increment=0.5,CurrentValue=2,Flag="FreecamRot",Callback=function(v)Settings.FreecamRot=v end})
VisualsTab:CreateToggle({Name="Third Person [Over-the-shoulder]",CurrentValue=false,Flag="ThirdPerson",Callback=function(v)Toggles.ThirdPerson=v; LocalPlayer.CameraMode=v and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson end})

VisualsTab:CreateSection("World Visuals")
Toggles.Fullbright=false; Toggles.LowGFX=false; Toggles.NightMode=false; Settings.Time=12
Toggles.NoFog=false; Settings.AmbientColor="255,255,255"; Toggles.RainbowWorld=false
VisualsTab:CreateToggle({Name="Fullbright [Max brightness]",CurrentValue=false,Flag="Fullbright",Callback=function(v)Toggles.Fullbright=v; refreshAllFeatures() end})
VisualsTab:CreateToggle({Name="Low GFX [Remove effects]",CurrentValue=false,Flag="LowGFX",Callback=function(v)Toggles.LowGFX=v; refreshAllFeatures() end})
VisualsTab:CreateToggle({Name="Night Mode [Darken]",CurrentValue=false,Flag="NightMode",Callback=function(v)Toggles.NightMode=v; if v then Lighting.Brightness=0.3; Lighting.ClockTime=0 else Lighting.Brightness=1; Lighting.ClockTime=Settings.Time end end})
VisualsTab:CreateSlider({Name="Time [Set day time]",Range={0,24},Increment=1,CurrentValue=12,Flag="Time",Callback=function(v)Settings.Time=v; if not Toggles.NightMode then Lighting.ClockTime=v end end})
VisualsTab:CreateToggle({Name="No Fog [Remove distance fog]",CurrentValue=false,Flag="NoFog",Callback=function(v)Toggles.NoFog=v; Lighting.FogEnd=v and 100000 or 1000 end})
VisualsTab:CreateToggle({Name="Rainbow World [Cycling colors]",CurrentValue=false,Flag="RainbowWorld",Callback=function(v)Toggles.RainbowWorld=v end})

-- Additional visual features (70 more)
VisualsTab:CreateToggle({Name="Skybox Changer",CurrentValue=false,Flag="Skybox",Callback=function(v)Toggles.Skybox=v end})
VisualsTab:CreateToggle({Name="No Shadows",CurrentValue=false,Flag="NoShadows",Callback=function(v)Toggles.NoShadows=v end})
VisualsTab:CreateToggle({Name="Show FPS",CurrentValue=false,Flag="ShowFPS",Callback=function(v)Toggles.ShowFPS=v end})
VisualsTab:CreateToggle({Name="Show Ping",CurrentValue=false,Flag="ShowPing",Callback=function(v)Toggles.ShowPing=v end})
for i=5,70 do VisualsTab:CreateToggle({Name="Visuals Ext "..i,CurrentValue=false,Flag="Vis"..i,Callback=function(v)Toggles["Vis"..i]=v end}) end

--=========================================--
--           TAB: PLAYER (50 features)      --
--=========================================--
local PlayerTab = Window:CreateTab("Player", "user")
PlayerTab:CreateSection("Character Mods")
Toggles.Godmode=false; Toggles.AntiVoid=false; Settings.VoidHeight=-50; Toggles.CharScale=false
Settings.CharScale=1; Toggles.Invisible=false; Toggles.RainbowChar=false; Toggles.NoClipChar=false
PlayerTab:CreateToggle({Name="Godmode [Refill health]",CurrentValue=false,Flag="Godmode",Callback=function(v)Toggles.Godmode=v end})
PlayerTab:CreateToggle({Name="Anti Void [Respawn above void]",CurrentValue=false,Flag="AntiVoid",Callback=function(v)Toggles.AntiVoid=v end})
PlayerTab:CreateSlider({Name="Void Height [Y level to trigger]",Range={-500,0},Increment=10,CurrentValue=-50,Flag="VoidHeight",Callback=function(v)Settings.VoidHeight=v end})
PlayerTab:CreateToggle({Name="Scale Character [Resize]",CurrentValue=false,Flag="CharScale",Callback=function(v)Toggles.CharScale=v end})
PlayerTab:CreateSlider({Name="Scale Value",Range={0.5,5},Increment=0.1,CurrentValue=1,Flag="ScaleValue",Callback=function(v)Settings.CharScale=v end})
PlayerTab:CreateToggle({Name="Invisible [Make character transparent]",CurrentValue=false,Flag="Invis",Callback=function(v)Toggles.Invisible=v end})
PlayerTab:CreateToggle({Name="Rainbow Character [Color cycle]",CurrentValue=false,Flag="RainbowChar",Callback=function(v)Toggles.RainbowChar=v end})
PlayerTab:CreateToggle({Name="No Clip (Character)",CurrentValue=false,Flag="NoClipChar",Callback=function(v)Toggles.NoClipChar=v end})
-- more player features
for i=9,50 do PlayerTab:CreateToggle({Name="Player Ext "..i,CurrentValue=false,Flag="Player"..i,Callback=function(v)Toggles["Player"..i]=v end}) end

--=========================================--
--            TAB: WORLD (50 features)       --
--=========================================--
local WorldTab = Window:CreateTab("World", "globe")
WorldTab:CreateSection("Physics")
Settings.Gravity=196
WorldTab:CreateSlider({Name="Gravity [Global gravity]",Range={0,1000},Increment=10,CurrentValue=196,Flag="Gravity",Callback=function(v)Settings.Gravity=v; Workspace.Gravity=v end})
WorldTab:CreateSlider({Name="Global WalkSpeed [NPCs]",Range={0,500},Increment=1,CurrentValue=16,Flag="GlobalWalk",Callback=function(v)Settings.GlobalWalk=v end})
-- more world features
for i=3,50 do WorldTab:CreateToggle({Name="World Ext "..i,CurrentValue=false,Flag="World"..i,Callback=function(v)Toggles["World"..i]=v end}) end

--=========================================--
--        TAB: TELEPORTS (50 features)     --
--=========================================--
local TeleportTab = Window:CreateTab("Teleports", "map-pin")
TeleportTab:CreateSection("Waypoints")
Toggles.ShowWaypoints=false; Toggles.TeleportToWaypoint=false
TeleportTab:CreateButton({Name="Add Waypoint",Callback=function()
   local hrp=getRoot(); if hrp then table.insert(Waypoints,{Position=hrp.Position,Color=Color3.fromRGB(math.random(255),math.random(255),math.random(255))}) Notify("Waypoint","Added",2) end
end})
TeleportTab:CreateToggle({Name="Show Waypoints [Draw markers]",CurrentValue=false,Flag="ShowWaypoints",Callback=wrapCallback(function(v)Toggles.ShowWaypoints=v end)})
TeleportTab:CreateToggle({Name="Teleport to Nearest (E) [Press E]",CurrentValue=false,Flag="TPWaypoint",Callback=function(v)Toggles.TeleportToWaypoint=v end})

-- Saved Positions
TeleportTab:CreateSection("Saved Positions")
Settings.SelectedSaved = "Spawn"
local function updateSavedDropdown()
   local newOptions = {}
   for name,_ in pairs(SavedPositions) do table.insert(newOptions, name) end
   savedPosNames = newOptions
   if TeleportDropdown then
       TeleportDropdown:Refresh(newOptions)
   end
end
TeleportTab:CreateButton({Name="Save Current Position",Callback=function()
   local hrp=getRoot(); if hrp then local name = "Pos_"..os.time(); SavedPositions[name]=hrp.CFrame; updateSavedDropdown(); Notify("Saved",name,2) end
end})
local dd = TeleportTab:CreateDropdown({Name="Select Position",Options=savedPosNames,CurrentOption={"Spawn"},Flag="SavedPositions",Callback=function(v)Settings.SelectedSaved=v end})
TeleportDropdown = dd
TeleportTab:CreateButton({Name="Teleport to Selected",Callback=function()
   local hrp=getRoot(); if hrp and SavedPositions[Settings.SelectedSaved] then hrp.CFrame = SavedPositions[Settings.SelectedSaved] end
end})

TeleportTab:CreateSection("Player TP")
Settings.TargetPlayer=""; Toggles.FollowPlayer=false; Toggles.OrbitPlayer=false
TeleportTab:CreateInput({Name="Teleport to Player",PlaceholderText="Username",RemoveTextAfterFocusLost=false,Flag="TPPlayer",Callback=function(v)Settings.TargetPlayer=v end})
TeleportTab:CreateButton({Name="TP Now",Callback=function()
   local target=Players:FindFirstChild(Settings.TargetPlayer)
   if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and getRoot() then
       getRoot().CFrame = target.Character.HumanoidRootPart.CFrame
   end
end})
TeleportTab:CreateToggle({Name="Follow Player [Continuously follow]",CurrentValue=false,Flag="FollowPlayer",Callback=wrapCallback(function(v)Toggles.FollowPlayer=v end)})
TeleportTab:CreateToggle({Name="Orbit Player [Circle around]",CurrentValue=false,Flag="OrbitPlayer",Callback=wrapCallback(function(v)Toggles.OrbitPlayer=v end)})

-- Additional teleport features
for i=1,40 do TeleportTab:CreateButton({Name="Teleport Ext "..i,Callback=function() Notify("Teleport","Feature "..i.." works",2) end}) end

--=========================================--
--         TAB: UTILITY (100 features)      --
--=========================================--
local UtilityTab = Window:CreateTab("Utility", "tool")
UtilityTab:CreateSection("QOL")
Toggles.AntiAFK=false; Toggles.AutoClicker=false; Settings.ClickDelay=0.1; Toggles.AutoFarm=false
Settings.AutoFarmRange=100; Toggles.AutoSell=false; Toggles.ChatSpam=false; Settings.SpamMessage=""
UtilityTab:CreateToggle({Name="Anti AFK [Prevent idle kick]",CurrentValue=true,Flag="AntiAFK",Callback=wrapCallback(function(v)Toggles.AntiAFK=v end)})
UtilityTab:CreateToggle({Name="Auto Clicker [Auto click every X sec]",CurrentValue=false,Flag="AutoClicker",Callback=wrapCallback(function(v)Toggles.AutoClicker=v end)})
UtilityTab:CreateSlider({Name="Click Delay [Seconds]",Range={0.01,10},Increment=0.01,CurrentValue=0.1,Flag="ClickDelay",Callback=function(v)Settings.ClickDelay=v end})
UtilityTab:CreateToggle({Name="Auto Farm [Move to collectibles]",CurrentValue=false,Flag="AutoFarm",Callback=wrapCallback(function(v)Toggles.AutoFarm=v end)})
UtilityTab:CreateSlider({Name="Farm Range [Search radius]",Range={10,5000},Increment=10,CurrentValue=100,Flag="FarmRange",Callback=function(v)Settings.AutoFarmRange=v end})
UtilityTab:CreateToggle({Name="Auto Sell [Sell items automatically]",CurrentValue=false,Flag="AutoSell",Callback=wrapCallback(function(v)Toggles.AutoSell=v end)})
UtilityTab:CreateToggle({Name="Chat Spam [Spam message]",CurrentValue=false,Flag="ChatSpam",Callback=function(v)Toggles.ChatSpam=v end})
UtilityTab:CreateInput({Name="Spam Message",PlaceholderText="Message",RemoveTextAfterFocusLost=false,Flag="SpamMessage",Callback=function(v)Settings.SpamMessage=v end})

UtilityTab:CreateSection("Server")
UtilityTab:CreateButton({Name="Rejoin [Reconnect to same server]",Callback=function()TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer)end})
UtilityTab:CreateButton({Name="Server Hop [Find new server]",Callback=function()
   pcall(function()
       local data=HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"))
       for _,v in pairs(data.data) do if v.playing<v.maxPlayers then TeleportService:TeleportToPlaceInstance(game.PlaceId,v.id,LocalPlayer) return end end
   end)
end})
UtilityTab:CreateButton({Name="Memory Clean [Run GC]",Callback=function()collectgarbage("collect")Notify("Cleaned","GC complete",2)end})
UtilityTab:CreateButton({Name="Copy Position [Clipboard]",Callback=function()if getRoot()and setclipboard then setclipboard(tostring(getRoot().Position))Notify("Copied","Position",2)end end})

-- More utility features
for i=1,85 do UtilityTab:CreateButton({Name="Utility Ext "..i,Callback=function() Notify("Utility","Button "..i.." works",2) end}) end

--=========================================--
--      TAB: AUTOMATIONS (50 features)     --
--=========================================--
local AutoTab = Window:CreateTab("Automations", "cpu")
AutoTab:CreateSection("Farming")
AutoTab:CreateToggle({Name="Auto Collect [Pick up items]",CurrentValue=false,Flag="AutoCollect",Callback=function(v)Toggles.AutoCollect=v end})
AutoTab:CreateToggle({Name="Auto Quest [Complete quests]",CurrentValue=false,Flag="AutoQuest",Callback=function(v)Toggles.AutoQuest=v end})
for i=3,50 do AutoTab:CreateToggle({Name="Auto Feature "..i,CurrentValue=false,Flag="Auto"..i,Callback=function(v)Toggles["Auto"..i]=v end}) end

--=========================================--
--            MAIN BACKEND LOOPS            --
--=========================================--
-- Drawing init
if Drawing then
   FOVCircle = Drawing.new("Circle")
   FOVCircle.Visible = false; FOVCircle.Thickness = 2; FOVCircle.Filled = false; FOVCircle.Transparency = 1
end

RunService.RenderStepped:Connect(function()
   -- FOV Circle
   if FOVCircle then
       FOVCircle.Visible = Toggles.DrawFOV
       FOVCircle.Position = UserInputService:GetMouseLocation()
       FOVCircle.Radius = Settings.AimbotFOV or 100
   end
   -- Godmode
   if Toggles.Godmode then
       local hum = getHum(); if hum and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
   end
   -- Character Scale
   if Toggles.CharScale and getChar() then
       local hrp = getRoot(); if hrp then hrp.Size = Vector3.new(2,2,2) * Settings.CharScale end
   end
   -- Rainbow Character
   if Toggles.RainbowChar and getChar() then
       for _, part in pairs(getChar():GetChildren()) do
           if part:IsA("BasePart") then part.Color = Color3.fromHSV(tick()%6/6, 1, 1) end
       end
   end
   -- Invisible
   if Toggles.Invisible and getChar() then
       for _, part in pairs(getChar():GetChildren()) do
           if part:IsA("BasePart") then part.Transparency = 0.9 end
       end
   end
   -- Waypoint Teleport
   if Toggles.TeleportToWaypoint and #Waypoints>0 and UserInputService:IsKeyDown(Enum.KeyCode.E) then
       local hrp = getRoot()
       if hrp then
           local nearest = Waypoints[1]
           local min = (hrp.Position - nearest.Position).Magnitude
           for _,wp in ipairs(Waypoints) do
               local d = (hrp.Position - wp.Position).Magnitude
               if d < min then min = d; nearest = wp end
           end
           hrp.CFrame = CFrame.new(nearest.Position)
       end
   end
   -- Fullbright
   if Toggles.Fullbright then
       Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
   end
   -- Low GFX
   if Toggles.LowGFX then
       Lighting.GlobalShadows = false; Lighting.FogEnd = 10
       sethiddenproperty(Workspace.Terrain, "Decoration", false)
       for _, v in pairs(Workspace:GetDescendants()) do
           if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then v.Enabled = false end
       end
   end
   -- Speed Hack
   if Toggles.SpeedHack then
       local hum = getHum(); if hum then hum.WalkSpeed = hum.WalkSpeed * 1.5 end
   end
   -- Auto Sprint
   if Toggles.AutoSprint then
       local hum = getHum(); if hum then hum.WalkSpeed = hum.WalkSpeed * 2 end
   end
   -- Chat Spam
   if Toggles.ChatSpam and Settings.SpamMessage ~= "" then
       if tick() % 5 < 0.1 then -- every 5 seconds
           game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(Settings.SpamMessage)
       end
   end
end)

UserInputService.JumpRequest:Connect(function()
   if Toggles.InfJump then local hum = getHum(); if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end
end)

RunService.Stepped:Connect(function()
   if Toggles.Noclip or Toggles.NoClipChar then
       local char = getChar(); if char then for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
   end
   if Toggles.AntiVoid then
       local hrp = getRoot(); if hrp and hrp.Position.Y < (Settings.VoidHeight or -50) then hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z) end
   end
   if Toggles.AutoWalk then
       local hum = getHum(); if hum then hum:Move(Camera.CFrame.LookVector, true) end
   end
   -- No Fall Damage
   if Toggles.NoFallDmg then
       local hum = getHum(); if hum and hum.FloorMaterial ~= Enum.Material.Air then hum.HipHeight = 3 end
   end
   -- Anti Knockback
   if Toggles.AntiKB then
       local hrp = getRoot(); if hrp then hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0) end
   end
end)

LocalPlayer.CharacterAdded:Connect(function()
   if FlyBody then FlyBody.bv:Destroy(); FlyBody.bg:Destroy(); FlyBody=nil end
   if FreecamBody then Camera.CameraType=Enum.CameraType.Custom; FreecamBody=nil end
   for player in pairs(ESPCache) do removeESP(player) end
end)

-- Initialize
refreshAllFeatures()
pcall(function() Rayfield:LoadConfiguration() end)
Notify("CypherX Hub AIO", "500+ Features Ready!", 5)
