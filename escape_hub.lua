if not game:IsLoaded() then game.Loaded:Wait() end

-- Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CYPHERX HUB — ESCAPE V2+",
   LoadingTitle = "CypherX Loading...",
   LoadingSubtitle = "Optimized Build",
   Theme = "Default",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "CypherXConfig",
      FileName = "EscapeV2Plus"
   },
})

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- TABS
local MainTab = Window:CreateTab("Main", "swords")
local VisualsTab = Window:CreateTab("Visuals", "eye")
local TeleportsTab = Window:CreateTab("Teleports", "map-pin")

-- STATE
local Toggles = {
    AutoWalk = false,
    Noclip = false,
    InfJump = false,
    Fly = false,
    ESP = false,
    Godmode = false,
    AntiAFK = false
}

local Settings = {
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    Gravity = 196
}

local connections = {}
local FlyBody = nil

-- SAFE CHARACTER FETCH
local function getHumanoid()
    local char = LocalPlayer.Character
    if char then
        return char:FindFirstChildOfClass("Humanoid")
    end
end

local function getRoot()
    local char = LocalPlayer.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
end

-- =========================
-- MAIN TAB
-- =========================

MainTab:CreateSection("Movement")

MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16,300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v)
      Settings.WalkSpeed = v
   end
})

MainTab:CreateSlider({
   Name = "Jump Power",
   Range = {50,300},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v)
      Settings.JumpPower = v
   end
})

MainTab:CreateSlider({
   Name = "Gravity",
   Range = {0,300},
   Increment = 1,
   CurrentValue = 196,
   Callback = function(v)
      Settings.Gravity = v
      workspace.Gravity = v
   end
})

-- ENFORCE STATS
connections.stats = RunService.Heartbeat:Connect(function()
    local hum = getHumanoid()
    if hum then
        if hum.WalkSpeed ~= Settings.WalkSpeed then
            hum.WalkSpeed = Settings.WalkSpeed
        end
        if hum.JumpPower ~= Settings.JumpPower then
            hum.JumpPower = Settings.JumpPower
        end
    end
end)

-- AUTO WALK
MainTab:CreateToggle({
   Name = "Auto Walk",
   Callback = function(v) Toggles.AutoWalk = v end
})

connections.autowalk = RunService.Heartbeat:Connect(function()
    if Toggles.AutoWalk then
        local hum = getHumanoid()
        if hum then
            hum:Move(Vector3.new(1,0,0), true)
        end
    end
end)

-- NOCLIP
MainTab:CreateToggle({
   Name = "Noclip",
   Callback = function(v) Toggles.Noclip = v end
})

connections.noclip = RunService.Stepped:Connect(function()
    if Toggles.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _,v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

-- INF JUMP
MainTab:CreateToggle({
   Name = "Infinite Jump",
   Callback = function(v) Toggles.InfJump = v end
})

UIS.JumpRequest:Connect(function()
    if Toggles.InfJump then
        local hum = getHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- GODMODE
MainTab:CreateToggle({
   Name = "Godmode",
   Callback = function(v) Toggles.Godmode = v end
})

connections.god = RunService.Heartbeat:Connect(function()
    if Toggles.Godmode then
        local hum = getHumanoid()
        if hum then
            hum.Health = hum.MaxHealth
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
        end
    end
end)

-- FLY
MainTab:CreateSection("Fly")

MainTab:CreateToggle({
   Name = "Fly",
   Callback = function(v)
      Toggles.Fly = v
      local root = getRoot()
      local hum = getHumanoid()
      if not root or not hum then return end

      if v then
          local bv = Instance.new("BodyVelocity")
          bv.MaxForce = Vector3.new(1e5,1e5,1e5)
          bv.Parent = root

          local bg = Instance.new("BodyGyro")
          bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
          bg.Parent = root

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
   end
})

MainTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10,200},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(v)
      Settings.FlySpeed = v
   end
})

connections.fly = RunService.RenderStepped:Connect(function()
    if Toggles.Fly and FlyBody then
        local root = getRoot()
        if not root then return end

        local cam = workspace.CurrentCamera
        local dir = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end

        if dir.Magnitude > 0 then dir = dir.Unit end

        FlyBody.bv.Velocity = dir * Settings.FlySpeed
        FlyBody.bg.CFrame = cam.CFrame
    end
end)

-- =========================
-- VISUALS
-- =========================

VisualsTab:CreateSection("ESP")

VisualsTab:CreateToggle({
   Name = "Player ESP",
   Callback = function(v) Toggles.ESP = v end
})

connections.esp = RunService.Heartbeat:Connect(function()
    if Toggles.ESP then
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if not p.Character:FindFirstChild("ESP") then
                    local h = Instance.new("Highlight")
                    h.Name = "ESP"
                    h.FillColor = Color3.new(1,0,0)
                    h.Parent = p.Character
                end
            end
        end
    end
end)

-- =========================
-- TELEPORTS
-- =========================

TeleportsTab:CreateSection("Coords")

local saved = {}

TeleportsTab:CreateButton({
    Name = "Save Position",
    Callback = function()
        local root = getRoot()
        if root then
            table.insert(saved, root.CFrame)
        end
    end
})

TeleportsTab:CreateButton({
    Name = "Teleport Slot 1",
    Callback = function()
        local root = getRoot()
        if root and saved[1] then
            root.CFrame = saved[1]
        end
    end
})

-- =========================
-- UTIL
-- =========================

MainTab:CreateToggle({
   Name = "Anti AFK",
   Callback = function(v) Toggles.AntiAFK = v end
})

LocalPlayer.Idled:Connect(function()
    if Toggles.AntiAFK then
        VirtualUser:Button2Down(Vector2.new())
    end
end)

-- UI TOGGLE
UIS.InputBegan:Connect(function(i,g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        Rayfield:ToggleUI()
    end
end)

Rayfield:LoadConfiguration()
