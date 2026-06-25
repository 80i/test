--// LOAD CHECK
if not game:IsLoaded() then game.Loaded:Wait() end

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// CHARACTER HANDLER
local character, humanoid, root

local function loadChar(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
end

player.CharacterAdded:Connect(loadChar)
if player.Character then loadChar(player.Character) end

--// FEATURE SYSTEM
local Features = {}

function Features.new(name, onEnable, onDisable)
    return {
        Name = name,
        Enabled = false,
        Enable = function(self)
            if self.Enabled then return end
            self.Enabled = true
            onEnable()
        end,
        Disable = function(self)
            if not self.Enabled then return end
            self.Enabled = false
            onDisable()
        end,
        Toggle = function(self)
            if self.Enabled then self:Disable() else self:Enable() end
        end
    }
end

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "CypherX_Pro"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 520, 0, 350)
main.Position = UDim2.new(0.3,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(15,15,18)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "CYPHERX PRO HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1

-- Container
local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1,0,1,-40)
container.Position = UDim2.new(0,0,0,40)
container.CanvasSize = UDim2.new(0,0,0,800)
container.ScrollBarThickness = 4
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,8)

--// TOGGLE UI
local function createToggle(name, feature)
    local frame = Instance.new("Frame", container)
    frame.Size = UDim2.new(1,-10,0,40)
    frame.BackgroundColor3 = Color3.fromRGB(22,22,28)
    Instance.new("UICorner", frame)

    local label = Instance.new("TextLabel", frame)
    label.Text = name
    label.Size = UDim2.new(0.6,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0,90,0,25)
    btn.Position = UDim2.new(1,-100,0.5,-12)
    btn.Text = "OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    Instance.new("UICorner", btn)

    local function update()
        if feature.Enabled then
            btn.Text = "ON"
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(0,170,100)
            }):Play()
        else
            btn.Text = "OFF"
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(40,40,50)
            }):Play()
        end
    end

    btn.MouseButton1Click:Connect(function()
        feature:Toggle()
        update()
    end)

    update()
end

--// FEATURES

-- 1 AutoWalk
local walkConn
local AutoWalk = Features.new("AutoWalk",
function()
    walkConn = RunService.Heartbeat:Connect(function()
        if humanoid then
            humanoid:Move(Vector3.new(1,0,0), true)
        end
    end)
end,
function()
    if walkConn then walkConn:Disconnect() end
end)

-- 2 Speed
local Speed = Features.new("Speed",
function()
    humanoid.WalkSpeed = 100
end,
function()
    humanoid.WalkSpeed = 16
end)

-- 3 Infinite Jump
local InfJump = Features.new("Infinite Jump",
function()
    _G.infJump = UIS.JumpRequest:Connect(function()
        humanoid:ChangeState("Jumping")
    end)
end,
function()
    if _G.infJump then _G.infJump:Disconnect() end
end)

-- 4 Noclip
local noclipConn
local Noclip = Features.new("Noclip",
function()
    noclipConn = RunService.Stepped:Connect(function()
        for _,v in ipairs(character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
end,
function()
    if noclipConn then noclipConn:Disconnect() end
end)

-- 5 Fly
local flyConn
local Fly = Features.new("Fly",
function()
    flyConn = RunService.RenderStepped:Connect(function()
        root.Velocity = Vector3.new(0,50,0)
    end)
end,
function()
    if flyConn then flyConn:Disconnect() end
end)

-- 6 Anti AFK
local AntiAFK = Features.new("AntiAFK",
function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0))
    end)
end,
function() end)

-- 7 Fullbright
local FullBright = Features.new("FullBright",
function()
    game.Lighting.Brightness = 5
end,
function()
    game.Lighting.Brightness = 1
end)

-- 8 Gravity
local Gravity = Features.new("Low Gravity",
function()
    game.Workspace.Gravity = 50
end,
function()
    game.Workspace.Gravity = 196
end)

-- 9 Teleport Forward
local TPForward = Features.new("TP Forward",
function()
    root.CFrame = root.CFrame + root.CFrame.LookVector * 20
end,
function() end)

-- 10 Spin
local spinConn
local Spin = Features.new("Spin",
function()
    spinConn = RunService.RenderStepped:Connect(function()
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(10), 0)
    end)
end,
function()
    if spinConn then spinConn:Disconnect() end
end)

-- 11 Super Jump
local SuperJump = Features.new("Super Jump",
function()
    humanoid.JumpPower = 120
end,
function()
    humanoid.JumpPower = 50
end)

-- 12 Sit Troll
local Sit = Features.new("Force Sit",
function()
    humanoid.Sit = true
end,
function()
    humanoid.Sit = false
end)

-- 13 Reset Character
local Reset = Features.new("Instant Reset",
function()
    character:BreakJoints()
end,
function() end)

-- 14 Walk on Air
local AirWalkConn
local AirWalk = Features.new("Air Walk",
function()
    AirWalkConn = RunService.Heartbeat:Connect(function()
        root.Velocity = Vector3.new(0,0,0)
    end)
end,
function()
    if AirWalkConn then AirWalkConn:Disconnect() end
end)

-- 15 FPS Boost
local FPS = Features.new("FPS Boost",
function()
    settings().Rendering.QualityLevel = "Level01"
end,
function() end)

--// REGISTER UI
createToggle("Auto Walk", AutoWalk)
createToggle("Speed", Speed)
createToggle("Infinite Jump", InfJump)
createToggle("Noclip", Noclip)
createToggle("Fly", Fly)
createToggle("Anti AFK", AntiAFK)
createToggle("Full Bright", FullBright)
createToggle("Low Gravity", Gravity)
createToggle("Teleport Forward", TPForward)
createToggle("Spin Bot", Spin)
createToggle("Super Jump", SuperJump)
createToggle("Force Sit", Sit)
createToggle("Reset Character", Reset)
createToggle("Air Walk", AirWalk)
createToggle("FPS Boost", FPS)

--// KEYBIND TO TOGGLE UI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
