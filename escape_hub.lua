if not game:IsLoaded() then game.Loaded:Wait() end

-- Rayfield Library Load
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CYPHERX HUB — ESCAPE V2",
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
local LocalPlayer = Players.LocalPlayer

-- Tabs
local MainTab = Window:CreateTab("Main", "swords")
local VisualsTab = Window:CreateTab("Visuals", "eye")
local TeleportsTab = Window:CreateTab("Teleports", "map-pin")

-- Variables
local Toggles = {
    AutoWalk = false,
    Noclip = false,
    InfJump = false,
    Fly = false,
    ESP = false
}

local Settings = {
    WalkSpeed = 16,
    FlySpeed = 50
}

local connections = {}

-- [[ MAIN TAB ]] --

local SectionMain = MainTab:CreateSection("Movement Enhancements")

MainTab:CreateSlider({
   Name = "WalkSpeed Override",
   Range = {16, 300},
   Increment = 1,
   Suffix = "WalkSpeed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider", 
   Callback = function(Value)
      Settings.WalkSpeed = Value
   end,
})

-- Continuously enforce walkspeed to bypass anti-resets
connections.walkspeed = RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if char.Humanoid.WalkSpeed ~= Settings.WalkSpeed then
            char.Humanoid.WalkSpeed = Settings.WalkSpeed
        end
    end
end)

MainTab:CreateToggle({
   Name = "Smart Auto-Walk",
   CurrentValue = false,
   Flag = "AutoWalkToggle", 
   Callback = function(Value)
      Toggles.AutoWalk = Value
   end,
})

connections.autowalk = RunService.Heartbeat:Connect(function()
    if Toggles.AutoWalk then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:Move(Vector3.new(1, 0, 0), true)
        end
    end
end)

MainTab:CreateToggle({
   Name = "Ghost Noclip Mode",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      Toggles.Noclip = Value
   end,
})

connections.noclip = RunService.Stepped:Connect(function()
    if Toggles.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(Value)
      Toggles.InfJump = Value
   end,
})

connections.infjump = UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local SectionFly = MainTab:CreateSection("Fly Controls")

local FlyBody = nil
MainTab:CreateToggle({
   Name = "Enable Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      Toggles.Fly = Value
      local char = LocalPlayer.Character
      if not char or not char:FindFirstChild("HumanoidRootPart") then return end
      local hrp = char.HumanoidRootPart

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
          
          char.Humanoid.PlatformStand = true
      else
          if FlyBody then
              FlyBody.bv:Destroy()
              FlyBody.bg:Destroy()
              FlyBody = nil
          end
          char.Humanoid.PlatformStand = false
      end
   end,
})

MainTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 500},
   Increment = 5,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "FlySpeedSlider",
   Callback = function(Value)
      Settings.FlySpeed = Value
   end,
})

local camera = workspace.CurrentCamera
connections.fly = RunService.RenderStepped:Connect(function()
    if Toggles.Fly and FlyBody then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local moveDir = Vector3.zero
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            
            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit
            end

            FlyBody.bv.Velocity = moveDir * Settings.FlySpeed
            FlyBody.bg.CFrame = camera.CFrame
        end
    end
end)


-- [[ VISUALS TAB ]] --
local SectionVisuals = VisualsTab:CreateSection("ESP Settings")

VisualsTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      Toggles.ESP = Value
      if not Value then
          for _, player in pairs(Players:GetPlayers()) do
              if player.Character and player.Character:FindFirstChild("CypherX_ESP") then
                  player.Character.CypherX_ESP:Destroy()
              end
          end
      end
   end,
})

local function AddHighlight(character)
    if not character then return end
    if character:FindFirstChild("CypherX_ESP") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "CypherX_ESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
end

connections.esploop = RunService.Heartbeat:Connect(function()
    if Toggles.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("CypherX_ESP") then
                AddHighlight(player.Character)
            end
        end
    end
end)


-- [[ TELEPORTS TAB ]] --
local SectionTeleports = TeleportsTab:CreateSection("Quick Travel")

local TeleportLocations = {
    ["End Stage"] = Vector3.new(7986.58, 718.30, 5143.11),
    ["Spawn Area"] = Vector3.new(0, 50, 0),
    ["Secret Zone"] = Vector3.new(1000, 100, 1000) 
}

local SelectedLocation = "End Stage"
local locationOptions = {}
for name, _ in pairs(TeleportLocations) do
    table.insert(locationOptions, name)
end

TeleportsTab:CreateDropdown({
   Name = "Select Location",
   Options = locationOptions,
   CurrentOption = {"End Stage"},
   MultipleOptions = false,
   Flag = "TeleportDropdown",
   Callback = function(Option)
      SelectedLocation = Option[1]
   end,
})

TeleportsTab:CreateButton({
   Name = "Teleport",
   Callback = function()
      local char = LocalPlayer.Character
      if char and char:FindFirstChild("HumanoidRootPart") then
          local dest = TeleportLocations[SelectedLocation]
          if dest then
              char.HumanoidRootPart.CFrame = CFrame.new(dest)
              Rayfield:Notify({
                 Title = "Teleported!",
                 Content = "Successfully teleported to " .. SelectedLocation,
                 Duration = 3,
                 Image = "check",
              })
          end
      end
   end,
})

-- Initial load config
Rayfield:LoadConfiguration()

Rayfield:Notify({
    Title = "CypherX Hub Loaded",
    Content = "Press RightShift to toggle UI",
    Duration = 5,
    Image = "info",
})
