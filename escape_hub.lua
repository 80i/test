if not game:IsLoaded() then game.Loaded:Wait() end

-- UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "CypherX Hub (Clean Core)",
    LoadingTitle = "Loading...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "CypherXConfig",
        FileName = "Core"
    }
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Helpers
local function getChar()
    return LocalPlayer.Character
end

local function getHum()
    local c = getChar()
    return c and c:FindFirstChild("Humanoid")
end

local function getRoot()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

--================================--
-- FEATURE ENGINE
--================================--

local Features = {}

local function register(name, init, run, cleanup)
    Features[name] = {
        Enabled = false,
        Init = init,
        Run = run,
        Cleanup = cleanup
    }
end

local function setFeature(name, state)
    local f = Features[name]
    if not f then return end

    if state and not f.Enabled then
        f.Enabled = true
        if f.Init then f.Init() end

    elseif not state and f.Enabled then
        f.Enabled = false
        if f.Cleanup then f.Cleanup() end
    end
end

--================================--
-- SETTINGS
--================================--

local Settings = {
    WalkSpeed = 16,
    FlySpeed = 60
}

--================================--
-- FEATURES
--================================--

-- WalkSpeed
register("WalkSpeed", nil, function(_, _, hum)
    if hum and hum.WalkSpeed ~= Settings.WalkSpeed then
        hum.WalkSpeed = Settings.WalkSpeed
    end
end)

-- Infinite Jump
register("InfJump",
    function()
        Features.InfJump.Conn = UserInputService.JumpRequest:Connect(function()
            local hum = getHum()
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end,
    nil,
    function()
        if Features.InfJump.Conn then
            Features.InfJump.Conn:Disconnect()
        end
    end
)

-- Noclip
register("Noclip", nil, function(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end)

-- Fly
local FlyBody = nil

register("Fly",

function()
    local hrp = getRoot()
    local hum = getHum()
    if not hrp or not hum then return end

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = hrp

    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.Parent = hrp

    FlyBody = {bv = bv, bg = bg}
    hum.PlatformStand = true
end,

function(_, hrp)
    if not FlyBody or not hrp then return end

    local cam = workspace.CurrentCamera
    local move = Vector3.zero

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end

    if move.Magnitude > 0 then
        move = move.Unit
    end

    FlyBody.bv.Velocity = move * Settings.FlySpeed
    FlyBody.bg.CFrame = cam.CFrame
end,

function()
    local hum = getHum()

    if FlyBody then
        FlyBody.bv:Destroy()
        FlyBody.bg:Destroy()
        FlyBody = nil
    end

    if hum then
        hum.PlatformStand = false
    end
end)

--================================--
-- LOOP
--================================--

RunService.RenderStepped:Connect(function()
    local char = getChar()
    local hrp = getRoot()
    local hum = getHum()

    for _, f in pairs(Features) do
        if f.Enabled and f.Run then
            f.Run(char, hrp, hum)
        end
    end
end)

--================================--
-- UI
--================================--

local Main = Window:CreateTab("Main")

Main:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    CurrentValue = 16,
    Callback = function(v)
        Settings.WalkSpeed = v
        setFeature("WalkSpeed", true)
    end
})

Main:CreateToggle({
    Name = "Infinite Jump",
    Callback = function(v)
        setFeature("InfJump", v)
    end
})

Main:CreateToggle({
    Name = "Noclip",
    Callback = function(v)
        setFeature("Noclip", v)
    end
})

Main:CreateToggle({
    Name = "Fly",
    Callback = function(v)
        setFeature("Fly", v)
    end
})

Main:CreateSlider({
    Name = "Fly Speed",
    Range = {20, 200},
    CurrentValue = 60,
    Callback = function(v)
        Settings.FlySpeed = v
    end
})

Rayfield:LoadConfiguration()
